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
    input [3:0]  op,
    input [1:0]  arg_sel,
    input [7:0]  arg0,   
    input [7:0]  arg1,     
    input [7:0]  arg2,
    input [7:0]  arg3);


   reg 	[1:0]	 sel_l;
   reg 	[3:0]	 op_l;

   wire       n;
   wire       v;
   wire       z;
   wire       c;

  
   always @(negedge clk) begin
      sel_l <= arg_sel;
      op_l <= op;
   end
   
   wire [7:0] arg = (sel_l == 2'b00 ? arg0 :
		     (sel_l == 2'b01 ? arg1 :
		      (sel_l == 2'b10 ? arg2 : arg3)));


   wire [7:0] inc_out;
   assign inc_out = arg + 1;

   assign {v, c, data_out} = (op_l == `OP_INC ? {2'b0, inc_out} : 
			      (op_l == `OP_TST ? {2'b0, data_in} : 10'h0FF));
   
   assign n = data_out[7];
   assign z = ~(data_out[7] | data_out[6] |
		data_out[5] | data_out[4] |
		data_out[3] | data_out[2] |
		data_out[1] | data_out[0]);
   
   assign sr_data = {n, v, 4'b0, z, c};
   
endmodule