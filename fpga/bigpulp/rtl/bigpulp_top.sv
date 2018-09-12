// Copyright 2016-2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

// --=========================================================================--
//
// ██████╗ ██╗ ██████╗ ██████╗ ██╗   ██╗██╗     ██████╗
// ██╔══██╗██║██╔════╝ ██╔══██╗██║   ██║██║     ██╔══██╗
// ██████╔╝██║██║  ███╗██████╔╝██║   ██║██║     ██████╔╝
// ██╔══██╗██║██║   ██║██╔═══╝ ██║   ██║██║     ██╔═══╝
// ██████╔╝██║╚██████╔╝██║     ╚██████╔╝███████╗██║
// ╚═════╝ ╚═╝ ╚═════╝ ╚═╝      ╚═════╝ ╚══════╝╚═╝
//
// Author: Pirmin Vogel - vogelpi@iis.ee.ethz.ch
//
// Purpose : HDL top for PULP on V2F-1XV7 with V2M-Juno
//
// --=========================================================================--

localparam NB_CORES    = 8;
localparam NB_CLUSTERS = 4;

// GPIO: Host -> PULP
`define HOST2PULP_FETCH_EN_0                 0
`define HOST2PULP_FETCH_EN_N     NB_CLUSTERS-1 // max 15

`define HOST2PULP_INTR_RAB_MISS_DIS         17

`ifdef RAB_AX_LOG_EN
  `define HOST2PULP_RAB_LOG_EN             27
  `define HOST2PULP_RAB_AR_LOG_CLR         28
  `define HOST2PULP_RAB_AW_LOG_CLR         29
`endif
`define HOST2PULP_CLK_EN                    30
`define HOST2PULP_RST_N                     31

// GPIO: PULP -> Host
`define PULP2HOST_EOC_0                      0
`define PULP2HOST_EOC_N          NB_CLUSTERS-1 // max 15
`ifdef RAB_AX_LOG_EN
   `define PULP2HOST_RAB_AR_LOG_RDY         28
   `define PULP2HOST_RAB_AW_LOG_RDY         29
`endif

// interrupts: PULP -> Host
`define PULP2HOST_INTR_EOC_0                 0
`define PULP2HOST_INTR_EOC_N     NB_CLUSTERS-1 // max 15

`define PULP2HOST_INTR_MAILBOX              16
`define PULP2HOST_INTR_RAB_MISS             17
`define PULP2HOST_INTR_RAB_MULTI            18
`define PULP2HOST_INTR_RAB_PROT             19
`define PULP2HOST_INTR_RAB_MHR_FULL         20
`ifdef RAB_AX_LOG_EN
  `define PULP2HOST_INTR_RAB_AR_LOG_FULL   21
  `define PULP2HOST_INTR_RAB_AW_LOG_FULL   22
`endif

module bigpulp_top
  (
    // Clocks and resets signals
    input  wire            ACLK,
    input  wire            ARESETn,

    // DDR RAM - DDR3 on V2F_1XV7 not used for now
    // output wire  [15:0]    DDR3_A,
    // output wire  [2:0]     DDR3_BA,
    // output wire  [1:0]     DDR3_CK_P,
    // output wire  [1:0]     DDR3_CK_N,
    // output wire  [1:0]     DDR3_CKE,
    // output wire  [7:0]     DDR3_DM,
    // inout  wire  [63:0]    DDR3_DQ,
    // inout  wire  [7:0]     DDR3_DQS_P,
    // inout  wire  [7:0]     DDR3_DQS_N,
    // output wire            DDR3_nCAS,
    // input  wire            DDR3_nEVENT,
    // output wire            DDR3_nRAS,
    // output wire            DDR3_nRESET,
    // inout  wire  [1:0]     DDR3_nS,
    // output wire            DDR3_nWE,
    // output wire  [1:0]     DDR3_ODT,
    // output wire            DDR3_SCL,
    // inout  wire            DDR3_SDA,
    // input  wire            DDR3_REFCLK_P,
    // input  wire            DDR3_REFCLK_N,
    // output wire            init_calib_complete,
    // output wire            mmcm_locked,
    // input  wire            DDR_SYS_CLK,

`ifndef PULP_FPGA_SIM
    // Thin-links on X-Bus
    input   wire     [7:0] tmif_data_o,
    input   wire           tmif_ctl_o,
    input   wire           tmif_valid_o,
    output  wire     [7:0] tmif_data_i,
    output  wire     [1:0] tmif_ctl_i,
    output  wire           tmif_valid_i,
    input   wire           tmif_clko,
    input   wire           tmif_clki,
    output  wire    [27:0] tsif_data_i,
    output  wire           tsif_ctl_i,
    output  wire           tsif_valid_i,
    input   wire    [23:0] tsif_data_o,
    input   wire     [1:0] tsif_ctl_o,
    input   wire           tsif_valid_o,
    input   wire           tsif_clki,
    input   wire           tsif_clko,
    input   wire           tsif_resetn,
    input   wire           tmif_resetn,
    input   wire           tmif_clkl_x2,
    input   wire           tsif_clkl_x2,
    input   wire           tmif_clkl_x1,
    input   wire           tsif_clkl_x1,

    // SCC
    input  wire      [7:0] DLL_LOCKED,
    input  wire            CFGCLK,          // Configuration data serial shift clock
    input  wire            nCFGRST,         // Config data reset to default settings
    input  wire            CFGLOAD,         // Load newly shifter data for read or write
    input  wire            CFGWnR,          // 1 = write new config, 0 = Read current config
    input  wire            CFGDATAIN,       // Serial shift data, sample on rising edge of CFGCLK
    output wire            CFGDATAOUT,      // Serial shift out data of current config

