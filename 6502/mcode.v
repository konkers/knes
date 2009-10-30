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

`define O	1'b0
`define X	1'b1

`define A_PC	`ADDR_MODE_PC
`define A_DL	`ADDR_MODE_DL

`define C_N	6'b000000
`define C_0	6'b000001
`define C_1	6'b000010
`define C_2	6'b000100
`define C_3	6'b001000
`define C_4	6'b010000
`define C_5	6'b100000

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
	//                                         D   D   P   P
	//                                  A      L   L   C   C           S
	//                                  D                              Y
	//                            R     D      L   L   L   L           N
	//                            E     R      A   A   A   A   I   I   C
	//                    R   R   G            T   T   T   T   N   N    
	//                    E   E         M      C   C   C   C   C   C   N
	//                    G   G   S     O      H   H   H   H           E
	//                            E     D                      D   P   X
	//                    W   R   L     E      H   L   H   L   L   C   T
    	// reset
	{8'h00, `C_N}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// JMP imm
	{8'h4C, `C_0}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{8'h4C, `C_1}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	{8'h4C, `C_2}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `X, `O, `O, `X, `X};
	// JMP ind
	{8'h6C, `C_0}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{8'h6C, `C_1}: x <= {`O, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{8'h6C, `C_2}: x <= {`O, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{8'h6C, `C_3}: x <= {`O, `O, `R_N, `A_DL, `O, `O, `O, `X, `X, `O, `O};
	{8'h6C, `C_4}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `X, `O, `O, `O, `X};
	// LDA imm
	{8'hA9, `C_0}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{8'hA9, `C_1}: x <= {`X, `O, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// LDX imm
	{8'hA2, `C_0}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{8'hA2, `C_1}: x <= {`X, `O, `R_X, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// LDY imm
	{8'hA0, `C_0}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{8'hA0, `C_1}: x <= {`X, `O, `R_Y, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// NOP
	{8'hEA, `C_0}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{8'hEA, `C_1}: x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};

	default:       x <= {`O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
      endcase
   end
endmodule 
     