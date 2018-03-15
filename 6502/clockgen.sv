`timescale 1ns / 1ps

// clockgen is responsible for generating both the internal and external
// clock signals.
//
// ph0 is the input clock.  A clock cycle is defined as starting low.
// ph1 is high during the first phase of the clock (i.e. the low phase)
// ph2 is high during the second phase of the clock (i.e. the hight phase)
//
// ph1_out and ph2_out are the output clocks routed to the output pins on the
// 6502.
module clockgen(
    input ph0,
    output ph1,
    output ph2,
    output ph1_out,
    output ph2_out
);

// This is an idealized representation of the 6502 clock generator.  The 
// real clock generator has logic to ensure that ph1 and ph2 are never
// high at once.  More info: 
// https://wiki.nesdev.com/w/index.php/Visual_circuit_tutorial#6502_cycle_and_phase_timing
always_comb begin
    ph1 = !ph0;
    ph1_out = ph1;
    ph2 = ph0;
    ph2_out = ph2;
end

endmodule