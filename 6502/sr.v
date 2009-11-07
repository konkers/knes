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

module sr(
    input clk,
    input rst_n,
    output reg [7:0] sr,
    input [7:0]	     update_mask,	     
    input [1:0]      update_sel,
    input [7:0]      alu_data);

   wire [7:0]	     update_data;

   mux4x8 update_mux(.out(update_data),
		     .sel(update_sel),
		     .in0(8'h00),
		     .in1(8'hFF),
		     .in2(alu_data),
		     .in3(8'hFF));
   
     always @(posedge clk) begin
	if (rst_n == 1'b0)
	  sr <= 8'h34;
	else
	  sr <= (sr & ~update_mask) | (update_data & update_mask);
     end

endmodule
