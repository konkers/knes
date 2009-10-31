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

   wire [1:0] 	  reg_sel;
   wire 	  reg_r;
   wire 	  reg_w;
   
   wire 	  ra_latch;
   wire 	  ra_oe;

   assign ra_latch = (reg_sel == `R_A) && reg_w;
   assign ra_oe    = (reg_sel == `R_A) && reg_r;

   register ra(.data(d),
	       .latch(ra_latch),
	       .oe(ra_oe),
	       .rst_n(rst_n));
   

   wire 	  rx_latch;
   wire 	  rx_oe;

   assign rx_latch = (reg_sel == `R_X) && reg_w;
   assign rx_oe    = (reg_sel == `R_X) && reg_r;

   register rx(.data(d),
	       .latch(rx_latch),
	       .oe(rx_oe),
	       .rst_n(rst_n));

   
   wire 	  ry_latch;
   wire 	  ry_oe;

   assign ry_latch = (reg_sel == `R_Y) && reg_w;
   assign ry_oe    = (reg_sel == `R_Y) && reg_r;

   register ry(.data(d),
	       .latch(ry_latch),
	       .oe(ry_oe),
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

   assign reg_sel    = x[`X_REG_SEL];
   assign reg_r      = x[`X_REG_R];
   assign reg_w      = x[`X_REG_W];
   
      
   inst_seq inst_seq(.cycle(cycle),
		     .sync(sync),
		     .next_sync(next_sync),
		     .clk(clk));

   mcode mcode(.ir(ir),
	       .cycle(cycle),
	       .x(x));

   ir ir_reg(.ir(ir),
	     .data(d),
	     .sync(sync),
	     .rst_n(rst_n));


endmodule