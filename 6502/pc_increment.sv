`timescale 1ns / 1ps

// pc_increment encapsulates the program counter increment logic for both 
// PCH and PCL.  This means that it has both a carry out and a half carry out.
module pc_increment(
    input [7:0] data_in,
    input increment,
    output [7:0] data_out,
    output half_carry_out,
    output carry_out
);

assign {half_carry_out, data_out[3:0]} = 
    {1'b0, data_in[3:0]} + {4'b0, increment};
assign {carry_out, data_out[7:4]} = 
    {1'b0, data_in[7:4]} + {4'b0, half_carry_out};

endmodule