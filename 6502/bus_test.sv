`timescale 1ns / 1ps

module bus_test (
    output wire [7:0] value,
    input wire [7:0][3:0] driver_values,
    input wire [3:0] driver_enables,
    input wire [7:0] pull_down_enables
); 

bus #(4) test_bus(value, driver_values, driver_enables, pull_down_enables);
endmodule
