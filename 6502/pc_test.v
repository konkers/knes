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

module pc_test;

   reg clk;
   reg rst_n;
   reg [7:0] data;
   reg latch_l;
   reg latch_h;
   reg inc;
   reg sync;
   wire [15:0] addr;
   wire       carry_out_l;
   wire       carry_out_h;

   pc pcl (.addr(addr[7:0]),
	   .carry_in(inc),
	   .carry_out(carry_out_l),
	   .data(data),
	   .latch(latch_l),
	   .sync(sync),
	   .clk(clk),
	   .rst_n(rst_n));
   
   pc pch (.addr(addr[15:8]),
	   .carry_in(carry_out_l),
	   .carry_out(carry_out_h),
	   .data(data),
	   .latch(latch_h),
	   .sync(sync),
	   .clk(clk),
	   .rst_n(rst_n));

   initial // Clock generator
     begin
	clk = 0;
	forever #1 clk = !clk;
     end
   
   initial	// Test stimulus
     begin
	rst_n = 0;
	data = {4'h5, 4'ha};
	latch_h = 0;
	latch_l = 0;
	inc = 1;
	sync = 0;
	#5 rst_n = 1;
	#4 data = 8'hfc; latch_l = 1;
	#2 data = 8'hff; latch_l = 0; latch_h = 1;
	#2 latch_h = 0; latch_l = 0; sync = 1;
	#2 sync = 2;
     end // initial begin

   initial #50 $finish;
   initial begin
      $dumpfile("pc_test.vcd");
      $dumpvars(0,pc_test);
   end
endmodule
  
    

   