`else // PULP_FPGA_SIM
    input  wire            tmif_clkl_x1,
    input  wire            tmif_resetn,

    input  wire     [31:0] m_axi_sim_araddr  ,
    input  wire      [1:0] m_axi_sim_arburst ,
    input  wire      [3:0] m_axi_sim_arcache ,
    input  wire     [14:0] m_axi_sim_arid    ,
    input  wire      [7:0] m_axi_sim_arlen   ,
    input  wire            m_axi_sim_arlock  ,
    input  wire      [2:0] m_axi_sim_arprot  ,
    input  wire      [3:0] m_axi_sim_arqos   ,
    output wire            m_axi_sim_arready ,
    input  wire      [3:0] m_axi_sim_arregion,
    input  wire      [2:0] m_axi_sim_arsize  ,
    input  wire            m_axi_sim_arvalid ,
    input  wire     [31:0] m_axi_sim_awaddr  ,
    input  wire      [1:0] m_axi_sim_awburst ,
    input  wire      [3:0] m_axi_sim_awcache ,
    input  wire     [14:0] m_axi_sim_awid    ,
    input  wire      [7:0] m_axi_sim_awlen   ,
    input  wire            m_axi_sim_awlock  ,
    input  wire      [2:0] m_axi_sim_awprot  ,
    input  wire      [3:0] m_axi_sim_awqos   ,
    output wire            m_axi_sim_awready ,
    input  wire      [3:0] m_axi_sim_awregion,
    input  wire      [2:0] m_axi_sim_awsize  ,
    input  wire            m_axi_sim_awvalid ,
    output wire     [14:0] m_axi_sim_bid     ,
    input  wire            m_axi_sim_bready  ,
    output wire      [1:0] m_axi_sim_bresp   ,
    output wire            m_axi_sim_bvalid  ,
    output wire     [63:0] m_axi_sim_rdata   ,
    output wire     [14:0] m_axi_sim_rid     ,
    output wire            m_axi_sim_rlast   ,
    input  wire            m_axi_sim_rready  ,
    output wire      [1:0] m_axi_sim_rresp   ,
    output wire            m_axi_sim_rvalid  ,
    input  wire     [63:0] m_axi_sim_wdata   ,
    input  wire     [14:0] m_axi_sim_wid     ,
    input  wire            m_axi_sim_wlast   ,
    output wire            m_axi_sim_wready  ,
    input  wire      [7:0] m_axi_sim_wstrb   ,
    input  wire            m_axi_sim_wvalid  ,
`endif

    // Interrupts
    output wire            pulp2host_intr_o
  );


  // ███████╗██╗ ██████╗ ███╗   ██╗ █████╗ ██╗     ███████╗
  // ██╔════╝██║██╔════╝ ████╗  ██║██╔══██╗██║     ██╔════╝
  // ███████╗██║██║  ███╗██╔██╗ ██║███████║██║     ███████╗
  // ╚════██║██║██║   ██║██║╚██╗██║██╔══██║██║     ╚════██║
  // ███████║██║╚██████╔╝██║ ╚████║██║  ██║███████╗███████║
  // ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚══════╝
  //
  //-------------------------------------------------------------------------
  // Thin Link Slave port, External master port
  //-------------------------------------------------------------------------
  wire [13:0]            awid_tlx_in;
  wire [39:0]            awaddr_tlx_in;
  wire [7:0]             awlen_tlx_in;
  wire [2:0]             awsize_tlx_in;
  wire [1:0]             awburst_tlx_in;
  wire                   awlock_tlx_in;
  wire [3:0]             awcache_tlx_in;
  wire [2:0]             awprot_tlx_in;
  wire [3:0]             awqos_tlx_in;
  wire                   awvalid_tlx_in;
  wire                   awready_tlx_in;
  wire [63:0]            wdata_tlx_in;
  wire [7:0]             wstrb_tlx_in;
  wire                   wlast_tlx_in;
  wire                   wvalid_tlx_in;
  wire                   wready_tlx_in;
  wire [13:0]            bid_tlx_in;
  wire [1:0]             bresp_tlx_in;
  wire                   bvalid_tlx_in;
  wire                   bready_tlx_in;
  wire [13:0]            arid_tlx_in;
  wire [39:0]            araddr_tlx_in;
  wire [7:0]             arlen_tlx_in;
  wire [2:0]             arsize_tlx_in;
  wire [1:0]             arburst_tlx_in;
  wire                   arlock_tlx_in;
  wire [3:0]             arcache_tlx_in;
  wire [2:0]             arprot_tlx_in;
  wire [3:0]             arqos_tlx_in;
  wire                   arvalid_tlx_in;
  wire                   arready_tlx_in;
  wire [13:0]            rid_tlx_in;
  wire [63:0]            rdata_tlx_in;
  wire [1:0]             rresp_tlx_in;
  wire                   rlast_tlx_in;
  wire                   rvalid_tlx_in;
  wire                   rready_tlx_in;

  //-------------------------------------------------------------------------
  // Thin Link Master port, External Slave port
  //-------------------------------------------------------------------------
  wire [5:0]             awid_tlx_out;
  wire [39:0]            awaddr_tlx_out;
  wire [7:0]             awlen_tlx_out;
  wire [2:0]             awsize_tlx_out;
  wire [1:0]             awburst_tlx_out;
  wire                   awlock_tlx_out;
  wire [3:0]             awcache_tlx_out;
  wire [2:0]             awprot_tlx_out;
  wire                   awvalid_tlx_out;
  wire                   awready_tlx_out;
  wire [127:0]           wdata_tlx_out;
  wire [15:0]            wstrb_tlx_out;
  wire                   wlast_tlx_out;
  wire                   wvalid_tlx_out;
  wire                   wready_tlx_out;
  wire [5:0]             bid_tlx_out;
  wire [1:0]             bresp_tlx_out;
  wire                   bvalid_tlx_out;
  wire                   bready_tlx_out;
  wire [5:0]             arid_tlx_out;
  wire [39:0]            araddr_tlx_out;
  wire [7:0]             arlen_tlx_out;
  wire [2:0]             arsize_tlx_out;
  wire [1:0]             arburst_tlx_out;
  wire                   arlock_tlx_out;
  wire [3:0]             arcache_tlx_out;
  wire [2:0]             arprot_tlx_out;
  wire                   arvalid_tlx_out;
  wire                   arready_tlx_out;
  wire [5:0]             rid_tlx_out;
  wire [127:0]           rdata_tlx_out;
  wire [1:0]             rresp_tlx_out;
  wire                   rlast_tlx_out;
  wire                   rvalid_tlx_out;
  wire                   rready_tlx_out;

  logic [3:0]            arsnoop_tlx_out;
  logic [1:0]            ardomain_tlx_out;
  logic [5:0]            aruser_tlx_out;

  logic [2:0]            awsnoop_tlx_out;
  logic [1:0]            awdomain_tlx_out;
  logic [4:0]            awuser_tlx_out;

  //-------------------------------------------------------------------------
  // SCC EPROM APB signals
  //-------------------------------------------------------------------------
  wire                   psel_apb_scc;
  wire                   penable_apb_scc;
  wire [31:0]            paddr_apb_scc;
  wire                   pwrite_apb_scc;
  wire [31:0]            pwdata_apb_scc;
  wire [31:0]            prdata_apb_scc;
  wire                   pslverr_apb_scc;
  wire                   pready_apb_scc;

  //-------------------------------------------------------------------------
  // APB clock and reset
  //-------------------------------------------------------------------------
  wire                   pclken_apb;
  assign pclken_apb = 1'b1;

  //-------------------------------------------------------------------------
  // Interconnect Wrapper
  //-------------------------------------------------------------------------
  logic [31:0]            clking_axi_araddr;
  logic [2:0]             clking_axi_arprot;
  logic                   clking_axi_arready;
  logic                   clking_axi_arvalid;
  logic [31:0]            clking_axi_awaddr;
  logic [2:0]             clking_axi_awprot;
  logic                   clking_axi_awready;
  logic                   clking_axi_awvalid;
  logic                   clking_axi_bready;
  logic [1:0]             clking_axi_bresp;
  logic                   clking_axi_bvalid;
  logic [31:0]            clking_axi_rdata;
  logic                   clking_axi_rready;
  logic [1:0]             clking_axi_rresp;
  logic                   clking_axi_rvalid;
  logic [31:0]            clking_axi_wdata;
  logic                   clking_axi_wready;
  logic [3:0]             clking_axi_wstrb;
  logic                   clking_axi_wvalid;

  logic [31:0]            host2pulp_gpio;
  logic [31:0]            pulp2host_gpio;

  logic [15:0]            rab_lite_araddr;
  logic [2:0]             rab_lite_arprot;
  logic [0:0]             rab_lite_arready;
  logic [0:0]             rab_lite_arvalid;
  logic [15:0]            rab_lite_awaddr;
  logic [2:0]             rab_lite_awprot;
  logic [0:0]             rab_lite_awready;
  logic [0:0]             rab_lite_awvalid;
  logic [0:0]             rab_lite_bready;
  logic [1:0]             rab_lite_bresp;
  logic [0:0]             rab_lite_bvalid;
  logic [63:0]            rab_lite_rdata;
  logic [0:0]             rab_lite_rready;
  logic [1:0]             rab_lite_rresp;
  logic [0:0]             rab_lite_rvalid;
  logic [63:0]            rab_lite_wdata;
  logic [0:0]             rab_lite_wready;
  logic [7:0]             rab_lite_wstrb;
  logic [0:0]             rab_lite_wvalid;

  logic [39:0]            rab_master_araddr;
  logic [1:0]             rab_master_arburst;
  logic [3:0]             rab_master_arcache;
  logic [5:0]             rab_master_arid;
  logic [7:0]             rab_master_arlen;
  logic                   rab_master_arlock;
  logic [2:0]             rab_master_arprot;
  logic [3:0]             rab_master_arqos;
  logic                   rab_master_arready;
  logic [3:0]             rab_master_arregion;
  logic [2:0]             rab_master_arsize;
  logic                   rab_master_arvalid;
  logic [5:0]             rab_master_aruser;
  logic [39:0]            rab_master_awaddr;
  logic [1:0]             rab_master_awburst;
  logic [3:0]             rab_master_awcache;
  logic [5:0]             rab_master_awid;
  logic [7:0]             rab_master_awlen;
  logic                   rab_master_awlock;
  logic [2:0]             rab_master_awprot;
  logic [3:0]             rab_master_awqos;
  logic                   rab_master_awready;
  logic [3:0]             rab_master_awregion;
  logic [2:0]             rab_master_awsize;
  logic [5:0]             rab_master_awuser;
  logic                   rab_master_awvalid;
  logic [5:0]             rab_master_bid;
  logic                   rab_master_bready;
  logic [1:0]             rab_master_bresp;
  logic                   rab_master_bvalid;
  logic [5:0]             rab_master_buser;
  logic [63:0]            rab_master_rdata;
  logic [5:0]             rab_master_rid;
  logic                   rab_master_rlast;
  logic                   rab_master_rready;
  logic [1:0]             rab_master_rresp;
  logic [5:0]             rab_master_ruser;
  logic                   rab_master_rvalid;
  logic [63:0]            rab_master_wdata;
  logic                   rab_master_wlast;
  logic                   rab_master_wready;
  logic [7:0]             rab_master_wstrb;
  logic [5:0]             rab_master_wuser;
  logic                   rab_master_wvalid;

  logic [31:0]            rab_slave_araddr;
  logic [1:0]             rab_slave_arburst;
  logic [3:0]             rab_slave_arcache;
  logic [14:0]            rab_slave_arid;
  logic [7:0]             rab_slave_arlen;
  logic                   rab_slave_arlock;
  logic [2:0]             rab_slave_arprot;
  logic [3:0]             rab_slave_arqos;
  logic                   rab_slave_arready;
  logic [3:0]             rab_slave_arregion;
  logic [2:0]             rab_slave_arsize;
  logic [5:0]             rab_slave_aruser;
  logic                   rab_slave_arvalid;
  logic [31:0]            rab_slave_awaddr;
  logic [1:0]             rab_slave_awburst;
  logic [3:0]             rab_slave_awcache;
  logic [14:0]            rab_slave_awid;
  logic [7:0]             rab_slave_awlen;
  logic                   rab_slave_awlock;
  logic [2:0]             rab_slave_awprot;
  logic [3:0]             rab_slave_awqos;
  logic                   rab_slave_awready;
  logic [3:0]             rab_slave_awregion;
  logic [2:0]             rab_slave_awsize;
  logic [5:0]             rab_slave_awuser;
  logic                   rab_slave_awvalid;
  logic [14:0]            rab_slave_bid;
  logic                   rab_slave_bready;
  logic [1:0]             rab_slave_bresp;
  logic                   rab_slave_bvalid;
  logic [5:0]             rab_slave_buser;
  logic [63:0]            rab_slave_rdata;
  logic [14:0]            rab_slave_rid;
  logic                   rab_slave_rlast;
  logic                   rab_slave_rready;
  logic [1:0]             rab_slave_rresp;
  logic [5:0]             rab_slave_ruser;
  logic                   rab_slave_rvalid;
  logic [63:0]            rab_slave_wdata;
  logic                   rab_slave_wlast;
  logic                   rab_slave_wready;
  logic [7:0]             rab_slave_wstrb;
  logic [5:0]             rab_slave_wuser;
  logic                   rab_slave_wvalid;

  // Host -> RAB Memory Logs
`ifdef RAB_AX_LOG_EN
  logic                   RabArBramClk_C;
  logic                   RabArBramRst_R;
  logic                   RabArBramEn_S;
  logic [32-1:0]          RabArBramAddr_S;
  logic [32-1:0]          RabArBramRd_D;
  logic [32-1:0]          RabArBramWr_D;
  logic [ 4-1:0]          RabArBramWrEn_S;
  logic                   RabAwBramClk_C;
  logic                   RabAwBramRst_R;
  logic                   RabAwBramEn_S;
  logic [32-1:0]          RabAwBramAddr_S;
  logic [32-1:0]          RabAwBramRd_D;
  logic [32-1:0]          RabAwBramWr_D;
  logic [ 4-1:0]          RabAwBramWrEn_S;
`endif

  // RAB Logger Control
