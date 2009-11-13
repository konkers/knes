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
    input             clk,
    input [7:0]       data_in,
    output reg [15:0]     data_out,
    input 	      latch_l,
    input 	      latch_h,
    input 	      inc);

   wire 	      carry;
   wire [15:0] 	      data_inc;

   wire 	      tmp_l;
   wire 	      tmp_h;

   reg [15:0] 	      data;
      
   assign {carry, data_inc} = data + 1;

   always @(negedge clk) 
     data_out <= inc == 1'b1 ? data_inc : data;
      
   always @(posedge latch_l) begin
      	data[7:0] <= data_in;
   end

   always @(posedge latch_h) begin
      	data[15:8] <= data_in;
   end
 
endmodule
