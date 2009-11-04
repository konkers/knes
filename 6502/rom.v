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

module rom (
    input [15:0] addr,
    inout [7:0]  data,
    input 	 oe_n);

   reg [7:0] 	 rom[0:(32 * 1024 - 1)];
   
   assign data = (oe_n == 1'b0) ? rom[addr] : 8'hZZZZ;
   
   initial $readmemh("rom.txt", rom);
endmodule
	    