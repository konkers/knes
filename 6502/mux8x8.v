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

module mux8x8(
    output reg [7:0] out,
    input [2:0]      sel,
    input [7:0]      in0,
    input [7:0]      in1,
    input [7:0]      in2,
    input [7:0]      in3,
    input [7:0]      in4,
    input [7:0]      in5,
    input [7:0]      in6,
    input [7:0]      in7);

   always @(sel or in0 or in1 or in2 or in3 or in4 or in5 or in6 or in7) begin
      case (sel)
	3'b000: out <= in0;
	3'b001: out <= in1;
	3'b010: out <= in2;
	3'b011: out <= in3;
	3'b100: out <= in4;
	3'b101: out <= in5;
	3'b110: out <= in6;
	3'b111: out <= in7;
      endcase
   end
   
endmodule

	      