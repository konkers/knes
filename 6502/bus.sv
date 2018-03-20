`timescale 1ns / 1ps

module bus #(
    parameter N
) ( 
    output wire [7:0] value,
    output wire is_driven,
    input wire [N-1:0][7:0] driver_values,
    input wire [N-1:0] driver_enables,
    input wire [7:0] pull_down_enables
); 

// Here we transpose the driver_values array.  Most blocks want 8 bit data
// to work on.  However bus_bit needs an Nx1 array for each bit.  It is hoped
// that this sorts itself out efficiently in sythesis.
wire [7:0][N-1:0] bits;
always_comb begin
    foreach (bits[i,j])
        bits[i][j] = driver_values[j][i];
end 

// value before pull downs.
wire [7:0] pre_pd_value;
generate
    genvar i;
    for (i=0; i < 8; i++)
        bus_bit #(N) bit_n(pre_pd_value[i], bits[i], driver_enables);
endgenerate

always_comb begin
    is_driven = |driver_enables;
    value = pre_pd_value & ~pull_down_enables;
end

endmodule
