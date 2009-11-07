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

module mux4x8_test;
   wire [7:0] out;
   reg [1:0]  sel;
   reg [7:0]  in0;
   reg [7:0]  in1;
   reg [7:0]  in2;
   reg [7:0]  in3;

   reg 	      clk;
   
   mux4x8 mux4x8(.out(out),
		 .sel(sel),
		 .in0(in0),
		 .in1(in1),
		 .in2(in2),
		 .in3(in3));

   initial // Clock generator
     begin
	clk = 1;
	forever #1 clk = !clk;
     end

   initial	// Test stimulus
     begin
	sel = 2'b00;
	in0 = 8'h00; in1 = 8'h5a; in2 = 8'ha5; in3 = 8'hff;
	#2; in3 = 8'h00; in2 = 8'h5a; in1 = 8'ha5; in0 = 8'hff;

	#2; in0 = 8'h00; in1 = 8'h5a; in2 = 8'ha5; in3 = 8'hff;
	sel = 2'b01;
	#2; in3 = 8'h00; in2 = 8'h5a; in1 = 8'ha5; in0 = 8'hff;

	#2; in0 = 8'h00; in1 = 8'h5a; in2 = 8'ha5; in3 = 8'hff;
	sel = 2'b10;
	#2; in3 = 8'h00; in2 = 8'h5a; in1 = 8'ha5; in0 = 8'hff;

	#2; in0 = 8'h00; in1 = 8'h5a; in2 = 8'ha5; in3 = 8'hff;
	sel = 2'b11;
	#2; in3 = 8'h00; in2 = 8'h5a; in1 = 8'ha5; in0 = 8'hff;
     end // initial begin

   initial #50 $finish;
   initial begin
      $dumpfile("mux4x8_test.vcd");
      $dumpvars(0,mux4x8_test);
   end

endmodule
