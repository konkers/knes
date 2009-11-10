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

module k6502(
`ifdef DEBUG
    output [`X_BITS-1:0] debug_x,
    output [15:0] 	 debug_dl, 	 
    output [7:0] 	 debug_ir,
    output [15:0] 	 debug_pc,
    output [7:0] 	 debug_sr,
    output [7:0] 	 debug_ra_data,
    output [7:0] 	 debug_rx_data,
    output [7:0] 	 debug_ry_data,
    output 		 debug_ex,
`endif
    output [15:0] 	 a,
    inout [7:0] 	 d,
    input 		 clk,
    input 		 rst_n,
    output 		 sync,
    output 		 rw
);

   wire [7:0] 		 data;
      
   wire [15:0] 	  dl;
   wire 	  dl_latch_l;
   wire 	  dl_latch_h;
   wire 	  dl_inc;
   	  
   data_latch data_latch(.data_in(data),
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
   wire 	  pc_update;
   
   pc pcl (.addr(pc[7:0]),
	   .carry_in(pc_inc),
	   .carry_out(carry_out_l),
	   .data(data),
	   .latch(pc_latch_l),
	   .update(pc_update),
	   .clk(clk),
	   .rst_n(rst_n));
   
   pc pch (.addr(pc[15:8]),
	   .carry_in(carry_out_l),
	   .carry_out(carry_out_h),
	   .data(data),
	   .latch(pc_latch_h),
	   .update(pc_update),
	   .clk(clk),
	   .rst_n(rst_n));

   wire [7:0] 	  alu_sr;
   wire [7:0] 	  alu_data;

   wire [1:0] 	  reg_sel;
   wire 	  reg_w;
   
   wire 	  ra_latch;
   wire [7:0] 	  ra_data;
   wire  	  ra_data_sel;
   wire [7:0] 	  ra_data_in;
   
   assign ra_latch = (reg_sel == `R_A) && reg_w;
   assign ra_data_in = ra_data_sel == 1'b0 ? data : alu_data;
   
   register ra(.data_in(ra_data_in),
	       .data_out(ra_data),
	       .latch(ra_latch),
	       .clk(clk),
	       .rst_n(rst_n));
   

   wire 	  rx_latch;
   wire [7:0] 	  rx_data;

   assign rx_latch = (reg_sel == `R_X) && reg_w;

   register rx(.data_in(data),
	       .data_out(rx_data),
	       .latch(rx_latch),
	       .clk(clk),
	       .rst_n(rst_n));

   
   wire 	  ry_latch;
   wire [7:0] 	  ry_data;
 	  
   assign ry_latch = (reg_sel == `R_Y) && reg_w;

   register ry(.data_in(data),
	       .data_out(ry_data),
	       .latch(ry_latch),
	       .clk(clk),
	       .rst_n(rst_n));
   
   wire [7:0] 	  sr;
   wire [7:0] 	  sr_update_mask;
   wire [1:0] 	  sr_update_sel;
   
      
   sr sr_reg(.clk(clk),
	     .rst_n(rst_n),
	     .sr(sr),
	     .update_mask(sr_update_mask),
	     .update_sel(sr_update_sel),
	     .alu_data(alu_sr));
      
   wire [`X_BITS-1:0] x;
   wire [7:0] ir;
   wire [5:0] cycle;
   wire [2:0] data_sel;
   wire       rw_in;
   wire [3:0] alu_op;
   wire [2:0] alu_input;
   
   assign next_sync =  x[`X_SYNC_NEXT] & rst_n;
   assign pc_inc =     x[`X_INC_PC] & rst_n;
   assign dl_inc =     x[`X_INC_DL] & rst_n;
   assign pc_latch_l = x[`X_PC_LATCH_L] & rst_n;
   assign pc_latch_h = x[`X_PC_LATCH_H] & rst_n;
   assign dl_latch_l = x[`X_DL_LATCH_L] & rst_n;
   assign dl_latch_h = x[`X_DL_LATCH_H] & rst_n;

   addr_latch addr_latch(.a(a),
			 .clk(clk),
			 .addr_sel(x[`X_ADDR_MODE]),
			 .addr0(pc),
			 .addr1(dl),
			 .addr2(16'hDEAD),
			 .addr3(16'hBEEF));

   assign reg_sel    = x[`X_REG_SEL];
   assign reg_w      = x[`X_REG_W];
   assign ra_data_sel= x[`X_A_DATA_SEL];
   assign pc_update  = x[`X_PC_UPDATE];
   assign data_sel   = x[`X_DATA_SEL];
   assign rw_in      = x[`X_RW];
   assign alu_op     = x[`X_ALU_OP];
   assign alu_input  = x[`X_ALU_INPUT];
   assign sr_update_sel = x[`X_SR_SEL];
   assign sr_update_mask = {x[`X_UPDATE_N],
			    x[`X_UPDATE_V],
			    1'b0,
			    x[`X_UPDATE_B],
			    x[`X_UPDATE_D],
			    x[`X_UPDATE_I],
			    x[`X_UPDATE_Z],
			    x[`X_UPDATE_C]};

   wire       rst;
   wire       nmi;
   wire       irq;

   int_seq int_seq(.clk(clk),
		   .sync(next_sync),
		   .rst_n(rst_n),
		   .nmi_n(1'b1),
		   .irq_n(1'b1),
		   .rst(rst),
		   .nmi(nmi),
		   .irq(irq));
      
   inst_seq inst_seq(.cycle(cycle),
		     .sync(sync),
		     .next_sync(next_sync),
		     .rst_n(rst_n),
		     .clk(clk));

   
   wire [1:0] b_sr;
   
   mcode mcode(.ir(ir),
	       .sr(sr),
	       .b_sr(b_sr),
	       .cycle(cycle),
	       .rst(rst),
	       .nmi(nmi),
	       .irq(irq),
	       .x(x));

   ir ir_reg(.ir(ir),
	     .data(data),
	     .sync(sync),
	     .rst_n(rst_n));

   alu alu(.clk(clk),
	   .data_in(d),
	   .data_out(alu_data),
	   .sr(sr),
	   .sr_data(alu_sr),
	   .b_sr(b_sr),
	   .op(alu_op),
	   .arg_sel(alu_input),
	   .arg0(8'h00),
	   .arg1(ra_data),
	   .arg2(rx_data),
	   .arg3(ry_data),
	   .arg4(pc[7:0]),
	   .arg5(pc[15:8]),
	   .arg6(8'hFF),
	   .arg7(8'hFF));
   
   wire [7:0] fi;
   assign fi = (rst == 1'b1 ? 8'hFC :
		(nmi == 1'b1 ? 8'hFA : 8'hFE));

   data_mux data_mux(.data(data),
		     .clk(clk),
		     .rw(rw),
		     .rw_in(rw_in),
		     .data_sel(data_sel),
		     .data0(d),
		     .data1(ra_data),
		     .data2(rx_data),
		     .data3(ry_data),
		     .data4(8'hFF),
		     .data5(fi),
		     .data6(alu_data),
		     .data7(8'hFF));

   assign d = (rw == `W) ? data : 8'hZZ;

`ifdef DEBUG
   assign debug_x = x;
   assign debug_dl = dl;
   assign debug_ir = ir;
   assign debug_pc = pc;
   assign debug_sr = sr;
   assign debug_ra_data = ra_data;
   assign debug_rx_data = rx_data;
   assign debug_ry_data = ry_data;
   assign debug_ex = x[`X_EXCEPTION];
`endif


   
endmodule