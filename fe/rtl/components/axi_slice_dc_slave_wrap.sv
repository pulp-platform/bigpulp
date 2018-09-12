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

module axi_slice_dc_slave_wrap
  #(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_USER_WIDTH = 6,
    parameter AXI_ID_WIDTH   = 10,
    parameter BUFFER_WIDTH   = 8
   )
  (
    input logic	         clk_i,
    input logic	         rst_ni,
    input logic          test_cgbypass_i,
    input logic          isolate_i,

    AXI_BUS.Slave        axi_slave,

    AXI_BUS_ASYNC.Master axi_master_async
  );

  logic s_b_valid;
  logic s_b_ready;

  logic s_r_valid;
  logic s_r_ready;

  assign axi_slave.b_valid = isolate_i ? 1'b0 : s_b_valid;
  assign s_b_ready = isolate_i ? 1'b1 : axi_slave.b_ready;

  assign axi_slave.r_valid = isolate_i ? 1'b0 : s_r_valid;
  assign s_r_ready = isolate_i ? 1'b1 : axi_slave.r_ready;

  axi_slice_dc_slave #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH ),
    .AXI_ID_WIDTH   ( AXI_ID_WIDTH   ),
    .BUFFER_WIDTH   ( BUFFER_WIDTH   )
  ) axi_slice_i (
    .clk_i                     ( clk_i                                    ),
    .rst_ni                    ( rst_ni                                   ),
    .test_cgbypass_i           ( test_cgbypass_i                          ),

    .axi_slave_aw_valid        ( axi_slave.aw_valid                       ),
    .axi_slave_aw_addr         ( axi_slave.aw_addr                        ),
    .axi_slave_aw_prot         ( axi_slave.aw_prot                        ),
    .axi_slave_aw_region       ( axi_slave.aw_region                      ),
    .axi_slave_aw_len          ( axi_slave.aw_len                         ),
    .axi_slave_aw_size         ( axi_slave.aw_size                        ),
    .axi_slave_aw_burst        ( axi_slave.aw_burst                       ),
    .axi_slave_aw_lock         ( axi_slave.aw_lock                        ),
    .axi_slave_aw_cache        ( axi_slave.aw_cache                       ),
    .axi_slave_aw_qos          ( axi_slave.aw_qos                         ),
    .axi_slave_aw_id           ( axi_slave.aw_id[AXI_ID_WIDTH-1:0]        ),
    .axi_slave_aw_user         ( axi_slave.aw_user                        ),
    .axi_slave_aw_ready        ( axi_slave.aw_ready                       ),

    .axi_slave_ar_valid        ( axi_slave.ar_valid                       ),
    .axi_slave_ar_addr         ( axi_slave.ar_addr                        ),
    .axi_slave_ar_prot         ( axi_slave.ar_prot                        ),
    .axi_slave_ar_region       ( axi_slave.ar_region                      ),
    .axi_slave_ar_len          ( axi_slave.ar_len                         ),
    .axi_slave_ar_size         ( axi_slave.ar_size                        ),
    .axi_slave_ar_burst        ( axi_slave.ar_burst                       ),
    .axi_slave_ar_lock         ( axi_slave.ar_lock                        ),
    .axi_slave_ar_cache        ( axi_slave.ar_cache                       ),
    .axi_slave_ar_qos          ( axi_slave.ar_qos                         ),
    .axi_slave_ar_id           ( axi_slave.ar_id[AXI_ID_WIDTH-1:0]        ),
    .axi_slave_ar_user         ( axi_slave.ar_user                        ),
    .axi_slave_ar_ready        ( axi_slave.ar_ready                       ),

    .axi_slave_w_valid         ( axi_slave.w_valid                        ),
    .axi_slave_w_data          ( axi_slave.w_data                         ),
    .axi_slave_w_strb          ( axi_slave.w_strb                         ),
    .axi_slave_w_user          ( axi_slave.w_user                         ),
    .axi_slave_w_last          ( axi_slave.w_last                         ),
    .axi_slave_w_ready         ( axi_slave.w_ready                        ),

    .axi_slave_r_valid         ( s_r_valid                                ),
    .axi_slave_r_data          ( axi_slave.r_data                         ),
    .axi_slave_r_resp          ( axi_slave.r_resp                         ),
    .axi_slave_r_last          ( axi_slave.r_last                         ),
    .axi_slave_r_id            ( axi_slave.r_id[AXI_ID_WIDTH-1:0]         ),
    .axi_slave_r_user          ( axi_slave.r_user                         ),
    .axi_slave_r_ready         ( s_r_ready                                ),

    .axi_slave_b_valid         ( s_b_valid                                ),
    .axi_slave_b_resp          ( axi_slave.b_resp                         ),
    .axi_slave_b_id            ( axi_slave.b_id[AXI_ID_WIDTH-1:0]         ),
    .axi_slave_b_user          ( axi_slave.b_user                         ),
    .axi_slave_b_ready         ( s_b_ready                                ),

    .axi_master_aw_addr        ( axi_master_async.aw_addr                 ),
    .axi_master_aw_prot        ( axi_master_async.aw_prot                 ),
    .axi_master_aw_region      ( axi_master_async.aw_region               ),
    .axi_master_aw_len         ( axi_master_async.aw_len                  ),
    .axi_master_aw_size        ( axi_master_async.aw_size                 ),
    .axi_master_aw_burst       ( axi_master_async.aw_burst                ),
    .axi_master_aw_lock        ( axi_master_async.aw_lock                 ),
    .axi_master_aw_cache       ( axi_master_async.aw_cache                ),
    .axi_master_aw_qos         ( axi_master_async.aw_qos                  ),
    .axi_master_aw_id          ( axi_master_async.aw_id[AXI_ID_WIDTH-1:0] ),
    .axi_master_aw_user        ( axi_master_async.aw_user                 ),
    .axi_master_aw_writetoken  ( axi_master_async.aw_writetoken           ),
    .axi_master_aw_readpointer ( axi_master_async.aw_readpointer          ),

    .axi_master_ar_addr        ( axi_master_async.ar_addr                 ),
    .axi_master_ar_prot        ( axi_master_async.ar_prot                 ),
    .axi_master_ar_region      ( axi_master_async.ar_region               ),
    .axi_master_ar_len         ( axi_master_async.ar_len                  ),
    .axi_master_ar_size        ( axi_master_async.ar_size                 ),
    .axi_master_ar_burst       ( axi_master_async.ar_burst                ),
    .axi_master_ar_lock        ( axi_master_async.ar_lock                 ),
    .axi_master_ar_cache       ( axi_master_async.ar_cache                ),
    .axi_master_ar_qos         ( axi_master_async.ar_qos                  ),
    .axi_master_ar_id          ( axi_master_async.ar_id[AXI_ID_WIDTH-1:0] ),
    .axi_master_ar_user        ( axi_master_async.ar_user                 ),
    .axi_master_ar_writetoken  ( axi_master_async.ar_writetoken           ),
    .axi_master_ar_readpointer ( axi_master_async.ar_readpointer          ),

    .axi_master_w_data         ( axi_master_async.w_data                  ),
    .axi_master_w_strb         ( axi_master_async.w_strb                  ),
    .axi_master_w_user         ( axi_master_async.w_user                  ),
    .axi_master_w_last         ( axi_master_async.w_last                  ),
    .axi_master_w_writetoken   ( axi_master_async.w_writetoken            ),
    .axi_master_w_readpointer  ( axi_master_async.w_readpointer           ),

    .axi_master_r_data         ( axi_master_async.r_data                  ),
    .axi_master_r_resp         ( axi_master_async.r_resp                  ),
    .axi_master_r_last         ( axi_master_async.r_last                  ),
    .axi_master_r_id           ( axi_master_async.r_id[AXI_ID_WIDTH-1:0]  ),
    .axi_master_r_user         ( axi_master_async.r_user                  ),
    .axi_master_r_writetoken   ( axi_master_async.r_writetoken            ),
    .axi_master_r_readpointer  ( axi_master_async.r_readpointer           ),

    .axi_master_b_resp         ( axi_master_async.b_resp                  ),
    .axi_master_b_id           ( axi_master_async.b_id[AXI_ID_WIDTH-1:0]  ),
    .axi_master_b_user         ( axi_master_async.b_user                  ),
    .axi_master_b_writetoken   ( axi_master_async.b_writetoken            ),
    .axi_master_b_readpointer  ( axi_master_async.b_readpointer           )
  );

endmodule
