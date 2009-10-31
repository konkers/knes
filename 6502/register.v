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

module register(
    inout [7:0]  data,
    input 	 latch,
    input 	 oe,
    input 	 rst_n);

   reg [7:0] 	 val;

   assign data = oe ? val : 8'hZZ;

   always @(posedge latch or negedge rst_n) begin
     if (rst_n == 0)
       val <= 8'h00;
     else
       val <= data;
   end
endmodule