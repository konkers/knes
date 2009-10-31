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

module k6502_test;

   wire [15:0] a;
   wire [7:0]  d;
   reg 	       clk;
   reg 	       rst_n;
   wire        sync;

   k6502 k6502(.a(a),
	       .d(d),
	       .clk(clk),
	       .rst_n(rst_n),
	       .sync(sync));

   rom rom(.addr(a),
	   .data(d),
	   .oe_n(1'b0));
      
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

   initial #5000 $finish;
   initial begin
      $dumpfile("k6502_test.vcd");
      $dumpvars(0,k6502_test);
   end

endmodule

       
   

   
       
	       