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

`define S_XX	6'bxxxxxx

`define S_C0	6'bxxxxx0
`define S_Z0	6'bxxxx0x
`define S_V0	6'bxxx0xx
`define S_N0	6'bxx0xxx

`define S_C1	6'bxxxxx1
`define S_Z1	6'bxxxx1x
`define S_V1	6'bxxx1xx
`define S_N1	6'bxx1xxx

`define S_BN	6'b11xxxx
`define S_BP	6'b10xxxx
`define S_BS	6'b0xxxxx

`define BRXX	8'bxxx10000

module mcode(
    input [7:0]               ir,
    input [7:0] 	      sr, 	      
    input [1:0] 	      b_sr, 	      
    input [5:0]               cycle,
    input 		      rst,
    input 		      nmi,
    input 		      irq,
    output reg [`X_BITS-1:0]  x);

   wire [22:0] 	mcode_state;

   assign mcode_state = {b_sr, sr[`SR_N], sr[`SR_V], sr[`SR_Z], sr[`SR_C], rst, nmi, irq, ir, cycle};
      
   always @(mcode_state) begin
      casex (mcode_state)
	//                                                                                                        A                     D   D   P   P
	//                                 E                                        A                         P                  A      L   L   C   C           S
	//                                 X     U   U   U   U   U   U   U          L                  D      C   D              D                              Y
	//                                 C     P   P   P   P   P   P   P          U                  A          A        R     D      L   L   L   L           N
	//                                 E     D   D   D   D   D   D   D   S            A            T      U   T        E     R      A   A   A   A   I   I   C
	//                                 P     A   A   A   A   A   A   A   R      I     L            A      P   A    R   G            T   T   T   T   N   N    
	//                                 T     T   T   T   T   T   T   T          N     U                   D        E         M      C   C   C   C   C   C   N
	//                                 I     E   E   E   E   E   E   E   S      P                  S      A   S    G   S     O      H   H   H   H           E
	//                                 O                                 E      U     O        R   E      T   E        E     D                      D   P   X
	//                                 N     N   V   B   D   I   Z   C   L      T     P        W   L      E   L    W   L     E      H   L   H   L   L   C   T
	{`S_XX, `RST, 8'hxx, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_FI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `RST, 8'hxx, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_FF, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `O, `O};
	{`S_XX, `RST, 8'hxx, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `O, `O};
	{`S_XX, `RST, 8'hxx, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_DL, `O, `O, `O, `X, `X, `O, `O};
	{`S_XX, `RST, 8'hxx, `C_4}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `X, `AD, `O, `R_N, `A_PC, `O, `O, `X, `O, `O, `O, `X};
	
    	// reset
	{`S_XX, `NON, 8'h00, `C_N}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// ADC imm
	{`S_XX, `NON, 8'h69, `C_0}: x <= {`E_0, `X, `X, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_ADD, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h69, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// ADC abs
	{`S_XX, `NON, 8'h6D, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h6D, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h6D, `C_2}: x <= {`E_0, `X, `X, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_ADD, `R, `D_DI, `O, `AA, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h6D, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// AND imm
	{`S_XX, `NON, 8'h29, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_AND, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h29, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// AND abs
	{`S_XX, `NON, 8'h2D, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h2D, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h2D, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_AND, `R, `D_DI, `O, `AA, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h2D, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// ASL A
	{`S_XX, `NON, 8'h0A, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_ASL, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h0A, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// ASL abs
	{`S_XX, `NON, 8'h0E, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h0E, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h0E, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_D, `OP_ASL, `R, `D_AL, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h0E, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_D, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_D, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h0E, `C_4}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `W, `D_RD, `O, `AD, `O, `R_N, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h0E, `C_5}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};

	// BRANCHES - 
	{`S_XX, `NON, `BRXX, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_L, `OP_BAD, `R, `D_AL, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};

	// BCC C == 0
	{`S_C1, `NON, 8'h90, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	{`S_C0, `NON, 8'h90, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	// BCS C == 1
	{`S_C0, `NON, 8'hB0, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	{`S_C1, `NON, 8'hB0, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	// BEQ Z == 1
	{`S_Z0, `NON, 8'hF0, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	{`S_Z1, `NON, 8'hF0, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	// BMI N == 1
	{`S_N0, `NON, 8'h30, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	{`S_N1, `NON, 8'h30, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	// BNE Z == 0
	{`S_Z1, `NON, 8'hD0, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	{`S_Z0, `NON, 8'hD0, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	// BPL N == 0
	{`S_N1, `NON, 8'h10, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	{`S_N0, `NON, 8'h10, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	// BVC V == 0
	{`S_V1, `NON, 8'h50, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	{`S_V0, `NON, 8'h50, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	// BVS V == 1
	{`S_V0, `NON, 8'h70, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	{`S_V1, `NON, 8'h70, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};

	{`S_BS, `NON, `BRXX, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `X, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	{`S_BN, `NON, `BRXX, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_H, `OP_INC, `R, `D_AL, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_BP, `NON, `BRXX, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_H, `OP_DEC, `R, `D_AL, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};

	{`S_XX, `NON, `BRXX, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `X, `AD, `O, `R_N, `A_PC, `O, `O, `X, `O, `O, `O, `X};

	
	// CLC
	{`S_XX, `NON, 8'h18, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h18, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `X, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// CLD
	{`S_XX, `NON, 8'hD8, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hD8, `C_1}: x <= {`E_0, `O, `O, `O, `X, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// CLI
	{`S_XX, `NON, 8'h58, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h58, `C_1}: x <= {`E_0, `O, `O, `O, `O, `X, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// CLV
	{`S_XX, `NON, 8'hB8, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hB8, `C_1}: x <= {`E_0, `O, `X, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// CMP imm
	{`S_XX, `NON, 8'hC9, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_CMP, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hC9, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// CMP abs
	{`S_XX, `NON, 8'hCD, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hCD, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hCD, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_CMP, `R, `D_DI, `O, `AA, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hCD, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// CPX imm
	{`S_XX, `NON, 8'hE0, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_X, `OP_CMP, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hE0, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// CPX abs
	{`S_XX, `NON, 8'hEC, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hEC, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hEC, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_X, `OP_CMP, `R, `D_DI, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hEC, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// CPY imm
	{`S_XX, `NON, 8'hC0, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_Y, `OP_CMP, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hC0, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// CPY abs
	{`S_XX, `NON, 8'hCC, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hCC, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hCC, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_Y, `OP_CMP, `R, `D_DI, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hCC, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// DEC abs
	{`S_XX, `NON, 8'hCE, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hCE, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hCE, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_D, `OP_DEC, `R, `D_AL, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hCE, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_D, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_D, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hCE, `C_4}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `W, `D_RD, `O, `AD, `O, `R_N, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hCE, `C_5}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// DEX
	{`S_XX, `NON, 8'hCA, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_X, `OP_DEC, `R, `D_AL, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hCA, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_X, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// DEY
	{`S_XX, `NON, 8'h88, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_Y, `OP_DEC, `R, `D_AL, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h88, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_Y, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// EOR imm
	{`S_XX, `NON, 8'h49, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_EOR, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h49, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// EOR abs
	{`S_XX, `NON, 8'h4D, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h4D, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h4D, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_EOR, `R, `D_DI, `O, `AA, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h4D, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// INC abs
	{`S_XX, `NON, 8'hEE, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hEE, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hEE, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_D, `OP_INC, `R, `D_AL, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hEE, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_D, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_D, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hEE, `C_4}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `W, `D_RD, `O, `AD, `O, `R_N, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hEE, `C_5}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// INX
	{`S_XX, `NON, 8'hE8, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_X, `OP_INC, `R, `D_AL, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hE8, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_X, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// INY
	{`S_XX, `NON, 8'hC8, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_Y, `OP_INC, `R, `D_AL, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hC8, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_Y, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// JMP imm
	{`S_XX, `NON, 8'h4C, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
    	{`S_XX, `NON, 8'h4C, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `X, `O, `X, `O};
	{`S_XX, `NON, 8'h4C, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `X, `AD, `O, `R_N, `A_PC, `O, `O, `X, `O, `O, `X, `X};
	// JMP ind
	{`S_XX, `NON, 8'h6C, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h6C, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h6C, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h6C, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_DL, `O, `O, `O, `X, `X, `O, `O};
	{`S_XX, `NON, 8'h6C, `C_4}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `X, `AD, `O, `R_N, `A_PC, `O, `O, `X, `O, `O, `O, `X};
	// LDA imm
	{`S_XX, `NON, 8'hA9, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hA9, `C_1}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// LDA abs
	{`S_XX, `NON, 8'hAD, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAD, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAD, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAD, `C_3}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// LDX imm
	{`S_XX, `NON, 8'hA2, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hA2, `C_1}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_X, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_X, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// LDX abs
	{`S_XX, `NON, 8'hAE, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAE, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAE, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAE, `C_3}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_X, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_X, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// LDY imm
	{`S_XX, `NON, 8'hA0, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hA0, `C_1}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_Y, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_Y, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// LDY abs
	{`S_XX, `NON, 8'hAC, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAC, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAC, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAC, `C_3}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_Y, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_Y, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// LSR A
	{`S_XX, `NON, 8'h4A, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_LSR, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h4A, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// LSR abs
	{`S_XX, `NON, 8'h4E, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h4E, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h4E, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_D, `OP_LSR, `R, `D_AL, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h4E, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_D, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_D, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h4E, `C_4}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `W, `D_RD, `O, `AD, `O, `R_N, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h4E, `C_5}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// NOP
	{`S_XX, `NON, 8'hEA, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hEA, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// ORA imm
	{`S_XX, `NON, 8'h09, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_OR , `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h09, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// ORA abs
	{`S_XX, `NON, 8'h0D, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h0D, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h0D, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_OR , `R, `D_DI, `O, `AA, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h0D, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// ROL A
	{`S_XX, `NON, 8'h2A, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_ROL, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h2A, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// ROL abs
	{`S_XX, `NON, 8'h2E, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h2E, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h2E, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_D, `OP_ROL, `R, `D_AL, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h2E, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_D, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_D, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h2E, `C_4}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `W, `D_RD, `O, `AD, `O, `R_N, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h2E, `C_5}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// ROR A
	{`S_XX, `NON, 8'h6A, `C_0}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_ROR, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h6A, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// ROR abs
	{`S_XX, `NON, 8'h6E, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h6E, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h6E, `C_2}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `X, `SR_A, `A_D, `OP_ROR, `R, `D_AL, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h6E, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_D, `OP_XXX, `R, `D_DI, `O, `AD, `X, `R_D, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h6E, `C_4}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `W, `D_RD, `O, `AD, `O, `R_N, `A_DL, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h6E, `C_5}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// SBC imm
	{`S_XX, `NON, 8'hE9, `C_0}: x <= {`E_0, `X, `X, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_SUB, `R, `D_DI, `O, `AA, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hE9, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// SBC abs
	{`S_XX, `NON, 8'hED, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hED, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hED, `C_2}: x <= {`E_0, `X, `X, `O, `O, `O, `X, `X, `SR_A, `A_A, `OP_SUB, `R, `D_DI, `O, `AA, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hED, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AA, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// SEC
	{`S_XX, `NON, 8'h38, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_F, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h38, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `X, `SR_F, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// SED
	{`S_XX, `NON, 8'hF8, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_F, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'hF8, `C_1}: x <= {`E_0, `O, `O, `O, `X, `O, `O, `O, `SR_F, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// SEI
	{`S_XX, `NON, 8'h78, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_F, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
	{`S_XX, `NON, 8'h78, `C_1}: x <= {`E_0, `O, `O, `O, `O, `X, `O, `O, `SR_F, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `X};
	// STA abs
	{`S_XX, `NON, 8'h8D, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8D, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8D, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `W, `D_RA, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8D, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// STX abs
	{`S_XX, `NON, 8'h8E, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8E, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8E, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `W, `D_RX, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8E, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// STY abs
	{`S_XX, `NON, 8'h8C, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8C, `C_1}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `X, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8C, `C_2}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `W, `D_RY, `O, `AD, `O, `R_N, `A_DL, `X, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8C, `C_3}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// TAX
	{`S_XX, `NON, 8'hAA, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_RA, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hAA, `C_1}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_X, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_X, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// TAY
	{`S_XX, `NON, 8'hA8, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_RA, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'hA8, `C_1}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_Y, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_Y, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// TXA
	{`S_XX, `NON, 8'h8A, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_RX, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h8A, `C_1}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `O, `X};
	// TYA
	{`S_XX, `NON, 8'h98, `C_0}: x <= {`E_0, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_RY, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `X, `O};
	{`S_XX, `NON, 8'h98, `C_1}: x <= {`E_0, `X, `O, `O, `O, `O, `X, `O, `SR_A, `A_A, `OP_TST, `R, `D_DI, `O, `AD, `X, `R_A, `A_PC, `O, `O, `O, `O, `O, `O, `X};


	default:                    x <= {`E_U, `O, `O, `O, `O, `O, `O, `O, `SR_0, `A_N, `OP_XXX, `R, `D_DI, `O, `AD, `O, `R_N, `A_PC, `O, `O, `O, `O, `O, `O, `O};
      endcase
   end
endmodule 
     