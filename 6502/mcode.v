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

`include "k6502_defs.v"

`define O 1'b0
`define X 1'b1

`define A_PC `ADDR_MODE_PC
`define A_DL `ADDR_MODE_DL

module mcode(
    input [7:0]  ir,
    input [5:0]  cycle,
    output [`X_BITS-1:0] x);
   
   wire [7:0] 	ir;
   wire [5:0] 	cycle;
   reg [`X_BITS-1:0] 	x;

   wire [14:0] 	mcode_state;

   assign mcode_state = {ir, cycle};
      
   always @(mcode_state) begin
      case (mcode_state)
	//                                D   D   P   P
	//                         A      L   L   C   C           S
	//                         D                              Y
	//                         D      L   L   L   L           N
	//                         R      A   A   A   A   I   I   C
	//                                T   T   T   T   N   N    
	//                         M      C   C   C   C   C   C   N
	//                         O      H   H   H   H           E
	//                         D                      D   P   X
	//                         E      H   L   H   L   L   C   T
    	// reset
	{8'h00, 6'b000000}: x <= {`A_PC, `O, `O, `O, `O, `O, `X, `X};
	// JMP imm
	{8'h4C, 6'b000001}: x <= {`A_PC, `O, `O, `O, `O, `O, `X, `O};
	{8'h4C, 6'b000010}: x <= {`A_PC, `O, `O, `O, `X, `O, `X, `O};
	{8'h4C, 6'b000100}: x <= {`A_PC, `O, `O, `X, `O, `O, `X, `X};
	// JMP ind
	{8'h6C, 6'b000001}: x <= {`A_PC, `O, `O, `O, `O, `O, `X, `O};
	{8'h6C, 6'b000010}: x <= {`A_PC, `O, `X, `O, `O, `O, `X, `O};
	{8'h6C, 6'b000100}: x <= {`A_DL, `X, `O, `O, `O, `O, `X, `O};
	{8'h6C, 6'b001000}: x <= {`A_DL, `O, `O, `O, `X, `X, `O, `O};
	{8'h6C, 6'b010000}: x <= {`A_PC, `O, `O, `X, `O, `O, `O, `X};
	// NOP
	{8'hEA, 6'b000001}: x <= {`A_PC, `O, `O, `O, `O, `O, `O, `O};
	{8'hEA, 6'b000010}: x <= {`A_PC, `O, `O, `O, `O, `O, `X, `X};

	default:            x <= {`A_PC, `O, `O, `O, `O, `O, `O, `X};
      endcase
   end
endmodule 
     