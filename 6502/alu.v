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
      if (op_l == `OP_BAD)
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
   assign add_c = op_l == `OP_BAD ? 1'b1 : op_sr[`SR_C];

   assign add_out = arg + data_in + add_c;
   assign add_v = add_out[7] ^ arg[7];
      
   wire [7:0] inc_out;
   assign inc_out = arg + 1;

   wire [7:0] dec_out;
   assign dec_out = arg - 1;

   assign {v, c, data_out} = (op_l == `OP_ADD ? {add_v, add_out} :
			      (op_l == `OP_DEC ? {2'b0, dec_out} : 
			       (op_l == `OP_INC ? {2'b0, inc_out} : 
				(op_l == `OP_TST ? {2'b0, data_in} :
				 (op_l == `OP_BAD ? {add_v, add_out} : 10'h0FF)))));
   
   assign n = data_out[7];
   assign z = ~(data_out[7] | data_out[6] |
		data_out[5] | data_out[4] |
		data_out[3] | data_out[2] |
		data_out[1] | data_out[0]);
   
   assign sr_data = {n, v, 4'b0, z, c};
   
endmodule