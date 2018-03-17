`timescale 1ns / 1ps

// A register with three inputs an a single output.  These is used for the
// B input regisser and the Program Counter Select Registers.
//
// load0 takes priority over load1 which take priorit over load2.  However, if
// any load is active, transitions on other loads will be ignored.
module register_triple_in(
    input [7:0] data_in0,
    input load0,
    input [7:0] data_in1,
    input load1,
    input [7:0] data_in2,
    input load2,
    output [7:0] data_out
);

logic [7:0] data_out;
wire load;
assign load = load0 | load1 | load2;

initial begin
    data_out = 8'b0;
end

always_ff @(posedge load) begin
    if(load0)
        data_out <= data_in0;
    else if(load1)
        data_out <= data_in1;
    else
        data_out <= data_in2;
end

endmodule
