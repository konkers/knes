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

`define TRACE

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
   wire [7:0]      sr;
   wire [7:0]      ra_data;
   wire [7:0]      rx_data;
   wire [7:0]      ry_data;
   wire 	   ex;
`endif

   k6502 k6502(
`ifdef DEBUG
	       .debug_x(x),
	       .debug_dl(dl),
	       .debug_ir(ir),
	       .debug_pc(pc),
	       .debug_sr(sr),
	       .debug_ra_data(ra_data),
	       .debug_rx_data(rx_data),
	       .debug_ry_data(ry_data),
	       .debug_ex(ex),
`endif
	       .a(a),
	       .d(d),
	       .clk(clk),
	       .rst_n(rst_n),
	       .sync(sync),
	       .rw(rw));

   rom rom(.addr({1'b0, a[14:0]}),
	   .data(d),
	   .oe_n(rw | ~a[15]));
      
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

`ifdef TRACE
   integer f;
`endif   


   always @(posedge clk) begin
      if (rw == 1'b1) 
	$fdisplay(f, "write %h=%h", a, d);
      if ((rw == 1'b1) && (a == 16'hDEAD))
	$finish;
   end

`ifdef EX
   always @(negedge clk) begin
      if ((rst_n == 1) && (ex == 1))
	$finish;
   end
`endif
   
   initial begin
      $dumpfile("k6502_test.vcd");
      $dumpvars(0,k6502_test);
   end

`ifdef TRACE
   reg [31:0] clk_counter;
   always @(posedge clk) begin
      if (rst_n == 1'b0)
	clk_counter <= 0;
      else
	clk_counter = clk_counter + 1;
   end

   initial begin
      f = $fopen("k6502_test.csv");
      $fdisplay(f, "clk_counter, pc, ir, sr, ra_data, rx_data, ry_data");
   end
   
   always @(posedge sync) begin
      #1 $fdisplay(f, "%d, %h, %h, %h, %h, %h, %h", clk_counter, pc, ir, sr, ra_data, rx_data, ry_data);
   end
`endif

endmodule

       
   

   
       
	       