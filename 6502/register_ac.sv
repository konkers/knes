`timescale 1ns / 1ps

// This is the Accumulator (AC) register.  It has a single input and 
// two bus outputs.
module register_ac(
    input [7:0] data_in,
    input load,
    inout [7:0] data_out0,
    input bus_enable0,
    inout [7:0] data_out1,
    input bus_enable1
);

logic [7:0] data_latch;
assign data_out0 = bus_enable0 ? data_latch : 8'bz;
assign data_out1 = bus_enable1 ? data_latch : 8'bz;

initial begin
    data_latch = 8'b0;
end

always_ff @(posedge load) begin
    data_latch <= data_in;
end

endmodule
