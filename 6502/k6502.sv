`timescale 1ns / 1ps

`ifdef VERILATOR
typedef struct packed {
`else
typedef struct {
`endif
    bit adh_abh;
    bit adl_abl;
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

register_single_in abh_reg(
    .data_in(adh_bus),
    .load(ph1 & control_signals.adh_abh),
    .data_out(a[15:8])
);

register_single_in abl_reg(
    .data_in(adl_bus),
    .load(ph1 & control_signals.adl_abl),
    .data_out(a[7:0])
);

wire [7:0] pre_decode_out;
register_single_in pre_decode_reg(
    .data_in(d),
    .load(ph2),
    .data_out(pre_decode_out)
);

endmodule