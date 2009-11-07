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

module mux4x8(
    output reg [7:0] out,
    input [1:0]      sel,
    input [7:0]      in0,
    input [7:0]      in1,
    input [7:0]      in2,
    input [7:0]      in3);

   always @(sel or in0 or in1 or in2 or in3) begin
      case (sel)
	2'b00: out <= in0;
	2'b01: out <= in1;
	2'b10: out <= in2;
	2'b11: out <= in3;
      endcase
   end
   
endmodule

	      