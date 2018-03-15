`timescale 1ns / 1ps

// register_adder_hold is used for the Adder Hold Register (ADD).
// It's a bit special in that it has seperate bus enables for bits
// 0-6 and 7 on one of it's outputs.
module register_adder_hold(
    input [7:0] data_in,
    input load,
    
    inout [7:0] data_out0,
    input bus_enable0,

    inout [7:0] data_out1,
    input bus_enable1_0_6,
    input bus_enable1_7
);

logic [7:0] data_out;

assign data_out0 = bus_enable0 ? data_out : 8'bz;
assign data_out1[6:0] = bus_enable1_0_6 ? data_out[6:0] : 7'bz;
assign data_out1[7] = bus_enable1_7 ? data_out[7] : 1'bz;

initial begin
    data_out = 8'b0;
end

always_ff @(posedge load) begin
    data_out <= data_in;
end

endmodule
