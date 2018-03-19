`timescale 1ns / 1ps

// This exists to instantiate a 4 driver bus_bit for the c++ testbench.
module bus_bit_test (
    output wire out,
    input wire [3:0] driver_value,
    input wire [3:0] driver_enable
);

bus_bit #(4) test_bus_bit(out, driver_value, driver_enable);

endmodule