// Copyright 2014-2018 ETH Zurich and University of Bologna.
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
//                            
//                                 ███████╗  ███████╗ ██████╗ ██╗  ██╗██╗  ██╗
//                                 ╚══███╔╝  ╚════██║██╔═████╗╚██╗██╔╝╚██╗██╔╝
//                            █████╗ ███╔╝█████╗ ██╔╝██║██╔██║ ╚███╔╝  ╚███╔╝ 
//                            ╚════╝███╔╝ ╚════╝██╔╝ ████╔╝██║ ██╔██╗  ██╔██╗ 
//                                 ███████╗     ██║  ╚██████╔╝██╔╝ ██╗██╔╝ ██╗
//                                 ╚══════╝     ╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
//
// Author: Pirmin Vogel - vogelpi@iis.ee.ethz.ch
// 
// Purpose : HDL top for PULP with Xilinx Zynq-7000 boards
// 
// --=========================================================================--

`ifdef ZEDBOARD
  localparam NB_CORES = 2;
`else 
  localparam NB_CORES = 8;
`endif
localparam NB_CLUSTERS      = 1;
localparam AXI_ACP_ID_WIDTH = 3;

// GPIO: Host -> PULP
`define HOST2PULP_FETCHEN_0                  0
`define HOST2PULP_FETCHEN_N      NB_CLUSTERS-1 // max 15

`define HOST2PULP_INTR_RAB_MISS_DIS         17

`ifdef RAB_AX_LOG_EN
  `define HOST2PULP_RAB_LOG_EN             27
  `define HOST2PULP_RAB_AR_LOG_CLR         28
  `define HOST2PULP_RAB_AW_LOG_CLR         29
`endif
`define HOST2PULP_CLKEN                     30
`define HOST2PULP_RSTN                      31

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

module bigpulp_z_70xx_top
  (
`ifdef PULP_FPGA_SIM
    input  wire                   FCLK_CLK0,        
    input  wire                   FCLK_RESET0_N,    
    input  wire                   FCLK_RESET1_N,    
    input  wire [31:0]            m_axi_sim_araddr, 
    input  wire [1:0]             m_axi_sim_arburst,
    input  wire [3:0]             m_axi_sim_arcache,
    input  wire [5:0]             m_axi_sim_arid,   
    input  wire [3:0]             m_axi_sim_arlen,  
    input  wire [1:0]             m_axi_sim_arlock, 
    input  wire [2:0]             m_axi_sim_arprot, 
    input  wire [3:0]             m_axi_sim_arqos,  
    output wire                   m_axi_sim_arready,
    input  wire [2:0]             m_axi_sim_arsize, 
    input  wire [5:0]             m_axi_sim_aruser, 
    input  wire                   m_axi_sim_arvalid,
    input  wire [31:0]            m_axi_sim_awaddr, 
    input  wire [1:0]             m_axi_sim_awburst,
    input  wire [3:0]             m_axi_sim_awcache,
    input  wire [5:0]             m_axi_sim_awid,   
    input  wire [3:0]             m_axi_sim_awlen,  
    input  wire [1:0]             m_axi_sim_awlock, 
    input  wire [2:0]             m_axi_sim_awprot, 
    input  wire [3:0]             m_axi_sim_awqos,  
    output wire                   m_axi_sim_awready,
    input  wire [2:0]             m_axi_sim_awsize, 
    input  wire [5:0]             m_axi_sim_awuser, 
    input  wire                   m_axi_sim_awvalid,
    output wire [5:0]             m_axi_sim_bid,    
    input  wire                   m_axi_sim_bready, 
    output wire [1:0]             m_axi_sim_bresp,  
    output wire [5:0]             m_axi_sim_buser,  
    output wire                   m_axi_sim_bvalid, 
    output wire [31:0]            m_axi_sim_rdata,  
    output wire [5:0]             m_axi_sim_rid,    
    output wire                   m_axi_sim_rlast,  
    input  wire                   m_axi_sim_rready, 
    output wire [1:0]             m_axi_sim_rresp,  
    output wire [5:0]             m_axi_sim_ruser,  
    output wire                   m_axi_sim_rvalid, 
    input  wire [31:0]            m_axi_sim_wdata,  
    input  wire [5:0]             m_axi_sim_wid,    
    input  wire                   m_axi_sim_wlast,  
    output wire                   m_axi_sim_wready, 
    input  wire [3:0]             m_axi_sim_wstrb,  
    input  wire [5:0]             m_axi_sim_wuser,  
    input  wire                   m_axi_sim_wvalid, 

    output wire                   uart_tx, // PULP -> Host
    input  wire                   uart_rx, // Host -> PULP
    output wire                   uart_rts_n,
    output wire                   uart_dtr_n,
    input  wire                   uart_cts_n,
    input  wire                   uart_dsr_n,
    output wire                   pulp2host_intr_o
`else // !`ifdef PULP_FPGA_SIM
    inout wire [14:0] DDR_addr,
    inout wire [2:0]  DDR_ba,
    inout wire        DDR_cas_n,
    inout wire        DDR_ck_n,
    inout wire        DDR_ck_p,
    inout wire        DDR_cke,
    inout wire        DDR_cs_n,
    inout wire [3:0]  DDR_dm,
    inout wire [31:0] DDR_dq,
    inout wire [3:0]  DDR_dqs_n,
    inout wire [3:0]  DDR_dqs_p,
    inout wire        DDR_odt,
    inout wire        DDR_ras_n,
    inout wire        DDR_reset_n,
    inout wire        DDR_we_n,
    inout wire        FIXED_IO_ddr_vrn,
    inout wire        FIXED_IO_ddr_vrp,
    inout wire [53:0] FIXED_IO_mio,
    inout wire        FIXED_IO_ps_clk,
    inout wire        FIXED_IO_ps_porb,
    inout wire        FIXED_IO_ps_srstb
`ifdef DEBUG_UART
   ,
    output wire       uart_rx_o,
    output wire       uart_tx_o
`endif // DEBUG_UART
`endif // PULP_FPGA_SIM
`ifdef DEBUG_CLK
   ,
    output wire       clk_div_o