`ifdef RAB_AX_LOG_EN
  logic                   RabLogEn_S;
  logic                   RabArLogClr_S;
  logic                   RabAwLogClr_S;
  logic                   RabArLogRdy_S;
  logic                   RabAwLogRdy_S;
`endif

  //-------------------------------------------------------------------------
  // AXI Interrupt Register
  //-------------------------------------------------------------------------
  AXI_LITE #(
    .AXI_ADDR_WIDTH ( 32 ),
    .AXI_DATA_WIDTH ( 64 ),
    .AXI_ID_WIDTH   ( 6  ),
    .AXI_USER_WIDTH ( 6  )
  ) intr_axi();

  logic [63:0]            pulp2host_intr;

  //-------------------------------------------------------------------------
  // Xilinx Clock Manager
  //-------------------------------------------------------------------------
  logic                   ClkRef_C;
  logic                   RstMaster_RB;
  logic                   ClkIcHost_C;
  logic                   ClkEn_S;
  logic                   RstDebug_R;
  logic                   RstUser_RB;

  logic                   ClkSoc_C;
  logic                   ClkSocGated_C;
  logic                   ClkCluster_C;
  logic                   ClkClusterGated_C;

  logic                   RstSoc_RB;
  logic                   RstIcPulp_RB;
  logic                   RstIcPulpGated_RB;
  logic                   RstIcHost_RB;
  logic                   RstIcHostSync_RB;
  logic                   RstIcHostClkConv_RB;

  //-------------------------------------------------------------------------
  // PULP SoC
  //-------------------------------------------------------------------------
  logic                   IntrRabMissEn_S;

  logic [NB_CLUSTERS-1:0] intr_eoc;
  logic                   intr_mailbox;
  logic                   intr_rab_miss;
  logic                   intr_rab_miss_host;
  logic                   intr_rab_multi;
  logic                   intr_rab_prot;
  logic                   intr_rab_mhf_full;

