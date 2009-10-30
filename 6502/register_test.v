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

module register_test;


   tri [7:0] data;
   reg [7:0] data_val;
   reg 	     data_oe;
   reg 	     latch;
   reg 	     oe;
   reg 	     clk;
   reg 	     rst_n;

   assign data = data_oe ? data_val : 8'hZZ;
      
   register  register   (.data(data),
			 .latch(latch),
			 .oe(oe),
			 .rst_n(rst_n));

   initial // Clock generator
     begin
	clk = 1;
	forever #1 clk = !clk;
     end
   
   initial	// Test stimulus
     begin
	data_val = 8'h00;
	data_oe = 1;
		rst_n = 0;
	latch = 0;
	oe = 0;

	#2 rst_n = 1;
	#2 oe = 1;
	#2 oe = 0;
	#2 data_val = 8'h5A; data_oe = 1; latch = 1;
	#2 data_oe = 0; latch = 0;
	#2 oe = 1;
	#2 oe = 0;
	#2 data_val = 8'hA5; data_oe = 1; latch = 1;
	#2 data_oe = 0; latch = 0;

	#2 oe = 1;
	#2 oe = 0;
     end

   initial #30 $finish;

   initial begin
      $dumpfile("register_test.vcd");
      $dumpvars(0,register_test);
   end
endmodule
  
    

