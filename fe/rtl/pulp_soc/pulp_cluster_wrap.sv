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

module pulp_cluster_wrap
#(
  // For simulation, the parameters are passed through this wrapper.
  // For synthesis, the pulp_cluster.sv (top) gets the paramters from pulp_soc_defines.sv
  // directly.
  // cluster parameters
  parameter NB_CORES           = `NB_CORES,
  parameter NB_HWACC_PORTS     = 0,
  parameter NB_DMAS            = 4,
  parameter NB_MPERIPHS        = 1,
  parameter NB_SPERIPHS        = 8,
  parameter CLUSTER_ALIAS_BASE = 12'h1B0,
  parameter TCDM_SIZE          = `TCDM_SIZE,              // [B], must be 2**N
  parameter NB_TCDM_BANKS      = `NB_TCDM_BANKS,          // must be 2**N
  parameter TCDM_BANK_SIZE     = TCDM_SIZE/NB_TCDM_BANKS, // [B]
  parameter TCDM_NUM_ROWS      = TCDM_BANK_SIZE/4,        // [words]
  parameter XNE_PRESENT        = 0,                       // set to 1 if XNE is present in the cluster

  // I$ parameters
  parameter SET_ASSOCIATIVE       = 4,
  parameter NB_CACHE_BANKS        = `NB_CACHE_BANKS,
  parameter CACHE_LINE            = 1,
  parameter CACHE_SIZE            = `CACHE_SIZE,
  parameter ICACHE_DATA_WIDTH     = 128,
  parameter L0_BUFFER_FEATURE     = "DISABLED",
  parameter MULTICAST_FEATURE     = "DISABLED",
  parameter SHARED_ICACHE         = "ENABLED",
  parameter DIRECT_MAPPED_FEATURE = "DISABLED",
  parameter L2_SIZE               = `L2_SIZE,
  parameter USE_REDUCED_TAG       = "TRUE",

  // core parameters
  parameter ROM_BOOT_ADDR     = 32'h1A000000,
  parameter BOOT_ADDR         = 32'h1C000000,
  parameter INSTR_RDATA_WIDTH = 128,
  
  // AXI parameters
  parameter AXI_ADDR_WIDTH        = 32,
  parameter AXI_DATA_C2S_WIDTH    = 64,
  parameter AXI_DATA_S2C_WIDTH    = 64,
  parameter AXI_USER_WIDTH        = 6,
  parameter AXI_ID_IN_WIDTH       = 4,
  parameter AXI_ID_OUT_WIDTH      = `AXI_ID_SOC_S_WIDTH,
  parameter AXI_STRB_C2S_WIDTH    = AXI_DATA_C2S_WIDTH/8,
  parameter AXI_STRB_S2C_WIDTH    = AXI_DATA_S2C_WIDTH/8,
  parameter DC_SLICE_BUFFER_WIDTH = 8,
  
  // TCDM and log interconnect parameters
  parameter DATA_WIDTH     = 32,
  parameter ADDR_WIDTH     = 32,
  parameter BE_WIDTH       = DATA_WIDTH/8,
  parameter TEST_SET_BIT   = 20,                       // bit used to indicate a test-and-set operation during a load in TCDM
  parameter ADDR_MEM_WIDTH = $clog2(TCDM_BANK_SIZE/4), // WORD address width per TCDM bank (the word width is 32 bits)
  
  // DMA parameters
  parameter TCDM_ADD_WIDTH     = ADDR_MEM_WIDTH + $clog2(NB_TCDM_BANKS) + 2, // BYTE address width TCDM
  parameter NB_OUTSND_BURSTS   = `NB_OUTSND_BURSTS,
  parameter MCHAN_BURST_LENGTH = `MCHAN_BURST_LENGTH,

  // peripheral and periph interconnect parameters
  parameter LOG_CLUSTER    = 5,  // unused
  parameter PE_ROUTING_LSB = 10, // LSB used as routing BIT in periph interco
  parameter PE_ROUTING_MSB = 13, // MSB used as routing BIT in periph interco
  parameter EVNT_WIDTH     = 8,  // size of the event bus
  parameter REMAP_ADDRESS  = 0   // for cluster virtualization
)
(
  input  logic                             clk_i,
  input  logic                             rst_ni,
  input  logic                             ref_clk_i,
  input  logic                             pmu_mem_pwdn_i,
  
  input logic [3:0]                        base_addr_i,

  input logic                              test_mode_i,

  input logic                              en_sa_boot_i,

  input logic [5:0]                        cluster_id_i,

  input logic                              fetch_en_i,
 
  output logic                             eoc_o,
  
  output logic                             busy_o,
 
  input  logic [DC_SLICE_BUFFER_WIDTH-1:0] ext_events_writetoken_i,
  output logic [DC_SLICE_BUFFER_WIDTH-1:0] ext_events_readpointer_o,
  input  logic            [EVNT_WIDTH-1:0] ext_events_dataasync_i,
  
  input  logic                             dma_pe_evt_ack_i,
  output logic                             dma_pe_evt_valid_o,

  input  logic                             dma_pe_irq_ack_i,
  output logic                             dma_pe_irq_valid_o,
  
  input  logic                             pf_evt_ack_i,
  output logic                             pf_evt_valid_o,

  AXI_BUS_ASYNC.Master                     data_master,
  AXI_BUS_ASYNC.Slave                      data_slave
);

  // data_master
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_aw_writetoken_o ;  // output
  logic        [AXI_ADDR_WIDTH-1:0] data_master_aw_addr_o ;        // output
  logic                       [2:0] data_master_aw_prot_o ;        // output
  logic                       [3:0] data_master_aw_region_o ;      // output
  logic                       [7:0] data_master_aw_len_o ;         // output
  logic                       [2:0] data_master_aw_size_o ;        // output
  logic                       [1:0] data_master_aw_burst_o ;       // output
  logic                             data_master_aw_lock_o ;        // output
  logic                       [3:0] data_master_aw_cache_o ;       // output
  logic                       [3:0] data_master_aw_qos_o ;         // output
  logic      [AXI_ID_OUT_WIDTH-1:0] data_master_aw_id_o ;          // output
  logic        [AXI_USER_WIDTH-1:0] data_master_aw_user_o ;        // output
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_aw_readpointer_i ; // input

  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_ar_writetoken_o ;  // output
  logic        [AXI_ADDR_WIDTH-1:0] data_master_ar_addr_o ;        // output
  logic                       [2:0] data_master_ar_prot_o ;        // output
  logic                       [3:0] data_master_ar_region_o ;      // output
  logic                       [7:0] data_master_ar_len_o ;         // output
  logic                       [2:0] data_master_ar_size_o ;        // output
  logic                       [1:0] data_master_ar_burst_o ;       // output
  logic                             data_master_ar_lock_o ;        // output
  logic                       [3:0] data_master_ar_cache_o ;       // output
  logic                       [3:0] data_master_ar_qos_o ;         // output
  logic      [AXI_ID_OUT_WIDTH-1:0] data_master_ar_id_o ;          // output
  logic        [AXI_USER_WIDTH-1:0] data_master_ar_user_o ;        // output
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_ar_readpointer_i ; // input

  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_w_writetoken_o ;   // output  
  logic    [AXI_DATA_C2S_WIDTH-1:0] data_master_w_data_o ;         // output
  logic    [AXI_STRB_C2S_WIDTH-1:0] data_master_w_strb_o ;         // output
  logic        [AXI_USER_WIDTH-1:0] data_master_w_user_o ;         // output
  logic                             data_master_w_last_o ;         // output
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_w_readpointer_i ;  // input

  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_r_writetoken_i ;   // input
  logic    [AXI_DATA_C2S_WIDTH-1:0] data_master_r_data_i ;         // input
  logic                       [1:0] data_master_r_resp_i ;         // input
  logic                             data_master_r_last_i ;         // input
  logic      [AXI_ID_OUT_WIDTH-1:0] data_master_r_id_i ;           // input
  logic        [AXI_USER_WIDTH-1:0] data_master_r_user_i ;         // input
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_r_readpointer_o ;  // output

  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_b_writetoken_i ;   // input
  logic                       [1:0] data_master_b_resp_i ;         // input
  logic      [AXI_ID_OUT_WIDTH-1:0] data_master_b_id_i ;           // input
  logic        [AXI_USER_WIDTH-1:0] data_master_b_user_i ;         // input
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_master_b_readpointer_o ;  // output

  // data_slave
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_aw_writetoken_i ;   // input
  logic        [AXI_ADDR_WIDTH-1:0] data_slave_aw_addr_i ;         // input
  logic                       [2:0] data_slave_aw_prot_i ;         // input
  logic                       [3:0] data_slave_aw_region_i ;       // input
  logic                       [7:0] data_slave_aw_len_i ;          // input
  logic                       [2:0] data_slave_aw_size_i ;         // input
  logic                       [1:0] data_slave_aw_burst_i ;        // input
  logic                             data_slave_aw_lock_i ;         // input
  logic                       [3:0] data_slave_aw_cache_i ;        // input
  logic                       [3:0] data_slave_aw_qos_i ;          // input
  logic       [AXI_ID_IN_WIDTH-1:0] data_slave_aw_id_i ;           // input
  logic        [AXI_USER_WIDTH-1:0] data_slave_aw_user_i ;         // input
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_aw_readpointer_o ;  // output

  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_ar_writetoken_i ;   // input
  logic        [AXI_ADDR_WIDTH-1:0] data_slave_ar_addr_i ;         // input
  logic                       [2:0] data_slave_ar_prot_i ;         // input
  logic                       [3:0] data_slave_ar_region_i ;       // input
  logic                       [7:0] data_slave_ar_len_i ;          // input
  logic                       [2:0] data_slave_ar_size_i ;         // input
  logic                       [1:0] data_slave_ar_burst_i ;        // input
  logic                             data_slave_ar_lock_i ;         // input
  logic                       [3:0] data_slave_ar_cache_i ;        // input
  logic                       [3:0] data_slave_ar_qos_i ;          // input
  logic       [AXI_ID_IN_WIDTH-1:0] data_slave_ar_id_i ;           // input
  logic        [AXI_USER_WIDTH-1:0] data_slave_ar_user_i ;         // input
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_ar_readpointer_o ;  // output

  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_w_writetoken_i ;    // input
  logic    [AXI_DATA_S2C_WIDTH-1:0] data_slave_w_data_i ;          // input
  logic    [AXI_STRB_S2C_WIDTH-1:0] data_slave_w_strb_i ;          // input
  logic        [AXI_USER_WIDTH-1:0] data_slave_w_user_i ;          // input
  logic                             data_slave_w_last_i ;          // input
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_w_readpointer_o ;   // output

  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_r_writetoken_o ;    // output
  logic    [AXI_DATA_S2C_WIDTH-1:0] data_slave_r_data_o ;          // output
  logic                       [1:0] data_slave_r_resp_o ;          // output
  logic                             data_slave_r_last_o ;          // output
  logic       [AXI_ID_IN_WIDTH-1:0] data_slave_r_id_o ;            // output
  logic        [AXI_USER_WIDTH-1:0] data_slave_r_user_o ;          // output
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_r_readpointer_i ;   // input

  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_b_writetoken_o ;    // output
  logic                       [1:0] data_slave_b_resp_o ;          // output
  logic       [AXI_ID_IN_WIDTH-1:0] data_slave_b_id_o ;            // output
  logic        [AXI_USER_WIDTH-1:0] data_slave_b_user_o ;          // output
  logic [DC_SLICE_BUFFER_WIDTH-1:0] data_slave_b_readpointer_i ;   // input

  always_comb
    begin : data_master_if
      data_master.aw_writetoken    <= data_master_aw_writetoken_o ; // output
      data_master.aw_addr          <= data_master_aw_addr_o ;       // output
      data_master.aw_prot          <= data_master_aw_prot_o ;       // output
      data_master.aw_region        <= data_master_aw_region_o ;     // output
      data_master.aw_len           <= data_master_aw_len_o ;        // output
      data_master.aw_size          <= data_master_aw_size_o ;       // output
      data_master.aw_burst         <= data_master_aw_burst_o ;      // output
      data_master.aw_lock          <= data_master_aw_lock_o ;       // output
      data_master.aw_cache         <= data_master_aw_cache_o ;      // output
      data_master.aw_qos           <= data_master_aw_qos_o ;        // output
      data_master.aw_id            <= data_master_aw_id_o ;         // output
      data_master.aw_user          <= data_master_aw_user_o ;       // output
      data_master_aw_readpointer_i <= data_master.aw_readpointer ;  // input

      data_master.ar_writetoken    <= data_master_ar_writetoken_o ; // output
      data_master.ar_addr          <= data_master_ar_addr_o ;       // output
      data_master.ar_prot          <= data_master_ar_prot_o ;       // output
      data_master.ar_region        <= data_master_ar_region_o ;     // output
      data_master.ar_len           <= data_master_ar_len_o ;        // output
      data_master.ar_size          <= data_master_ar_size_o ;       // output
      data_master.ar_burst         <= data_master_ar_burst_o ;      // output
      data_master.ar_lock          <= data_master_ar_lock_o ;       // output
      data_master.ar_cache         <= data_master_ar_cache_o ;      // output
      data_master.ar_qos           <= data_master_ar_qos_o ;        // output
      data_master.ar_id            <= data_master_ar_id_o ;         // output
      data_master.ar_user          <= data_master_ar_user_o ;       // output
      data_master_ar_readpointer_i <= data_master.ar_readpointer ;  // input

      data_master.w_writetoken     <= data_master_w_writetoken_o ;  // output
      data_master.w_data           <= data_master_w_data_o ;        // output
      data_master.w_strb           <= data_master_w_strb_o ;        // output
      data_master.w_user           <= data_master_w_user_o ;        // output
      data_master.w_last           <= data_master_w_last_o ;        // output      
      data_master_w_readpointer_i  <= data_master.w_readpointer ;   // input

      data_master_r_writetoken_i   <= data_master.r_writetoken ;    // input
      data_master_r_data_i         <= data_master.r_data ;          // input
      data_master_r_resp_i         <= data_master.r_resp ;          // input
      data_master_r_last_i         <= data_master.r_last ;          // input
      data_master_r_id_i           <= data_master.r_id ;            // input
      data_master_r_user_i         <= data_master.r_user ;          // input
      data_master.r_readpointer    <= data_master_r_readpointer_o ; // output

      data_master_b_writetoken_i   <= data_master.b_writetoken ;    // input
      data_master_b_resp_i         <= data_master.b_resp ;          // input
      data_master_b_id_i           <= data_master.b_id ;            // input
      data_master_b_user_i         <= data_master.b_user ;          // input
      data_master.b_readpointer    <= data_master_b_readpointer_o ; // output
    end

  always_comb
    begin : data_slave_if
      data_slave_aw_writetoken_i <= data_slave.aw_writetoken ;    // input
      data_slave_aw_addr_i       <= data_slave.aw_addr ;          // input
      data_slave_aw_prot_i       <= data_slave.aw_prot ;          // input
      data_slave_aw_region_i     <= data_slave.aw_region ;        // input
      data_slave_aw_len_i        <= data_slave.aw_len ;           // input
      data_slave_aw_size_i       <= data_slave.aw_size ;          // input
      data_slave_aw_burst_i      <= data_slave.aw_burst ;         // input
      data_slave_aw_lock_i       <= data_slave.aw_lock ;          // input
      data_slave_aw_cache_i      <= data_slave.aw_cache ;         // input
      data_slave_aw_qos_i        <= data_slave.aw_qos ;           // input
      data_slave_aw_id_i         <= data_slave.aw_id ;            // input
      data_slave_aw_user_i       <= data_slave.aw_user ;          // input
      data_slave.aw_readpointer  <= data_slave_aw_readpointer_o ; // output

      data_slave_ar_writetoken_i <= data_slave.ar_writetoken ;    // input
      data_slave_ar_addr_i       <= data_slave.ar_addr ;          // input
      data_slave_ar_prot_i       <= data_slave.ar_prot ;          // input
      data_slave_ar_region_i     <= data_slave.ar_region ;        // input
      data_slave_ar_len_i        <= data_slave.ar_len ;           // input
      data_slave_ar_size_i       <= data_slave.ar_size ;          // input
      data_slave_ar_burst_i      <= data_slave.ar_burst ;         // input
      data_slave_ar_lock_i       <= data_slave.ar_lock ;          // input
      data_slave_ar_cache_i      <= data_slave.ar_cache ;         // input
      data_slave_ar_qos_i        <= data_slave.ar_qos ;           // input
      data_slave_ar_id_i         <= data_slave.ar_id ;            // input
      data_slave_ar_user_i       <= data_slave.ar_user ;          // input
      data_slave.ar_readpointer  <= data_slave_ar_readpointer_o ; // output

      data_slave_w_writetoken_i  <= data_slave.w_writetoken ;     // input
      data_slave_w_data_i        <= data_slave.w_data ;           // input
      data_slave_w_strb_i        <= data_slave.w_strb ;           // input
      data_slave_w_user_i        <= data_slave.w_user ;           // input
      data_slave_w_last_i        <= data_slave.w_last ;           // input
      data_slave.w_readpointer   <= data_slave_w_readpointer_o ;  // output
      
      data_slave.r_data          <= data_slave_r_data_o ;         // output
      data_slave.r_resp          <= data_slave_r_resp_o ;         // output
      data_slave.r_id            <= data_slave_r_id_o ;           // output
      data_slave.r_user          <= data_slave_r_user_o ;         // output
      data_slave.r_last          <= data_slave_r_last_o ;         // output
      data_slave.r_writetoken    <= data_slave_r_writetoken_o ;   // output
      data_slave_r_readpointer_i <= data_slave.r_readpointer ;    // input
      
      data_slave.b_resp          <= data_slave_b_resp_o ;         // output
      data_slave.b_id            <= data_slave_b_id_o ;           // output
      data_slave.b_user          <= data_slave_b_user_o ;         // output
      data_slave.b_writetoken    <= data_slave_b_writetoken_o ;   // output
      data_slave_b_readpointer_i <= data_slave.b_readpointer ;    // input
    end

  pulp_cluster #(
`ifdef PULP_FPGA_SIM
    // cluster parameters
    .NB_CORES              ( NB_CORES              ),
    .NB_HWACC_PORTS        ( NB_HWACC_PORTS        ),
    .NB_DMAS               ( NB_DMAS               ),
    .NB_MPERIPHS           ( NB_MPERIPHS           ),
    .NB_SPERIPHS           ( NB_SPERIPHS           ),
    .CLUSTER_ALIAS_BASE    ( CLUSTER_ALIAS_BASE    ),
    .TCDM_SIZE             ( TCDM_SIZE             ),
    .NB_TCDM_BANKS         ( NB_TCDM_BANKS         ),
    .TCDM_BANK_SIZE        ( TCDM_BANK_SIZE        ),
    .TCDM_NUM_ROWS         ( TCDM_NUM_ROWS         ),
    .XNE_PRESENT           ( XNE_PRESENT           ),

    // I$ parameters
    .SET_ASSOCIATIVE       ( SET_ASSOCIATIVE       ),
    .NB_CACHE_BANKS        ( NB_CACHE_BANKS        ),
    .CACHE_LINE            ( CACHE_LINE            ),
    .CACHE_SIZE            ( CACHE_SIZE            ),
    .ICACHE_DATA_WIDTH     ( ICACHE_DATA_WIDTH     ),
    .L0_BUFFER_FEATURE     ( L0_BUFFER_FEATURE     ),
    .MULTICAST_FEATURE     ( MULTICAST_FEATURE     ),
    .SHARED_ICACHE         ( SHARED_ICACHE         ),
    .DIRECT_MAPPED_FEATURE ( DIRECT_MAPPED_FEATURE ),
    .L2_SIZE               ( L2_SIZE               ),
    .USE_REDUCED_TAG       ( USE_REDUCED_TAG       ),

    // core parameters
    .ROM_BOOT_ADDR         ( ROM_BOOT_ADDR         ),
    .BOOT_ADDR             ( BOOT_ADDR             ),
    .INSTR_RDATA_WIDTH     ( INSTR_RDATA_WIDTH     ),

    // AXI parameters
    .AXI_ADDR_WIDTH        ( AXI_ADDR_WIDTH        ),
    .AXI_DATA_C2S_WIDTH    ( AXI_DATA_C2S_WIDTH    ),
    .AXI_DATA_S2C_WIDTH    ( AXI_DATA_S2C_WIDTH    ),
    .AXI_USER_WIDTH        ( AXI_USER_WIDTH        ),
    .AXI_ID_IN_WIDTH       ( AXI_ID_IN_WIDTH       ),
    .AXI_ID_OUT_WIDTH      ( AXI_ID_OUT_WIDTH      ),
    .AXI_STRB_C2S_WIDTH    ( AXI_STRB_C2S_WIDTH    ),
    .AXI_STRB_S2C_WIDTH    ( AXI_STRB_S2C_WIDTH    ),
    .DC_SLICE_BUFFER_WIDTH ( DC_SLICE_BUFFER_WIDTH ),

    // TCDM and log interconnect parameters
    .DATA_WIDTH            ( DATA_WIDTH            ),
    .ADDR_WIDTH            ( ADDR_WIDTH            ),
    .BE_WIDTH              ( BE_WIDTH              ),
    .TEST_SET_BIT          ( TEST_SET_BIT          ),
    .ADDR_MEM_WIDTH        ( ADDR_MEM_WIDTH        ),

    // DMA parameters
    .TCDM_ADD_WIDTH        ( TCDM_ADD_WIDTH        ),
    .NB_OUTSND_BURSTS      ( NB_OUTSND_BURSTS      ),
    .MCHAN_BURST_LENGTH    ( MCHAN_BURST_LENGTH    ),

    // peripheral and periph interconnect parameters
    .LOG_CLUSTER           ( LOG_CLUSTER           ),
    .PE_ROUTING_LSB        ( PE_ROUTING_LSB        ),
    .PE_ROUTING_MSB        ( PE_ROUTING_MSB        ),
    .EVNT_WIDTH            ( EVNT_WIDTH            ),
    .REMAP_ADDRESS         ( REMAP_ADDRESS         )
