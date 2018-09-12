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

module pulp_soc

// Parameters {{{
#(
  parameter AXI_EXT_ADDR_WIDTH     = `AXI_EXT_ADDR_WIDTH,
  parameter AXI_ADDR_WIDTH         = 32,
  parameter AXI_DATA_WIDTH         = 64,
  parameter AXI_STRB_WIDTH         = AXI_DATA_WIDTH/8,
  parameter AXI_USER_WIDTH         = 6,

  parameter AXI_LITE_ADDR_WIDTH    = 16,
  parameter AXI_LITE_DATA_WIDTH    = `AXI_LITE_DATA_WIDTH,

  parameter AXI_ID_EXT_S_WIDTH     = `AXI_ID_EXT_S_WIDTH,
  parameter AXI_ID_EXT_S_ACP_WIDTH = `AXI_ID_EXT_S_ACP_WIDTH,
  parameter AXI_ID_EXT_M_WIDTH     = `AXI_ID_EXT_M_WIDTH,

  parameter AXI_ID_SOC_S_WIDTH     = `AXI_ID_SOC_S_WIDTH,
  parameter AXI_ID_SOC_M_WIDTH     = `AXI_ID_SOC_M_WIDTH,

  parameter NB_CLUSTERS            = `NB_CLUSTERS,
  parameter NB_CORES               = `NB_CORES,
  parameter BUFFER_WIDTH           = 8,
  parameter NB_L2_BANKS            = 4,
  parameter L2_BANK_SIZE           = 8192, // in 64-bit words --> 256KB
  parameter L2_MEM_ADDR_WIDTH      = $clog2(L2_BANK_SIZE * NB_L2_BANKS)
)
// }}}

// Ports {{{
(
  input logic                               clk_cluster_i,        // Clock
  input logic                               clk_soc_i,            // Clock
  input logic                               clk_soc_non_gated_i,  // Clock

  input logic                               rst_n,  // Asynchronous reset active low

  input  logic                              test_mode_i,
  input  logic                              mode_select_i,
  input  logic            [NB_CLUSTERS-1:0] fetch_en_i,
  output logic            [NB_CLUSTERS-1:0] eoc_o,
  output logic            [NB_CLUSTERS-1:0] cluster_busy_o,

  // uart
  input  logic                              uart_rx_i,
  output logic                              uart_tx_o,
  output logic                              uart_rts_no,
  output logic                              uart_dtr_no,
  input  logic                              uart_cts_ni,
  input  logic                              uart_dsr_ni,

`ifdef JUNO
  // stdout AXI port
  output logic                              stdout_master_aw_valid,
  output logic                              stdout_master_aw_lock,
  input  logic                              stdout_master_aw_ready,
  output logic                              stdout_master_ar_valid,
  output logic                              stdout_master_ar_lock,
  input  logic                              stdout_master_ar_ready,
  output logic                              stdout_master_w_valid,
  output logic                              stdout_master_w_last,
  input  logic                              stdout_master_w_ready,
  input  logic                              stdout_master_r_valid,
  input  logic                              stdout_master_r_last,
  output logic                              stdout_master_r_ready,
  input  logic                              stdout_master_b_valid,
  output logic                              stdout_master_b_ready,
  output logic         [AXI_ADDR_WIDTH-1:0] stdout_master_aw_addr,
  output logic                        [2:0] stdout_master_aw_prot,
  output logic                        [3:0] stdout_master_aw_region,
  output logic                        [7:0] stdout_master_aw_len,
  output logic                        [2:0] stdout_master_aw_size,
  output logic                        [1:0] stdout_master_aw_burst,
  output logic                        [3:0] stdout_master_aw_cache,
  output logic                        [3:0] stdout_master_aw_qos,
  output logic                        [9:0] stdout_master_aw_id,
  output logic         [AXI_USER_WIDTH-1:0] stdout_master_aw_user,
  output logic         [AXI_ADDR_WIDTH-1:0] stdout_master_ar_addr,
  output logic                        [2:0] stdout_master_ar_prot,
  output logic                        [3:0] stdout_master_ar_region,
  output logic                        [7:0] stdout_master_ar_len,
  output logic                        [2:0] stdout_master_ar_size,
  output logic                        [1:0] stdout_master_ar_burst,
  output logic                        [3:0] stdout_master_ar_cache,
  output logic                        [3:0] stdout_master_ar_qos,
  output logic                        [9:0] stdout_master_ar_id,
  output logic         [AXI_USER_WIDTH-1:0] stdout_master_ar_user,
  output logic         [AXI_DATA_WIDTH-1:0] stdout_master_w_data,
  output logic         [AXI_STRB_WIDTH-1:0] stdout_master_w_strb,
  output logic         [AXI_USER_WIDTH-1:0] stdout_master_w_user,
  input  logic         [AXI_DATA_WIDTH-1:0] stdout_master_r_data,
  input  logic                        [1:0] stdout_master_r_resp,
  input  logic                        [9:0] stdout_master_r_id,
  input  logic         [AXI_USER_WIDTH-1:0] stdout_master_r_user,
  input  logic                        [1:0] stdout_master_b_resp,
  input  logic                        [9:0] stdout_master_b_id,
  input  logic         [AXI_USER_WIDTH-1:0] stdout_master_b_user,
