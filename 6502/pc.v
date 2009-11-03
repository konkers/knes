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

module pc (
    output reg [7:0] addr,
    input 	     carry_in,
    output 	     carry_out,
    input [7:0]      data,
    input 	     latch,
    input 	     update,
    input 	     clk,
    input 	     rst_n);

   reg [7:0] 	     new_addr;
   wire [7:0] 	     addr_inc;
       
   assign {carry_out, addr_inc} = addr + carry_in;

   always @ (negedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
	   addr <= 8'h00;
	end else if (update == 1'b1) begin
	   addr <= new_addr;
	end else begin
	   addr <= addr_inc;
	end
   end

   always @(posedge latch)
     begin
	new_addr <= data;
     end
endmodule