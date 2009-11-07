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

module register(
    input [7:0]       data_in,
    output reg [7:0]  data_out,
    input 	      latch,
    input 	      clk,
    input 	      rst_n);

   reg [7:0] 	      pre_data;
   
   always @(negedge clk) begin
      data_out <= pre_data;
   end
   
   always @(posedge latch or negedge rst_n) begin
     if (rst_n == 0)
       pre_data <= 8'h00;
     else
       pre_data <= data_in;
   end
endmodule