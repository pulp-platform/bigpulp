// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "pulp_soc_defines.sv"

module axi_id_remap_wrap
#(
  parameter AXI_ADDR_WIDTH   = 32,
  parameter AXI_DATA_WIDTH   = 64,
  parameter AXI_USER_WIDTH   = 6,
  parameter AXI_ID_IN_WIDTH  = 6,
  parameter AXI_ID_OUT_WIDTH = 6,
  parameter AXI_ID_SLOT      = 16
)
(
  input logic	   clk_i,
  input logic	   rst_ni,

  AXI_BUS.Slave  axi_slave,

  AXI_BUS.Master axi_master
);

  axi_id_remap #(
    .AXI_ADDRESS_W ( AXI_ADDR_WIDTH   ),
    .AXI_DATA_W    ( AXI_DATA_WIDTH   ),
    .AXI_USER_W    ( AXI_USER_WIDTH   ),
    .AXI_ID_IN     ( AXI_ID_IN_WIDTH  ),
    .AXI_ID_OUT    ( AXI_ID_OUT_WIDTH ),
    .ID_SLOT       ( AXI_ID_SLOT      )
  ) axi_id_remap_i (
    .clk             ( clk_i                                  ),
    .rst_n           ( rst_ni                                 ),

    .targ_awvalid_i  ( axi_slave.aw_valid                     ),
    .targ_awaddr_i   ( axi_slave.aw_addr                      ),
    .targ_awprot_i   ( axi_slave.aw_prot                      ),
    .targ_awregion_i ( axi_slave.aw_region                    ),
    .targ_awlen_i    ( axi_slave.aw_len                       ),
    .targ_awsize_i   ( axi_slave.aw_size                      ),
    .targ_awburst_i  ( axi_slave.aw_burst                     ),
    .targ_awlock_i   ( axi_slave.aw_lock                      ),
    .targ_awcache_i  ( axi_slave.aw_cache                     ),
    .targ_awqos_i    ( axi_slave.aw_qos                       ),
    .targ_awid_i     ( axi_slave.aw_id[AXI_ID_IN_WIDTH-1:0]   ),
    .targ_awuser_i   ( axi_slave.aw_user                      ),
    .targ_awready_o  ( axi_slave.aw_ready                     ),

    .targ_arvalid_i  ( axi_slave.ar_valid                     ),
    .targ_araddr_i   ( axi_slave.ar_addr                      ),
    .targ_arprot_i   ( axi_slave.ar_prot                      ),
    .targ_arregion_i ( axi_slave.ar_region                    ),
    .targ_arlen_i    ( axi_slave.ar_len                       ),
    .targ_arsize_i   ( axi_slave.ar_size                      ),
    .targ_arburst_i  ( axi_slave.ar_burst                     ),
    .targ_arlock_i   ( axi_slave.ar_lock                      ),
    .targ_arcache_i  ( axi_slave.ar_cache                     ),
    .targ_arqos_i    ( axi_slave.ar_qos                       ),
    .targ_arid_i     ( axi_slave.ar_id[AXI_ID_IN_WIDTH-1:0]   ),
    .targ_aruser_i   ( axi_slave.ar_user                      ),
    .targ_arready_o  ( axi_slave.ar_ready                     ),

    .targ_wvalid_i   ( axi_slave.w_valid                      ),
    .targ_wdata_i    ( axi_slave.w_data                       ),
    .targ_wstrb_i    ( axi_slave.w_strb                       ),
    .targ_wuser_i    ( axi_slave.w_user                       ),
    .targ_wlast_i    ( axi_slave.w_last                       ),
    .targ_wready_o   ( axi_slave.w_ready                      ),

    .targ_rvalid_o   ( axi_slave.r_valid                      ),
    .targ_rdata_o    ( axi_slave.r_data                       ),
    .targ_rresp_o    ( axi_slave.r_resp                       ),
    .targ_rlast_o    ( axi_slave.r_last                       ),
    .targ_rid_o      ( axi_slave.r_id[AXI_ID_IN_WIDTH-1:0]    ),
    .targ_ruser_o    ( axi_slave.r_user                       ),
    .targ_rready_i   ( axi_slave.r_ready                      ),

    .targ_bvalid_o   ( axi_slave.b_valid                      ),
    .targ_bresp_o    ( axi_slave.b_resp                       ),
    .targ_bid_o      ( axi_slave.b_id[AXI_ID_IN_WIDTH-1:0]    ),
    .targ_buser_o    ( axi_slave.b_user                       ),
    .targ_bready_i   ( axi_slave.b_ready                      ),

    .init_awvalid_o  ( axi_master.aw_valid                    ),
    .init_awaddr_o   ( axi_master.aw_addr                     ),
    .init_awprot_o   ( axi_master.aw_prot                     ),
    .init_awregion_o ( axi_master.aw_region                   ),
    .init_awlen_o    ( axi_master.aw_len                      ),
    .init_awsize_o   ( axi_master.aw_size                     ),
    .init_awburst_o  ( axi_master.aw_burst                    ),
    .init_awlock_o   ( axi_master.aw_lock                     ),
    .init_awcache_o  ( axi_master.aw_cache                    ),
    .init_awqos_o    ( axi_master.aw_qos                      ),
    .init_awid_o     ( axi_master.aw_id[AXI_ID_OUT_WIDTH-1:0] ),
    .init_awuser_o   ( axi_master.aw_user                     ),
    .init_awready_i  ( axi_master.aw_ready                    ),

    .init_arvalid_o  ( axi_master.ar_valid                    ),
    .init_araddr_o   ( axi_master.ar_addr                     ),
    .init_arprot_o   ( axi_master.ar_prot                     ),
    .init_arregion_o ( axi_master.ar_region                   ),
    .init_arlen_o    ( axi_master.ar_len                      ),
    .init_arsize_o   ( axi_master.ar_size                     ),
    .init_arburst_o  ( axi_master.ar_burst                    ),
    .init_arlock_o   ( axi_master.ar_lock                     ),
    .init_arcache_o  ( axi_master.ar_cache                    ),
    .init_arqos_o    ( axi_master.ar_qos                      ),
    .init_arid_o     ( axi_master.ar_id[AXI_ID_OUT_WIDTH-1:0] ),
    .init_aruser_o   ( axi_master.ar_user                     ),
    .init_arready_i  ( axi_master.ar_ready                    ),

    .init_wvalid_o   ( axi_master.w_valid                     ),
    .init_wdata_o    ( axi_master.w_data                      ),
    .init_wstrb_o    ( axi_master.w_strb                      ),
    .init_wuser_o    ( axi_master.w_user                      ),
    .init_wlast_o    ( axi_master.w_last                      ),
    .init_wready_i   ( axi_master.w_ready                     ),

    .init_rvalid_i   ( axi_master.r_valid                     ),
    .init_rdata_i    ( axi_master.r_data                      ),
    .init_rresp_i    ( axi_master.r_resp                      ),
    .init_rlast_i    ( axi_master.r_last                      ),
    .init_rid_i      ( axi_master.r_id[AXI_ID_OUT_WIDTH-1:0]  ),
    .init_ruser_i    ( axi_master.r_user                      ),
    .init_rready_o   ( axi_master.r_ready                     ),

    .init_bvalid_i   ( axi_master.b_valid                     ),
    .init_bresp_i    ( axi_master.b_resp                      ),
    .init_bid_i      ( axi_master.b_id[AXI_ID_OUT_WIDTH-1:0]  ),
    .init_buser_i    ( axi_master.b_user                      ),
    .init_bready_o   ( axi_master.b_ready                     )
  );

endmodule
