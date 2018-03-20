`timescale 1ns / 1ps

module alu (
    input wire [7:0] a_in,
    input wire [7:0] b_in,
    input wire decimal_enable,
    input wire carry_in,
    input wire sum_en,
    input wire and_en,
    input wire eor_en,
    input wire or_en,
    input wire shift_en,
    output wire [7:0] data_out,
    output wire overflow,
    output wire half_carry,
    output wire carry
);

always_comb begin
    if (sum_en) begin
        {half_carry, data_out[3:0]} =
            {1'b0, a_in[3:0]} + {1'b0, b_in[3:0]} + {4'b0, carry_in};
        {carry, data_out[7:4]} =
            {1'b0, a_in[7:4]} + {1'b0, b_in[7:4]} + {4'b0, half_carry};
    end else if (and_en) begin
        data_out = a_in & b_in;
        carry = 1'b0;
        half_carry = 1'b0;
    end else if (eor_en) begin
        data_out = a_in ^ b_in;
        carry = 1'b0;
        half_carry = 1'b0;
    end else if (or_en) begin
        data_out = a_in | b_in;
        carry = 1'b0;
        half_carry = 1'b0;
    end else if (shift_en) begin
        {data_out, carry} = {carry_in, a_in};
        half_carry = 1'b0;
    end else begin
        data_out = 8'hFF;
        carry = 1'b0;
        half_carry = 1'b0;
    end

    // Overflow as shown in Arlet Ottens ALU:
    // https://github.com/Arlet/verilog-6502
    overflow = a_in[7] ^ b_in[7] ^ data_out[7] ^ carry;
end
endmodule