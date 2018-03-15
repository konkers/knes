`timescale 1ns / 1ps

// The input_data_latch is used to latch data from the external data bus.
// It can drive the three busses (connected to DB, ADL, and ADH on the
// 6502.
module input_data_latch(
    input [7:0] data_in,
    input load,
    input bus_enable0,
    inout [7:0] data_out0,
    input bus_enable1,
    inout [7:0] data_out1,
    input bus_enable2,
    inout [7:0] data_out2
);

logic [7:0] data_latch;

assign data_out0 = bus_enable0 ? data_latch : 8'bz;
assign data_out1 = bus_enable1 ? data_latch : 8'bz;
assign data_out2 = bus_enable2 ? data_latch : 8'bz;

initial begin
    data_latch = 8'b0;
end

always_ff @(posedge load) begin
    data_latch <= data_in;
end
endmodule