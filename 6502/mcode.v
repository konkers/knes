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
	// reset
	{8'h00, 6'b000000}: x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_0, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_0, `SYNC_NEXT_1};

	// JMP
	{8'h4C, 6'b000001}: x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_0, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_1, `SYNC_NEXT_0};
	{8'h4C, 6'b000010}: x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_0, `PC_LATCH_L_1, `INC_DL_0, `INC_PC_1, `SYNC_NEXT_0};
	{8'h4C, 6'b000100}: x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_1, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_1, `SYNC_NEXT_1};

	// JMP
	{8'h6C, 6'b000001}: x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_0, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_1, `SYNC_NEXT_0};
	{8'h6C, 6'b000010}: x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_1, `PC_LATCH_H_0, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_1, `SYNC_NEXT_0};
	{8'h6C, 6'b000100}: x <= {`ADDR_MODE_DL, `DL_LATCH_H_1, `DL_LATCH_L_0, `PC_LATCH_H_0, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_1, `SYNC_NEXT_0};
	{8'h6C, 6'b001000}: x <= {`ADDR_MODE_DL, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_0, `PC_LATCH_L_1, `INC_DL_1, `INC_PC_0, `SYNC_NEXT_0};
	{8'h6C, 6'b010000}: x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_1, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_0, `SYNC_NEXT_1};

	// NOP
	{8'hEA, 6'b000001}: x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_0, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_0, `SYNC_NEXT_0};
	{8'hEA, 6'b000010}: x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_0, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_1, `SYNC_NEXT_1};

	default:            x <= {`ADDR_MODE_PC, `DL_LATCH_H_0, `DL_LATCH_L_0, `PC_LATCH_H_0, `PC_LATCH_L_0, `INC_DL_0, `INC_PC_0, `SYNC_NEXT_1};
      endcase
   end
endmodule 
     