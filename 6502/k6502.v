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

`include "k6502_defs.v"

module k6502(
    output [15:0] a,
    inout [7:0]   d,
    input 	  clk,
    input 	  rst_n,
    output 	  sync);


   wire [15:0] 	  a;
   tri [7:0] 	  d;
   wire 	  clk;
   wire 	  rst_n;
   wire 	  sync;
 	  
   assign d = 8'hZZ;


   wire [15:0] 	  dl;
   wire 	  dl_latch_l;
   wire 	  dl_latch_h;
   wire 	  dl_inc;
   	  
   data_latch data_latch(.data_in(d),
			 .data_out(dl),
			 .latch_l(dl_latch_l),
			 .latch_h(dl_latch_h),
			 .inc(dl_inc));
      
   wire [15:0] 	  pc;
   wire 	  pc_inc;
   wire 	  carry_out_l;
   wire 	  carry_out_h;
   wire 	  pc_latch_l;
   wire 	  pc_latch_h;
   wire		  next_sync;

   
   pc pcl (.addr(pc[7:0]),
	   .carry_in(pc_inc),
	   .carry_out(carry_out_l),
	   .data(d),
	   .latch(pc_latch_l),
	   .sync(next_sync),
	   .clk(clk),
	   .rst_n(rst_n));
   
   pc pch (.addr(pc[15:8]),
	   .carry_in(carry_out_l),
	   .carry_out(carry_out_h),
	   .data(d),
	   .latch(pc_latch_h),
	   .sync(next_sync),
	   .clk(clk),
	   .rst_n(rst_n));

   wire [`X_BITS-1:0] x;
   wire [5:0] cycle;
   wire [7:0] ir;
   
   assign next_sync =  x[`X_SYNC_NEXT] & rst_n;
   assign pc_inc =     x[`X_INC_PC] & rst_n;
   assign dl_inc =     x[`X_INC_DL] & rst_n;
   assign pc_latch_l = x[`X_PC_LATCH_L] & rst_n;
   assign pc_latch_h = x[`X_PC_LATCH_H] & rst_n;
   assign dl_latch_l = x[`X_DL_LATCH_L] & rst_n;
   assign dl_latch_h = x[`X_DL_LATCH_H] & rst_n;

   assign a = (x[`X_ADDR_MODE] == `ADDR_MODE_PC) ? pc :
	      ((x[`X_ADDR_MODE] == `ADDR_MODE_DL) ? dl :
	       16'hCAFE);
      
   inst_seq inst_seq(.cycle(cycle),
		     .sync(sync),
		     .next_sync(next_sync),
		     .clk(clk));

   mcode mcode(.ir(ir),
	       .cycle(cycle),
	       .x(x));

   ir ir(.ir(ir),
	 .data(d),
	 .sync(sync),
	 .rst_n(rst_n));


endmodule