`endif // JUNO

  // Host -> RAB
  input  logic                              rab_slave_aw_valid,
  input  logic         [AXI_ADDR_WIDTH-1:0] rab_slave_aw_addr,
  input  logic                        [2:0] rab_slave_aw_prot,
  input  logic                        [3:0] rab_slave_aw_region,
  input  logic                        [7:0] rab_slave_aw_len,
  input  logic                        [2:0] rab_slave_aw_size,
  input  logic                        [1:0] rab_slave_aw_burst,
  input  logic                              rab_slave_aw_lock,
  input  logic                        [3:0] rab_slave_aw_cache,
  input  logic                        [3:0] rab_slave_aw_qos,
  input  logic     [AXI_ID_EXT_M_WIDTH-1:0] rab_slave_aw_id,
  input  logic         [AXI_USER_WIDTH-1:0] rab_slave_aw_user,
  output logic                              rab_slave_aw_ready,
  input  logic                              rab_slave_ar_valid,
  input  logic         [AXI_ADDR_WIDTH-1:0] rab_slave_ar_addr,
  input  logic                        [2:0] rab_slave_ar_prot,
  input  logic                        [3:0] rab_slave_ar_region,
  input  logic                        [7:0] rab_slave_ar_len,
  input  logic                        [2:0] rab_slave_ar_size,
  input  logic                        [1:0] rab_slave_ar_burst,
  input  logic                              rab_slave_ar_lock,
  input  logic                        [3:0] rab_slave_ar_cache,
  input  logic                        [3:0] rab_slave_ar_qos,
  input  logic     [AXI_ID_EXT_M_WIDTH-1:0] rab_slave_ar_id,
  input  logic         [AXI_USER_WIDTH-1:0] rab_slave_ar_user,
  output logic                              rab_slave_ar_ready,
  input  logic                              rab_slave_w_valid,
  input  logic         [AXI_DATA_WIDTH-1:0] rab_slave_w_data,
  input  logic         [AXI_STRB_WIDTH-1:0] rab_slave_w_strb,
  input  logic         [AXI_USER_WIDTH-1:0] rab_slave_w_user,
  input  logic                              rab_slave_w_last,
  output logic                              rab_slave_w_ready,
  output logic                              rab_slave_r_valid,
  output logic         [AXI_DATA_WIDTH-1:0] rab_slave_r_data,
  output logic                        [1:0] rab_slave_r_resp,
  output logic                              rab_slave_r_last,
  output logic     [AXI_ID_EXT_M_WIDTH-1:0] rab_slave_r_id,
  output logic         [AXI_USER_WIDTH-1:0] rab_slave_r_user,
  input  logic                              rab_slave_r_ready,
  output logic                              rab_slave_b_valid,
  output logic                        [1:0] rab_slave_b_resp,
  output logic     [AXI_ID_EXT_M_WIDTH-1:0] rab_slave_b_id,
  output logic         [AXI_USER_WIDTH-1:0] rab_slave_b_user,
  input  logic                              rab_slave_b_ready,

  // RAB -> Host
  output logic                              rab_master_aw_valid,
  output logic     [AXI_EXT_ADDR_WIDTH-1:0] rab_master_aw_addr,
  output logic                        [2:0] rab_master_aw_prot,
  output logic                        [3:0] rab_master_aw_region,
  output logic                        [7:0] rab_master_aw_len,
  output logic                        [2:0] rab_master_aw_size,
  output logic                        [1:0] rab_master_aw_burst,
  output logic                              rab_master_aw_lock,
  output logic                        [3:0] rab_master_aw_cache,
  output logic                        [3:0] rab_master_aw_qos,
  output logic     [AXI_ID_EXT_S_WIDTH-1:0] rab_master_aw_id,
  output logic         [AXI_USER_WIDTH-1:0] rab_master_aw_user,
  input  logic                              rab_master_aw_ready,
  output logic                              rab_master_ar_valid,
  output logic     [AXI_EXT_ADDR_WIDTH-1:0] rab_master_ar_addr,
  output logic                        [2:0] rab_master_ar_prot,
  output logic                        [3:0] rab_master_ar_region,
  output logic                        [7:0] rab_master_ar_len,
  output logic                        [2:0] rab_master_ar_size,
  output logic                        [1:0] rab_master_ar_burst,
  output logic                              rab_master_ar_lock,
  output logic                        [3:0] rab_master_ar_cache,
  output logic                        [3:0] rab_master_ar_qos,
  output logic     [AXI_ID_EXT_S_WIDTH-1:0] rab_master_ar_id,
  output logic         [AXI_USER_WIDTH-1:0] rab_master_ar_user,
  input  logic                              rab_master_ar_ready,
  output logic                              rab_master_w_valid,
  output logic         [AXI_DATA_WIDTH-1:0] rab_master_w_data,
  output logic         [AXI_STRB_WIDTH-1:0] rab_master_w_strb,
  output logic         [AXI_USER_WIDTH-1:0] rab_master_w_user,
  output logic                              rab_master_w_last,
  input  logic                              rab_master_w_ready,
  input  logic                              rab_master_r_valid,
  input  logic         [AXI_DATA_WIDTH-1:0] rab_master_r_data,
  input  logic                        [1:0] rab_master_r_resp,
  input  logic                              rab_master_r_last,
  input  logic     [AXI_ID_EXT_S_WIDTH-1:0] rab_master_r_id,
  input  logic         [AXI_USER_WIDTH-1:0] rab_master_r_user,
  output logic                              rab_master_r_ready,
  input  logic                              rab_master_b_valid,
  input  logic                        [1:0] rab_master_b_resp,
  input  logic     [AXI_ID_EXT_S_WIDTH-1:0] rab_master_b_id,
  input  logic         [AXI_USER_WIDTH-1:0] rab_master_b_user,
  output logic                              rab_master_b_ready,

`ifdef EN_ACP
  // RAB -> Host (ACP)
  output logic                              rab_acp_aw_valid,
  output logic     [AXI_EXT_ADDR_WIDTH-1:0] rab_acp_aw_addr,
  output logic                        [2:0] rab_acp_aw_prot,
  output logic                        [3:0] rab_acp_aw_region,
  output logic                        [7:0] rab_acp_aw_len,
  output logic                        [2:0] rab_acp_aw_size,
  output logic                        [1:0] rab_acp_aw_burst,
  output logic                              rab_acp_aw_lock,
  output logic                        [3:0] rab_acp_aw_cache,
  output logic                        [3:0] rab_acp_aw_qos,
  output logic [AXI_ID_EXT_S_ACP_WIDTH-1:0] rab_acp_aw_id,
  output logic         [AXI_USER_WIDTH-1:0] rab_acp_aw_user,
  input  logic                              rab_acp_aw_ready,
  output logic                              rab_acp_ar_valid,
  output logic     [AXI_EXT_ADDR_WIDTH-1:0] rab_acp_ar_addr,
  output logic                        [2:0] rab_acp_ar_prot,
  output logic                        [3:0] rab_acp_ar_region,
  output logic                        [7:0] rab_acp_ar_len,
  output logic                        [2:0] rab_acp_ar_size,
  output logic                        [1:0] rab_acp_ar_burst,
  output logic                              rab_acp_ar_lock,
  output logic                        [3:0] rab_acp_ar_cache,
  output logic                        [3:0] rab_acp_ar_qos,
  output logic [AXI_ID_EXT_S_ACP_WIDTH-1:0] rab_acp_ar_id,
  output logic         [AXI_USER_WIDTH-1:0] rab_acp_ar_user,
  input  logic                              rab_acp_ar_ready,
  output logic                              rab_acp_w_valid,
  output logic         [AXI_DATA_WIDTH-1:0] rab_acp_w_data,
  output logic         [AXI_STRB_WIDTH-1:0] rab_acp_w_strb,
  output logic         [AXI_USER_WIDTH-1:0] rab_acp_w_user,
  output logic                              rab_acp_w_last,
  input  logic                              rab_acp_w_ready,
  input  logic                              rab_acp_r_valid,
  input  logic         [AXI_DATA_WIDTH-1:0] rab_acp_r_data,
  input  logic                        [1:0] rab_acp_r_resp,
  input  logic                              rab_acp_r_last,
  input  logic [AXI_ID_EXT_S_ACP_WIDTH-1:0] rab_acp_r_id,
  input  logic         [AXI_USER_WIDTH-1:0] rab_acp_r_user,
  output logic                              rab_acp_r_ready,
  input  logic                              rab_acp_b_valid,
  input  logic                        [1:0] rab_acp_b_resp,
  input  logic [AXI_ID_EXT_S_ACP_WIDTH-1:0] rab_acp_b_id,
  input  logic         [AXI_USER_WIDTH-1:0] rab_acp_b_user,
  output logic                              rab_acp_b_ready,
