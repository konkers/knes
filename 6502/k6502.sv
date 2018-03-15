`timescale 1ns / 1ps

`ifdef VERILATOR
typedef struct packed {
`else
typedef struct {
`endif
    bit add_adl;
    bit add_sb_6_0;
    bit add_sb_7;
    bit adh_abh;
    bit adl_abl;
    bit dl_adh;
    bit dl_adl;
    bit dl_db;
    bit sb_x;
    bit sb_y;
    bit x_sb;
    bit y_sb;
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

control_signals_t control_signals;

// Address Bus High Register (ABH)
register_single_in abh_reg(
    .data_in(adh_bus),
    .load(ph1 & control_signals.adh_abh),
    .data_out(a[15:8])
);

// Address Bus Low Register (ABL)
register_single_in abl_reg(
    .data_in(adl_bus),
    .load(ph1 & control_signals.adl_abl),
    .data_out(a[7:0])
);

// X Index Register (X)
register_index x_reg(
    .data(sb_bus),
    .load(control_signals.sb_x),
    .bus_enable(control_signals.x_sb)
);

// Y Index Register (Y)
register_index y_reg(
    .data(sb_bus),
    .load(control_signals.sb_y),
    .bus_enable(control_signals.y_sb)
);

// Input Data Latch (DL)
input_data_latch dl_reg(
    .data_in(d),
    .load(ph2),
    .bus_enable0(control_signals.dl_db),
    .data_out0(db_bus),
    .bus_enable1(control_signals.dl_adl),
    .data_out1(adl_bus),
    .bus_enable2(control_signals.dl_adh),
    .data_out2(adh_bus)
);

// Pre Decode Register (PD)
wire [7:0] pre_decode_out;
register_single_in pd_reg(
    .data_in(d),
    .load(ph2),
    .data_out(pre_decode_out)
);

wire [7:0] alu_out;

// Adder Hold Register (ADD)
register_adder_hold add_reg(
    .data_in(alu_out),
    .load(ph2),
    .data_out0(adl_bus),
    .bus_enable0(control_signals.add_adl),
    .data_out1(sb_bus),
    .bus_enable1_0_6(control_signals.add_sb_6_0),
    .bus_enable1_7(control_signals.add_sb_7)
);

endmodule