`ifdef RAB_AX_LOG_EN
  logic                   intr_rab_aw_log_full;
  logic                   intr_rab_ar_log_full;
`endif

  logic                   mode_select;
  logic                   test_mode;

  logic [NB_CLUSTERS-1:0] fetch_en;
  logic [NB_CLUSTERS-1:0] cluster_busy;

  //-------------------------------------------------------------------------
  // Stdout
  //-------------------------------------------------------------------------
  logic                   stdout_master_awvalid;
  logic [31:0]            stdout_master_awaddr;
  logic [2:0]             stdout_master_awprot;
  logic [3:0]             stdout_master_awregion;
  logic [7:0]             stdout_master_awlen;
  logic [2:0]             stdout_master_awsize;
  logic [1:0]             stdout_master_awburst;
  logic                   stdout_master_awlock;
  logic [3:0]             stdout_master_awcache;
  logic [3:0]             stdout_master_awqos;
  logic [9:0]             stdout_master_awid;
  logic [5:0]             stdout_master_awuser;
  logic                   stdout_master_awready;
  logic                   stdout_master_arvalid;
  logic [31:0]            stdout_master_araddr;
  logic [2:0]             stdout_master_arprot;
  logic [3:0]             stdout_master_arregion;
  logic [7:0]             stdout_master_arlen;
  logic [2:0]             stdout_master_arsize;
  logic [1:0]             stdout_master_arburst;
  logic                   stdout_master_arlock;
  logic [3:0]             stdout_master_arcache;
  logic [3:0]             stdout_master_arqos;
  logic [9:0]             stdout_master_arid;
  logic [5:0]             stdout_master_aruser;
  logic                   stdout_master_arready;
  logic                   stdout_master_wvalid;
  logic [63:0]            stdout_master_wdata;
  logic [7:0]             stdout_master_wstrb;
  logic [5:0]             stdout_master_wuser;
  logic                   stdout_master_wlast;
  logic                   stdout_master_wready;
  logic                   stdout_master_rvalid;
  logic [63:0]            stdout_master_rdata;
  logic [1:0]             stdout_master_rresp;
  logic                   stdout_master_rlast;
  logic [9:0]             stdout_master_rid;
  logic [5:0]             stdout_master_ruser;
  logic                   stdout_master_rready;
  logic                   stdout_master_bvalid;
  logic [1:0]             stdout_master_bresp;
  logic [9:0]             stdout_master_bid;
  logic [5:0]             stdout_master_buser;
  logic                   stdout_master_bready;


  //  █████╗ ███████╗███████╗██╗ ██████╗ ███╗   ██╗███╗   ███╗███████╗███╗   ██╗████████╗███████╗
  // ██╔══██╗██╔════╝██╔════╝██║██╔════╝ ████╗  ██║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
  // ███████║███████╗███████╗██║██║  ███╗██╔██╗ ██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ███████╗
  // ██╔══██║╚════██║╚════██║██║██║   ██║██║╚██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║
  // ██║  ██║███████║███████║██║╚██████╔╝██║ ╚████║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ███████║
  // ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
  //
  //-------------------------------------------------------------------------
  // Outputs
  //-------------------------------------------------------------------------

  //-------------------------------------------------------------------------
  // Clocks and resets
  //-------------------------------------------------------------------------
  // ACLK = 100 MHz reference
  // tmif_clkl_x1 = tsif_clkl_x1 = TLX clocks
  // ARESETn = global reset, sync to ACLK
  // tmif_resetn = tsif_resetn = TLX resets, derived from ARESETn, sync to tmif_clkl_x2
  assign ClkRef_C     = ACLK;
  assign RstMaster_RB = ARESETn;      // sync to ACLK
  assign ClkIcHost_C  = tmif_clkl_x1; // == tsif_clkl_x1
  assign RstIcHost_RB = tmif_resetn;  // == tsif_resetn

  assign ClkEn_S       = host2pulp_gpio[`HOST2PULP_CLK_EN];
  assign RstUser_RB    = host2pulp_gpio[`HOST2PULP_RST_N];

  //-------------------------------------------------------------------------
  // Signals
  //-------------------------------------------------------------------------
  assign IntrRabMissEn_S    = ~host2pulp_gpio[`HOST2PULP_INTR_RAB_MISS_DIS];
  assign intr_rab_miss_host = intr_rab_miss & IntrRabMissEn_S;

`ifdef RAB_AX_LOG_EN
  assign RabLogEn_S    = host2pulp_gpio[`HOST2PULP_RAB_LOG_EN];
  assign RabArLogClr_S = host2pulp_gpio[`HOST2PULP_RAB_AR_LOG_CLR];
  assign RabAwLogClr_S = host2pulp_gpio[`HOST2PULP_RAB_AW_LOG_CLR];
`endif

  assign fetch_en = host2pulp_gpio[`HOST2PULP_FETCH_EN_N:`HOST2PULP_FETCH_EN_0];

  assign mode_select = 0;
  assign test_mode   = 1'b0;

  // PULP2HOST GPIOs
  logic [31:0]            pulp2host_gpio_r;
  always_ff @(posedge ClkSoc_C or negedge RstIcPulp_RB)
    begin
      if (RstIcPulp_RB == 1'b0)
        pulp2host_gpio_r = 32'b0;
      else
        begin
          pulp2host_gpio_r[`PULP2HOST_EOC_N:`PULP2HOST_EOC_0] = intr_eoc;
       `ifdef RAB_AX_LOG_EN
          pulp2host_gpio_r[`PULP2HOST_RAB_AR_LOG_RDY] = RabArLogRdy_S;
          pulp2host_gpio_r[`PULP2HOST_RAB_AW_LOG_RDY] = RabAwLogRdy_S;
       `endif
        end
    end
  assign pulp2host_gpio = pulp2host_gpio_r;

  // interrupts
  always_comb
    begin
      pulp2host_intr = '0;

      pulp2host_intr[`PULP2HOST_INTR_EOC_N:`PULP2HOST_INTR_EOC_0] = intr_eoc;
      pulp2host_intr[`PULP2HOST_INTR_MAILBOX                    ] = intr_mailbox;
      pulp2host_intr[`PULP2HOST_INTR_RAB_MISS                   ] = intr_rab_miss_host;
      pulp2host_intr[`PULP2HOST_INTR_RAB_MULTI                  ] = intr_rab_multi;
      pulp2host_intr[`PULP2HOST_INTR_RAB_PROT                   ] = intr_rab_prot;
      pulp2host_intr[`PULP2HOST_INTR_RAB_MHR_FULL               ] = intr_rab_mhf_full;
    `ifdef RAB_AX_LOG_EN
      pulp2host_intr[`PULP2HOST_INTR_RAB_AR_LOG_FULL            ] = intr_rab_ar_log_full;
      pulp2host_intr[`PULP2HOST_INTR_RAB_AW_LOG_FULL            ] = intr_rab_aw_log_full;
    `endif
    end

  // ACE-Lite signals on TLX master port (See AMBA AXI and ACE Protocol Specification C3.1, C11.2)
  assign arsnoop_tlx_out = 4'b0;
  assign awsnoop_tlx_out = 3'b0;
  always_comb begin
     if (arcache_tlx_out[3:2] == 2'b00) begin  // Device or Non-Cacheable
        ardomain_tlx_out = 2'b11;                    // System -> ReadNoSnoop
     end else begin                            // Write-Through or Write-Back
        ardomain_tlx_out = 2'b10;                    // Outer-Shareable -> ReadOnce
     end
  end
  always_comb begin
     if (awcache_tlx_out == 4'b0011) begin  // Device or Non-Cacheable
        awdomain_tlx_out = 2'b11;                    // System -> WriteNoSnoop
     end else begin                         // Write-Through or Write-Back
        awdomain_tlx_out = 2'b10;                    // Outer-Shareable -> WriteUnique
     end
  end

  assign aruser_tlx_out[5:2] = arsnoop_tlx_out;
  assign aruser_tlx_out[1:0] = ardomain_tlx_out;
  assign awuser_tlx_out[4:2] = awsnoop_tlx_out;
  assign awuser_tlx_out[1:0] = awdomain_tlx_out;

  //******************************************************************************
  //**************************** Unused AXI signals ******************************
  //******************************************************************************

  // user signals
  // rab_master_aruser, _awuser, _wuser left open
  assign rab_master_ruser = 6'b0;
  assign rab_master_buser = 6'b0;

  // stdout_master_aruser, _awuser, _wuser left open
  assign stdout_master_ruser = 6'b0;
  assign stdout_master_buser = 6'b0;

  // rab_slave_ruser, _buser left open
  assign rab_slave_aruser = 6'b0;
  assign rab_slave_awuser = 6'b0;
  assign rab_slave_wuser  = 6'b0;

  // qos signals
  // arqos_tlx_out, awqos_, arregion_, awregion_ left open
  assign arqos_tlx_in = 4'b0;
  assign awqos_tlx_in = 4'b0;

  // serialization in DWIDTH converter, no ID
  assign awid_tlx_out = 6'b0;
  assign arid_tlx_out = 6'b0;

`ifndef PULP_FPGA_SIM

  // ████████╗██╗  ██╗██╗███╗   ██╗    ██╗     ██╗███╗   ██╗██╗  ██╗███████╗
  // ╚══██╔══╝██║  ██║██║████╗  ██║    ██║     ██║████╗  ██║██║ ██╔╝██╔════╝
  //    ██║   ███████║██║██╔██╗ ██║    ██║     ██║██╔██╗ ██║█████╔╝ ███████╗
  //    ██║   ██╔══██║██║██║╚██╗██║    ██║     ██║██║╚██╗██║██╔═██╗ ╚════██║
  //    ██║   ██║  ██║██║██║ ╚████║    ███████╗██║██║ ╚████║██║  ██╗███████║
  //    ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
  //
  //******************************************************************************
  //********************* Thin Link Slave port, External master port *************
  //******************************************************************************
  mod_nic400_tlx_axi_tmif_fpga_side u_nic400_tlx_axi_tmif_fpga_side (
    .awid_slave_0_m       ( awid_tlx_in    ),
    .awaddr_slave_0_m     ( awaddr_tlx_in  ),
    .awlen_slave_0_m      ( awlen_tlx_in   ),
    .awsize_slave_0_m     ( awsize_tlx_in  ),
    .awburst_slave_0_m    ( awburst_tlx_in ),
    .awlock_slave_0_m     ( awlock_tlx_in  ),
    .awcache_slave_0_m    ( awcache_tlx_in ),
    .awprot_slave_0_m     ( awprot_tlx_in  ),
    .awvalid_slave_0_m    ( awvalid_tlx_in ),
    .awready_slave_0_m    ( awready_tlx_in ),
    .wdata_slave_0_m      ( wdata_tlx_in   ),
    .wstrb_slave_0_m      ( wstrb_tlx_in   ),
    .wlast_slave_0_m      ( wlast_tlx_in   ),
    .wvalid_slave_0_m     ( wvalid_tlx_in  ),
    .wready_slave_0_m     ( wready_tlx_in  ),
    .bid_slave_0_m        ( bid_tlx_in     ),
    .bresp_slave_0_m      ( bresp_tlx_in   ),
    .bvalid_slave_0_m     ( bvalid_tlx_in  ),
    .bready_slave_0_m     ( bready_tlx_in  ),
    .arid_slave_0_m       ( arid_tlx_in    ),
    .araddr_slave_0_m     ( araddr_tlx_in  ),
    .arlen_slave_0_m      ( arlen_tlx_in   ),
    .arsize_slave_0_m     ( arsize_tlx_in  ),
    .arburst_slave_0_m    ( arburst_tlx_in ),
    .arlock_slave_0_m     ( arlock_tlx_in  ),
    .arcache_slave_0_m    ( arcache_tlx_in ),
    .arprot_slave_0_m     ( arprot_tlx_in  ),
    .arvalid_slave_0_m    ( arvalid_tlx_in ),
    .arready_slave_0_m    ( arready_tlx_in ),
    .rid_slave_0_m        ( rid_tlx_in     ),
    .rdata_slave_0_m      ( rdata_tlx_in   ),
    .rresp_slave_0_m      ( rresp_tlx_in   ),
    .rlast_slave_0_m      ( rlast_tlx_in   ),
    .rvalid_slave_0_m     ( rvalid_tlx_in  ),
    .rready_slave_0_m     ( rready_tlx_in  ),
    .awuser_slave_0_m     (                ),
    .aruser_slave_0_m     (                ),

    // Non-bus signals
    .tclk_rev_2x          ( tmif_clkl_x2 ),
    .tclk_rev_1x          ( tmif_clkl_x1 ), // Now input
    .tclk_rev_resetn      ( tmif_resetn  ),

    // Instance: outputs to JUNO
    .tmif_data_i          ( tmif_data_i  ),
    .tmif_ctl_i           ( tmif_ctl_i   ),
    .tmif_valid_i         ( tmif_valid_i ),
    .tmif_clk_i           ( tmif_clki    ), // Shift clock. Now input.

    // Instance: inputs from JUNO
    .tmif_data_o          ( tmif_data_o  ),
    .tmif_ctl_o           ( tmif_ctl_o   ),
    .tmif_valid_o         ( tmif_valid_o ),
    .tmif_clk_o           ( tmif_clko    )
  );

  //******************************************************************************
  //********************* Thin Link Master port, External Slave port *************
  //******************************************************************************
  mod_nic400_tlx_axi_tsif_fpga_side u_nic400_tlx_axi_tsif_fpga_side (
    .awid_slave_0_s      ( awid_tlx_out    ),
    .awaddr_slave_0_s    ( awaddr_tlx_out  ),
    .awlen_slave_0_s     ( awlen_tlx_out   ),
    .awsize_slave_0_s    ( awsize_tlx_out  ),
    .awburst_slave_0_s   ( awburst_tlx_out ),
    .awlock_slave_0_s    ( awlock_tlx_out  ),
    .awcache_slave_0_s   ( awcache_tlx_out ),
    .awprot_slave_0_s    ( awprot_tlx_out  ),
    .awvalid_slave_0_s   ( awvalid_tlx_out ),
    .awready_slave_0_s   ( awready_tlx_out ),
    .wdata_slave_0_s     ( wdata_tlx_out   ),
    .wstrb_slave_0_s     ( wstrb_tlx_out   ),
    .wlast_slave_0_s     ( wlast_tlx_out   ),
    .wvalid_slave_0_s    ( wvalid_tlx_out  ),
    .wready_slave_0_s    ( wready_tlx_out  ),
    .bid_slave_0_s       ( bid_tlx_out     ),
    .bresp_slave_0_s     ( bresp_tlx_out   ),
    .bvalid_slave_0_s    ( bvalid_tlx_out  ),
    .bready_slave_0_s    ( bready_tlx_out  ),
    .arid_slave_0_s      ( arid_tlx_out    ),
    .araddr_slave_0_s    ( araddr_tlx_out  ),
    .arlen_slave_0_s     ( arlen_tlx_out   ),
    .arsize_slave_0_s    ( arsize_tlx_out  ),
    .arburst_slave_0_s   ( arburst_tlx_out ),
    .arlock_slave_0_s    ( arlock_tlx_out  ),
    .arcache_slave_0_s   ( arcache_tlx_out ),
    .arprot_slave_0_s    ( arprot_tlx_out  ),
    .arvalid_slave_0_s   ( arvalid_tlx_out ),
    .arready_slave_0_s   ( arready_tlx_out ),
    .rid_slave_0_s       ( rid_tlx_out     ),
    .rdata_slave_0_s     ( rdata_tlx_out   ),
    .rresp_slave_0_s     ( rresp_tlx_out   ),
    .rlast_slave_0_s     ( rlast_tlx_out   ),
    .rvalid_slave_0_s    ( rvalid_tlx_out  ),
    .rready_slave_0_s    ( rready_tlx_out  ),
    .awuser_slave_0_s    ( awuser_tlx_out  ),
    .aruser_slave_0_s    ( aruser_tlx_out  ),

    // Non-bus signals
    .tclk_fwd_2x         ( tsif_clkl_x2 ),
    .tclk_fwd_1x         ( tsif_clkl_x1 ), // Now input.
    .tclk_fwd_resetn     ( tsif_resetn  ),

    // Instance: outputs to JUNO
    .tsif_data_i         ( tsif_data_i  ),
    .tsif_ctl_i          ( tsif_ctl_i   ),
    .tsif_valid_i        ( tsif_valid_i ),
    .tsif_clk_i          ( tsif_clki    ), // Shift clock. Now input.

    // Instance: inputs from JUNO
    .tsif_data_o         ( tsif_data_o  ),
    .tsif_ctl_o          ( tsif_ctl_o   ),
    .tsif_valid_o        ( tsif_valid_o ),
    .tsif_clk_o          ( tsif_clko    )
  );

  //-----------------------------------
  // APB Interface (SCC)
  //-----------------------------------
  scc u_scc (
    .PCLK           ( ACLK                ),
    .PRESETn        ( ARESETn             ),
    .PSEL           ( psel_apb_scc        ),
    .PENABLE        ( penable_apb_scc     ),
    .PADDR          ( paddr_apb_scc[11:0] ),
    .PWRITE         ( pwrite_apb_scc      ),
    .PWDATA         ( pwdata_apb_scc      ),
    .PRDATA         ( prdata_apb_scc      ),


    .CFGCLK         ( CFGCLK              ),
    .nCFGRST        ( nCFGRST             ),
    .CFGLOAD        ( CFGLOAD             ),
    .CFGWnR         ( CFGWnR              ),
    .CFGDATAIN      ( CFGDATAIN           ),
    .CFGDATAOUT     ( CFGDATAOUT          ),

    .DLL_LOCKED     ( DLL_LOCKED          ),

    .SWITCH_OUTPUT  (                     ),
    .ALT_LED_SOURCE ( 8'b0                ),

    .CFGREG_IN      ( 256'b0              ),
    .CFGREG_OUT     (                     )
  );

  assign pslverr_apb_scc = 1'b0;
  assign pready_apb_scc  = 1'b1;

`endif // PULP_FPGA_SIM

  // ██╗ ██████╗    ██╗    ██╗██████╗  █████╗ ██████╗ ██████╗ ███████╗██████╗
  // ██║██╔════╝    ██║    ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
  // ██║██║         ██║ █╗ ██║██████╔╝███████║██████╔╝██████╔╝█████╗  ██████╔╝
  // ██║██║         ██║███╗██║██╔══██╗██╔══██║██╔═══╝ ██╔═══╝ ██╔══╝  ██╔══██╗
  // ██║╚██████╗    ╚███╔███╔╝██║  ██║██║  ██║██║     ██║     ███████╗██║  ██║
  // ╚═╝ ╚═════╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝
  //
  ic_wrapper ic_wrapper_i (
    .ClkIcHost_CI         ( ClkIcHost_C         ),
    .ClkIcHostClkConv_CI  ( ClkIcHost_C         ),
    .ClkIcPulp_CI         ( ClkSoc_C            ),
    .ClkIcPulpGated_CI    ( ClkSocGated_C       ),
    .RstIcPulp_RBI        ( RstIcPulp_RB        ),
    .RstIcPulpGated_RBI   ( RstIcPulpGated_RB   ),
    .RstIcHost_RBI        ( RstIcHostSync_RB    ),
    .RstIcHostClkConv_RBI ( RstIcHostClkConv_RB ),
    .RstDebug_RO          ( RstDebug_R          ),
    .RstMaster_RBI        ( RstMaster_RB        ),

    .host2pulp_gpio ( host2pulp_gpio ),
    .pulp2host_gpio ( pulp2host_gpio ),

    .clking_axi_araddr  ( clking_axi_araddr  ),
    .clking_axi_arprot  ( clking_axi_arprot  ),
    .clking_axi_arready ( clking_axi_arready ),
    .clking_axi_arvalid ( clking_axi_arvalid ),
    .clking_axi_awaddr  ( clking_axi_awaddr  ),
    .clking_axi_awprot  ( clking_axi_awprot  ),
    .clking_axi_awready ( clking_axi_awready ),
    .clking_axi_awvalid ( clking_axi_awvalid ),
    .clking_axi_bready  ( clking_axi_bready  ),
    .clking_axi_bresp   ( clking_axi_bresp   ),
    .clking_axi_bvalid  ( clking_axi_bvalid  ),
    .clking_axi_rdata   ( clking_axi_rdata   ),
    .clking_axi_rready  ( clking_axi_rready  ),
    .clking_axi_rresp   ( clking_axi_rresp   ),
    .clking_axi_rvalid  ( clking_axi_rvalid  ),
    .clking_axi_wdata   ( clking_axi_wdata   ),
    .clking_axi_wready  ( clking_axi_wready  ),
    .clking_axi_wstrb   ( clking_axi_wstrb   ),
    .clking_axi_wvalid  ( clking_axi_wvalid  ),

    .intr_axi_araddr  ( intr_axi.ar_addr  ),
    .intr_axi_arprot  (                   ), // no prot in AXI_LITE system verilog interface
    .intr_axi_arready ( intr_axi.ar_ready ),
    .intr_axi_arvalid ( intr_axi.ar_valid ),
    .intr_axi_awaddr  ( intr_axi.aw_addr  ),
    .intr_axi_awprot  (                   ), // no prot in AXI_LITE system verilog interface
    .intr_axi_awready ( intr_axi.aw_ready ),
    .intr_axi_awvalid ( intr_axi.aw_valid ),
    .intr_axi_bready  ( intr_axi.b_ready  ),
    .intr_axi_bresp   ( intr_axi.b_resp   ),
    .intr_axi_bvalid  ( intr_axi.b_valid  ),
    .intr_axi_rdata   ( intr_axi.r_data   ),
    .intr_axi_rready  ( intr_axi.r_ready  ),
    .intr_axi_rresp   ( intr_axi.r_resp   ),
    .intr_axi_rvalid  ( intr_axi.r_valid  ),
    .intr_axi_wdata   ( intr_axi.w_data   ),
    .intr_axi_wready  ( intr_axi.w_ready  ),
    .intr_axi_wstrb   ( intr_axi.w_strb   ),
    .intr_axi_wvalid  ( intr_axi.w_valid  ),

    .rab_lite_araddr ( rab_lite_araddr  ),
    .rab_lite_arprot ( rab_lite_arprot  ),
    .rab_lite_arready( rab_lite_arready ),
    .rab_lite_arvalid( rab_lite_arvalid ),
    .rab_lite_awaddr ( rab_lite_awaddr  ),
    .rab_lite_awprot ( rab_lite_awprot  ),
    .rab_lite_awready( rab_lite_awready ),
    .rab_lite_awvalid( rab_lite_awvalid ),
    .rab_lite_bready ( rab_lite_bready  ),
    .rab_lite_bresp  ( rab_lite_bresp   ),
    .rab_lite_bvalid ( rab_lite_bvalid  ),
    .rab_lite_rdata  ( rab_lite_rdata   ),
    .rab_lite_rready ( rab_lite_rready  ),
    .rab_lite_rresp  ( rab_lite_rresp   ),
    .rab_lite_rvalid ( rab_lite_rvalid  ),
    .rab_lite_wdata  ( rab_lite_wdata   ),
    .rab_lite_wready ( rab_lite_wready  ),
    .rab_lite_wstrb  ( rab_lite_wstrb   ),
    .rab_lite_wvalid ( rab_lite_wvalid  ),

    .rab_master_araddr   ( rab_master_araddr   ),
    .rab_master_arburst  ( rab_master_arburst  ),
    .rab_master_arcache  ( rab_master_arcache  ),
    .rab_master_arid     ( rab_master_arid     ),
    .rab_master_arlen    ( rab_master_arlen    ),
    .rab_master_arlock   ( rab_master_arlock   ),
    .rab_master_arprot   ( rab_master_arprot   ),
    .rab_master_arqos    ( rab_master_arqos    ),
    .rab_master_arready  ( rab_master_arready  ),
    .rab_master_arregion ( rab_master_arregion ),
    .rab_master_arsize   ( rab_master_arsize   ),
    .rab_master_arvalid  ( rab_master_arvalid  ),
    .rab_master_awaddr   ( rab_master_awaddr   ),
    .rab_master_awburst  ( rab_master_awburst  ),
    .rab_master_awcache  ( rab_master_awcache  ),
    .rab_master_awid     ( rab_master_awid     ),
    .rab_master_awlen    ( rab_master_awlen    ),
    .rab_master_awlock   ( rab_master_awlock   ),
    .rab_master_awprot   ( rab_master_awprot   ),
    .rab_master_awqos    ( rab_master_awqos    ),
    .rab_master_awready  ( rab_master_awready  ),
    .rab_master_awregion ( rab_master_awregion ),
    .rab_master_awsize   ( rab_master_awsize   ),
    .rab_master_awvalid  ( rab_master_awvalid  ),
    .rab_master_bid      ( rab_master_bid      ),
    .rab_master_bready   ( rab_master_bready   ),
    .rab_master_bresp    ( rab_master_bresp    ),
    .rab_master_bvalid   ( rab_master_bvalid   ),
    .rab_master_rid      ( rab_master_rid      ),
    .rab_master_rdata    ( rab_master_rdata    ),
    .rab_master_rlast    ( rab_master_rlast    ),
    .rab_master_rready   ( rab_master_rready   ),
    .rab_master_rresp    ( rab_master_rresp    ),
    .rab_master_rvalid   ( rab_master_rvalid   ),
    .rab_master_wdata    ( rab_master_wdata    ),
    .rab_master_wlast    ( rab_master_wlast    ),
    .rab_master_wready   ( rab_master_wready   ),
    .rab_master_wstrb    ( rab_master_wstrb    ),
    .rab_master_wvalid   ( rab_master_wvalid   ),

    .rab_slave_araddr   ( rab_slave_araddr   ),
    .rab_slave_arburst  ( rab_slave_arburst  ),
    .rab_slave_arcache  ( rab_slave_arcache  ),
    .rab_slave_arid     ( rab_slave_arid     ),
    .rab_slave_arlen    ( rab_slave_arlen    ),
    .rab_slave_arlock   ( rab_slave_arlock   ),
    .rab_slave_arprot   ( rab_slave_arprot   ),
    .rab_slave_arqos    ( rab_slave_arqos    ),
    .rab_slave_arready  ( rab_slave_arready  ),
    .rab_slave_arregion ( rab_slave_arregion ),
    .rab_slave_arsize   ( rab_slave_arsize   ),
    .rab_slave_arvalid  ( rab_slave_arvalid  ),
    .rab_slave_awaddr   ( rab_slave_awaddr   ),
    .rab_slave_awburst  ( rab_slave_awburst  ),
    .rab_slave_awcache  ( rab_slave_awcache  ),
    .rab_slave_awid     ( rab_slave_awid     ),
    .rab_slave_awlen    ( rab_slave_awlen    ),
    .rab_slave_awlock   ( rab_slave_awlock   ),
    .rab_slave_awprot   ( rab_slave_awprot   ),
    .rab_slave_awqos    ( rab_slave_awqos    ),
    .rab_slave_awready  ( rab_slave_awready  ),
    .rab_slave_awregion ( rab_slave_awregion ),
    .rab_slave_awsize   ( rab_slave_awsize   ),
    .rab_slave_awvalid  ( rab_slave_awvalid  ),
    .rab_slave_bid      ( rab_slave_bid      ),
    .rab_slave_bready   ( rab_slave_bready   ),
    .rab_slave_bresp    ( rab_slave_bresp    ),
    .rab_slave_bvalid   ( rab_slave_bvalid   ),
    .rab_slave_rid      ( rab_slave_rid      ),
    .rab_slave_rdata    ( rab_slave_rdata    ),
    .rab_slave_rlast    ( rab_slave_rlast    ),
    .rab_slave_rready   ( rab_slave_rready   ),
    .rab_slave_rresp    ( rab_slave_rresp    ),
    .rab_slave_rvalid   ( rab_slave_rvalid   ),
    .rab_slave_wdata    ( rab_slave_wdata    ),
    .rab_slave_wlast    ( rab_slave_wlast    ),
    .rab_slave_wready   ( rab_slave_wready   ),
    .rab_slave_wstrb    ( rab_slave_wstrb    ),
    .rab_slave_wvalid   ( rab_slave_wvalid   ),

    .stdout_slave_araddr   ( stdout_master_araddr   ),
    .stdout_slave_arburst  ( stdout_master_arburst  ),
    .stdout_slave_arcache  ( stdout_master_arcache  ),
    .stdout_slave_arid     ( stdout_master_arid     ),
    .stdout_slave_arlen    ( stdout_master_arlen    ),
    .stdout_slave_arlock   ( stdout_master_arlock   ),
    .stdout_slave_arprot   ( stdout_master_arprot   ),
    .stdout_slave_arqos    ( stdout_master_arqos    ),
    .stdout_slave_arready  ( stdout_master_arready  ),
    .stdout_slave_arregion ( stdout_master_arregion ),
    .stdout_slave_arsize   ( stdout_master_arsize   ),
    .stdout_slave_arvalid  ( stdout_master_arvalid  ),
    .stdout_slave_awaddr   ( stdout_master_awaddr   ),
    .stdout_slave_awburst  ( stdout_master_awburst  ),
    .stdout_slave_awcache  ( stdout_master_awcache  ),
    .stdout_slave_awid     ( stdout_master_awid     ),
    .stdout_slave_awlen    ( stdout_master_awlen    ),
    .stdout_slave_awlock   ( stdout_master_awlock   ),
    .stdout_slave_awprot   ( stdout_master_awprot   ),
    .stdout_slave_awqos    ( stdout_master_awqos    ),
    .stdout_slave_awready  ( stdout_master_awready  ),
    .stdout_slave_awregion ( stdout_master_awregion ),
    .stdout_slave_awsize   ( stdout_master_awsize   ),
    .stdout_slave_awvalid  ( stdout_master_awvalid  ),
    .stdout_slave_bid      ( stdout_master_bid      ),
    .stdout_slave_bready   ( stdout_master_bready   ),
    .stdout_slave_bresp    ( stdout_master_bresp    ),
    .stdout_slave_bvalid   ( stdout_master_bvalid   ),
    .stdout_slave_rid      ( stdout_master_rid      ),
    .stdout_slave_rdata    ( stdout_master_rdata    ),
    .stdout_slave_rlast    ( stdout_master_rlast    ),
    .stdout_slave_rready   ( stdout_master_rready   ),
    .stdout_slave_rresp    ( stdout_master_rresp    ),
    .stdout_slave_rvalid   ( stdout_master_rvalid   ),
    .stdout_slave_wdata    ( stdout_master_wdata    ),
    .stdout_slave_wlast    ( stdout_master_wlast    ),
    .stdout_slave_wready   ( stdout_master_wready   ),
    .stdout_slave_wstrb    ( stdout_master_wstrb    ),
    .stdout_slave_wvalid   ( stdout_master_wvalid   ),

    // Host -> RAB Memory Logs
`ifdef RAB_AX_LOG_EN
    .rab_ar_bram_clk  ( RabArBramClk_C  ),
    .rab_ar_bram_rst  ( RabArBramRst_R  ),
    .rab_ar_bram_en   ( RabArBramEn_S   ),
    .rab_ar_bram_addr ( RabArBramAddr_S ),
    .rab_ar_bram_dout ( RabArBramRd_D   ),
    .rab_ar_bram_din  ( RabArBramWr_D   ),
    .rab_ar_bram_we   ( RabArBramWrEn_S ),
    .rab_aw_bram_clk  ( RabAwBramClk_C  ),
    .rab_aw_bram_rst  ( RabAwBramRst_R  ),
    .rab_aw_bram_en   ( RabAwBramEn_S   ),
    .rab_aw_bram_addr ( RabAwBramAddr_S ),
    .rab_aw_bram_dout ( RabAwBramRd_D   ),
    .rab_aw_bram_din  ( RabAwBramWr_D   ),
    .rab_aw_bram_we   ( RabAwBramWrEn_S ),
`endif

`ifndef PULP_FPGA_SIM
    .tsif_araddr   ( araddr_tlx_out  ),
    .tsif_arburst  ( arburst_tlx_out ),
    .tsif_arcache  ( arcache_tlx_out ),
    .tsif_arlen    ( arlen_tlx_out   ),
    .tsif_arlock   ( arlock_tlx_out  ),
    .tsif_arprot   ( arprot_tlx_out  ),
    .tsif_arqos    (                 ),
    .tsif_arready  ( arready_tlx_out ),
    .tsif_arregion (                 ),
    .tsif_arsize   ( arsize_tlx_out  ),
    .tsif_arvalid  ( arvalid_tlx_out ),
    .tsif_awaddr   ( awaddr_tlx_out  ),
    .tsif_awburst  ( awburst_tlx_out ),
    .tsif_awcache  ( awcache_tlx_out ),
    .tsif_awlen    ( awlen_tlx_out   ),
    .tsif_awlock   ( awlock_tlx_out  ),
    .tsif_awprot   ( awprot_tlx_out  ),
    .tsif_awqos    (                 ),
    .tsif_awready  ( awready_tlx_out ),
    .tsif_awregion (                 ),
    .tsif_awsize   ( awsize_tlx_out  ),
    .tsif_awvalid  ( awvalid_tlx_out ),
    .tsif_bready   ( bready_tlx_out  ),
    .tsif_bresp    ( bresp_tlx_out   ),
    .tsif_bvalid   ( bvalid_tlx_out  ),
    .tsif_rdata    ( rdata_tlx_out   ),
    .tsif_rlast    ( rlast_tlx_out   ),
    .tsif_rready   ( rready_tlx_out  ),
    .tsif_rresp    ( rresp_tlx_out   ),
    .tsif_rvalid   ( rvalid_tlx_out  ),
    .tsif_wdata    ( wdata_tlx_out   ),
    .tsif_wlast    ( wlast_tlx_out   ),
    .tsif_wready   ( wready_tlx_out  ),
    .tsif_wstrb    ( wstrb_tlx_out   ),
    .tsif_wvalid   ( wvalid_tlx_out  ),

    .tmif_arid    ( arid_tlx_in    ),
    .tmif_araddr  ( araddr_tlx_in  ),
    .tmif_arburst ( arburst_tlx_in ),
    .tmif_arcache ( arcache_tlx_in ),
    .tmif_arlen   ( arlen_tlx_in   ),
    .tmif_arlock  ( arlock_tlx_in  ),
    .tmif_arprot  ( arprot_tlx_in  ),
    .tmif_arqos   ( arqos_tlx_in   ),
    .tmif_arready ( arready_tlx_in ),
    .tmif_arsize  ( arsize_tlx_in  ),
    .tmif_arvalid ( arvalid_tlx_in ),
    .tmif_awaddr  ( awaddr_tlx_in  ),
    .tmif_awid    ( awid_tlx_in    ),
    .tmif_awburst ( awburst_tlx_in ),
    .tmif_awcache ( awcache_tlx_in ),
    .tmif_awlen   ( awlen_tlx_in   ),
    .tmif_awlock  ( awlock_tlx_in  ),
    .tmif_awprot  ( awprot_tlx_in  ),
    .tmif_awqos   ( awqos_tlx_in   ),
    .tmif_awready ( awready_tlx_in ),
    .tmif_awsize  ( awsize_tlx_in  ),
    .tmif_awvalid ( awvalid_tlx_in ),
    .tmif_bid     ( bid_tlx_in     ),
    .tmif_bready  ( bready_tlx_in  ),
    .tmif_bresp   ( bresp_tlx_in   ),
    .tmif_bvalid  ( bvalid_tlx_in  ),
    .tmif_rid     ( rid_tlx_in     ),
    .tmif_rdata   ( rdata_tlx_in   ),
    .tmif_rlast   ( rlast_tlx_in   ),
    .tmif_rready  ( rready_tlx_in  ),
    .tmif_rresp   ( rresp_tlx_in   ),
    .tmif_rvalid  ( rvalid_tlx_in  ),
    .tmif_wdata   ( wdata_tlx_in   ),
    .tmif_wlast   ( wlast_tlx_in   ),
    .tmif_wready  ( wready_tlx_in  ),
    .tmif_wstrb   ( wstrb_tlx_in   ),
    .tmif_wvalid  ( wvalid_tlx_in  )
`else // PULP_FPGA_SIM
    .m_axi_sim_araddr   ( m_axi_sim_araddr   ),
    .m_axi_sim_arburst  ( m_axi_sim_arburst  ),
    .m_axi_sim_arcache  ( m_axi_sim_arcache  ),
    .m_axi_sim_arid     ( m_axi_sim_arid     ),
    .m_axi_sim_arlen    ( m_axi_sim_arlen    ),
    .m_axi_sim_arlock   ( m_axi_sim_arlock   ),
    .m_axi_sim_arprot   ( m_axi_sim_arprot   ),
    .m_axi_sim_arqos    ( m_axi_sim_arqos    ),
    .m_axi_sim_arready  ( m_axi_sim_arready  ),
    //.m_axi_sim_arregion ( m_axi_sim_arregion ),
    .m_axi_sim_arsize   ( m_axi_sim_arsize   ),
    .m_axi_sim_arvalid  ( m_axi_sim_arvalid  ),
    .m_axi_sim_awaddr   ( m_axi_sim_awaddr   ),
    .m_axi_sim_awburst  ( m_axi_sim_awburst  ),
    .m_axi_sim_awcache  ( m_axi_sim_awcache  ),
    .m_axi_sim_awid     ( m_axi_sim_awid     ),
    .m_axi_sim_awlen    ( m_axi_sim_awlen    ),
    .m_axi_sim_awlock   ( m_axi_sim_awlock   ),
    .m_axi_sim_awprot   ( m_axi_sim_awprot   ),
    .m_axi_sim_awqos    ( m_axi_sim_awqos    ),
    .m_axi_sim_awready  ( m_axi_sim_awready  ),
    //.m_axi_sim_awregion ( m_axi_sim_awregion  ),
    .m_axi_sim_awsize   ( m_axi_sim_awsize   ),
    .m_axi_sim_awvalid  ( m_axi_sim_awvalid  ),
    .m_axi_sim_bid      ( m_axi_sim_bid      ),
    .m_axi_sim_bready   ( m_axi_sim_bready   ),
    .m_axi_sim_bresp    ( m_axi_sim_bresp    ),
    .m_axi_sim_bvalid   ( m_axi_sim_bvalid   ),
    .m_axi_sim_rdata    ( m_axi_sim_rdata    ),
    .m_axi_sim_rid      ( m_axi_sim_rid      ),
    .m_axi_sim_rlast    ( m_axi_sim_rlast    ),
    .m_axi_sim_rready   ( m_axi_sim_rready   ),
    .m_axi_sim_rresp    ( m_axi_sim_rresp    ),
    .m_axi_sim_rvalid   ( m_axi_sim_rvalid   ),
    .m_axi_sim_wdata    ( m_axi_sim_wdata    ),
    .m_axi_sim_wlast    ( m_axi_sim_wlast    ),
    .m_axi_sim_wready   ( m_axi_sim_wready   ),
    .m_axi_sim_wstrb    ( m_axi_sim_wstrb    ),
    .m_axi_sim_wvalid   ( m_axi_sim_wvalid   )
`endif
  );

  //  █████╗ ██╗  ██╗██╗    ██╗███╗   ██╗████████╗██████╗     ██████╗ ███████╗ ██████╗
  // ██╔══██╗╚██╗██╔╝██║    ██║████╗  ██║╚══██╔══╝██╔══██╗    ██╔══██╗██╔════╝██╔════╝
  // ███████║ ╚███╔╝ ██║    ██║██╔██╗ ██║   ██║   ██████╔╝    ██████╔╝█████╗  ██║  ███╗
  // ██╔══██║ ██╔██╗ ██║    ██║██║╚██╗██║   ██║   ██╔══██╗    ██╔══██╗██╔══╝  ██║   ██║
  // ██║  ██║██╔╝ ██╗██║    ██║██║ ╚████║   ██║   ██║  ██║    ██║  ██║███████╗╚██████╔╝
  // ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝    ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝ ╚═════╝
  //
  axi_intr_reg #(
    .AXI_ADDR_WIDTH ( 32 ),
    .AXI_DATA_WIDTH ( 64 )
  ) axi_intr_reg_i (
    .Clk_CI      ( ClkSoc_C         ),
    .Rst_RBI     ( RstSoc_RB        ),

    .axi4lite    ( intr_axi         ),

    .IntrPulp_SI ( pulp2host_intr   ),
    .IntrHost_SO ( pulp2host_intr_o )
  );

  //  ██████╗██╗     ██╗  ██╗    ██████╗ ███████╗████████╗     ██████╗ ███████╗███╗   ██╗
  // ██╔════╝██║     ██║ ██╔╝    ██╔══██╗██╔════╝╚══██╔══╝    ██╔════╝ ██╔════╝████╗  ██║
  // ██║     ██║     █████╔╝     ██████╔╝███████╗   ██║       ██║  ███╗█████╗  ██╔██╗ ██║
  // ██║     ██║     ██╔═██╗     ██╔══██╗╚════██║   ██║       ██║   ██║██╔══╝  ██║╚██╗██║
  // ╚██████╗███████╗██║  ██╗    ██║  ██║███████║   ██║       ╚██████╔╝███████╗██║ ╚████║
  //  ╚═════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝   ╚═╝        ╚═════╝ ╚══════╝╚═╝  ╚═══╝
  //
  clk_rst_gen clk_rst_gen_i (
    .ClkRef_CI               ( ClkRef_C            ), // 100 MHz reference clock
    .RstMaster_RBI           ( RstMaster_RB        ), // board reset

    .ClkIcHost_CI            ( ClkIcHost_C         ),
    .RstIcHost_RBI           ( RstIcHost_RB        ), // needs to be combined with RstDebug_RBI and
                                                      // synced to ClkIcHost_CI
    .ClkEn_SI                ( ClkEn_S             ),
    .RstDebug_RBI            ( ~RstDebug_R         ), // MicroBlaze Debug Module reset (active high)
    .RstUser_RBI             ( RstUser_RB          ), // GPIO reset (axi_pulp_control)

    .clking_axi_awaddr       ( clking_axi_awaddr   ),
    .clking_axi_awvalid      ( clking_axi_awvalid  ),
    .clking_axi_awready      ( clking_axi_awready  ),
    .clking_axi_wdata        ( clking_axi_wdata    ),
    .clking_axi_wstrb        ( clking_axi_wstrb    ),
    .clking_axi_wvalid       ( clking_axi_wvalid   ),
    .clking_axi_wready       ( clking_axi_wready   ),
    .clking_axi_bresp        ( clking_axi_bresp    ),
    .clking_axi_bvalid       ( clking_axi_bvalid   ),
    .clking_axi_bready       ( clking_axi_bready   ),
    .clking_axi_araddr       ( clking_axi_araddr   ),
    .clking_axi_arvalid      ( clking_axi_arvalid  ),
    .clking_axi_arready      ( clking_axi_arready  ),
    .clking_axi_rdata        ( clking_axi_rdata    ),
    .clking_axi_rresp        ( clking_axi_rresp    ),
    .clking_axi_rvalid       ( clking_axi_rvalid   ),
    .clking_axi_rready       ( clking_axi_rready   ),

    .ClkSoc_CO               ( ClkSoc_C            ),
    .ClkSocGated_CO          ( ClkSocGated_C       ),
    .ClkCluster_CO           ( ClkCluster_C        ),
    .ClkClusterGated_CO      ( ClkClusterGated_C   ),

    .RstSoc_RBO              ( RstSoc_RB           ), // controllable by GPIO reset
    .RstIcPulp_RBO           ( RstIcPulp_RB        ), // same as RstSoc_RBO except for GPIO reset, synced to ClkSoc_CO
    .RstIcPulpGated_RBO      ( RstIcPulpGated_RB   ), // same as RstSoc_RBO except for GPIO reset, synced to ClkSocGated_CO
    .RstIcHost_RBO           ( RstIcHostSync_RB    ), // use for ic_wrapper
    .RstIcHostClkConv_RBO    ( RstIcHostClkConv_RB )  // reset clock conv interfaces running at ClkIcHost_C in ic_wrapper
  );

  // ██████╗ ██╗   ██╗██╗     ██████╗     ███████╗ ██████╗  ██████╗
  // ██╔══██╗██║   ██║██║     ██╔══██╗    ██╔════╝██╔═══██╗██╔════╝
  // ██████╔╝██║   ██║██║     ██████╔╝    ███████╗██║   ██║██║
  // ██╔═══╝ ██║   ██║██║     ██╔═══╝     ╚════██║██║   ██║██║
  // ██║     ╚██████╔╝███████╗██║         ███████║╚██████╔╝╚██████╗
  // ╚═╝      ╚═════╝ ╚══════╝╚═╝         ╚══════╝ ╚═════╝  ╚═════╝
  //
  pulp_soc #(
    // for simulation only: pulp_soc_stub.v used for implementation has no parameters
`ifdef PULP_FPGA_SIM
    .AXI_EXT_ADDR_WIDTH ( 40          ),
    .AXI_ADDR_WIDTH     ( 32          ),
    .AXI_DATA_WIDTH     ( 64          ),
    .AXI_USER_WIDTH     (  6          ),
    .AXI_ID_EXT_S_WIDTH (  6          ),
    .AXI_ID_EXT_M_WIDTH ( 15          ),
    .AXI_ID_SOC_S_WIDTH (  6          ),
    .AXI_ID_SOC_M_WIDTH (  9          ),
    .NB_CLUSTERS        ( NB_CLUSTERS ),
    .NB_CORES           ( NB_CORES    )
`endif
  ) pulp_soc_i (
    .clk_cluster_i       ( ClkClusterGated_C  ),
    .clk_soc_i           ( ClkSocGated_C      ),
    .clk_soc_non_gated_i ( ClkSoc_C           ),
    .rst_n               ( RstSoc_RB          ),

    .test_mode_i    ( test_mode    ),
    .mode_select_i  ( mode_select  ),
    .fetch_en_i     ( fetch_en     ),
    .eoc_o          ( intr_eoc     ),
    .cluster_busy_o ( cluster_busy ),

    // uart
    .uart_rx_i   ( 1'b1 ),
    .uart_tx_o   (      ),
    .uart_rts_no (      ),
    .uart_dtr_no (      ),
    .uart_cts_ni ( 1'b0 ),
    .uart_dsr_ni ( 1'b0 ),

    // stdout AXI port
    .stdout_master_aw_valid  ( stdout_master_awvalid  ),
    .stdout_master_aw_lock   ( stdout_master_awlock   ),
    .stdout_master_aw_ready  ( stdout_master_awready  ),
    .stdout_master_ar_valid  ( stdout_master_arvalid  ),
    .stdout_master_ar_lock   ( stdout_master_arlock   ),
    .stdout_master_ar_ready  ( stdout_master_arready  ),
    .stdout_master_w_valid   ( stdout_master_wvalid   ),
    .stdout_master_w_last    ( stdout_master_wlast    ),
    .stdout_master_w_ready   ( stdout_master_wready   ),
    .stdout_master_r_valid   ( stdout_master_rvalid   ),
    .stdout_master_r_last    ( stdout_master_rlast    ),
    .stdout_master_r_ready   ( stdout_master_rready   ),
    .stdout_master_b_valid   ( stdout_master_bvalid   ),
    .stdout_master_b_ready   ( stdout_master_bready   ),
    .stdout_master_aw_addr   ( stdout_master_awaddr   ),
    .stdout_master_aw_prot   ( stdout_master_awprot   ),
    .stdout_master_aw_region ( stdout_master_awregion ),
    .stdout_master_aw_len    ( stdout_master_awlen    ),
    .stdout_master_aw_size   ( stdout_master_awsize   ),
    .stdout_master_aw_burst  ( stdout_master_awburst  ),
    .stdout_master_aw_cache  ( stdout_master_awcache  ),
    .stdout_master_aw_qos    ( stdout_master_awqos    ),
    .stdout_master_aw_id     ( stdout_master_awid     ),
    .stdout_master_aw_user   ( stdout_master_awuser   ),
    .stdout_master_ar_addr   ( stdout_master_araddr   ),
    .stdout_master_ar_prot   ( stdout_master_arprot   ),
    .stdout_master_ar_region ( stdout_master_arregion ),
    .stdout_master_ar_len    ( stdout_master_arlen    ),
    .stdout_master_ar_size   ( stdout_master_arsize   ),
    .stdout_master_ar_burst  ( stdout_master_arburst  ),
    .stdout_master_ar_cache  ( stdout_master_arcache  ),
    .stdout_master_ar_qos    ( stdout_master_arqos    ),
    .stdout_master_ar_id     ( stdout_master_arid     ),
    .stdout_master_ar_user   ( stdout_master_aruser   ),
    .stdout_master_w_data    ( stdout_master_wdata    ),
    .stdout_master_w_strb    ( stdout_master_wstrb    ),
    .stdout_master_w_user    ( stdout_master_wuser    ),
    .stdout_master_r_data    ( stdout_master_rdata    ),
    .stdout_master_r_resp    ( stdout_master_rresp    ),
    .stdout_master_r_id      ( stdout_master_rid      ),
    .stdout_master_r_user    ( stdout_master_ruser    ),
    .stdout_master_b_resp    ( stdout_master_bresp    ),
    .stdout_master_b_id      ( stdout_master_bid      ),
    .stdout_master_b_user    ( stdout_master_buser    ),

    // Host -> PULP AXI port
    .rab_slave_aw_valid  ( rab_slave_awvalid  ),
    .rab_slave_aw_addr   ( rab_slave_awaddr   ),
    .rab_slave_aw_prot   ( rab_slave_awprot   ),
    .rab_slave_aw_region ( rab_slave_awregion ),
    .rab_slave_aw_len    ( rab_slave_awlen    ),
    .rab_slave_aw_size   ( rab_slave_awsize   ),
    .rab_slave_aw_burst  ( rab_slave_awburst  ),
    .rab_slave_aw_lock   ( rab_slave_awlock   ),
    .rab_slave_aw_cache  ( rab_slave_awcache  ),
    .rab_slave_aw_qos    ( rab_slave_awqos    ),
    .rab_slave_aw_id     ( rab_slave_awid     ),
    .rab_slave_aw_user   ( rab_slave_awuser   ),
    .rab_slave_aw_ready  ( rab_slave_awready  ),
    .rab_slave_ar_valid  ( rab_slave_arvalid  ),
    .rab_slave_ar_addr   ( rab_slave_araddr   ),
    .rab_slave_ar_prot   ( rab_slave_arprot   ),
    .rab_slave_ar_region ( rab_slave_arregion ),
    .rab_slave_ar_len    ( rab_slave_arlen    ),
    .rab_slave_ar_size   ( rab_slave_arsize   ),
    .rab_slave_ar_burst  ( rab_slave_arburst  ),
    .rab_slave_ar_lock   ( rab_slave_arlock   ),
    .rab_slave_ar_cache  ( rab_slave_arcache  ),
    .rab_slave_ar_qos    ( rab_slave_arqos    ),
    .rab_slave_ar_id     ( rab_slave_arid     ),
    .rab_slave_ar_user   ( rab_slave_aruser   ),
    .rab_slave_ar_ready  ( rab_slave_arready  ),
    .rab_slave_w_valid   ( rab_slave_wvalid   ),
    .rab_slave_w_data    ( rab_slave_wdata    ),
    .rab_slave_w_strb    ( rab_slave_wstrb    ),
    .rab_slave_w_user    ( rab_slave_wuser    ),
    .rab_slave_w_last    ( rab_slave_wlast    ),
    .rab_slave_w_ready   ( rab_slave_wready   ),
    .rab_slave_r_valid   ( rab_slave_rvalid   ),
    .rab_slave_r_data    ( rab_slave_rdata    ),
    .rab_slave_r_resp    ( rab_slave_rresp    ),
    .rab_slave_r_last    ( rab_slave_rlast    ),
    .rab_slave_r_id      ( rab_slave_rid      ),
    .rab_slave_r_user    ( rab_slave_ruser    ),
    .rab_slave_r_ready   ( rab_slave_rready   ),
    .rab_slave_b_valid   ( rab_slave_bvalid   ),
    .rab_slave_b_resp    ( rab_slave_bresp    ),
    .rab_slave_b_id      ( rab_slave_bid      ),
    .rab_slave_b_user    ( rab_slave_buser    ),
    .rab_slave_b_ready   ( rab_slave_bready   ),

    // PULP -> Host AXI port
    .rab_master_aw_valid  ( rab_master_awvalid  ),
    .rab_master_aw_addr   ( rab_master_awaddr   ),
    .rab_master_aw_prot   ( rab_master_awprot   ),
    .rab_master_aw_region ( rab_master_awregion ),
    .rab_master_aw_len    ( rab_master_awlen    ),
    .rab_master_aw_size   ( rab_master_awsize   ),
    .rab_master_aw_burst  ( rab_master_awburst  ),
    .rab_master_aw_lock   ( rab_master_awlock   ),
    .rab_master_aw_cache  ( rab_master_awcache  ),
    .rab_master_aw_qos    ( rab_master_awqos    ),
    .rab_master_aw_id     ( rab_master_awid     ),
    .rab_master_aw_user   ( rab_master_awuser   ),
    .rab_master_aw_ready  ( rab_master_awready  ),
    .rab_master_ar_valid  ( rab_master_arvalid  ),
    .rab_master_ar_addr   ( rab_master_araddr   ),
    .rab_master_ar_prot   ( rab_master_arprot   ),
    .rab_master_ar_region ( rab_master_arregion ),
    .rab_master_ar_len    ( rab_master_arlen    ),
    .rab_master_ar_size   ( rab_master_arsize   ),
    .rab_master_ar_burst  ( rab_master_arburst  ),
    .rab_master_ar_lock   ( rab_master_arlock   ),
    .rab_master_ar_cache  ( rab_master_arcache  ),
    .rab_master_ar_qos    ( rab_master_arqos    ),
    .rab_master_ar_id     ( rab_master_arid     ),
    .rab_master_ar_user   ( rab_master_aruser   ),
    .rab_master_ar_ready  ( rab_master_arready  ),
    .rab_master_w_valid   ( rab_master_wvalid   ),
    .rab_master_w_data    ( rab_master_wdata    ),
    .rab_master_w_strb    ( rab_master_wstrb    ),
    .rab_master_w_user    ( rab_master_wuser    ),
    .rab_master_w_last    ( rab_master_wlast    ),
    .rab_master_w_ready   ( rab_master_wready   ),
    .rab_master_r_valid   ( rab_master_rvalid   ),
    .rab_master_r_data    ( rab_master_rdata    ),
    .rab_master_r_resp    ( rab_master_rresp    ),
    .rab_master_r_last    ( rab_master_rlast    ),
    .rab_master_r_id      ( rab_master_rid      ),
    .rab_master_r_user    ( rab_master_ruser    ),
    .rab_master_r_ready   ( rab_master_rready   ),
    .rab_master_b_valid   ( rab_master_bvalid   ),
    .rab_master_b_resp    ( rab_master_bresp    ),
    .rab_master_b_id      ( rab_master_bid      ),
    .rab_master_b_user    ( rab_master_buser    ),
    .rab_master_b_ready   ( rab_master_bready   ),

    // RAB config AXI-Lite port
    .rab_lite_aw_addr  ( rab_lite_awaddr  ),
    .rab_lite_aw_valid ( rab_lite_awvalid ),
    .rab_lite_aw_ready ( rab_lite_awready ),
    .rab_lite_w_data   ( rab_lite_wdata   ),
    .rab_lite_w_strb   ( rab_lite_wstrb   ),
    .rab_lite_w_valid  ( rab_lite_wvalid  ),
    .rab_lite_w_ready  ( rab_lite_wready  ),
    .rab_lite_b_resp   ( rab_lite_bresp   ),
    .rab_lite_b_valid  ( rab_lite_bvalid  ),
    .rab_lite_b_ready  ( rab_lite_bready  ),
    .rab_lite_ar_addr  ( rab_lite_araddr  ),
    .rab_lite_ar_valid ( rab_lite_arvalid ),
    .rab_lite_ar_ready ( rab_lite_arready ),
    .rab_lite_r_data   ( rab_lite_rdata   ),
    .rab_lite_r_resp   ( rab_lite_rresp   ),
    .rab_lite_r_valid  ( rab_lite_rvalid  ),
    .rab_lite_r_ready  ( rab_lite_rready  ),

    // Host -> RAB Memory Logs
`ifdef RAB_AX_LOG_EN
    .RabArBramClk_CI  ( RabArBramClk_C  ),
    .RabArBramRst_RI  ( RabArBramRst_R  ),
    .RabArBramEn_SI   ( RabArBramEn_S   ),
    .RabArBramAddr_SI ( RabArBramAddr_S ),
    .RabArBramRd_DO   ( RabArBramRd_D   ),
    .RabArBramWr_DI   ( RabArBramWr_D   ),
    .RabArBramWrEn_SI ( RabArBramWrEn_S ),
    .RabAwBramClk_CI  ( RabAwBramClk_C  ),
    .RabAwBramRst_RI  ( RabAwBramRst_R  ),
    .RabAwBramEn_SI   ( RabAwBramEn_S   ),
    .RabAwBramAddr_SI ( RabAwBramAddr_S ),
    .RabAwBramRd_DO   ( RabAwBramRd_D   ),
    .RabAwBramWr_DI   ( RabAwBramWr_D   ),
    .RabAwBramWrEn_SI ( RabAwBramWrEn_S ),
`endif

    // RAB Logger Control
`ifdef RAB_AX_LOG_EN
    .RabLogEn_SI      ( RabLogEn_S    ),
    .RabArLogClr_SI   ( RabArLogClr_S ),
    .RabAwLogClr_SI   ( RabAwLogClr_S ),
    .RabArLogRdy_SO   ( RabArLogRdy_S ),
    .RabAwLogRdy_SO   ( RabAwLogRdy_S ),
`endif

    // PULP -> Host interrupts
`ifdef RAB_AX_LOG_EN
    .intr_rab_ar_log_full_o ( intr_rab_ar_log_full ),
    .intr_rab_aw_log_full_o ( intr_rab_aw_log_full ),
`endif
    .intr_mailbox_o         ( intr_mailbox         ),
    .intr_rab_miss_o        ( intr_rab_miss        ),
    .intr_rab_multi_o       ( intr_rab_multi       ),
    .intr_rab_prot_o        ( intr_rab_prot        ),
    .intr_rab_mhf_full_o    ( intr_rab_mhf_full    )
  );

endmodule
