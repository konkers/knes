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

`timescale 1ns/1ns

module rom_test;
   reg [15:0] addr;
   tri [7:0]  data;
   reg 	      oe_n;
   reg 	      clk;

   rom rom(.addr(addr),
	   .data(data),
	   .oe_n(oe_n));

   initial // Clock generator
     begin
	clk = 1;
	forever #1 clk = !clk;
     end

   initial	// Test stimulus
     begin
	addr = 16'h0000;
	oe_n = 1'b1;
	#2;
	oe_n = 1'b0;
	#2; addr = 16'h0001;
	#2; addr = 16'h0002;
	#2; addr = 16'h0003;
	#2; addr = 16'h0004;
	#2; addr = 16'h0005;
	#2; addr = 16'h0006;
	#2; addr = 16'h0007;
	#2; addr = 16'h0008;
	#2; addr = 16'h0009;
	#2; addr = 16'h000A;
     end // initial begin

   initial #50 $finish;
   initial begin
      $dumpfile("rom_test.vcd");
      $dumpvars(0,rom_test);
   end

endmodule

   