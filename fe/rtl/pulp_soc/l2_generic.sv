// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module l2_generic
#(
  parameter MEM_ADDR_WIDTH = 13
)
(
  input logic                       CLK,
  input logic                       RSTN,
  input logic                       INITN,

  input logic                       CEN,
  input logic                       WEN,
  input logic  [MEM_ADDR_WIDTH-1:0] A,
  input logic  [63:0]               D,
  input logic  [7:0]                BE,
  output logic [63:0]               Q,
  input logic  [1:0]                WM,
  input logic  [2:0]                RM,

  input logic                       TM
);

  logic s_cen;
  logic s_wen;

  // GENERATION OF CEN
  always_comb
    begin
      s_cen = 1'b1;
      if (CEN == 1'b0)
        s_cen = 1'b0;
    end

  // GENERATION OF WEN
  always_comb
    begin
      s_wen = 1'b1;
      if (WEN == 1'b0)
        s_wen = 1'b0;
    end

  // MEMORY CUTS
  generic_memory #(
    .ADDR_WIDTH ( MEM_ADDR_WIDTH )
  ) cut_lo (
    .CLK        ( CLK      ),
    .INITN      ( INITN    ),
    .CEN        ( s_cen    ),
    .A          ( A        ),
    .WEN        ( s_wen    ),
    .D          ( D[31:0]  ),
    .BEN        ( ~BE[3:0] ),
    .Q          ( Q[31:0]  )
  );

  generic_memory #(
    .ADDR_WIDTH ( MEM_ADDR_WIDTH )
  ) cut_hi (
    .CLK        ( CLK      ),
    .INITN      ( INITN    ),
    .CEN        ( s_cen    ),
    .A          ( A        ),
    .WEN        ( s_wen    ),
    .D          ( D[63:32] ),
    .BEN        ( ~BE[7:4] ),
    .Q          ( Q[63:32] )
  );

endmodule
