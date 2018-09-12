// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

/*
 * SoC Bus to RAB Configuration Port Converter
 *
 * This module performs protocol conversion (AXI4 -> AXI4LITE) and, if necessary (depending on the
 * platform), data width conversion to connect a ULPSOC bus master to the RAB configuration slave.
 *
 * For read accesses aligned to 32-bit words but not to 64-bit words, the data is returned in the
 * upper 32 bit of the 64-bit word so that it ends up correctly in the registers of PULP.  The lower
 * 32 bit (ignored by PULP in this case) are set to zero.  This multiplexing on the R channel is
 * conditional on the last valid adddress on the AR channel.  Therefore, this module does not
 * support multiple outstanding reads and will serialize them.
 *
 * Also, only 32-bit reads are supported.
 *
 * Current Maintainers:
 * - Andreas Kurth  <andkurt@ee.ethz.ch>
 * - Pirmin Vogel   <vogelpi@iis.ee.ethz.ch>
 */

module socbus_to_rab_cfg_conv

  // Parameters {{{
  #(
    parameter AXI_ADDR_WIDTH  = 32,
    parameter AXI_DATA_WIDTH  = 64,
    parameter AXI_ID_WIDTH    = 10,
    parameter AXI_USER_WIDTH  =  6
  )
  // }}}

  // Ports {{{
  (

    input  logic  Clk_CI,
    input  logic  Rst_RBI,

    AXI_BUS.Slave   FromSoc_PS,
    AXI_LITE.Master ToRabCfg_PM

  );
  // }}}

  // Signal Declarations {{{
  enum reg {READY, READ}    State_SP,   State_SN;
  reg [AXI_ADDR_WIDTH-1:0]  ArAddr_DP,  ArAddr_DN;
  // }}}

  // Assert that module is used under the constraints it was designed for. {{{
  initial begin
    assert (AXI_DATA_WIDTH == 64)
      else $fatal(1, "This converter was designed for a 64-bit SoC data bus!");
  end
  // }}}

  // 32-to-64-bit Data Multiplexing to Make Reads Compatible with PULP {{{
  //
  // When reading, put 32-bit word from slave into lower or upper 32-bit of 64-bit of master,
  // depending on the read address.
  //
  // The problem:  The interface coming from the SoC Bus is 64-bit wide, PULP has 32-bit registers,
  // and the AXI Lite port is either 32- or 64-bit wide.  If a read is 32-bit, but not 64-bit
  // aligned (e.g., on 0x4), PULP wants those 32 bit that are written to the registers in the upper
  // 32 bit of the 64-bit bus.  The data width converter, however, places them in the lower 32 bit
  // of the 64-bit bus.
  //
  // The solution:  In this section, 32 bit words on the 64-bit wide R channel are put in the
  // position expected by PULP, conditional on the address on the AR channel.

  AXI_BUS
    #(
      .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH ),
      .AXI_DATA_WIDTH ( AXI_DATA_WIDTH ),
      .AXI_ID_WIDTH   ( AXI_ID_WIDTH   ),
      .AXI_USER_WIDTH ( AXI_USER_WIDTH )
    ) InternalSoc_PM ();

  // Connect signals that are directly forwarded. {{{

  assign InternalSoc_PM.aw_addr   = FromSoc_PS.aw_addr;
  assign InternalSoc_PM.aw_prot   = FromSoc_PS.aw_prot;
  assign InternalSoc_PM.aw_region = FromSoc_PS.aw_region;
  assign InternalSoc_PM.aw_len    = FromSoc_PS.aw_len;
  assign InternalSoc_PM.aw_size   = FromSoc_PS.aw_size;
  assign InternalSoc_PM.aw_burst  = FromSoc_PS.aw_burst;
  assign InternalSoc_PM.aw_lock   = FromSoc_PS.aw_lock;
  assign InternalSoc_PM.aw_cache  = FromSoc_PS.aw_cache;
  assign InternalSoc_PM.aw_qos    = FromSoc_PS.aw_qos;
  assign InternalSoc_PM.aw_id     = FromSoc_PS.aw_id;
  assign InternalSoc_PM.aw_user   = FromSoc_PS.aw_user;
  assign FromSoc_PS.aw_ready      = InternalSoc_PM.aw_ready;
  assign InternalSoc_PM.aw_valid  = FromSoc_PS.aw_valid;

  assign InternalSoc_PM.ar_addr   = FromSoc_PS.ar_addr;
  assign InternalSoc_PM.ar_prot   = FromSoc_PS.ar_prot;
  assign InternalSoc_PM.ar_region = FromSoc_PS.ar_region;
  assign InternalSoc_PM.ar_len    = FromSoc_PS.ar_len;
  assign InternalSoc_PM.ar_size   = FromSoc_PS.ar_size;
  assign InternalSoc_PM.ar_burst  = FromSoc_PS.ar_burst;
  assign InternalSoc_PM.ar_lock   = FromSoc_PS.ar_lock;
  assign InternalSoc_PM.ar_cache  = FromSoc_PS.ar_cache;
  assign InternalSoc_PM.ar_qos    = FromSoc_PS.ar_qos;
  assign InternalSoc_PM.ar_id     = FromSoc_PS.ar_id;
  assign InternalSoc_PM.ar_user   = FromSoc_PS.ar_user;
  assign InternalSoc_PM.ar_valid  = FromSoc_PS.ar_valid;

  assign InternalSoc_PM.w_data    = FromSoc_PS.w_data;
  assign InternalSoc_PM.w_strb    = FromSoc_PS.w_strb;
  assign InternalSoc_PM.w_user    = FromSoc_PS.w_user;
  assign InternalSoc_PM.w_last    = FromSoc_PS.w_last;
  assign FromSoc_PS.w_ready       = InternalSoc_PM.w_ready;
  assign InternalSoc_PM.w_valid   = FromSoc_PS.w_valid;

  assign FromSoc_PS.r_resp        = InternalSoc_PM.r_resp;
  assign FromSoc_PS.r_id          = InternalSoc_PM.r_id;
  assign FromSoc_PS.r_user        = InternalSoc_PM.r_user;
  assign FromSoc_PS.r_last        = InternalSoc_PM.r_last;
  assign InternalSoc_PM.r_ready   = FromSoc_PS.r_ready;

  assign FromSoc_PS.b_resp        = InternalSoc_PM.b_resp;
  assign FromSoc_PS.b_id          = InternalSoc_PM.b_id;
  assign FromSoc_PS.b_user        = InternalSoc_PM.b_user;
  assign InternalSoc_PM.b_ready   = FromSoc_PS.b_ready;
  assign FromSoc_PS.b_valid       = InternalSoc_PM.b_valid;

  // }}}

  // Conditional on the latched AR address, place 32-bit word on R channel as expected by PULP. {{{
  always_comb begin
    if (ArAddr_DP[2] == 1'b1) begin // upper 32-bit word of 64-bit data double word
      FromSoc_PS.r_data = {InternalSoc_PM.r_data[31:0], 32'h00000000};
    end
    else begin
      FromSoc_PS.r_data = {32'h00000000, InternalSoc_PM.r_data[31:0]};
    end
  end
  // }}}

  // FSM to Control Handshaking Outputs and AR Latching. {{{
  always_comb begin
    // Default Assignments
    ArAddr_DN           = ArAddr_DP;
    FromSoc_PS.ar_ready = 1'b0;
    FromSoc_PS.r_valid  = 1'b0;
    State_SN            = State_SP;

    case (State_SP)

      READY: begin
        FromSoc_PS.ar_ready = InternalSoc_PM.ar_ready;
        if (FromSoc_PS.ar_valid && InternalSoc_PM.ar_ready) begin
          ArAddr_DN = FromSoc_PS.ar_addr;
          State_SN  = READ;
        end
      end

      READ: begin
        FromSoc_PS.r_valid  = InternalSoc_PM.r_valid;
        if (FromSoc_PS.r_ready && InternalSoc_PM.r_valid) begin
          State_SN  = READY;
        end
      end

      default: begin
        State_SN = READY;
      end

    endcase
  end
  // }}}


  // }}}

  `ifndef HOST_IS_64_BIT
  AXI_LITE ToDwidthConv_P ();
  `endif

  // Protocol Converter {{{
  AxiToAxiLitePc
    #(
      .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH  ),
      .AXI_ID_WIDTH   ( AXI_ID_WIDTH    )
    ) prot_conv
    (
      .Clk_CI     ( Clk_CI          ),
      .Rst_RBI    ( Rst_RBI         ),

      .Axi_PS     ( InternalSoc_PM  ),
      `ifdef HOST_IS_64_BIT
      .AxiLite_PM ( ToRabCfg_PM     )
      `else
      .AxiLite_PM ( ToDwidthConv_P  )
      `endif
    );
  // }}}

  // Data Width Converter (all platforms without 64-bit host) {{{
  `ifndef HOST_IS_64_BIT
  xilinx_axi_dwidth_conv_rab_cfg dwidth_conv
    (
      .s_axi_aclk     ( Clk_CI                  ),
      .s_axi_aresetn  ( Rst_RBI                 ),

      .s_axi_awaddr   ( ToDwidthConv_P.aw_addr  ),
      .s_axi_awprot   ( 'b0                     ),
      .s_axi_awvalid  ( ToDwidthConv_P.aw_valid ),
      .s_axi_awready  ( ToDwidthConv_P.aw_ready ),
      .s_axi_wdata    ( ToDwidthConv_P.w_data   ),
      .s_axi_wstrb    ( ToDwidthConv_P.w_strb   ),
      .s_axi_wvalid   ( ToDwidthConv_P.w_valid  ),
      .s_axi_wready   ( ToDwidthConv_P.w_ready  ),
      .s_axi_bresp    ( ToDwidthConv_P.b_resp   ),
      .s_axi_bvalid   ( ToDwidthConv_P.b_valid  ),
      .s_axi_bready   ( ToDwidthConv_P.b_ready  ),
      .s_axi_araddr   ( ToDwidthConv_P.ar_addr  ),
      .s_axi_arprot   ( 'b0                     ),
      .s_axi_arvalid  ( ToDwidthConv_P.ar_valid ),
      .s_axi_arready  ( ToDwidthConv_P.ar_ready ),
      .s_axi_rdata    ( ToDwidthConv_P.r_data   ),
      .s_axi_rresp    ( ToDwidthConv_P.r_resp   ),
      .s_axi_rvalid   ( ToDwidthConv_P.r_valid  ),
      .s_axi_rready   ( ToDwidthConv_P.r_ready  ),

      .m_axi_awaddr   ( ToRabCfg_PM.aw_addr     ),
      .m_axi_awprot   (                         ),
      .m_axi_awvalid  ( ToRabCfg_PM.aw_valid    ),
      .m_axi_awready  ( ToRabCfg_PM.aw_ready    ),
      .m_axi_wdata    ( ToRabCfg_PM.w_data      ),
      .m_axi_wstrb    ( ToRabCfg_PM.w_strb      ),
      .m_axi_wvalid   ( ToRabCfg_PM.w_valid     ),
      .m_axi_wready   ( ToRabCfg_PM.w_ready     ),
      .m_axi_bresp    ( ToRabCfg_PM.b_resp      ),
      .m_axi_bvalid   ( ToRabCfg_PM.b_valid     ),
      .m_axi_bready   ( ToRabCfg_PM.b_ready     ),
      .m_axi_araddr   ( ToRabCfg_PM.ar_addr     ),
      .m_axi_arprot   (                         ),
      .m_axi_arvalid  ( ToRabCfg_PM.ar_valid    ),
      .m_axi_arready  ( ToRabCfg_PM.ar_ready    ),
      .m_axi_rdata    ( ToRabCfg_PM.r_data      ),
      .m_axi_rresp    ( ToRabCfg_PM.r_resp      ),
      .m_axi_rvalid   ( ToRabCfg_PM.r_valid     ),
      .m_axi_rready   ( ToRabCfg_PM.r_ready     )
    );
  `endif
  // }}}

  // Flip-Flops {{{
  always_ff @ (posedge Clk_CI) begin
    ArAddr_DP <= {AXI_ADDR_WIDTH{1'b0}};
    State_SP  <= READY;
    if (Rst_RBI) begin
      ArAddr_DP <= ArAddr_DN;
      State_SP  <= State_SN;
    end
  end
  // }}}

endmodule

// vim: ts=2 sw=2 sts=2 et nosmartindent autoindent foldmethod=marker tw=100
