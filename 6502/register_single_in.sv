`timescale 1ns / 1ps

// A register with a single input and a single output.  These are used in
// several places including the Predecode, Address Bus High, and Address Bus
// Low registers.
module register_single_in(
    input [7:0] data_in,
    input load,
    output [7:0] data_out
);

logic [7:0] data_out;

initial begin
    data_out = 8'b0;
end

always_ff @(posedge load) begin
    data_out <= data_in;
end

endmodule
