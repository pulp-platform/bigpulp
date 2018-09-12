// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module l2_mem
#(
  parameter MEM_ADDR_WIDTH = 1,
  parameter NB_BANKS       = 2,
  parameter BANK_SIZE      = 4096
)
(
  input logic                 clk_i,
  input logic                 rst_ni,
  input logic                 test_en_i,

  UNICAD_MEM_BUS_64.Slave     mem_slave
);

`ifdef PULP_FPGA_SIM

  l2_generic #(
    .MEM_ADDR_WIDTH ( MEM_ADDR_WIDTH )
  ) l2_generic_i (
    .CLK   ( clk_i                             ),
    .RSTN  ( rst_ni                            ),
    .INITN ( 1'b1                              ),
    .D     ( mem_slave.wdata                   ),
    .A     ( mem_slave.add[MEM_ADDR_WIDTH-1:0] ),
    .CEN   ( mem_slave.csn                     ),
    .WEN   ( mem_slave.wen                     ),
    .BE    ( mem_slave.be                      ),
    .Q     ( mem_slave.rdata                   ),
    .WM    ( 2'b0                              ),
    .RM    ( 3'b0                              ),
    .TM    ( test_en_i                         )
  );

`else

  SyncSpRamBeNx64 #(
    .ADDR_WIDTH ( MEM_ADDR_WIDTH    ),
    .DATA_DEPTH ( 2**MEM_ADDR_WIDTH ),
    .OUT_REGS   ( 0                 )
  ) SyncSpRamBeNx64_i (
    .Clk_CI    ( clk_i                             ),
    .Rst_RBI   ( rst_ni                            ),
    .CSel_SI   ( ~mem_slave.csn                    ),
    .WrEn_SI   ( ~mem_slave.wen                    ),
    .BEn_SI    ( mem_slave.be                      ),
    .Addr_DI   ( mem_slave.add[MEM_ADDR_WIDTH-1:0] ),
    .WrData_DI ( mem_slave.wdata                   ),
    .RdData_DO ( mem_slave.rdata                   )
  );

`endif

endmodule
