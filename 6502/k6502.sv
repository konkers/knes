`timescale 1ns / 1ps

`ifdef VERILATOR
typedef struct packed {
`else
typedef struct {
`endif
    bit ac_db;
    bit ac_sb;
    bit add_adl;
    bit add_sb_6_0;
    bit add_sb_7;
    bit adh_abh;
    bit adl_abl;
    bit dl_adh;
    bit dl_adl;
    bit dl_db;
    bit sb_ac;
    bit sb_add;
    bit sb_x;
    bit sb_y;
    bit x_sb;
    bit y_sb;
    bit z_add;
} control_signals_t;

// 6502 toplevel module.
module k6502(
    inout [7:0] d,
    inout [15:0] a,
    input reset_n,
    input ph0,
    output ph1_out,
    output ph2_out
);

wire ph1;
wire ph2;
clockgen clockgen(
    .ph0(ph0),
    .ph1(ph1),
    .ph2(ph2),
    .ph1_out(ph1_out),
    .ph2_out(ph2_out)
);

wire [7:0] db_bus;
wire [7:0] sb_bus;
wire [7:0] adl_bus;
wire [7:0] adh_bus;

control_signals_t ctl;

// Address Bus High Register (ABH)
register_single_in abh_reg(
    .data_in(adh_bus),
    .load(ph1 & ctl.adh_abh),
    .data_out(a[15:8])
);

// Address Bus Low Register (ABL)
register_single_in abl_reg(
    .data_in(adl_bus),
    .load(ph1 & ctl.adl_abl),
    .data_out(a[7:0])
);

// X Index Register (X)
register_index x_reg(
    .data(sb_bus),
    .load(ctl.sb_x),
    .bus_enable(ctl.x_sb)
);

// Y Index Register (Y)
register_index y_reg(
    .data(sb_bus),
    .load(ctl.sb_y),
    .bus_enable(ctl.y_sb)
);

wire [7:0] ai_out;
// A Input Register (AI)
register_double_in ai_reg(
    .data_in0(8'b0),
    .load0(ctl.z_add),
    .data_in1(sb_bus),
    .load1(ctl.sb_add),
    .data_out(ai_out)
);

wire [7:0] alu_out;
// Adder Hold Register (ADD)
register_adder_hold add_reg(
    .data_in(alu_out),
    .load(ph2),
    .data_out0(adl_bus),
    .bus_enable0(ctl.add_adl),
    .data_out1(sb_bus),
    .bus_enable1_0_6(ctl.add_sb_6_0),
    .bus_enable1_7(ctl.add_sb_7)
);

// TODO(#1): Decimal adjust register is not implemented and routed around.
register_ac ac_reg(
    .data_in(sb_bus),
    .load(ctl.sb_ac),
    .data_out0(db_bus),
    .bus_enable0(ctl.ac_db),
    .data_out1(sb_bus),
    .bus_enable1(ctl.ac_sb)
);

// Input Data Latch (DL)
input_data_latch dl_reg(
    .data_in(d),
    .load(ph2),
    .bus_enable0(ctl.dl_db),
    .data_out0(db_bus),
    .bus_enable1(ctl.dl_adl),
    .data_out1(adl_bus),
    .bus_enable2(ctl.dl_adh),
    .data_out2(adh_bus)
);

wire [7:0] pre_decode_out;
// Pre Decode Register (PD)
register_single_in pd_reg(
    .data_in(d),
    .load(ph2),
    .data_out(pre_decode_out)
);

endmodule