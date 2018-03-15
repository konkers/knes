`timescale 1ns / 1ps

// A register with a single input and a single output.  These are used in
// several places including the Predecode, Address Bus High, and Address Bus
// Low registers.
//
// load0 takes priority over load1.  However, if load1 is active, a load0
// transistion will be ignored.
module register_double_in(
    input [7:0] data_in0,
    input load0,
    input [7:0] data_in1,
    input load1,
    output [7:0] data_out
);

logic [7:0] data_out;
wire load;
assign load = load0 | load1;

initial begin
    data_out = 8'b0;
end

always_ff @(posedge load) begin
    if(load0)
        data_out <= data_in0;
    else
        data_out <= data_in1;
end

endmodule
