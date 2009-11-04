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

module int_seq(
    input clk,
    input sync,
    input  rst_n,
    input  nmi_n,
    input  irq_n,
    output rst,
    output nmi,
    output irq);

   reg 	      rst_latch;
   
   assign {rst, nmi, irq} = (rst_latch == 1'b1 ? 3'b100 :
			     (nmi_n == 1'b0 ? 3'b010 :
			      (irq_n == 1'b0 ? 3'b001 : 3'b000)));
   
   always @(negedge clk) begin
      if (rst_n == 1'b0)
	rst_latch = 1'b1;
      else if (sync == 1'b1)
	rst_latch = 1'b0;
   end
     
endmodule
