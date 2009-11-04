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

`include "6502/k6502_defs.v"

module neek(input clk,
    output reg [3:0] led);

   reg [3:0] 	     rst_seq;
   reg [24:0] 	     clk_div;

   initial begin
      clk_div = 25'h0000000;
      led = 4'h0;
      rst_seq = 4'b0001;
   end
      
   always @(posedge clk)
     clk_div <= clk_div + 1;

   wire k6502_clk;
   wire rst;
   
   assign k6502_clk = clk_div[21];
   assign rst = rst_seq[0] & rst_seq[1] & rst_seq[2] & rst_seq[3];
   
   always @(posedge k6502_clk) begin
      rst_seq = {rst_seq[3:1], 1'b0};
   end
   
   wire [15:0] a;
   wire [7:0]  d;
   wire        sync;
   wire        rw;
`ifdef DEBUG
   wire [`X_BITS-1:0] x;
   wire [15:0] 	      pc;
   wire [15:0]      dl;
   wire [7:0]      ir;
`endif

      k6502 k6502(
`ifdef DEBUG
	       .x(x),
	       .pc(pc),
	       .dl(dl),
	       .ir(ir),
`endif
	       .a(a),
	       .d(d),
	       .clk(k6502_clk),
	       .rst_n(~rst),
	       .sync(sync),
	       .rw(rw));

   rom rom(.addr({1'b0, a[14:0]}),
	   .data(d),
	   .oe_n(rw & a[15]));

   always @(posedge k6502_clk) begin
     if (rw == 1'b1)
       led <= ~d[3:0];
   end
   
endmodule