`endif
  ) pulp_cluster_i (
    .clk_i,
    .rst_ni,
    .ref_clk_i,
    .pmu_mem_pwdn_i,

    .base_addr_i,

    .test_mode_i,

    .en_sa_boot_i,

    .cluster_id_i,

    .fetch_en_i,

    .eoc_o,

    .busy_o,

    .ext_events_writetoken_i,
    .ext_events_readpointer_o,
    .ext_events_dataasync_i,

    .dma_pe_evt_ack_i,
    .dma_pe_evt_valid_o,

    .dma_pe_irq_ack_i,
    .dma_pe_irq_valid_o,

    .pf_evt_ack_i,
    .pf_evt_valid_o,

    // data slave IF
    .data_slave_aw_writetoken_i,
    .data_slave_aw_addr_i,
    .data_slave_aw_prot_i,
    .data_slave_aw_region_i,
    .data_slave_aw_len_i,
    .data_slave_aw_size_i,
    .data_slave_aw_burst_i,
    .data_slave_aw_lock_i,
    .data_slave_aw_cache_i,
    .data_slave_aw_qos_i,
    .data_slave_aw_id_i,
    .data_slave_aw_user_i,
    .data_slave_aw_readpointer_o,

    .data_slave_ar_writetoken_i,
    .data_slave_ar_addr_i,
    .data_slave_ar_prot_i,
    .data_slave_ar_region_i,
    .data_slave_ar_len_i,
    .data_slave_ar_size_i,
    .data_slave_ar_burst_i,
    .data_slave_ar_lock_i,
    .data_slave_ar_cache_i,
    .data_slave_ar_qos_i,
    .data_slave_ar_id_i,
    .data_slave_ar_user_i,
    .data_slave_ar_readpointer_o,

    .data_slave_w_writetoken_i,
    .data_slave_w_data_i,
    .data_slave_w_strb_i,
    .data_slave_w_user_i,
    .data_slave_w_last_i,
    .data_slave_w_readpointer_o,

    .data_slave_r_writetoken_o,
    .data_slave_r_data_o,
    .data_slave_r_resp_o,
    .data_slave_r_last_o,
    .data_slave_r_id_o,
    .data_slave_r_user_o,
    .data_slave_r_readpointer_i,

    .data_slave_b_writetoken_o,
    .data_slave_b_resp_o,
    .data_slave_b_id_o,
    .data_slave_b_user_o,
    .data_slave_b_readpointer_i,

    // data maste rIF
    .data_master_aw_writetoken_o,
    .data_master_aw_addr_o,
    .data_master_aw_prot_o,
    .data_master_aw_region_o,
    .data_master_aw_len_o,
    .data_master_aw_size_o,
    .data_master_aw_burst_o,
    .data_master_aw_lock_o,
    .data_master_aw_cache_o,
    .data_master_aw_qos_o,
    .data_master_aw_id_o,
    .data_master_aw_user_o,
    .data_master_aw_readpointer_i,

    .data_master_ar_writetoken_o,
    .data_master_ar_addr_o,
    .data_master_ar_prot_o,
    .data_master_ar_region_o,
    .data_master_ar_len_o,
    .data_master_ar_size_o,
    .data_master_ar_burst_o,
    .data_master_ar_lock_o,
    .data_master_ar_cache_o,
    .data_master_ar_qos_o,
    .data_master_ar_id_o,
    .data_master_ar_user_o,
    .data_master_ar_readpointer_i,

    .data_master_w_writetoken_o,
    .data_master_w_data_o,
    .data_master_w_strb_o,
    .data_master_w_user_o,
    .data_master_w_last_o,
    .data_master_w_readpointer_i,

    .data_master_r_writetoken_i,
    .data_master_r_data_i,
    .data_master_r_resp_i,
    .data_master_r_last_i,
    .data_master_r_id_i,
    .data_master_r_user_i,
    .data_master_r_readpointer_o,

    .data_master_b_writetoken_i,
    .data_master_b_resp_i,
    .data_master_b_id_i,
    .data_master_b_user_i,
    .data_master_b_readpointer_o
  );

endmodule
