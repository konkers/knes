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
`define DEBUG

`define X_SYNC_NEXT	0

`define X_INC_PC	1

`define X_INC_DL	2

`define X_PC_LATCH_L	3

`define X_PC_LATCH_H	4

`define X_DL_LATCH_L	5

`define X_DL_LATCH_H	6

`define X_ADDR_MODE	8:7
`define   ADDR_MODE_PC    2'b00
`define   ADDR_MODE_DL    2'b01

`define X_REG_SEL       10:9
`define   R_N             2'b00
`define   R_X             2'b00
`define   R_Y             2'b01
`define   R_A             2'b10

`define X_REG_W		11

`define X_PC_UPDATE	12

`define X_DATA_SEL      15:13
`define   D_DI            3'h0
`define   D_RA            3'h1
`define   D_RX            3'h2
`define   D_RY            3'h3

`define X_RW		16
`define   R               1'b0
`define   W               1'b1

`define X_BITS		17