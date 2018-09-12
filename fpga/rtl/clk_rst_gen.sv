// Copyright 2018 ETH Zurich and University of Bologna.
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
//  ██████╗██╗     ██╗  ██╗    ██████╗ ███████╗████████╗     ██████╗ ███████╗███╗   ██╗
// ██╔════╝██║     ██║ ██╔╝    ██╔══██╗██╔════╝╚══██╔══╝    ██╔════╝ ██╔════╝████╗  ██║
// ██║     ██║     █████╔╝     ██████╔╝███████╗   ██║       ██║  ███╗█████╗  ██╔██╗ ██║
// ██║     ██║     ██╔═██╗     ██╔══██╗╚════██║   ██║       ██║   ██║██╔══╝  ██║╚██╗██║
// ╚██████╗███████╗██║  ██╗    ██║  ██║███████║   ██║       ╚██████╔╝███████╗██║ ╚████║
//  ╚═════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝   ╚═╝        ╚═════╝ ╚══════╝╚═╝  ╚═══╝
// 
// Author: Pirmin Vogel - vogelpi@iis.ee.ethz.ch
// 
// Purpose : Clock generation and gating, reset synchronization for host-2-pulp 
//           interconnects
// 
// --=========================================================================--

module clk_rst_gen
  (
    input  logic        ClkRef_CI,     // 100 MHz reference clock
    input  logic        RstMaster_RBI, // board reset

    input  logic        ClkIcHost_CI,
    input  logic        RstIcHost_RBI, // needs to be combined with RstDebug_RBI and 
                                       // synced to ClkIcHost_CI
    input  logic        ClkEn_SI,      
    input  logic        RstDebug_RBI,  // MicroBlaze Debug Module reset
    input  logic        RstUser_RBI,   // GPIO reset (axi_pulp_control)
 
    input  logic [10:0] clking_axi_awaddr,
    input  logic        clking_axi_awvalid,
    output logic        clking_axi_awready,
    input  logic [31:0] clking_axi_wdata,
    input  logic  [3:0] clking_axi_wstrb,
    input  logic        clking_axi_wvalid,
    output logic        clking_axi_wready,
    output logic  [1:0] clking_axi_bresp,
    output logic        clking_axi_bvalid,
    input  logic        clking_axi_bready,
    input  logic [10:0] clking_axi_araddr,
    input  logic        clking_axi_arvalid,
    output logic        clking_axi_arready,
    output logic [31:0] clking_axi_rdata,
    output logic  [1:0] clking_axi_rresp,
    output logic        clking_axi_rvalid,
    input  logic        clking_axi_rready,
  
    output logic        ClkSoc_CO,
    output logic        ClkSocGated_CO,
    output logic        ClkCluster_CO,
    output logic        ClkClusterGated_CO,
  
    output logic        RstSoc_RBO,     
    output logic        RstIcPulp_RBO,
    output logic        RstIcPulpGated_RBO,
    output logic        RstIcHost_RBO,        // RstIcHost_RBI & RstDebug_RBI synced to ClkIcHost
    output logic        RstIcHostClkConv_RBO  // RstIcHost_RBI & RstDebug_RBI & ~Locked synced to ClkIcHost
  );

  // Number of ClkIcHost_CI cycles to delay the locked signal.
  //
  // Xilinx recommends to keep all AXI interfaces in reset for at least 16 cycles of the slowest clock
  // With a host interface clock of 100 MHz, the worst case is with PULP at 5 MHz (100/5*16 = 320).
  localparam  N_DELAY_CYCLES = 320;

  logic [N_DELAY_CYCLES-1:0] Locked_SP;

  logic       RstClkMgr_RB;

  logic       Locked_S;

  logic       ClkEnSoc_SP;
  logic       ClkEnCluster_SP;

  // Async resets
  logic       RstSoc_RBA;
  logic       RstIcPulp_RBA;
  logic       RstIcHost_RBA;
  logic       RstIcHostClkConv_RBA;

  // Reset synchronizer
  logic [2:0] RstSoc_RB;
  logic [2:0] RstIcPulp_RB;
  logic [2:0] RstIcPulpGated_RB;
  logic [2:0] RstIcHost_RB;
  logic [2:0] RstIcHostClkConv_RB;
  
  assign RstClkMgr_RB = RstMaster_RBI & RstIcHost_RBI;       

  // Clock manager IP
  xilinx_clock_manager clk_manager_i
    (
      .s_axi_aclk    ( ClkIcHost_CI       ),
      .s_axi_aresetn ( RstClkMgr_RB       ),

      .s_axi_awaddr  ( clking_axi_awaddr  ),
      .s_axi_awvalid ( clking_axi_awvalid ),
      .s_axi_awready ( clking_axi_awready ),
      .s_axi_wdata   ( clking_axi_wdata   ),
      .s_axi_wstrb   ( clking_axi_wstrb   ),
      .s_axi_wvalid  ( clking_axi_wvalid  ),
      .s_axi_wready  ( clking_axi_wready  ),
      .s_axi_bresp   ( clking_axi_bresp   ),
      .s_axi_bvalid  ( clking_axi_bvalid  ),
      .s_axi_bready  ( clking_axi_bready  ),
      .s_axi_araddr  ( clking_axi_araddr  ),
      .s_axi_arvalid ( clking_axi_arvalid ),
      .s_axi_arready ( clking_axi_arready ),
      .s_axi_rdata   ( clking_axi_rdata   ),
      .s_axi_rresp   ( clking_axi_rresp   ),
      .s_axi_rvalid  ( clking_axi_rvalid  ),
      .s_axi_rready  ( clking_axi_rready  ),

      .clk_in1       ( ClkRef_CI          ),
      .clk_out1      ( ClkSoc_CO          ),
      .clk_out2      ( ClkCluster_CO      ),
      .locked        ( Locked_S           )
    );

    // Clock gating
    always_ff @(posedge ClkSoc_CO) begin
      begin
        ClkEnSoc_SP <= ClkEn_SI;
      end
    end

    BUFGCE bufgce_soc_i
      (
        .I  ( ClkSoc_CO      ),
        .CE ( ClkEnSoc_SP    ),
        .O  ( ClkSocGated_CO )
      );

    always_ff @(posedge ClkCluster_CO) begin
      begin
        ClkEnCluster_SP <= ClkEn_SI;
      end
    end

    BUFGCE bufgce_cluster_i
      (
        .I  ( ClkCluster_CO      ),
        .CE ( ClkEnCluster_SP    ),
        .O  ( ClkClusterGated_CO )
      );

    // Delay lock signal
    always_ff @(posedge ClkIcHost_CI) begin
      if (RstMaster_RBI == 1'b0)
        Locked_SP <= 'b0;
      else
        begin
          if (Locked_S == 1'b0) begin
            Locked_SP <= 'b0;
          end else begin
            Locked_SP[N_DELAY_CYCLES-1]   <= 1'b1;
            Locked_SP[N_DELAY_CYCLES-2:0] <= Locked_SP[N_DELAY_CYCLES-1:1];
          end
        end
    end

    // Resets ( ~RstMaster_RBI -> ~Locked_S )
    assign RstIcHost_RBA        = RstIcHost_RBI & RstDebug_RBI;
    assign RstIcHostClkConv_RBA = Locked_SP[0] & RstIcHost_RBI & RstDebug_RBI;
    assign RstIcPulp_RBA        = Locked_SP[0] & RstMaster_RBI & RstDebug_RBI;
    assign RstSoc_RBA           = Locked_SP[0] & RstMaster_RBI & RstDebug_RBI & RstUser_RBI;

    // Sync resets for interconnects
    always_ff @(posedge ClkIcHost_CI) begin
      if (RstMaster_RBI == 1'b0)
        RstIcHostClkConv_RB <= 'b0;
      else
        begin
          RstIcHostClkConv_RB[1:0] <= RstIcHostClkConv_RB[2:1];
          if(~RstIcHostClkConv_RBA) begin
            RstIcHostClkConv_RB[2] <= 1'b0;
          end else begin
            RstIcHostClkConv_RB[2] <= 1'b1;
          end
        end
    end

    always_ff @(posedge ClkIcHost_CI) begin
      if (RstMaster_RBI == 1'b0)
        RstIcHost_RB <= 'b0;
      else
        begin
          RstIcHost_RB[1:0] <= RstIcHost_RB[2:1];
          if(~RstIcHost_RBA) begin
            RstIcHost_RB[2] <= 1'b0;
          end else begin
            RstIcHost_RB[2] <= 1'b1;
          end
        end
    end

    always_ff @(posedge ClkSoc_CO) begin
      if (RstMaster_RBI == 1'b0)
        RstIcPulp_RB <= 'b0;
      else
        begin
          RstIcPulp_RB[1:0] <= RstIcPulp_RB[2:1];
          if(~RstIcPulp_RBA) begin
            RstIcPulp_RB[2] <= 1'b0;
          end else begin
            RstIcPulp_RB[2] <= 1'b1;
          end
        end
    end

    always_ff @(posedge ClkSocGated_CO) begin
      if (RstMaster_RBI == 1'b0)
        RstIcPulpGated_RB <= 'b0;
      else
        begin
          RstIcPulpGated_RB[1:0] <= RstIcPulpGated_RB[2:1];
          if(~RstIcPulp_RBA) begin
            RstIcPulpGated_RB[2] <= 1'b0;
          end else begin
            RstIcPulpGated_RB[2] <= 1'b1;
          end
        end
    end

    always_ff @(posedge ClkSoc_CO) begin
      if (RstMaster_RBI == 1'b0)
        RstSoc_RB <= 'b0;
      else
        begin
          RstSoc_RB[1:0] <= RstSoc_RB[2:1];
          if(~RstSoc_RBA) begin
            RstSoc_RB[2] <= 1'b0;
          end else begin
            RstSoc_RB[2] <= 1'b1;
          end
        end
    end

    // assign outputs
    assign RstIcHostClkConv_RBO = RstIcHostClkConv_RB[0];
    assign RstIcHost_RBO        = RstIcHost_RB[0];
    assign RstIcPulp_RBO        = RstIcPulp_RB[0];
    assign RstIcPulpGated_RBO   = RstIcPulpGated_RB[0];
    assign RstSoc_RBO           = RstSoc_RB[0];

endmodule