`endif // DEBUG_CLK
  );


  // ███████╗██╗ ██████╗ ███╗   ██╗ █████╗ ██╗     ███████╗
  // ██╔════╝██║██╔════╝ ████╗  ██║██╔══██╗██║     ██╔════╝
  // ███████╗██║██║  ███╗██╔██╗ ██║███████║██║     ███████╗
  // ╚════██║██║██║   ██║██║╚██╗██║██╔══██║██║     ╚════██║
  // ███████║██║╚██████╔╝██║ ╚████║██║  ██║███████╗███████║
  // ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚══════╝
  //
  logic [31:0] pulp2host_gpio;
  logic [31:0] host2pulp_gpio;

  wire [10:0] clking_axi_awaddr;  // input
  wire        clking_axi_awvalid; // input
  wire        clking_axi_awready; // output
  wire [31:0] clking_axi_wdata;   // input
  wire  [3:0] clking_axi_wstrb;   // input
  wire        clking_axi_wvalid;  // input
  wire        clking_axi_wready;  // output
  wire  [1:0] clking_axi_bresp;   // output
  wire        clking_axi_bvalid;  // output
  wire        clking_axi_bready;  // input
  wire [10:0] clking_axi_araddr;  // input
  wire        clking_axi_arvalid; // input
  wire        clking_axi_arready; // output
  wire [31:0] clking_axi_rdata;   // output
  wire  [1:0] clking_axi_rresp;   // output
  wire        clking_axi_rvalid;  // output
  wire        clking_axi_rready;  // input

  wire [15:0] rab_lite_awaddr;        // input
  wire        rab_lite_awvalid;       // input
  wire        rab_lite_awready;       // output
  wire [31:0] rab_lite_wdata;         // input
  wire  [3:0] rab_lite_wstrb;         // input
  wire        rab_lite_wvalid;        // input
  wire        rab_lite_wready;        // output
  wire  [1:0] rab_lite_bresp;         // output
  wire        rab_lite_bvalid;        // output
  wire        rab_lite_bready;        // input
  wire [15:0] rab_lite_araddr;        // input
  wire        rab_lite_arvalid;       // input
  wire        rab_lite_arready;       // output
  wire [31:0] rab_lite_rdata;         // output
  wire  [1:0] rab_lite_rresp;         // output
  wire        rab_lite_rvalid;        // output
  wire        rab_lite_rready;        // input

  wire        rab_master_awvalid;     // output
  wire [31:0] rab_master_awaddr;      // output
  wire [2:0]  rab_master_awprot;      // output
  wire [3:0]  rab_master_awregion;    // output
  wire [7:0]  rab_master_awlen;       // output
  wire [2:0]  rab_master_awsize;      // output
  wire [1:0]  rab_master_awburst;     // output
  wire        rab_master_awlock;      // output
  wire [3:0]  rab_master_awcache;     // output
  wire [3:0]  rab_master_awqos;       // output
  wire [5:0]  rab_master_awid;        // output
  wire [5:0]  rab_master_awuser;      // output
  wire        rab_master_awready;     // input
  wire        rab_master_arvalid;     // output
  wire [31:0] rab_master_araddr;      // output
  wire [2:0]  rab_master_arprot;      // output
  wire [3:0]  rab_master_arregion;    // output
  wire [7:0]  rab_master_arlen;       // output
  wire [2:0]  rab_master_arsize;      // output
  wire [1:0]  rab_master_arburst;     // output
  wire        rab_master_arlock;      // output
  wire [3:0]  rab_master_arcache;     // output
  wire [3:0]  rab_master_arqos;       // output
  wire [5:0]  rab_master_arid;        // output
  wire [5:0]  rab_master_aruser;      // output
  wire        rab_master_arready;     // input
  wire        rab_master_wvalid;      // output
  wire [63:0] rab_master_wdata;       // output
  wire [7:0]  rab_master_wstrb;       // output
  wire [5:0]  rab_master_wuser;       // output
  wire        rab_master_wlast;       // output
  wire        rab_master_wready;      // input
  wire        rab_master_rvalid;      // input
  wire [63:0] rab_master_rdata;       // input
  wire [1:0]  rab_master_rresp;       // input
  wire        rab_master_rlast;       // input
  wire [5:0]  rab_master_rid;         // input
  wire [5:0]  rab_master_ruser;       // input
  wire        rab_master_rready;      // output
  wire        rab_master_bvalid;      // input
  wire [1:0]  rab_master_bresp;       // input
  wire [5:0]  rab_master_bid;         // input
  wire [5:0]  rab_master_buser;       // input
  wire        rab_master_bready;      // output

  wire                        rab_acp_awvalid;        // output
  wire [31:0]                 rab_acp_awaddr;         // output
  wire [2:0]                  rab_acp_awprot;         // output
  wire [3:0]                  rab_acp_awregion;       // output
  wire [7:0]                  rab_acp_awlen;          // output
  wire [2:0]                  rab_acp_awsize;         // output
  wire [1:0]                  rab_acp_awburst;        // output
  wire                        rab_acp_awlock;         // output
  wire [3:0]                  rab_acp_awcache;        // output
  wire [3:0]                  rab_acp_awqos;          // output
  wire [AXI_ACP_ID_WIDTH-1:0] rab_acp_awid;           // output
  wire [5:0]                  rab_acp_awuser;         // output
  wire                        rab_acp_awready;        // input
  wire                        rab_acp_arvalid;        // output
  wire [31:0]                 rab_acp_araddr;         // output
  wire [2:0]                  rab_acp_arprot;         // output
  wire [3:0]                  rab_acp_arregion;       // output
  wire [7:0]                  rab_acp_arlen;          // output
  wire [2:0]                  rab_acp_arsize;         // output
  wire [1:0]                  rab_acp_arburst;        // output
  wire                        rab_acp_arlock;         // output
  wire [3:0]                  rab_acp_arcache;        // output
  wire [3:0]                  rab_acp_arqos;          // output
  wire [AXI_ACP_ID_WIDTH-1:0] rab_acp_arid;           // output
  wire [5:0]                  rab_acp_aruser;         // output
  wire                        rab_acp_arready;        // input
  wire                        rab_acp_wvalid;         // output
  wire [63:0]                 rab_acp_wdata;          // output
  wire [7:0]                  rab_acp_wstrb;          // output
  wire [5:0]                  rab_acp_wuser;          // output
  wire                        rab_acp_wlast;          // output
  wire                        rab_acp_wready;         // input
  wire                        rab_acp_rvalid;         // input
  wire [63:0]                 rab_acp_rdata;          // input
  wire [1:0]                  rab_acp_rresp;          // input
  wire                        rab_acp_rlast;          // input
  wire [AXI_ACP_ID_WIDTH-1:0] rab_acp_rid;            // input
  wire [5:0]                  rab_acp_ruser;          // input
  wire                        rab_acp_rready;         // output
  wire                        rab_acp_bvalid;         // input
  wire [1:0]                  rab_acp_bresp;          // input
  wire [AXI_ACP_ID_WIDTH-1:0] rab_acp_bid;            // input
  wire [5:0]                  rab_acp_buser;          // input
  wire                        rab_acp_bready;         // output

  wire        rab_slave_awvalid;      // input
  wire [31:0] rab_slave_awaddr;       // input
  wire [2:0]  rab_slave_awprot;       // input
  wire [3:0]  rab_slave_awregion;     // input
  wire [7:0]  rab_slave_awlen;        // input
  wire [2:0]  rab_slave_awsize;       // input
  wire [1:0]  rab_slave_awburst;      // input
  wire        rab_slave_awlock;       // input
  wire [3:0]  rab_slave_awcache;      // input
  wire [3:0]  rab_slave_awqos;        // input
  wire [5:0]  rab_slave_awid;         // input
  wire [5:0]  rab_slave_awuser;       // input
  wire        rab_slave_awready;      // input
  wire        rab_slave_arvalid;      // input
  wire [31:0] rab_slave_araddr;       // input
  wire [2:0]  rab_slave_arprot;       // input
  wire [3:0]  rab_slave_arregion;     // input
  wire [7:0]  rab_slave_arlen;        // input
  wire [2:0]  rab_slave_arsize;       // input
  wire [1:0]  rab_slave_arburst;      // input
  wire        rab_slave_arlock;       // input
  wire [3:0]  rab_slave_arcache;      // input
  wire [3:0]  rab_slave_arqos;        // input
  wire [5:0]  rab_slave_arid;         // input
  wire [5:0]  rab_slave_aruser;       // input
  wire        rab_slave_arready;      // input
  wire        rab_slave_wvalid;       // input
  wire [63:0] rab_slave_wdata;        // input
  wire [7:0]  rab_slave_wstrb;        // input
  wire [5:0]  rab_slave_wuser;        // input
  wire        rab_slave_wlast;        // input
  wire        rab_slave_wready;       // input
  wire        rab_slave_rvalid;       // input
  wire [63:0] rab_slave_rdata;        // input
  wire [1:0]  rab_slave_rresp;        // input
  wire        rab_slave_rlast;        // input
  wire [5:0]  rab_slave_rid;          // input
  wire [5:0]  rab_slave_ruser;        // input
  wire        rab_slave_rready;       // input
  wire        rab_slave_bvalid;       // input
  wire [1:0]  rab_slave_bresp;        // input
  wire [5:0]  rab_slave_bid;          // input
  wire [5:0]  rab_slave_buser;        // input
  wire        rab_slave_bready;       // input

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
    .AXI_DATA_WIDTH ( 32 ),
    .AXI_ID_WIDTH   ( 6  ),
    .AXI_USER_WIDTH ( 6  )
  ) intr_axi();

  logic [31:0]            pulp2host_intr;

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

  //-------------------------------------------------------------------------
  // PULP SoC
  //-------------------------------------------------------------------------
  logic                   IntrRabMissEn_S;
  logic                   intr_rab_miss;
  logic [NB_CLUSTERS-1:0] intr_eoc;
  logic                   intr_mailbox;
  logic                   intr_rab_miss_host;
  logic                   intr_rab_multi;
  logic                   intr_rab_prot;
  logic                   intr_rab_mhf_full;
`ifdef RAB_AX_LOG_EN
  logic                   intr_rab_aw_log_full;
  logic                   intr_rab_ar_log_full;
