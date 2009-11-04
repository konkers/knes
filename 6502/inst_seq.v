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

module inst_seq(
    output reg [5:0] cycle,
    output reg 	     sync,
    input 	     next_sync,
    input 	     rst_n,
    input 	     clk);

   always @(posedge clk) begin
      if (rst_n == 1'b0) begin
	 cycle <= 6'b000000;
      end else if (next_sync == 1) begin
	 cycle <= 6'b000001;
      end else if (cycle == 6'b000000) begin
	 cycle <= 6'b000001;
      end else begin
	 cycle[5:0] <= {cycle[4:0],1'b0};
      end
      sync <= next_sync;
   end
endmodule