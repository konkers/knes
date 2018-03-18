`timescale 1ns / 1ps

// regiser_pc is used for both the high and low byte PC register (PCL and PCH).
module register_pc(
    input [7:0] data_in,
    input load,
    inout [7:0] data_out0,
    input bus_enable0,
    inout [7:0] data_out1,
    input bus_enable1,
    output [7:0] pc_out
);

logic [7:0] pc_latch;
assign pc_out = pc_latch;
assign data_out0 = bus_enable0 ? pc_latch : 8'bz;
assign data_out1 = bus_enable1 ? pc_latch : 8'bz;

initial begin
    pc_latch = 8'b0;
end

always_ff @(posedge load) begin
    pc_latch <= data_in;
end

endmodule
