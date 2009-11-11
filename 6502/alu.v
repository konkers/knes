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

module alu(
    input        clk,
    input [7:0]  data_in,
    output [7:0] data_out,
    input [7:0]  sr,  
    output [7:0] sr_data,  
    output reg [1:0] b_sr,  
    input [3:0]  op,
    input [2:0]  arg_sel,
    input [7:0]  arg0,   
    input [7:0]  arg1,     
    input [7:0]  arg2,
    input [7:0]  arg3,
    input [7:0]  arg4,
    input [7:0]  arg5,
    input [7:0]  arg6,
    input [7:0]  arg7);


   reg [2:0] 	 sel_l;
   reg [3:0] 	 op_l;
   reg [7:0] 	 op_sr;
   
   wire       n;
   wire       v;
   wire       z;
   wire       c;

  
   always @(negedge clk) begin
      sel_l <= arg_sel;
      op_l <= op;
      op_sr <= sr;
   end

   always @(posedge clk) begin
      if ((op_l == `OP_BAD) || (op_l == `OP_DAD))
	b_sr <= {sr_data[`SR_V], sr_data[`SR_C]};
   end
   
   wire [7:0] arg = (sel_l == 3'b000 ? arg0 :
		     (sel_l == 3'b001 ? arg1 :
		      (sel_l == 3'b010 ? arg2 : 
		       (sel_l == 3'b011 ? arg3 :
			(sel_l == 3'b100 ? arg4 :
			 (sel_l == 3'b101 ? arg5 :
			  (sel_l == 3'b110 ? arg6 : arg7)))))));

   wire [8:0] add_out;
   wire       add_v;
   wire       add_c;
   assign add_c = (op_l == `OP_BAD ? 1'b1 : 
		   (op_l == `OP_DAD ? 1'b0 :
		    (op_l == `OP_ADD ? 1'b0 : op_sr[`SR_C])));

   assign add_out = arg + data_in + add_c;
   assign add_v = data_in[7] == 0 ? ~arg[7] & add_out[7] :
		  arg[7] & ~add_out[7];

   
   wire [7:0] and_out;
   assign and_out = arg & data_in;

   wire [8:0] asl_out;
   assign asl_out = {arg, 1'b0};
      
   wire [8:0] cmp_out;
   assign cmp_out = arg - data_in;
      
   wire [7:0] dec_out;
   assign dec_out = arg - 1;

   wire [7:0] eor_out;
   assign eor_out = arg ^ data_in;

   wire [7:0] inc_out;
   assign inc_out = arg + 1;

   wire [8:0] lsr_out;
   assign lsr_out = {arg[0], 1'b0, arg[7:1]};

   wire [7:0] or_out;
   assign or_out = arg | data_in;
   
   wire [8:0] rol_out;
   assign rol_out = {arg[7:0], op_sr[`SR_C]};

   wire [8:0] ror_out;
   assign ror_out = {arg[0], op_sr[`SR_C], arg[7:1]};

   wire [8:0] sub_out;
   wire       sub_v;
   wire       sub_c;
   assign sub_c = ~op_sr[`SR_C];

   assign sub_out = (arg - data_in) - sub_c ;
   assign sub_v = data_in[7] == 1 ? ~arg[7] & sub_out[7] :
		  arg[7] & ~sub_out[7];
   
   assign {v, c, data_out} = (op_l == `OP_ADC ? {add_v, add_out} :
			      (op_l == `OP_AND ? {2'b0, and_out} : 
			       (op_l == `OP_ASL ? {1'b0, asl_out} : 
				(op_l == `OP_CMP ? {1'b0, cmp_out} : 
				 (op_l == `OP_DEC ? {2'b0, dec_out} : 
				  (op_l == `OP_EOR ? {2'b0, eor_out} : 
				   (op_l == `OP_INC ? {2'b0, inc_out} : 
				    (op_l == `OP_LSR ? {1'b0, lsr_out} : 
				     (op_l == `OP_OR  ? {2'b0, or_out } : 
				      (op_l == `OP_ROL ? {1'b0, rol_out} : 
				       (op_l == `OP_ROR ? {1'b0, ror_out} : 
					(op_l == `OP_SBC ? {sub_v, sub_out} :
					 (op_l == `OP_TST ? {2'b0, arg} :
					  (op_l == `OP_BAD ? {add_v, add_out} : 
					   (op_l == `OP_DAD ? {add_v, add_out} : 
					    {add_v, add_out} )))))))))))))));
      
   assign n = data_out[7];
   assign z = ~(data_out[7] | data_out[6] |
		data_out[5] | data_out[4] |
		data_out[3] | data_out[2] |
		data_out[1] | data_out[0]);
   
   assign sr_data = {n, v, 4'b0, z, c};
   
endmodule