`endif

`ifndef PULP_FPGA_SIM
  wire                    uart_rx;
  wire                    uart_tx;
  wire                    uart_rts_n;
  wire                    uart_dtr_n;
  wire                    uart_cts_n;
  wire                    uart_dsr_n;
`endif //  `ifndef PULP_FPGA_SIM
  logic                   mode_select;
  logic                   test_mode;
  
  logic [NB_CLUSTERS-1:0] fetch_en;
  logic [NB_CLUSTERS-1:0] cluster_busy;

  //  █████╗ ███████╗███████╗██╗ ██████╗ ███╗   ██╗███╗   ███╗███████╗███╗   ██╗████████╗███████╗
  // ██╔══██╗██╔════╝██╔════╝██║██╔════╝ ████╗  ██║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
  // ███████║███████╗███████╗██║██║  ███╗██╔██╗ ██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ███████╗
  // ██╔══██║╚════██║╚════██║██║██║   ██║██║╚██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║
  // ██║  ██║███████║███████║██║╚██████╔╝██║ ╚████║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ███████║
  // ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
           
  //-------------------------------------------------------------------------
  // Clocks and resets
  //-------------------------------------------------------------------------
  assign ClkRef_C     = ClkIcHost_C;
  assign RstMaster_RB = RstIcHost_RB;
  
  assign ClkEn_S      = host2pulp_gpio[`HOST2PULP_CLKEN];
  assign RstUser_RB   = host2pulp_gpio[`HOST2PULP_RSTN ];

  assign RstDebug_R   = 1'b0;

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

  assign fetch_en = host2pulp_gpio[`HOST2PULP_FETCHEN_N:`HOST2PULP_FETCHEN_0];

  assign mode_select = 0;
  assign test_mode   = 1'b0;

  // PULP2HOST GPIOs
  logic [31:0]            pulp2host_gpio_r;
  always_ff @(posedge ClkSoc_C or negedge RstIcPulp_RB)
    begin
      if (RstIcPulp_RB == 1'b0)
        pulp2host_gpio_r <= 32'b0;
      else
        begin
          pulp2host_gpio_r[`PULP2HOST_EOC_N:`PULP2HOST_EOC_0] <= intr_eoc;
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

`ifdef DEBUG_UART
  // uart debug
  logic uart_rx_r;
  logic uart_tx_r; 

  always_ff @(posedge ClkIcHost_C or negedge RstIcHostSync_RB)
    begin
       if (RstIcHostSync_RB == 1'b0)
         begin
            uart_rx_r <= 1'b1;
            uart_tx_r <= 1'b1;
         end
       else
         begin
            uart_rx_r <= uart_rx;
            uart_tx_r <= uart_tx;
         end
    end
   
  assign uart_tx_o = uart_tx_r;
  assign uart_rx_o = uart_rx_r;
`endif // DEBUG_UART

`ifdef DEBUG_CLK // divide the clock of the pulp_soc by 1000
  logic [9:0] ClkCnt_SN, ClkCnt_SP;
  logic       ClkDiv_SN, ClkDiv_SP;

  always_comb
    begin
      ClkCnt_SN = ClkCnt_SP + 1;
      ClkDiv_SN = ClkDiv_SP;
      if (ClkCnt_SP >= 499) // switch and reset at 500
        begin
          ClkCnt_SN = '0;
          ClkDiv_SN = ~ClkDiv_SP;
        end
    end

  always_ff @(posedge ClkSoc_C or negedge RstSoc_RB)
    begin
      if (RstSoc_RB == 1'b0)
        begin
          ClkCnt_SP <= '0;
          ClkDiv_SP <= 1'b0;
        end
      else
        begin
          ClkCnt_SP <= ClkCnt_SN;
          ClkDiv_SP <= ClkDiv_SN;
        end
    end

  assign clk_div_o = ClkDiv_SP;
`endif // DEBUG_CLK
   
  //******************************************************************************
  //**************************** Unused AXI signals ******************************
  //******************************************************************************
  
  // user signals
  // rab_master_aruser, _awuser, _wuser left open
  assign rab_master_ruser = 6'b0;
  assign rab_master_buser = 6'b0;
  assign rab_acp_ruser    = 6'b0;
  assign rab_acp_buser    = 6'b0;

  // rab_slave_ruser, _buser left open
  assign rab_slave_aruser = 6'b0;
  assign rab_slave_awuser = 6'b0;
  assign rab_slave_wuser  = 6'b0;

  // IDs
  // rab_slave_id not driven by ps7_wrapper, ID width = 0 because of data width converter
  assign rab_slave_awid = '0;
  assign rab_slave_arid = '0;

  // Zynq Processing System
  ps7_wrapper ps7_wrapper_i (
    .ClkIcHost_CO         ( ClkIcHost_C          ),
    .ClkIcPulp_CI         ( ClkSoc_C             ),
    .ClkIcPulpGated_CI    ( ClkSocGated_C        ),
    .RstIcHost_RBI        ( RstIcHostSync_RB     ),
    .RstIcHost_RBO        ( RstIcHost_RB         ),
    .RstIcPulp_RBI        ( RstIcPulp_RB         ),
    .RstIcPulpGated_RBI   ( RstIcPulpGated_RB    ),
    .RstPulp_RBO          (                      ), // not used anymore
`ifdef PULP_FPGA_SIM
    .FCLK_CLK0            ( FCLK_CLK0            ),
    .FCLK_RESET0_N        ( FCLK_RESET0_N        ),
    .FCLK_RESET1_N        ( FCLK_RESET1_N        ),
    .m_axi_sim_araddr     ( m_axi_sim_araddr     ),
    .m_axi_sim_arburst    ( m_axi_sim_arburst    ),
    .m_axi_sim_arcache    ( m_axi_sim_arcache    ),
    .m_axi_sim_arid       ( m_axi_sim_arid       ),
    .m_axi_sim_arlen      ( m_axi_sim_arlen      ),
    .m_axi_sim_arlock     ( m_axi_sim_arlock     ),
    .m_axi_sim_arprot     ( m_axi_sim_arprot     ),
    .m_axi_sim_arqos      ( m_axi_sim_arqos      ),
    .m_axi_sim_arready    ( m_axi_sim_arready    ),
    .m_axi_sim_arsize     ( m_axi_sim_arsize     ),
    .m_axi_sim_arvalid    ( m_axi_sim_arvalid    ),
    .m_axi_sim_awaddr     ( m_axi_sim_awaddr     ),
    .m_axi_sim_awburst    ( m_axi_sim_awburst    ),
    .m_axi_sim_awcache    ( m_axi_sim_awcache    ),
    .m_axi_sim_awid       ( m_axi_sim_awid       ),
    .m_axi_sim_awlen      ( m_axi_sim_awlen      ),
    .m_axi_sim_awlock     ( m_axi_sim_awlock     ),
    .m_axi_sim_awprot     ( m_axi_sim_awprot     ),
    .m_axi_sim_awqos      ( m_axi_sim_awqos      ),
    .m_axi_sim_awready    ( m_axi_sim_awready    ),
    .m_axi_sim_awsize     ( m_axi_sim_awsize     ),
    .m_axi_sim_awvalid    ( m_axi_sim_awvalid    ),
    .m_axi_sim_bid        ( m_axi_sim_bid        ),
    .m_axi_sim_bready     ( m_axi_sim_bready     ),
    .m_axi_sim_bresp      ( m_axi_sim_bresp      ),
    .m_axi_sim_bvalid     ( m_axi_sim_bvalid     ),
    .m_axi_sim_rdata      ( m_axi_sim_rdata      ),
    .m_axi_sim_rid        ( m_axi_sim_rid        ),
    .m_axi_sim_rlast      ( m_axi_sim_rlast      ),
    .m_axi_sim_rready     ( m_axi_sim_rready     ),
    .m_axi_sim_rresp      ( m_axi_sim_rresp      ),
    .m_axi_sim_rvalid     ( m_axi_sim_rvalid     ),
    .m_axi_sim_wdata      ( m_axi_sim_wdata      ),
    .m_axi_sim_wid        ( m_axi_sim_wid        ),
    .m_axi_sim_wlast      ( m_axi_sim_wlast      ),
    .m_axi_sim_wready     ( m_axi_sim_wready     ),
    .m_axi_sim_wstrb      ( m_axi_sim_wstrb      ),
    .m_axi_sim_wvalid     ( m_axi_sim_wvalid     ),
`else
    .DDR_addr             ( DDR_addr             ),
    .DDR_ba               ( DDR_ba               ),
    .DDR_cas_n            ( DDR_cas_n            ),
    .DDR_ck_n             ( DDR_ck_n             ),
    .DDR_ck_p             ( DDR_ck_p             ),
    .DDR_cke              ( DDR_cke              ),
    .DDR_cs_n             ( DDR_cs_n             ),
    .DDR_dm               ( DDR_dm               ),
    .DDR_dq               ( DDR_dq               ),
    .DDR_dqs_n            ( DDR_dqs_n            ),
    .DDR_dqs_p            ( DDR_dqs_p            ),
    .DDR_odt              ( DDR_odt              ),
    .DDR_ras_n            ( DDR_ras_n            ),
    .DDR_reset_n          ( DDR_reset_n          ),
    .DDR_we_n             ( DDR_we_n             ),
    .FIXED_IO_ddr_vrn     ( FIXED_IO_ddr_vrn     ),
    .FIXED_IO_ddr_vrp     ( FIXED_IO_ddr_vrp     ),
    .FIXED_IO_mio         ( FIXED_IO_mio         ),
    .FIXED_IO_ps_clk      ( FIXED_IO_ps_clk      ),
    .FIXED_IO_ps_porb     ( FIXED_IO_ps_porb     ),
    .FIXED_IO_ps_srstb    ( FIXED_IO_ps_srstb    ),
    .UART_0_rxd           ( uart_tx              ), // PULP -> Host
    .UART_0_txd           ( uart_rx              ), // Host -> PULP
    .UART_0_ctsn          ( uart_rts_n           ), // null-modem wiring 
    .UART_0_dcdn          ( uart_dtr_n           ), // null-modem wiring
    .UART_0_dsrn          ( uart_dtr_n           ), // null-modem wiring
    .UART_0_dtrn          ( uart_dsr_n           ), // null-modem wiring
    .UART_0_ri            ( 0'b0                 ), // null-modem wiring
    .UART_0_rtsn          ( uart_cts_n           ), // null-modem wiring
    .pulp2host_intr       ( pulp2host_intr_o     ),
`endif // !`ifdef PULP_FPGA_SIM

    .host2pulp_gpio       ( host2pulp_gpio       ),
    .pulp2host_gpio       ( pulp2host_gpio       ),
   
    .clking_axi_araddr    ( clking_axi_araddr    ),
    .clking_axi_arprot    ( clking_axi_arprot    ),
    .clking_axi_arready   ( clking_axi_arready   ),
    .clking_axi_arvalid   ( clking_axi_arvalid   ),
    .clking_axi_awaddr    ( clking_axi_awaddr    ),
    .clking_axi_awprot    ( clking_axi_awprot    ),
    .clking_axi_awready   ( clking_axi_awready   ),
    .clking_axi_awvalid   ( clking_axi_awvalid   ),
    .clking_axi_bready    ( clking_axi_bready    ),
    .clking_axi_bresp     ( clking_axi_bresp     ),
    .clking_axi_bvalid    ( clking_axi_bvalid    ),
    .clking_axi_rdata     ( clking_axi_rdata     ),
    .clking_axi_rready    ( clking_axi_rready    ),
    .clking_axi_rresp     ( clking_axi_rresp     ),
    .clking_axi_rvalid    ( clking_axi_rvalid    ),
    .clking_axi_wdata     ( clking_axi_wdata     ),
    .clking_axi_wready    ( clking_axi_wready    ),
    .clking_axi_wvalid    ( clking_axi_wvalid    ),
    .clking_axi_wstrb     ( clking_axi_wstrb     ),

    .intr_axi_araddr      ( intr_axi.ar_addr     ),
    .intr_axi_arprot      (                      ), // no prot in AXI_LITE system verilog interface
    .intr_axi_arready     ( intr_axi.ar_ready    ),
    .intr_axi_arvalid     ( intr_axi.ar_valid    ),
    .intr_axi_awaddr      ( intr_axi.aw_addr     ),
    .intr_axi_awprot      (                      ), // no prot in AXI_LITE system verilog interface
    .intr_axi_awready     ( intr_axi.aw_ready    ),
    .intr_axi_awvalid     ( intr_axi.aw_valid    ),
    .intr_axi_bready      ( intr_axi.b_ready     ),
    .intr_axi_bresp       ( intr_axi.b_resp      ),
    .intr_axi_bvalid      ( intr_axi.b_valid     ),
    .intr_axi_rdata       ( intr_axi.r_data      ),
    .intr_axi_rready      ( intr_axi.r_ready     ),
    .intr_axi_rresp       ( intr_axi.r_resp      ),
    .intr_axi_rvalid      ( intr_axi.r_valid     ),
    .intr_axi_wdata       ( intr_axi.w_data      ),
    .intr_axi_wready      ( intr_axi.w_ready     ),
    .intr_axi_wstrb       ( intr_axi.w_strb      ),
    .intr_axi_wvalid      ( intr_axi.w_valid     ),

    .rab_lite_araddr      ( rab_lite_araddr      ),
    .rab_lite_arprot      ( rab_lite_arprot      ),
    .rab_lite_arready     ( rab_lite_arready     ),
    .rab_lite_arvalid     ( rab_lite_arvalid     ),
    .rab_lite_awaddr      ( rab_lite_awaddr      ),
    .rab_lite_awprot      ( rab_lite_awprot      ),
    .rab_lite_awready     ( rab_lite_awready     ),
    .rab_lite_awvalid     ( rab_lite_awvalid     ),
    .rab_lite_bready      ( rab_lite_bready      ),
    .rab_lite_bresp       ( rab_lite_bresp       ),
    .rab_lite_bvalid      ( rab_lite_bvalid      ),
    .rab_lite_rdata       ( rab_lite_rdata       ),
    .rab_lite_rready      ( rab_lite_rready      ),
    .rab_lite_rresp       ( rab_lite_rresp       ),
    .rab_lite_rvalid      ( rab_lite_rvalid      ),
    .rab_lite_wdata       ( rab_lite_wdata       ),
    .rab_lite_wready      ( rab_lite_wready      ),
    .rab_lite_wstrb       ( rab_lite_wstrb       ),
    .rab_lite_wvalid      ( rab_lite_wvalid      ),

    .rab_master_araddr    ( rab_master_araddr    ),
    .rab_master_arburst   ( rab_master_arburst   ),
    .rab_master_arcache   ( rab_master_arcache   ),
    .rab_master_arid      ( rab_master_arid      ),
    .rab_master_arlen     ( rab_master_arlen     ),
    .rab_master_arlock    ( rab_master_arlock    ),
    .rab_master_arprot    ( rab_master_arprot    ),
    .rab_master_arqos     ( rab_master_arqos     ),
    .rab_master_arready   ( rab_master_arready   ),
    .rab_master_arregion  ( rab_master_arregion  ),
    .rab_master_arsize    ( rab_master_arsize    ),
    .rab_master_arvalid   ( rab_master_arvalid   ),
    .rab_master_awaddr    ( rab_master_awaddr    ),
    .rab_master_awburst   ( rab_master_awburst   ),
    .rab_master_awcache   ( rab_master_awcache   ),
    .rab_master_awid      ( rab_master_awid      ),
    .rab_master_awlen     ( rab_master_awlen     ),
    .rab_master_awlock    ( rab_master_awlock    ),
    .rab_master_awprot    ( rab_master_awprot    ),
    .rab_master_awqos     ( rab_master_awqos     ),
    .rab_master_awready   ( rab_master_awready   ),
    .rab_master_awregion  ( rab_master_awregion  ),
    .rab_master_awsize    ( rab_master_awsize    ),
    .rab_master_awvalid   ( rab_master_awvalid   ),
    .rab_master_bid       ( rab_master_bid       ),
    .rab_master_bready    ( rab_master_bready    ),
    .rab_master_bresp     ( rab_master_bresp     ),
    .rab_master_bvalid    ( rab_master_bvalid    ),
    .rab_master_rdata     ( rab_master_rdata     ),
    .rab_master_rid       ( rab_master_rid       ),
    .rab_master_rlast     ( rab_master_rlast     ),
    .rab_master_rready    ( rab_master_rready    ),
    .rab_master_rresp     ( rab_master_rresp     ),
    .rab_master_rvalid    ( rab_master_rvalid    ),
    .rab_master_wdata     ( rab_master_wdata     ),
    .rab_master_wlast     ( rab_master_wlast     ),
    .rab_master_wready    ( rab_master_wready    ),
    .rab_master_wstrb     ( rab_master_wstrb     ),
    .rab_master_wvalid    ( rab_master_wvalid    ),

    .rab_acp_araddr       ( rab_acp_araddr       ),
    .rab_acp_arburst      ( rab_acp_arburst      ),
    .rab_acp_arcache      ( rab_acp_arcache      ),
    .rab_acp_arid         ( rab_acp_arid         ),
    .rab_acp_arlen        ( rab_acp_arlen        ),
    .rab_acp_arlock       ( rab_acp_arlock       ),
    .rab_acp_arprot       ( rab_acp_arprot       ),
    .rab_acp_arqos        ( rab_acp_arqos        ),
    .rab_acp_arready      ( rab_acp_arready      ),
    .rab_acp_arregion     ( rab_acp_arregion     ),
    .rab_acp_arsize       ( rab_acp_arsize       ),
    .rab_acp_arvalid      ( rab_acp_arvalid      ),
    .rab_acp_awaddr       ( rab_acp_awaddr       ),
    .rab_acp_awburst      ( rab_acp_awburst      ),
    .rab_acp_awcache      ( rab_acp_awcache      ),
    .rab_acp_awid         ( rab_acp_awid         ),
    .rab_acp_awlen        ( rab_acp_awlen        ),
    .rab_acp_awlock       ( rab_acp_awlock       ),
    .rab_acp_awprot       ( rab_acp_awprot       ),
    .rab_acp_awqos        ( rab_acp_awqos        ),
    .rab_acp_awready      ( rab_acp_awready      ),
    .rab_acp_awregion     ( rab_acp_awregion     ),
    .rab_acp_awsize       ( rab_acp_awsize       ),
    .rab_acp_awvalid      ( rab_acp_awvalid      ),
    .rab_acp_bid          ( rab_acp_bid          ),
    .rab_acp_bready       ( rab_acp_bready       ),
    .rab_acp_bresp        ( rab_acp_bresp        ),
    .rab_acp_bvalid       ( rab_acp_bvalid       ),
    .rab_acp_rdata        ( rab_acp_rdata        ),
    .rab_acp_rid          ( rab_acp_rid          ),
    .rab_acp_rlast        ( rab_acp_rlast        ),
    .rab_acp_rready       ( rab_acp_rready       ),
    .rab_acp_rresp        ( rab_acp_rresp        ),
    .rab_acp_rvalid       ( rab_acp_rvalid       ),
    .rab_acp_wdata        ( rab_acp_wdata        ),
    .rab_acp_wlast        ( rab_acp_wlast        ),
    .rab_acp_wready       ( rab_acp_wready       ),
    .rab_acp_wstrb        ( rab_acp_wstrb        ),
    .rab_acp_wvalid       ( rab_acp_wvalid       ),

    .rab_slave_araddr     ( rab_slave_araddr     ),
    .rab_slave_arburst    ( rab_slave_arburst    ),
    .rab_slave_arcache    ( rab_slave_arcache    ),
    //.rab_slave_arid       ( rab_slave_arid       ),
    .rab_slave_arlen      ( rab_slave_arlen      ),
    .rab_slave_arlock     ( rab_slave_arlock     ),
    .rab_slave_arprot     ( rab_slave_arprot     ),
    .rab_slave_arqos      ( rab_slave_arqos      ),
    .rab_slave_arready    ( rab_slave_arready    ),
    .rab_slave_arregion   ( rab_slave_arregion   ),
    .rab_slave_arsize     ( rab_slave_arsize     ),
    .rab_slave_arvalid    ( rab_slave_arvalid    ),
    .rab_slave_awaddr     ( rab_slave_awaddr     ),
    .rab_slave_awburst    ( rab_slave_awburst    ),
    .rab_slave_awcache    ( rab_slave_awcache    ),
    //.rab_slave_awid       ( rab_slave_awid       ),
    .rab_slave_awlen      ( rab_slave_awlen      ),
    .rab_slave_awlock     ( rab_slave_awlock     ),
    .rab_slave_awprot     ( rab_slave_awprot     ),
    .rab_slave_awqos      ( rab_slave_awqos      ),
    .rab_slave_awready    ( rab_slave_awready    ),
    .rab_slave_awregion   ( rab_slave_awregion   ),
    .rab_slave_awsize     ( rab_slave_awsize     ),
    .rab_slave_awvalid    ( rab_slave_awvalid    ),
    //.rab_slave_bid        ( rab_slave_bid        ),
    .rab_slave_bready     ( rab_slave_bready     ),
    .rab_slave_bresp      ( rab_slave_bresp      ),
    .rab_slave_bvalid     ( rab_slave_bvalid     ),
    //.rab_slave_rid        ( rab_slave_rid        ),
    .rab_slave_rdata      ( rab_slave_rdata      ),
    .rab_slave_rlast      ( rab_slave_rlast      ),
    .rab_slave_rready     ( rab_slave_rready     ),
    .rab_slave_rresp      ( rab_slave_rresp      ),
    .rab_slave_rvalid     ( rab_slave_rvalid     ),
    .rab_slave_wdata      ( rab_slave_wdata      ),
    .rab_slave_wlast      ( rab_slave_wlast      ),
    .rab_slave_wready     ( rab_slave_wready     ),
    .rab_slave_wstrb      ( rab_slave_wstrb      ),
    .rab_slave_wvalid     ( rab_slave_wvalid     )

    // Host -> RAB Memory Logs
`ifdef RAB_AX_LOG_EN
    ,
    .rab_ar_bram_clk      ( RabArBramClk_C       ),
    .rab_ar_bram_rst      ( RabArBramRst_R       ),
    .rab_ar_bram_en       ( RabArBramEn_S        ),
    .rab_ar_bram_addr     ( RabArBramAddr_S      ),
    .rab_ar_bram_dout     ( RabArBramRd_D        ),
    .rab_ar_bram_din      ( RabArBramWr_D        ),
    .rab_ar_bram_we       ( RabArBramWrEn_S      ),
    .rab_aw_bram_clk      ( RabAwBramClk_C       ),
    .rab_aw_bram_rst      ( RabAwBramRst_R       ),
    .rab_aw_bram_en       ( RabAwBramEn_S        ),
    .rab_aw_bram_addr     ( RabAwBramAddr_S      ),
    .rab_aw_bram_dout     ( RabAwBramRd_D        ),
    .rab_aw_bram_din      ( RabAwBramWr_D        ),
    .rab_aw_bram_we       ( RabAwBramWrEn_S      )
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
    .AXI_DATA_WIDTH ( 32 )
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
  clk_rst_gen clk_rst_gen_i
    (
    .ClkRef_CI               ( ClkRef_C           ), // 100 MHz reference clock
    .RstMaster_RBI           ( RstMaster_RB       ), // board reset
       
    .ClkIcHost_CI            ( ClkIcHost_C        ),
    .RstIcHost_RBI           ( RstIcHost_RB       ), // needs to be combined with RstDebug_RBI and 
                                                     // synced to ClkIcHost_CI
    .ClkEn_SI                ( ClkEn_S            ),
    .RstDebug_RBI            ( ~RstDebug_R        ), // MicroBlaze Debug Module reset (active high)
    .RstUser_RBI             ( RstUser_RB         ), // GPIO reset (axi_pulp_control)

    .clking_axi_awaddr       ( clking_axi_awaddr  ),
    .clking_axi_awvalid      ( clking_axi_awvalid ),
    .clking_axi_awready      ( clking_axi_awready ),
    .clking_axi_wdata        ( clking_axi_wdata   ),
    .clking_axi_wstrb        ( clking_axi_wstrb   ),
    .clking_axi_wvalid       ( clking_axi_wvalid  ),
    .clking_axi_wready       ( clking_axi_wready  ),
    .clking_axi_bresp        ( clking_axi_bresp   ),
    .clking_axi_bvalid       ( clking_axi_bvalid  ),
    .clking_axi_bready       ( clking_axi_bready  ),
    .clking_axi_araddr       ( clking_axi_araddr  ),
    .clking_axi_arvalid      ( clking_axi_arvalid ),
    .clking_axi_arready      ( clking_axi_arready ),
    .clking_axi_rdata        ( clking_axi_rdata   ),
    .clking_axi_rresp        ( clking_axi_rresp   ),
    .clking_axi_rvalid       ( clking_axi_rvalid  ),
    .clking_axi_rready       ( clking_axi_rready  ),

    .ClkSoc_CO               ( ClkSoc_C           ),
    .ClkSocGated_CO          ( ClkSocGated_C      ),
    .ClkCluster_CO           ( ClkCluster_C       ),
    .ClkClusterGated_CO      ( ClkClusterGated_C  ),

    .RstSoc_RBO              ( RstSoc_RB          ), // controllable by GPIO reset
    .RstIcPulp_RBO           ( RstIcPulp_RB       ), // same as RstSoc_RBO except for GPIO reset, synced to ClkSoc_CO
    .RstIcPulpGated_RBO      ( RstIcPulpGated_RB  ), // same as RstSoc_RBO except for GPIO reset, synced to ClkSocGated_CO
    .RstIcHost_RBO           ( RstIcHostSync_RB   ), // use for ic_wrapper
    .RstIcHostClkConv_RBO    (                    )  // not used on Zynq
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
    .AXI_EXT_ADDR_WIDTH     ( 32                ),
    .AXI_ADDR_WIDTH         ( 32                ),
    .AXI_DATA_WIDTH         ( 64                ),
    .AXI_USER_WIDTH         (  6                ),
    .AXI_ID_EXT_S_WIDTH     (  6                ),
    .AXI_ID_EXT_S_ACP_WIDTH (  AXI_ACP_ID_WIDTH ),
    .AXI_ID_EXT_M_WIDTH     (  6                ),
    .AXI_ID_SOC_S_WIDTH     (  6                ),
    .AXI_ID_SOC_M_WIDTH     (  7                ),
    .NB_CLUSTERS            ( NB_CLUSTERS       ),
    .NB_CORES               ( NB_CORES          )
`endif
  ) pulp_soc_i (
    .clk_cluster_i       ( ClkClusterGated_C ),
    .clk_soc_i           ( ClkSocGated_C     ),
    .clk_soc_non_gated_i ( ClkSoc_C          ),
    .rst_n               ( RstSoc_RB         ),

    .test_mode_i    ( test_mode    ),
    .mode_select_i  ( mode_select  ),
    .fetch_en_i     ( fetch_en     ),
    .eoc_o          ( intr_eoc     ),
    .cluster_busy_o ( cluster_busy ),

    // uart
    .uart_rx_i   ( uart_rx     ),
    .uart_tx_o   ( uart_tx     ),
    .uart_rts_no ( uart_rts_n  ),
    .uart_dtr_no ( uart_dtr_n  ),
    .uart_cts_ni ( uart_cts_n  ),
    .uart_dsr_ni ( uart_dsr_n  ),    

    // PULP -> Host AXI port
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

    // Host -> PULP AXI port, HP
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

    // Host -> PULP AXI port, ACP
    .rab_acp_aw_valid  ( rab_acp_awvalid  ),
    .rab_acp_aw_addr   ( rab_acp_awaddr   ),
    .rab_acp_aw_prot   ( rab_acp_awprot   ),
    .rab_acp_aw_region ( rab_acp_awregion ),
    .rab_acp_aw_len    ( rab_acp_awlen    ),
    .rab_acp_aw_size   ( rab_acp_awsize   ),
    .rab_acp_aw_burst  ( rab_acp_awburst  ),
    .rab_acp_aw_lock   ( rab_acp_awlock   ),
    .rab_acp_aw_cache  ( rab_acp_awcache  ),
    .rab_acp_aw_qos    ( rab_acp_awqos    ),
    .rab_acp_aw_id     ( rab_acp_awid     ),
    .rab_acp_aw_user   ( rab_acp_awuser   ),
    .rab_acp_aw_ready  ( rab_acp_awready  ),
    .rab_acp_ar_valid  ( rab_acp_arvalid  ),
    .rab_acp_ar_addr   ( rab_acp_araddr   ),
    .rab_acp_ar_prot   ( rab_acp_arprot   ),
    .rab_acp_ar_region ( rab_acp_arregion ),
    .rab_acp_ar_len    ( rab_acp_arlen    ),
    .rab_acp_ar_size   ( rab_acp_arsize   ),
    .rab_acp_ar_burst  ( rab_acp_arburst  ),
    .rab_acp_ar_lock   ( rab_acp_arlock   ),
    .rab_acp_ar_cache  ( rab_acp_arcache  ),
    .rab_acp_ar_qos    ( rab_acp_arqos    ),
    .rab_acp_ar_id     ( rab_acp_arid     ),
    .rab_acp_ar_user   ( rab_acp_aruser   ),
    .rab_acp_ar_ready  ( rab_acp_arready  ),
    .rab_acp_w_valid   ( rab_acp_wvalid   ),
    .rab_acp_w_data    ( rab_acp_wdata    ),
    .rab_acp_w_strb    ( rab_acp_wstrb    ),
    .rab_acp_w_user    ( rab_acp_wuser    ),
    .rab_acp_w_last    ( rab_acp_wlast    ),
    .rab_acp_w_ready   ( rab_acp_wready   ),
    .rab_acp_r_valid   ( rab_acp_rvalid   ),
    .rab_acp_r_data    ( rab_acp_rdata    ),
    .rab_acp_r_resp    ( rab_acp_rresp    ),
    .rab_acp_r_last    ( rab_acp_rlast    ),
    .rab_acp_r_id      ( rab_acp_rid      ),
    .rab_acp_r_user    ( rab_acp_ruser    ),
    .rab_acp_r_ready   ( rab_acp_rready   ),
    .rab_acp_b_valid   ( rab_acp_bvalid   ),
    .rab_acp_b_resp    ( rab_acp_bresp    ),
    .rab_acp_b_id      ( rab_acp_bid      ),
    .rab_acp_b_user    ( rab_acp_buser    ),
    .rab_acp_b_ready   ( rab_acp_bready   ),

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
    .RabLogEn_SI      (RabLogEn_S    ),
    .RabArLogClr_SI   (RabArLogClr_S ),
    .RabAwLogClr_SI   (RabAwLogClr_S ),
    .RabArLogRdy_SO   (RabArLogRdy_S ),
    .RabAwLogRdy_SO   (RabAwLogRdy_S ),
`endif

    // PULP -> Host interrupts
`ifdef RAB_AX_LOG_EN
    .intr_rab_ar_log_full_o ( intr_rab_ar_log_full  ),
    .intr_rab_aw_log_full_o ( intr_rab_aw_log_full  ),
`endif

    // PULP -> Host interrupts
    .intr_mailbox_o      ( intr_mailbox      ),
    .intr_rab_miss_o     ( intr_rab_miss     ),
    .intr_rab_multi_o    ( intr_rab_multi    ),
    .intr_rab_prot_o     ( intr_rab_prot     ),
    .intr_rab_mhf_full_o ( intr_rab_mhf_full )
  );

endmodule
