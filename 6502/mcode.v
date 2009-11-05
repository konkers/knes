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

`define RST	3'b100
`define NMI	3'b010
`define IRQ	3'b001
`define NON	3'b000


module mcode(
    input [7:0]               ir,
    input [5:0]               cycle,
    input 		      rst,
    input 		      nmi,
    input 		      irq,
    output reg [`X_BITS-1:0]  x);

   wire [16:0] 	mcode_state;

   assign mcode_state = {rst,nmi,irq,ir, cycle};
      
   always @(mcode_state) begin
      casex (mcode_state)
	//                                                                         D   D   P   P
	//                          A                         P             A      L   L   C   C           S
	//                          L                  D      C             D                              Y
	//                          U                  A              R     D      L   L   L   L           N
	//                                A            T      U       E     R      A   A   A   A   I   I   C
	//                          I     L            A      P   R   G            T   T   T   T   N   N    
	//                          N     U                   D   E         M      C   C   C   C   C   C   N
	//                          P                  S      A   G   S     O      H   H   H   H           E
	//                          U     O        R   E      T       E     D                      D   P   X
	//                          T     P        W   L      E   W   L     E      H   L   H   L   L   C   T
	{`RST, 8'hxx, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_FI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`RST, 8'hxx, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_FF, `O, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `O, `O};
	{`RST, 8'hxx, `C_2}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `O, `O};
	{`RST, 8'hxx, `C_3}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_DL, `O, `O, `O, `X, `X, `O, `O};
	{`RST, 8'hxx, `C_4}: x <= {`A_N, `OP_XXX, `R, `D_DI, `X, `O, `R_N, `A_PC, `O, `O, `X, `O, `O, `O, `X};
	
    	// reset
	{`NON, 8'h00, `C_N}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// INX
	{`NON, 8'hE8, `C_0}: x <= {`A_X, `OP_INC, `R, `D_AL, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`NON, 8'hE8, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `X, `R_X, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// JMP imm
	{`NON, 8'h4C, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'h4C, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	{`NON, 8'h4C, `C_2}: x <= {`A_N, `OP_XXX, `R, `D_DI, `X, `O, `R_N, `A_PC, `O, `O, `X, `O, `O, `X, `X};
	// JMP ind
	{`NON, 8'h6C, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'h6C, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`NON, 8'h6C, `C_2}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`NON, 8'h6C, `C_3}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_DL, `O, `O, `O, `X, `X, `O, `O};
	{`NON, 8'h6C, `C_4}: x <= {`A_N, `OP_XXX, `R, `D_DI, `X, `O, `R_N, `A_PC, `O, `O, `X, `O, `O, `O, `X};
	// LDA imm
	{`NON, 8'hA9, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'hA9, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// LDA abs
	{`NON, 8'hAD, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'hAD, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`NON, 8'hAD, `C_2}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`NON, 8'hAD, `C_3}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// LDX imm
	{`NON, 8'hA2, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'hA2, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `X, `R_X, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// LDX abs
	{`NON, 8'hAE, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'hAE, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`NON, 8'hAE, `C_2}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`NON, 8'hAE, `C_3}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `X, `R_X, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// LDY imm
	{`NON, 8'hA0, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'hA0, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `X, `R_Y, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// LDY abs
	{`NON, 8'hAC, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'hAC, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`NON, 8'hAC, `C_2}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`NON, 8'hAC, `C_3}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `X, `R_Y, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// NOP
	{`NON, 8'hEA, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`NON, 8'hEA, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// STA abs
	{`NON, 8'h8D, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'h8D, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`NON, 8'h8D, `C_2}: x <= {`A_N, `OP_XXX, `W, `D_RA, `O, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`NON, 8'h8D, `C_3}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// STX abs
	{`NON, 8'h8E, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'h8E, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`NON, 8'h8E, `C_2}: x <= {`A_N, `OP_XXX, `W, `D_RX, `O, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`NON, 8'h8E, `C_3}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// STY abs
	{`NON, 8'h8C, `C_0}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`NON, 8'h8C, `C_1}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`NON, 8'h8C, `C_2}: x <= {`A_N, `OP_XXX, `W, `D_RY, `O, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`NON, 8'h8C, `C_3}: x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};

	default:             x <= {`A_N, `OP_XXX, `R, `D_DI, `O, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
      endcase
   end
endmodule 
     