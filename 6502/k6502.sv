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
    bit adh_pch;
    bit adl_pcl;
    bit adl_add;
    bit db_add;
    bit db_n_add;
    bit dl_adh;
    bit dl_adl;
    bit dl_db;
    bit i_pc;
    bit pch_adh;
    bit pch_db;
    bit pch_pch;
    bit pcl_adl;
    bit pcl_db;
    bit pcl_pcl;
    bit s_adl;
    bit s_s;
    bit s_sb;
    bit sb_ac;
    bit sb_add;
    bit sb_s;
    bit sb_x;
    bit sb_y;
    bit x_sb;
    bit y_sb;
    bit z_adh0;
    bit z_adh7_1;
    bit z_adl0;
    bit z_adl1;
    bit z_adl2;
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

// Register outputs
wire [7:0] reg_ac_out;
wire [7:0] reg_add_out;
wire [7:0] reg_dl_out;
wire [7:0] reg_pch_out;
wire [7:0] reg_pcl_out;
wire [7:0] reg_s_out;
wire [7:0] reg_x_out;
wire [7:0] reg_y_out;

wire [7:0] db_value;
bus #(4) db_bus(
    .value(db_value),
    .driver_values({reg_dl_out, reg_pch_out, reg_pch_out, reg_ac_out}),
    .driver_enables({ctl.dl_db, ctl.pcl_db, ctl.pch_db, ctl.ac_db}),
    .pull_down_enables(8'b0)
);

wire [7:0] sb_value;
bus #(6) sb_bus(
    .value(sb_value),
    .driver_values({
        reg_s_out,
        {1'b1, reg_add_out[6:0]},
        {reg_add_out[7], 7'hFF},
        reg_x_out,
        reg_y_out,
        reg_ac_out}),
    .driver_enables({
        ctl.s_sb,
        ctl.add_sb_6_0,
        ctl.add_sb_7,
        ctl.x_sb,
        ctl.y_sb,
        ctl.ac_sb}),
    .pull_down_enables(8'b0)
);

wire [7:0] adl_value;
bus #(4) adl_bus(
    .value(adl_value),
    .driver_values({reg_dl_out, reg_pcl_out, reg_s_out, reg_add_out}),
    .driver_enables({ctl.dl_adl, ctl.pcl_adl, ctl.s_adl, ctl.add_adl}),
    .pull_down_enables({5'b0, ctl.z_adl2, ctl.z_adl1, ctl.z_adl0})
);

wire [7:0] adh_value;
bus #(2) adh_bus(
    .value(adh_value),
    .driver_values({reg_dl_out, reg_pch_out}),
    .driver_enables({ctl.dl_adh, ctl.pch_adh}),
    .pull_down_enables({
        ctl.z_adh7_1, ctl.z_adh7_1, ctl.z_adh7_1, ctl.z_adh7_1,
        ctl.z_adh7_1, ctl.z_adh7_1, ctl.z_adh7_1, ctl.z_adh0})
);

control_signals_t ctl;

wire [7:0] pcls_out;
// Program Counter Low Select Register (PCLS)
register_double_in pcls_regs(
    .data_in0(reg_pcl_out),
    .load0(ctl.pcl_pcl),
    .data_in1(adl_value),
    .load1(ctl.adl_pcl),
    .data_out(pcls_out)
);

wire pclc;
wire pcl_hc; // unused
wire [7:0] pcl_inc_out;
pc_increment pcl_inc(
    .data_in(pcls_out),
    .increment(ctl.i_pc),
    .carry_out(pclc),
    .half_carry_out(pcl_hc),
    .data_out(pcl_inc_out)
);

register_single_in pcl_reg(
    .data_in(pcl_inc_out),
    .load(ph2),
    .data_out(reg_pcl_out)
);

// TODO(#2): Merge this and PCLS into a single module.
wire [7:0] pchs_out;
// Program Counter High Select Register (PCHS)
register_double_in pchs_regs(
    .data_in0(reg_pch_out),
    .load0(ctl.pch_pch),
    .data_in1(adh_value),
    .load1(ctl.adh_pch),
    .data_out(pchs_out)
);

wire pchc;
wire pch_c; // unused
wire [7:0] pch_inc_out;
pc_increment pch_inc(
    .data_in(pchs_out),
    .increment(pclc),
    .carry_out(pch_c),
    .half_carry_out(pchc),
    .data_out(pch_inc_out)
);

register_single_in pch_reg(
    .data_in(pch_inc_out),
    .load(ph2),
    .data_out(reg_pch_out)
);

// Stack Pointer Register (S)
// I'm unclear on how the hold signal (ctl.s_s) is supposed to work.  For
// now, it's used to mask load (ctl.sb_s).
register_single_in s_reg(
    .data_in(sb_value),
    .load(ctl.sb_s & ~ctl.s_s),
    .data_out(reg_s_out)
);

// Address Bus High Register (ABH)
register_single_in abh_reg(
    .data_in(adh_value),
    .load(ph1 & ctl.adh_abh),
    .data_out(a[15:8])
);

// Address Bus Low Register (ABL)
register_single_in abl_reg(
    .data_in(adl_value),
    .load(ph1 & ctl.adl_abl),
    .data_out(a[7:0])
);

// X Index Register (X)
register_single_in x_reg(
    .data_in(sb_value),
    .load(ctl.sb_x),
    .data_out(reg_x_out)
);

// Y Index Register (Y)
register_single_in y_reg(
    .data_in(sb_value),
    .load(ctl.sb_y),
    .data_out(reg_y_out)
);

wire [7:0] ai_out;
// A Input Register (AI)
register_double_in ai_reg(
    .data_in0(8'b0),
    .load0(ctl.z_add),
    .data_in1(sb_value),
    .load1(ctl.sb_add),
    .data_out(ai_out)
);

wire [7:0] bi_out;
// B Input Register (BI)
register_triple_in bi_reg(
    .data_in0(~db_value),
    .load0(ctl.db_n_add),
    .data_in1(db_value),
    .load1(ctl.db_add),
    .data_in2(adl_value),
    .load2(ctl.adl_add),
    .data_out(bi_out)
);

wire [7:0] alu_out;
// Adder Hold Register (ADD)
register_single_in add_reg(
    .data_in(alu_out),
    .load(ph2),
    .data_out(reg_add_out)
);

// TODO(#1): Decimal adjust register is not implemented and routed around.
register_single_in ac_reg(
    .data_in(sb_value),
    .load(ctl.sb_ac),
    .data_out(reg_ac_out)
);

// Input Data Latch (DL)
register_single_in dl_reg(
    .data_in(d),
    .load(ph2),
    .data_out(reg_dl_out)
);

wire [7:0] pre_decode_out;
// Pre Decode Register (PD)
register_single_in pd_reg(
    .data_in(d),
    .load(ph2),
    .data_out(pre_decode_out)
);

endmodule