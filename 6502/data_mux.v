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

module data_mux(
    output [7:0] data,
    input 	 clk,
    output reg 	 rw,
    input 	 rw_in,
    input [2:0]  data_sel,
    input [7:0]  data0,
    input [7:0]  data1,
    input [7:0]  data2,
    input [7:0]  data3,
    input [7:0]  data4,
    input [7:0]  data5,
    input [7:0]  data6,
    input [7:0]  data7);

   reg [2:0] 	 sel;

   assign data = (sel == 3'b000 ? data0 : 
		  (sel == 3'b001 ? data1 : 
		   (sel == 3'b010 ? data2 : 
		    (sel == 3'b011 ? data3 : 
		     (sel == 3'b100 ? data4 : 
		      (sel == 3'b101 ? data5 : 
		       (sel == 3'b110 ? data6 : data7)))))));

   always @(negedge clk) begin
      sel <= data_sel;
      rw <= rw_in;
   end

   
endmodule
		   