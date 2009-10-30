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

module ir_test;
   wire [7:0] ir;
   reg [7:0]  data;
   reg 	      sync;
   reg 	      rst_n;
   reg 	      clk;
 	      
   ir ir(.ir(ir),
	 .data(data),
	 .sync(sync),
	 .rst_n(rst_n));

   initial // Clock generator
     begin
	clk = 1;
	forever #1 clk = !clk;
     end

   initial	// Test stimulus
     begin
	data = 8'h5a;
	sync = 1'b0;
	rst_n = 1'b0;
	#2;
	rst_n = 1'b1;
	#2; sync = 1'b1;
	#2; sync = 1'b0; data = 8'ha5;
	#4
	#2; sync = 1'b1;
	#2; sync = 1'b0; data = 8'h5a;
     end // initial begin

   initial #50 $finish;
   initial begin
      $dumpfile("ir_test.vcd");
      $dumpvars(0,ir_test);
   end

endmodule
