// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module axi_mem_if_wrap
#(
  parameter AXI_ADDRESS_WIDTH = 32,
  parameter AXI_DATA_WIDTH    = 64,
  parameter AXI_ID_WIDTH      = 16,
  parameter AXI_USER_WIDTH    = 10,
  parameter BUFF_DEPTH_SLAVE  = 2
)
(
  input logic              clk_i,
  input logic              rst_ni,
  input logic              test_en_i,

  AXI_BUS.Slave            axi_slave,

  UNICAD_MEM_BUS_64.Master mem_master
);

  logic [AXI_ADDRESS_WIDTH-1:0] aw_addr;
  logic [AXI_ADDRESS_WIDTH-1:0] ar_addr;

  assign aw_addr = {3'b000, axi_slave.aw_addr[AXI_ADDRESS_WIDTH-1:3]};
  assign ar_addr = {3'b000, axi_slave.ar_addr[AXI_ADDRESS_WIDTH-1:3]};

  axi_mem_if #(
    .AXI4_ADDRESS_WIDTH ( AXI_ADDRESS_WIDTH   ),
    .AXI4_RDATA_WIDTH   ( AXI_DATA_WIDTH      ),
    .AXI4_WDATA_WIDTH   ( AXI_DATA_WIDTH      ),
    .AXI4_ID_WIDTH      ( AXI_ID_WIDTH        ),
    .AXI4_USER_WIDTH    ( AXI_USER_WIDTH      ),
    .BUFF_DEPTH_SLAVE   ( BUFF_DEPTH_SLAVE    )
  ) axi_mem_if_i (
    .ACLK               ( clk_i               ),
    .ARESETn            ( rst_ni              ),
    .test_en_i          ( test_en_i           ),

    .AWVALID_i          ( axi_slave.aw_valid  ),
    .AWADDR_i           ( aw_addr             ),
    .AWPROT_i           ( axi_slave.aw_prot   ),
    .AWREGION_i         ( axi_slave.aw_region ),
    .AWLEN_i            ( axi_slave.aw_len    ),
    .AWSIZE_i           ( axi_slave.aw_size   ),
    .AWBURST_i          ( axi_slave.aw_burst  ),
    .AWLOCK_i           ( axi_slave.aw_lock   ),
    .AWCACHE_i          ( axi_slave.aw_cache  ),
    .AWQOS_i            ( axi_slave.aw_qos    ),
    .AWID_i             ( axi_slave.aw_id     ),
    .AWUSER_i           ( axi_slave.aw_user   ),
    .AWREADY_o          ( axi_slave.aw_ready  ),

    .ARVALID_i          ( axi_slave.ar_valid  ),
    .ARADDR_i           ( ar_addr             ),
    .ARPROT_i           ( axi_slave.ar_prot   ),
    .ARREGION_i         ( axi_slave.ar_region ),
    .ARLEN_i            ( axi_slave.ar_len    ),
    .ARSIZE_i           ( axi_slave.ar_size   ),
    .ARBURST_i          ( axi_slave.ar_burst  ),
    .ARLOCK_i           ( axi_slave.ar_lock   ),
    .ARCACHE_i          ( axi_slave.ar_cache  ),
    .ARQOS_i            ( axi_slave.ar_qos    ),
    .ARID_i             ( axi_slave.ar_id     ),
    .ARUSER_i           ( axi_slave.ar_user   ),
    .ARREADY_o          ( axi_slave.ar_ready  ),

    .RVALID_o           ( axi_slave.r_valid   ),
    .RDATA_o            ( axi_slave.r_data    ),
    .RRESP_o            ( axi_slave.r_resp    ),
    .RLAST_o            ( axi_slave.r_last    ),
    .RID_o              ( axi_slave.r_id      ),
    .RUSER_o            ( axi_slave.r_user    ),
    .RREADY_i           ( axi_slave.r_ready   ),

    .WVALID_i           ( axi_slave.w_valid   ),
    .WDATA_i            ( axi_slave.w_data    ),
    .WSTRB_i            ( axi_slave.w_strb    ),
    .WLAST_i            ( axi_slave.w_last    ),
    .WUSER_i            ( axi_slave.w_user    ),
    .WREADY_o           ( axi_slave.w_ready   ),

    .BVALID_o           ( axi_slave.b_valid   ),
    .BRESP_o            ( axi_slave.b_resp    ),
    .BID_o              ( axi_slave.b_id      ),
    .BUSER_o            ( axi_slave.b_user    ),
    .BREADY_i           ( axi_slave.b_ready   ),

    .CEN                ( mem_master.csn      ),
    .WEN                ( mem_master.wen      ),
    .A                  ( mem_master.add      ),
    .D                  ( mem_master.wdata    ),
    .BE                 ( mem_master.be       ),
    .Q                  ( mem_master.rdata    )
  );

endmodule
