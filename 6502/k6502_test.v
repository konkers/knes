//
// Copyright 2009 Erik Gilling
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

`timescale 1ns/1ps

`include "k6502_defs.v"

module k6502_test;

   wire [15:0] a;
   wire [7:0]  d;
   reg 	       clk;
   reg 	       rst_n;
   wire        sync;
   wire        rw;
`ifdef DEBUG
   wire [`X_BITS-1:0] x;
   wire [15:0] 	      pc;
   wire [15:0]      dl;
   wire [7:0]      ir;
`endif

   k6502 k6502(
`ifdef DEBUG
	       .x(x),
	       .pc(pc),
	       .dl(dl),
	       .ir(ir),
`endif
	       .a(a),
	       .d(d),
	       .clk(clk),
	       .rst_n(rst_n),
	       .sync(sync),
	       .rw(rw));

   rom rom(.addr({1'b0, a[14:0]}),
	   .data(d),
	   .oe_n(rw & a[15]));
      
   initial // Clock generator
     begin
	clk = 1;
	forever #125 clk = !clk;
     end

   initial	// Test stimulus
     begin
	rst_n = 0;
	#500 rst_n = 1;
     end

   initial #10000 $finish;
   initial begin
      $dumpfile("k6502_test.vcd");
      $dumpvars(0,k6502_test);
   end

endmodule

       
   

   
       
	       