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

module addr_latch(
    output [15:0] a,
    input 	      clk,
    input [1:0]       addr_sel,
    input [15:0]      addr0,
    input [15:0]      addr1,
    input [15:0]      addr2,
    input [15:0]      addr3);
   
   reg [1:0] 	      sel;

   assign a = (sel == 2'b00 ? addr0 :
	       (sel == 2'b01 ? addr1 :
		(sel == 2'b10 ? addr2 :
		 addr3)));
   
   always @(negedge clk) begin
      sel <= addr_sel;
   end
endmodule
		  