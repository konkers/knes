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

module data_latch(
    input [7:0]       data_in,
    output reg [15:0] data_out,
    input 	      latch_l,
    input 	      latch_h,
    input 	      inc);

   always @(posedge latch_l or posedge latch_h or posedge inc) begin
      if (latch_l == 1)
	data_out[7:0] = data_in;
      else if (latch_h == 1)
	data_out[15:8] = data_in;
      else if (inc == 1)
	data_out = data_out + 1;
   end
endmodule