`timescale 1ns / 1ps

// A bit lane on a bus.  It is parametrized on the number of inputs to the bus.
// It emulates and open-drain style bus.
//
// This method is described by Andrew Holme at
// http://www.aholme.co.uk/6502/Main.htm.  The input feedback described there
// is not implemented.  We'll see if we need it in our model.  Doing so will
// require introducing a register between in and out and clocking it off a
// higher rate clock than the main clock.
module bus_bit #(
    parameter N
) ( 
    output wire out,
    input wire [N-1:0] driver_value,
    input wire [N-1:0] driver_enable
); 

always_comb begin
    // (value | ~enable) has the effect of setting any drivers that are
    // not enabled to high.  This is to emulate open drain semantics.
    out = &(driver_value | ~driver_enable);
end

endmodule