`endif

  // Host -> RAB config
  input  logic    [AXI_LITE_ADDR_WIDTH-1:0] rab_lite_aw_addr,
  input  logic                              rab_lite_aw_valid,
  output logic                              rab_lite_aw_ready,
  input  logic    [AXI_LITE_DATA_WIDTH-1:0] rab_lite_w_data,
  input  logic  [AXI_LITE_DATA_WIDTH/8-1:0] rab_lite_w_strb,
  input  logic                              rab_lite_w_valid,
  output logic                              rab_lite_w_ready,
  output logic                        [1:0] rab_lite_b_resp,
  output logic                              rab_lite_b_valid,
  input  logic                              rab_lite_b_ready,
  input  logic    [AXI_LITE_ADDR_WIDTH-1:0] rab_lite_ar_addr,
  input  logic                              rab_lite_ar_valid,
  output logic                              rab_lite_ar_ready,
  output logic    [AXI_LITE_DATA_WIDTH-1:0] rab_lite_r_data,
  output logic                        [1:0] rab_lite_r_resp,
  output logic                              rab_lite_r_valid,
  input  logic                              rab_lite_r_ready,

`ifdef RAB_AX_LOG_EN
  // Host -> RAB Memory Logs
  input  logic                              RabArBramClk_CI,
  input  logic                              RabArBramRst_RI,
  input  logic                              RabArBramEn_SI,
  input  logic                     [32-1:0] RabArBramAddr_SI,
  output logic                     [32-1:0] RabArBramRd_DO,
  input  logic                     [32-1:0] RabArBramWr_DI,
  input  logic                     [ 4-1:0] RabArBramWrEn_SI,
  input  logic                              RabAwBramClk_CI,
  input  logic                              RabAwBramRst_RI,
  input  logic                              RabAwBramEn_SI,
  input  logic                     [32-1:0] RabAwBramAddr_SI,
  output logic                     [32-1:0] RabAwBramRd_DO,
  input  logic                     [32-1:0] RabAwBramWr_DI,
  input  logic                     [ 4-1:0] RabAwBramWrEn_SI,

  // RAB Logger Control
  input  logic                              RabLogEn_SI,
  input  logic                              RabArLogClr_SI,
  input  logic                              RabAwLogClr_SI,
  output logic                              RabArLogRdy_SO,
  output logic                              RabAwLogRdy_SO,
`endif

  // interrupts
`ifdef RAB_AX_LOG_EN
  output logic                              intr_rab_ar_log_full_o,
  output logic                              intr_rab_aw_log_full_o,
`endif
  output logic                              intr_mailbox_o,
  output logic                              intr_rab_miss_o,
  output logic                              intr_rab_multi_o,
  output logic                              intr_rab_prot_o,
  output logic                              intr_rab_mhf_full_o

);
// }}}

  localparam EVNT_WIDTH = 8;

  logic                                     rstn_soc_sync;
  logic                                     rstn_cluster_sync;
  logic [NB_CLUSTERS-1:0][BUFFER_WIDTH-1:0] cluster_events_wt;
  logic [NB_CLUSTERS-1:0][BUFFER_WIDTH-1:0] cluster_events_rp;
  logic [NB_CLUSTERS-1:0][BUFFER_WIDTH-1:0] cluster_events_da;

  // Interface Declarations {{{
  // Host -> RAB
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_EXT_M_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) s_rab_slave();

  // RAB -> Host
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_EXT_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_EXT_S_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) s_rab_master();

`ifdef RAB_AX_LOG_EN
  // Host -> RAB Memory Logs
  BramPort #(
    .DATA_BITW  ( 32                    ),
    .ADDR_BITW  ( `RAB_AX_LOG_ADDR_BITW )
  ) RabArBram_PS();
  BramPort #(
    .DATA_BITW  ( 32                    ),
    .ADDR_BITW  ( `RAB_AX_LOG_ADDR_BITW )
  ) RabAwBram_PS();
`endif

`ifdef EN_ACP
  // RAB -> Host (ACP)
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_EXT_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH         ),
    .AXI_ID_WIDTH   ( AXI_ID_EXT_S_ACP_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH         )
  ) s_rab_acp();
`endif

  // Host -> RAB config
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AXI_LITE_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_LITE_DATA_WIDTH )
  ) s_rab_lite_from_host();

  // Crossbar -> RAB Config Port
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AXI_LITE_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_LITE_DATA_WIDTH )
  ) s_rab_lite();

  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) soc_bus_to_apb();

  // DC-FIFO -> SoC-Bus
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_S_WIDTH  ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH      )
  ) s_data_master_bus[NB_CLUSTERS]();

  // Cluster -> DC-FIFO
  AXI_BUS_ASYNC #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_S_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     ),
    .BUFFER_WIDTH   ( BUFFER_WIDTH       )
  ) s_data_master_bus_async[NB_CLUSTERS]();

  // SoC-Bus -> ID Remapper
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH  ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH      )
  ) s_data_slave_bus[NB_CLUSTERS]();

  // ID Remapper -> DC-FIFO
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH   ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH   ),
    .AXI_ID_WIDTH   ( 4                ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH   )
  ) s_data_slave_bus_id_remapped[NB_CLUSTERS]();

  // DC-FIFO -> Cluster
  AXI_BUS_ASYNC #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( 4                  ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     ),
    .BUFFER_WIDTH   ( BUFFER_WIDTH       )
  ) s_data_slave_bus_async[NB_CLUSTERS]();

  //AXI BUS FROM SOC_BUS to L2
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) s_soc_l2_bus();

  // AXI BUS From SOCBUS to RAB
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) s_socbus_to_rab();

  // AXI BUS From SOCBUS to Converter for RAB Config Port
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) s_socbus_to_rab_cfg();

  // AXILite BUS From Converter to RAB Config Port Crossbar
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( AXI_LITE_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_LITE_DATA_WIDTH )
  ) s_socbus_to_rab_cfg_conv();

  // AXI BUS From RAB to SOCBUS
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_S_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) s_rab_to_socbus();

  // AXI BUS From SOCBUS to Mailbox
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) s_socbus_to_mailbox();

`ifdef JUNO
  // AXI STDOUT
  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) stdout_master();
