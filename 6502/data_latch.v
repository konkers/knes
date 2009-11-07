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

module data_latch(
    input [7:0]       data_in,
    output reg [15:0] data_out,
    input 	      latch_l,
    input 	      latch_h,
    input 	      inc);

   wire 	      carry;
   wire [15:0] 	      data_inc;

   wire 	      tmp_l;
   wire 	      tmp_h;
   
   
   assign {carry, data_inc} = data_out + 1;
   assign tmp_l = latch_l | inc;
   assign tmp_h = latch_h | inc;

   always @(posedge tmp_l) begin
      if (inc == 1'b0)
	data_out[7:0] <= data_in;
      else
	data_out[7:0] <= data_inc[7:0];
   end
 
   always @(posedge tmp_h) begin
      if (inc == 1'b0)
	data_out[15:8] <= data_in;
      else
	data_out[15:8] <= data_inc[15:8];
   end
 
endmodule
