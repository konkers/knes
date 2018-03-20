`timescale 1ns / 1ps

module pass_mosfets (
    input wire [1:0][7:0] bus_input,
    input wire [1:0] bus_driven,
    input wire pass_enable,
    output wire [1:0][7:0] bus_output
);

generate
    genvar i;
    for (i=0; i < 2; i++)
        always_comb  begin
            if (pass_enable & bus_driven[!i] & !bus_driven[i])
                bus_output[i] = bus_input[!i];
            else
                bus_output[i] = bus_input[i];
        end
endgenerate
endmodule