`endif // JUNO

  // Interfavce between L2_ram_IF and BRAM
  UNICAD_MEM_BUS_64 s_soc_l2_mem();

  // }}}

  genvar i,j;
  generate

  // AXI_RAB {{{
  //  █████╗ ██╗  ██╗██╗        ██████╗  █████╗ ██████╗
  // ██╔══██╗╚██╗██╔╝██║        ██╔══██╗██╔══██╗██╔══██╗
  // ███████║ ╚███╔╝ ██║        ██████╔╝███████║██████╔╝
  // ██╔══██║ ██╔██╗ ██║        ██╔══██╗██╔══██║██╔══██╗
  // ██║  ██║██╔╝ ██╗██║███████╗██║  ██║██║  ██║██████╔╝
  // ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝
  axi_rab_wrap #(
    .AXI_EXT_ADDR_WIDTH     ( AXI_EXT_ADDR_WIDTH     ),
    .AXI_INT_ADDR_WIDTH     ( AXI_ADDR_WIDTH         ),
    .AXI_DATA_WIDTH         ( AXI_DATA_WIDTH         ),
    .AXI_USER_WIDTH         ( AXI_USER_WIDTH         ),
    .AXI_LITE_ADDR_WIDTH    ( AXI_LITE_ADDR_WIDTH    ),
    .AXI_LITE_DATA_WIDTH    ( AXI_LITE_DATA_WIDTH    ),
    .AXI_ID_EXT_S_WIDTH     ( AXI_ID_EXT_S_WIDTH     ),
    .AXI_ID_EXT_S_ACP_WIDTH ( AXI_ID_EXT_S_ACP_WIDTH ),
    .AXI_ID_EXT_M_WIDTH     ( AXI_ID_EXT_M_WIDTH     ),
    .AXI_ID_SOC_S_WIDTH     ( AXI_ID_SOC_S_WIDTH     ),
    .AXI_ID_SOC_M_WIDTH     ( AXI_ID_SOC_M_WIDTH     ),
    .N_PORTS                ( `RAB_N_PORTS           ),
    .N_L2_SETS              ( `RAB_L2_N_SETS         ),
    .N_L2_SET_ENTRIES       ( `RAB_L2_N_SET_ENTRIES  )
  ) axi_rab_wrap_i (
    .clk_i              ( clk_soc_i              ),
    .non_gated_clk_i    ( clk_soc_non_gated_i    ),
    .rst_ni             ( rstn_soc_sync          ),

    .rab_to_socbus      ( s_rab_to_socbus        ),
    .socbus_to_rab      ( s_socbus_to_rab        ),

    .rab_master         ( s_rab_master           ),

`ifdef EN_ACP
    .rab_acp            ( s_rab_acp              ),
`endif

    .rab_slave          ( s_rab_slave            ),

    .rab_lite           ( s_rab_lite             ),

`ifdef RAB_AX_LOG_EN
    .ArBram_PS          ( RabArBram_PS           ),
    .AwBram_PS          ( RabAwBram_PS           ),

    .LogEn_SI           ( RabLogEn_SI            ),
    .ArLogClr_SI        ( RabArLogClr_SI         ),
    .AwLogClr_SI        ( RabAwLogClr_SI         ),
    .ArLogRdy_SO        ( RabArLogRdy_SO         ),
    .AwLogRdy_SO        ( RabAwLogRdy_SO         ),
`endif

`ifdef RAB_AX_LOG_EN
    .intr_ar_log_full_o ( intr_rab_ar_log_full_o ),
    .intr_aw_log_full_o ( intr_rab_aw_log_full_o ),
`endif
    .intr_miss_o        ( intr_rab_miss_o        ),
    .intr_multi_o       ( intr_rab_multi_o       ),
    .intr_prot_o        ( intr_rab_prot_o        ),
    .intr_mhf_full_o    ( intr_rab_mhf_full_o    )
  );
  // }}}

  // ULP Clusters {{{
  //  ██████╗██╗     ██╗   ██╗███████╗████████╗███████╗██████╗ ███████╗
  // ██╔════╝██║     ██║   ██║██╔════╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝
  // ██║     ██║     ██║   ██║███████╗   ██║   █████╗  ██████╔╝███████╗
  // ██║     ██║     ██║   ██║╚════██║   ██║   ██╔══╝  ██╔══██╗╚════██║
  // ╚██████╗███████╗╚██████╔╝███████║   ██║   ███████╗██║  ██║███████║
  //  ╚═════╝╚══════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝
  //
  logic [NB_CLUSTERS-1:0] [5:0] CLUSTER_ID;
  for(i=0;i<NB_CLUSTERS; i++)
  begin : CLUSTER
    assign CLUSTER_ID[i] = i;

    pulp_cluster_wrap #(
      // cluster parameters
      .NB_CORES              ( `NB_CORES             ),

      // AXI parameters
      .AXI_ADDR_WIDTH        ( AXI_ADDR_WIDTH        ),
      .AXI_DATA_C2S_WIDTH    ( AXI_DATA_WIDTH        ),
      .AXI_DATA_S2C_WIDTH    ( AXI_DATA_WIDTH        ),
      .AXI_USER_WIDTH        ( AXI_USER_WIDTH        ),
      .AXI_ID_IN_WIDTH       ( 4                     ),
      .AXI_ID_OUT_WIDTH      ( AXI_ID_SOC_S_WIDTH    ),
      .AXI_STRB_C2S_WIDTH    ( AXI_STRB_WIDTH        ),
      .AXI_STRB_S2C_WIDTH    ( AXI_STRB_WIDTH        ),
      .DC_SLICE_BUFFER_WIDTH ( BUFFER_WIDTH          )
    ) cluster_i (
      .clk_i                    ( clk_cluster_i              ),
      .rst_ni                   ( rstn_cluster_sync          ),
      .ref_clk_i                ( clk_cluster_i              ),
      .pmu_mem_pwdn_i           ( 1'b0                       ),

      .base_addr_i              ( '0                         ), // not used

      .test_mode_i              ( test_mode_i                ),

      .en_sa_boot_i             ( mode_select_i              ),

      .cluster_id_i             ( CLUSTER_ID[i]              ),

      .fetch_en_i               ( fetch_en_i[i]              ),

      .eoc_o                    ( eoc_o[i]                   ),

      .busy_o                   ( cluster_busy_o[i]          ),

      .ext_events_writetoken_i  ( cluster_events_wt[i]       ),
      .ext_events_readpointer_o ( cluster_events_rp[i]       ),
      .ext_events_dataasync_i   ( cluster_events_da[i]       ),

      .dma_pe_evt_ack_i         ( 1'b1                       ),
      .dma_pe_evt_valid_o       (                            ),

      .dma_pe_irq_ack_i         ( 1'b1                       ),
      .dma_pe_irq_valid_o       (                            ),

      .pf_evt_ack_i             ( 1'b1                       ),
      .pf_evt_valid_o           (                            ),

      .data_master              ( s_data_master_bus_async[i] ),
      .data_slave               ( s_data_slave_bus_async[i]  )
    );
  end
  // }}}

  // DC FIFOs {{{
  // ██████╗  ██████╗        ███████╗██╗███████╗ ██████╗
  // ██╔══██╗██╔════╝        ██╔════╝██║██╔════╝██╔═══██╗
  // ██║  ██║██║             █████╗  ██║█████╗  ██║   ██║
  // ██║  ██║██║             ██╔══╝  ██║██╔══╝  ██║   ██║
  // ██████╔╝╚██████╗███████╗██║     ██║██║     ╚██████╔╝
  // ╚═════╝  ╚═════╝╚══════╝╚═╝     ╚═╝╚═╝      ╚═════╝
  for(i=0;i<NB_CLUSTERS; i++)
  begin : DC_FIFO
    axi_slice_dc_master_wrap #(
      .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
      .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
      .AXI_ID_WIDTH   ( AXI_ID_SOC_S_WIDTH ),
      .AXI_USER_WIDTH ( AXI_USER_WIDTH     ),
      .BUFFER_WIDTH   ( BUFFER_WIDTH       )
    ) dc_fifo_data_master_bus_i (
      .clk_i           ( clk_soc_i                  ),
      .rst_ni          ( rstn_soc_sync              ),
      .test_cgbypass_i ( 1'b0                       ),
      .isolate_i       ( 1'b0                       ),
      .clock_down_i    ( 1'b0                       ),
      .incoming_req_o  (                            ),
      .axi_slave_async ( s_data_master_bus_async[i] ),
      .axi_master      ( s_data_master_bus[i]       )
    );

    axi_slice_dc_slave_wrap #(
      .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH    ),
      .AXI_DATA_WIDTH ( AXI_DATA_WIDTH    ),
      .AXI_ID_WIDTH   ( 4                 ),
      .AXI_USER_WIDTH ( AXI_USER_WIDTH    ),
      .BUFFER_WIDTH   ( BUFFER_WIDTH      )
    ) dc_fifo_data_slave_bus_i (
      .clk_i            ( clk_soc_i                       ),
      .rst_ni           ( rstn_soc_sync                   ),
      .test_cgbypass_i  ( 1'b0                            ),      
      .isolate_i        ( 1'b0                            ),
      .axi_slave        ( s_data_slave_bus_id_remapped[i] ), // FROM REMAPPER
      .axi_master_async ( s_data_slave_bus_async[i]       )  // TO CLUSTER
    );
  end
  // }}}

  // L2 MEM {{{
  // ██╗     ██████╗         ███╗   ███╗███████╗███╗   ███╗
  // ██║     ╚════██╗        ████╗ ████║██╔════╝████╗ ████║
  // ██║      █████╔╝        ██╔████╔██║█████╗  ██╔████╔██║
  // ██║     ██╔═══╝         ██║╚██╔╝██║██╔══╝  ██║╚██╔╝██║
  // ███████╗███████╗███████╗██║ ╚═╝ ██║███████╗██║ ╚═╝ ██║
  // ╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝
  axi_mem_if_wrap #(
    .AXI_ADDRESS_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH    ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH      ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH    ( AXI_USER_WIDTH     ),
    .BUFF_DEPTH_SLAVE  ( 4                  )
  ) l2_mem_if_i (
    .clk_i      ( clk_soc_i     ),
    .rst_ni     ( rstn_soc_sync ),
    .test_en_i  ( test_mode_i   ),

    .axi_slave  ( s_soc_l2_bus  ),
    .mem_master ( s_soc_l2_mem  )
  );

  l2_mem #(
    .MEM_ADDR_WIDTH ( L2_MEM_ADDR_WIDTH )
  ) l2_mem_i (
    .clk_i          ( clk_soc_i         ),
    .rst_ni         ( rstn_soc_sync     ),
    .test_en_i      ( test_mode_i       ),
    .mem_slave      ( s_soc_l2_mem      )
  );
  // }}}

  // AXI ID Remappers {{{
  // ██████╗ ███████╗███╗   ███╗ █████╗ ██████╗
  // ██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔══██╗
  // ██████╔╝█████╗  ██╔████╔██║███████║██████╔╝
  // ██╔══██╗██╔══╝  ██║╚██╔╝██║██╔══██║██╔═══╝
  // ██║  ██║███████╗██║ ╚═╝ ██║██║  ██║██║
  // ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝
  for(i=0; i<NB_CLUSTERS; i++)
  begin : ID_REMAPPER_CL
    axi_id_remap_wrap #(
      .AXI_ADDR_WIDTH   ( AXI_ADDR_WIDTH     ),
      .AXI_DATA_WIDTH   ( AXI_DATA_WIDTH     ),
      .AXI_USER_WIDTH   ( AXI_USER_WIDTH     ),
      .AXI_ID_IN_WIDTH  ( AXI_ID_SOC_M_WIDTH ),
      .AXI_ID_OUT_WIDTH ( 4                  ),
      .AXI_ID_SLOT      ( 4                  )
    ) i_axi_id_remap_wrap (
      .clk_i      ( clk_soc_i                       ),
      .rst_ni     ( rstn_soc_sync                   ),
      .axi_slave  ( s_data_slave_bus[i]             ), //From SOCBUS
      .axi_master ( s_data_slave_bus_id_remapped[i] )  //To DC_FIFO
    );
  end
  // }}}

  // Event distribution
  // ███████╗██╗   ██╗███████╗███╗   ██╗████████╗███████╗
  // ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
  // █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ███████╗
  // ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ╚════██║
  // ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ███████║
  // ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
  //just properly init the dc fifos, no events connected on SoC side
  for(i=0;i<NB_CLUSTERS;i++)
  begin :  EVENT_CLUSTER
    dc_token_ring_fifo_din #(
      .DATA_WIDTH   ( EVNT_WIDTH   ),
      .BUFFER_DEPTH ( BUFFER_WIDTH )
    ) u_event_dc (
      .clk          ( clk_soc_i            ),
      .rstn         ( rstn_soc_sync        ),
      .data         ( '0                   ),
      .valid        ( 1'b0                 ),
      .ready        (                      ),
      .write_token  ( cluster_events_wt[i] ),
      .read_pointer ( cluster_events_rp[i] ),
      .data_async   ( cluster_events_da[i] )
    );
  end
  // }}}

  endgenerate

  // Clock and Reset Generators {{{
  // ██████╗ ███████╗████████╗      ██████╗ ███████╗███╗   ██╗
  // ██╔══██╗██╔════╝╚══██╔══╝     ██╔════╝ ██╔════╝████╗  ██║
  // ██████╔╝███████╗   ██║        ██║  ███╗█████╗  ██╔██╗ ██║
  // ██╔══██╗╚════██║   ██║        ██║   ██║██╔══╝  ██║╚██╗██║
  // ██║  ██║███████║   ██║███████╗╚██████╔╝███████╗██║ ╚████║
  // ╚═╝  ╚═╝╚══════╝   ╚═╝╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝
  //cluster rst is sync with the soc clock to proper reset the soc side of the dual clock fifos
  rstgen i_rst_gen_cluster_soc (
    // PAD FRAME SIGNALS
    .clk_i       ( clk_soc_i     ),
    .rst_ni      ( rst_n         ),

    // TEST MODE
    .test_mode_i ( test_mode_i   ),

    // OUTPUT RESET
    .rst_no      ( rstn_soc_sync ),
    .init_no     (               ) //not used
  );

  //cluster rst is sync with the cluster clock
  rstgen i_rst_gen_cluster (
    // PAD FRAME SIGNALS
    .clk_i      ( clk_cluster_i     ),
    .rst_ni     ( rst_n             ),

    // TEST MODE
    .test_mode_i( test_mode_i       ),

    // OUTPUT RES ET
    .rst_no     ( rstn_cluster_sync ),
    .init_no    (                   ) //not used
  );
  // }}}

  // SoC Bus to RAB Configuration Port Converter {{{
  socbus_to_rab_cfg_conv #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) i_socbus_to_rab_cfg_conv (
    .Clk_CI      ( clk_soc_i                ),
    .Rst_RBI     ( rstn_soc_sync            ),

    .FromSoc_PS  ( s_socbus_to_rab_cfg      ),
    .ToRabCfg_PM ( s_socbus_to_rab_cfg_conv )
  );
  // }}}

  // AXI Lite Crossbar to connect Host and SoC Bus to RAB Configuration Port {{{
  xilinx_axi_xbar_rab_cfg_wrap #(
    .ADDR_BITW     ( AXI_ADDR_WIDTH           ),
    .DATA_BITW     ( AXI_LITE_DATA_WIDTH      )
  ) i_xilinx_axi_xbar_rab_cfg_wrap (
    .Clk_CI        ( clk_soc_i                ),
    .Rst_RBI       ( rstn_soc_sync            ),

    .Slave0_PS     ( s_rab_lite_from_host     ),
    .Slave1_PS     ( s_socbus_to_rab_cfg_conv ),
    .Master_PM     ( s_rab_lite               )
  );
  // }}}

  // SoC Bus {{{
  // ███████╗ ██████╗  ██████╗        ██████╗ ██╗   ██╗███████╗
  // ██╔════╝██╔═══██╗██╔════╝        ██╔══██╗██║   ██║██╔════╝
  // ███████╗██║   ██║██║             ██████╔╝██║   ██║███████╗
  // ╚════██║██║   ██║██║             ██╔══██╗██║   ██║╚════██║
  // ███████║╚██████╔╝╚██████╗███████╗██████╔╝╚██████╔╝███████║
  // ╚══════╝ ╚═════╝  ╚═════╝╚══════╝╚═════╝  ╚═════╝ ╚══════╝
  soc_bus_wrap #(
    .AXI_ADDR_WIDTH   ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH   ( AXI_DATA_WIDTH     ),
    .AXI_ID_IN_WIDTH  ( AXI_ID_SOC_S_WIDTH ),
    .AXI_ID_OUT_WIDTH ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH   ( AXI_USER_WIDTH     ),
    .NB_CLUSTERS      ( NB_CLUSTERS        )
  ) i_soc_bus_wrap (
    .clk_i               ( clk_soc_i           ),
    .rst_ni              ( rstn_soc_sync       ),
    .test_en_i           ( test_mode_i         ),

    //TARGET   --> AXI ID = 10bit
    .cluster_data_slave  ( s_data_master_bus   ), // AXI_BUS.Slave
    .cluster_data_master ( s_data_slave_bus    ), // AXI_BUS.Master
    .soc_rab_slave       ( s_rab_to_socbus     ), // AXI_BUS.Slave
    .soc_rab_master      ( s_socbus_to_rab     ), // AXI_BUS.Master
    .soc_rab_cfg_master  ( s_socbus_to_rab_cfg ), // AXI_BUS.Master
    .mailbox_master      ( s_socbus_to_mailbox ), // AXI_BUS.Master

`ifdef JUNO
    .soc_stdout_master   ( stdout_master       ), // AXI_BUS.Master
`endif

    .soc_l2_master       ( s_soc_l2_bus        ), // AXI_BUS.Master
    .soc_apb_master      ( soc_bus_to_apb      )
  );
  // }}}

  // Mailbox {{{
  // ███╗   ███╗ █████╗ ██╗██╗     ██████╗  ██████╗ ██╗  ██╗
  // ████╗ ████║██╔══██╗██║██║     ██╔══██╗██╔═══██╗╚██╗██╔╝
  // ██╔████╔██║███████║██║██║     ██████╔╝██║   ██║ ╚███╔╝
  // ██║╚██╔╝██║██╔══██║██║██║     ██╔══██╗██║   ██║ ██╔██╗
  // ██║ ╚═╝ ██║██║  ██║██║███████╗██████╔╝╚██████╔╝██╔╝ ██╗
  // ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝
  xilinx_mailbox_wrap #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     )
  ) xilinx_mailbox_wrap_i (
    .Clk_CI     ( clk_soc_i           ),
    .Rst_RBI    ( rstn_soc_sync       ),

    .FromSoc_PS ( s_socbus_to_mailbox ),

    .Irq0_SO    ( intr_mailbox_o      ),
    .Irq1_SO    (                     )
  );
  // }}}

  // SoC Peripherals (AXI 2 APB) {{{
  //  █████╗ ██╗  ██╗██╗        ██████╗          █████╗ ██████╗ ██████╗
  // ██╔══██╗╚██╗██╔╝██║        ╚════██╗        ██╔══██╗██╔══██╗██╔══██╗
  // ███████║ ╚███╔╝ ██║         █████╔╝        ███████║██████╔╝██████╔╝
  // ██╔══██║ ██╔██╗ ██║        ██╔═══╝         ██╔══██║██╔═══╝ ██╔══██╗
  // ██║  ██║██╔╝ ██╗██║███████╗███████╗███████╗██║  ██║██║     ██████╔╝
  // ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═════╝
  soc_peripherals_multicluster #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH     ),
    .AXI_ID_WIDTH   ( AXI_ID_SOC_M_WIDTH ),
    .NB_CORES       ( NB_CORES           ),
    .NB_CLUSTERS    ( NB_CLUSTERS        )
  ) soc_registers (
    .clk_i       ( clk_soc_i      ),
    .rst_ni      ( rstn_soc_sync  ),

    .test_mode_i ( test_mode_i    ),

    .uart_rx_i   ( uart_rx_i      ),
    .uart_tx_o   ( uart_tx_o      ),
    .uart_rts_no ( uart_rts_no    ),
    .uart_dtr_no ( uart_dtr_no    ),
    .uart_cts_ni ( uart_cts_ni    ),
    .uart_dsr_ni ( uart_dsr_ni    ),

    // SLAVE PORTS
    .axi_slave   ( soc_bus_to_apb )
  );
  // }}}

  // Interface Bindings {{{
  // ██╗███████        ██████╗ ██╗███╗   ██╗██████╗
  // ██║██╔════        ██╔══██╗██║████╗  ██║██╔══██╗
  // ██║█████╗         ██████╔╝██║██╔██╗ ██║██║  ██║
  // ██║██╔══╝         ██╔══██╗██║██║╚██╗██║██║  ██║
  // ██║██║    ███████╗██████╔╝██║██║ ╚████║██████╔╝
  // ╚═╝╚═╝    ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝
`ifdef JUNO
  assign stdout_master_aw_valid  = stdout_master.aw_valid ;
  assign stdout_master_aw_lock   = stdout_master.aw_lock  ;
  assign stdout_master_ar_valid  = stdout_master.ar_valid ;
  assign stdout_master_ar_lock   = stdout_master.ar_lock  ;
  assign stdout_master_w_valid   = stdout_master.w_valid  ;
  assign stdout_master_w_last    = stdout_master.w_last   ;
  assign stdout_master_r_ready   = stdout_master.r_ready  ;
  assign stdout_master_b_ready   = stdout_master.b_ready  ;
  assign stdout_master_aw_addr   = stdout_master.aw_addr  ;
  assign stdout_master_aw_prot   = stdout_master.aw_prot  ;
  assign stdout_master_aw_region = stdout_master.aw_region;
  assign stdout_master_aw_len    = stdout_master.aw_len   ;
  assign stdout_master_aw_size   = stdout_master.aw_size  ;
  assign stdout_master_aw_burst  = stdout_master.aw_burst ;
  assign stdout_master_aw_cache  = stdout_master.aw_cache ;
  assign stdout_master_aw_qos    = stdout_master.aw_qos   ;
  assign stdout_master_aw_id     = stdout_master.aw_id    ;
  assign stdout_master_aw_user   = stdout_master.aw_user  ;
  assign stdout_master_ar_addr   = stdout_master.ar_addr  ;
  assign stdout_master_ar_prot   = stdout_master.ar_prot  ;
  assign stdout_master_ar_region = stdout_master.ar_region;
  assign stdout_master_ar_len    = stdout_master.ar_len   ;
  assign stdout_master_ar_size   = stdout_master.ar_size  ;
  assign stdout_master_ar_burst  = stdout_master.ar_burst ;
  assign stdout_master_ar_cache  = stdout_master.ar_cache ;
  assign stdout_master_ar_qos    = stdout_master.ar_qos   ;
  assign stdout_master_ar_id     = stdout_master.ar_id    ;
  assign stdout_master_ar_user   = stdout_master.ar_user  ;
  assign stdout_master_w_data    = stdout_master.w_data   ;
  assign stdout_master_w_strb    = stdout_master.w_strb   ;
  assign stdout_master_w_user    = stdout_master.w_user   ;
  assign stdout_master.aw_ready  = stdout_master_aw_ready ;
  assign stdout_master.ar_ready  = stdout_master_ar_ready ;
  assign stdout_master.w_ready   = stdout_master_w_ready  ;
  assign stdout_master.r_valid   = stdout_master_r_valid  ;
  assign stdout_master.r_last    = stdout_master_r_last   ;
  assign stdout_master.b_valid   = stdout_master_b_valid  ;
  assign stdout_master.r_data    = stdout_master_r_data   ;
  assign stdout_master.r_resp    = stdout_master_r_resp   ;
  assign stdout_master.r_id      = stdout_master_r_id     ;
  assign stdout_master.r_user    = stdout_master_r_user   ;
  assign stdout_master.b_resp    = stdout_master_b_resp   ;
  assign stdout_master.b_id      = stdout_master_b_id     ;
  assign stdout_master.b_user    = stdout_master_b_user   ;
`endif // JUNO

  assign rab_master_aw_valid     = s_rab_master.aw_valid  ;
  assign rab_master_aw_addr      = s_rab_master.aw_addr   ;
  assign rab_master_aw_prot      = s_rab_master.aw_prot   ;
  assign rab_master_aw_region    = s_rab_master.aw_region ;
  assign rab_master_aw_len       = s_rab_master.aw_len    ;
  assign rab_master_aw_size      = s_rab_master.aw_size   ;
  assign rab_master_aw_burst     = s_rab_master.aw_burst  ;
  assign rab_master_aw_lock      = s_rab_master.aw_lock   ;
  assign rab_master_aw_cache     = s_rab_master.aw_cache  ;
  assign rab_master_aw_qos       = s_rab_master.aw_qos    ;
  assign rab_master_aw_id        = s_rab_master.aw_id     ;
  assign rab_master_aw_user      = s_rab_master.aw_user   ;
  assign s_rab_master.aw_ready   = rab_master_aw_ready    ;
  assign rab_master_ar_valid     = s_rab_master.ar_valid  ;
  assign rab_master_ar_addr      = s_rab_master.ar_addr   ;
  assign rab_master_ar_prot      = s_rab_master.ar_prot   ;
  assign rab_master_ar_region    = s_rab_master.ar_region ;
  assign rab_master_ar_len       = s_rab_master.ar_len    ;
  assign rab_master_ar_size      = s_rab_master.ar_size   ;
  assign rab_master_ar_burst     = s_rab_master.ar_burst  ;
  assign rab_master_ar_lock      = s_rab_master.ar_lock   ;
  assign rab_master_ar_cache     = s_rab_master.ar_cache  ;
  assign rab_master_ar_qos       = s_rab_master.ar_qos    ;
  assign rab_master_ar_id        = s_rab_master.ar_id     ;
  assign rab_master_ar_user      = s_rab_master.ar_user   ;
  assign s_rab_master.ar_ready   = rab_master_ar_ready    ;
  assign rab_master_w_valid      = s_rab_master.w_valid   ;
  assign rab_master_w_data       = s_rab_master.w_data    ;
  assign rab_master_w_strb       = s_rab_master.w_strb    ;
  assign rab_master_w_user       = s_rab_master.w_user    ;
  assign rab_master_w_last       = s_rab_master.w_last    ;
  assign s_rab_master.w_ready    = rab_master_w_ready     ;
  assign s_rab_master.r_valid    = rab_master_r_valid     ;
  assign s_rab_master.r_data     = rab_master_r_data      ;
  assign s_rab_master.r_resp     = rab_master_r_resp      ;
  assign s_rab_master.r_last     = rab_master_r_last      ;
  assign s_rab_master.r_id       = rab_master_r_id        ;
  assign s_rab_master.r_user     = rab_master_r_user      ;
  assign rab_master_r_ready      = s_rab_master.r_ready   ;
  assign s_rab_master.b_valid    = rab_master_b_valid     ;
  assign s_rab_master.b_resp     = rab_master_b_resp      ;
  assign s_rab_master.b_id       = rab_master_b_id        ;
  assign s_rab_master.b_user     = rab_master_b_user      ;
  assign rab_master_b_ready      = s_rab_master.b_ready   ;

`ifdef EN_ACP
  assign rab_acp_aw_valid     = s_rab_acp.aw_valid  ;
  assign rab_acp_aw_addr      = s_rab_acp.aw_addr   ;
  assign rab_acp_aw_prot      = s_rab_acp.aw_prot   ;
  assign rab_acp_aw_region    = s_rab_acp.aw_region ;
  assign rab_acp_aw_len       = s_rab_acp.aw_len    ;
  assign rab_acp_aw_size      = s_rab_acp.aw_size   ;
  assign rab_acp_aw_burst     = s_rab_acp.aw_burst  ;
  assign rab_acp_aw_lock      = s_rab_acp.aw_lock   ;
  assign rab_acp_aw_cache     = s_rab_acp.aw_cache  ;
  assign rab_acp_aw_qos       = s_rab_acp.aw_qos    ;
  assign rab_acp_aw_id        = s_rab_acp.aw_id     ;
  assign rab_acp_aw_user      = s_rab_acp.aw_user   ;
  assign s_rab_acp.aw_ready   = rab_acp_aw_ready    ;
  assign rab_acp_ar_valid     = s_rab_acp.ar_valid  ;
  assign rab_acp_ar_addr      = s_rab_acp.ar_addr   ;
  assign rab_acp_ar_prot      = s_rab_acp.ar_prot   ;
  assign rab_acp_ar_region    = s_rab_acp.ar_region ;
  assign rab_acp_ar_len       = s_rab_acp.ar_len    ;
  assign rab_acp_ar_size      = s_rab_acp.ar_size   ;
  assign rab_acp_ar_burst     = s_rab_acp.ar_burst  ;
  assign rab_acp_ar_lock      = s_rab_acp.ar_lock   ;
  assign rab_acp_ar_cache     = s_rab_acp.ar_cache  ;
  assign rab_acp_ar_qos       = s_rab_acp.ar_qos    ;
  assign rab_acp_ar_id        = s_rab_acp.ar_id     ;
  assign rab_acp_ar_user      = s_rab_acp.ar_user   ;
  assign s_rab_acp.ar_ready   = rab_acp_ar_ready    ;
  assign rab_acp_w_valid      = s_rab_acp.w_valid   ;
  assign rab_acp_w_data       = s_rab_acp.w_data    ;
  assign rab_acp_w_strb       = s_rab_acp.w_strb    ;
  assign rab_acp_w_user       = s_rab_acp.w_user    ;
  assign rab_acp_w_last       = s_rab_acp.w_last    ;
  assign s_rab_acp.w_ready    = rab_acp_w_ready     ;
  assign s_rab_acp.r_valid    = rab_acp_r_valid     ;
  assign s_rab_acp.r_data     = rab_acp_r_data      ;
  assign s_rab_acp.r_resp     = rab_acp_r_resp      ;
  assign s_rab_acp.r_last     = rab_acp_r_last      ;
  assign s_rab_acp.r_id       = rab_acp_r_id        ;
  assign s_rab_acp.r_user     = rab_acp_r_user      ;
  assign rab_acp_r_ready      = s_rab_acp.r_ready   ;
  assign s_rab_acp.b_valid    = rab_acp_b_valid     ;
  assign s_rab_acp.b_resp     = rab_acp_b_resp      ;
  assign s_rab_acp.b_id       = rab_acp_b_id        ;
  assign s_rab_acp.b_user     = rab_acp_b_user      ;
  assign rab_acp_b_ready      = s_rab_acp.b_ready   ;
`endif

  assign s_rab_slave.aw_valid    = rab_slave_aw_valid   ;
  assign s_rab_slave.aw_addr     = rab_slave_aw_addr    ;
  assign s_rab_slave.aw_prot     = rab_slave_aw_prot    ;
  assign s_rab_slave.aw_region   = rab_slave_aw_region  ;
  assign s_rab_slave.aw_len      = rab_slave_aw_len     ;
  assign s_rab_slave.aw_size     = rab_slave_aw_size    ;
  assign s_rab_slave.aw_burst    = rab_slave_aw_burst   ;
  assign s_rab_slave.aw_lock     = rab_slave_aw_lock    ;
  assign s_rab_slave.aw_cache    = rab_slave_aw_cache   ;
  assign s_rab_slave.aw_qos      = rab_slave_aw_qos     ;
  assign s_rab_slave.aw_id       = rab_slave_aw_id      ;
  assign s_rab_slave.aw_user     = rab_slave_aw_user    ;
  assign rab_slave_aw_ready      = s_rab_slave.aw_ready ;
  assign s_rab_slave.ar_valid    = rab_slave_ar_valid   ;
  assign s_rab_slave.ar_addr     = rab_slave_ar_addr    ;
  assign s_rab_slave.ar_prot     = rab_slave_ar_prot    ;
  assign s_rab_slave.ar_region   = rab_slave_ar_region  ;
  assign s_rab_slave.ar_len      = rab_slave_ar_len     ;
  assign s_rab_slave.ar_size     = rab_slave_ar_size    ;
  assign s_rab_slave.ar_burst    = rab_slave_ar_burst   ;
  assign s_rab_slave.ar_lock     = rab_slave_ar_lock    ;
  assign s_rab_slave.ar_cache    = rab_slave_ar_cache   ;
  assign s_rab_slave.ar_qos      = rab_slave_ar_qos     ;
  assign s_rab_slave.ar_id       = rab_slave_ar_id      ;
  assign s_rab_slave.ar_user     = rab_slave_ar_user    ;
  assign rab_slave_ar_ready      = s_rab_slave.ar_ready ;
  assign s_rab_slave.w_valid     = rab_slave_w_valid    ;
  assign s_rab_slave.w_data      = rab_slave_w_data     ;
  assign s_rab_slave.w_strb      = rab_slave_w_strb     ;
  assign s_rab_slave.w_user      = rab_slave_w_user     ;
  assign s_rab_slave.w_last      = rab_slave_w_last     ;
  assign rab_slave_w_ready       = s_rab_slave.w_ready  ;
  assign rab_slave_r_valid       = s_rab_slave.r_valid  ;
  assign rab_slave_r_data        = s_rab_slave.r_data   ;
  assign rab_slave_r_resp        = s_rab_slave.r_resp   ;
  assign rab_slave_r_last        = s_rab_slave.r_last   ;
  assign rab_slave_r_id          = s_rab_slave.r_id     ;
  assign rab_slave_r_user        = s_rab_slave.r_user   ;
  assign s_rab_slave.r_ready     = rab_slave_r_ready    ;
  assign rab_slave_b_valid       = s_rab_slave.b_valid  ;
  assign rab_slave_b_resp        = s_rab_slave.b_resp   ;
  assign rab_slave_b_id          = s_rab_slave.b_id     ;
  assign rab_slave_b_user        = s_rab_slave.b_user   ;
  assign s_rab_slave.b_ready     = rab_slave_b_ready    ;

  assign s_rab_lite_from_host.aw_addr  = rab_lite_aw_addr              ;
  assign s_rab_lite_from_host.aw_valid = rab_lite_aw_valid             ;
  assign rab_lite_aw_ready             = s_rab_lite_from_host.aw_ready ;
  assign s_rab_lite_from_host.w_data   = rab_lite_w_data               ;
  assign s_rab_lite_from_host.w_strb   = rab_lite_w_strb               ;
  assign s_rab_lite_from_host.w_valid  = rab_lite_w_valid              ;
  assign rab_lite_w_ready              = s_rab_lite_from_host.w_ready  ;
  assign rab_lite_b_resp               = s_rab_lite_from_host.b_resp   ;
  assign rab_lite_b_valid              = s_rab_lite_from_host.b_valid  ;
  assign s_rab_lite_from_host.b_ready  = rab_lite_b_ready              ;
  assign s_rab_lite_from_host.ar_addr  = rab_lite_ar_addr              ;
  assign s_rab_lite_from_host.ar_valid = rab_lite_ar_valid             ;
  assign rab_lite_ar_ready             = s_rab_lite_from_host.ar_ready ;
  assign rab_lite_r_data               = s_rab_lite_from_host.r_data   ;
  assign rab_lite_r_resp               = s_rab_lite_from_host.r_resp   ;
  assign rab_lite_r_valid              = s_rab_lite_from_host.r_valid  ;
  assign s_rab_lite_from_host.r_ready  = rab_lite_r_ready              ;

`ifdef RAB_AX_LOG_EN
  assign RabArBram_PS.Clk_C  = RabArBramClk_CI   ;
  assign RabArBram_PS.Rst_R  = RabArBramRst_RI   ;
  assign RabArBram_PS.En_S   = RabArBramEn_SI    ;
  assign RabArBram_PS.Addr_S = RabArBramAddr_SI  ;
  assign RabArBramRd_DO      = RabArBram_PS.Rd_D ;
  assign RabArBram_PS.Wr_D   = RabArBramWr_DI    ;
  assign RabArBram_PS.WrEn_S = RabArBramWrEn_SI  ;
  assign RabAwBram_PS.Clk_C  = RabAwBramClk_CI   ;
  assign RabAwBram_PS.Rst_R  = RabAwBramRst_RI   ;
  assign RabAwBram_PS.En_S   = RabAwBramEn_SI    ;
  assign RabAwBram_PS.Addr_S = RabAwBramAddr_SI  ;
  assign RabAwBramRd_DO      = RabAwBram_PS.Rd_D ;
  assign RabAwBram_PS.Wr_D   = RabAwBramWr_DI    ;
  assign RabAwBram_PS.WrEn_S = RabAwBramWrEn_SI  ;
`endif
/// }}}

endmodule

// vim: ts=3 sw=3 sts=3 et nosmartindent autoindent foldmethod=marker
