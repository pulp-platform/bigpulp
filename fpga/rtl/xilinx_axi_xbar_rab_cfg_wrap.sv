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
 * Wrapper Around the Xilinx AXI Crossbar Used to Connect the RAB Configuration Port
 *
 * Current Maintainers:
 * - Andreas Kurth  <andkurt@ee.ethz.ch>
 * - Pirmin Vogel   <vogelpi@iis.ee.ethz.ch>
 */

import CfMath::ceil_div;

module xilinx_axi_xbar_rab_cfg_wrap

  // Parameters {{{
  #(
    parameter integer ADDR_BITW = 32,
    parameter integer DATA_BITW = 32
  )
  // }}}

  // Ports {{{
  (

    input  logic    Clk_CI,
    input  logic    Rst_RBI,

    AXI_LITE.Slave  Slave0_PS,
    AXI_LITE.Slave  Slave1_PS,
    AXI_LITE.Master Master_PM

  );
  // }}}

  // Module-Wide Constants {{{
  localparam integer NUM_SI     = 2;
  localparam integer DATA_BYTEW = ceil_div(DATA_BITW, 8);
  // }}}

  // Signal Declarations {{{
  logic [NUM_SI*ADDR_BITW -1:0] AwAddr_D, ArAddr_D;
  logic [NUM_SI           -1:0] AwValid_D, WValid_D, BValid_D, ArValid_D, RValid_D;
  logic [NUM_SI           -1:0] AwReady_D, WReady_D, BReady_D, ArReady_D, RReady_D;
  logic [NUM_SI*DATA_BITW -1:0] WData_D, RData_D;
  logic [NUM_SI*2         -1:0] BResp_D, RResp_D;
  logic [NUM_SI*DATA_BYTEW-1:0] WStrb_D;
  // }}}

  // Pack and Unpack Slave Signals {{{
  genvar s;
  for (s = 0; s < NUM_SI; s++) begin

    localparam integer ADDR_BIT_LOW   = ADDR_BITW * s;
    localparam integer ADDR_BIT_HIGH  = ADDR_BIT_LOW + (ADDR_BITW-1);
    localparam integer DATA_BIT_LOW   = DATA_BITW * s;
    localparam integer DATA_BIT_HIGH  = DATA_BIT_LOW + (DATA_BITW-1);
    localparam integer DATA_BYTE_LOW  = DATA_BYTEW * s;
    localparam integer DATA_BYTE_HIGH = DATA_BYTE_LOW + (DATA_BYTEW-1);
    localparam integer RESP_BIT_LOW   = 2 * s;
    localparam integer RESP_BIT_HIGH  = RESP_BIT_LOW + (2-1);

    // This is extremely ugly and only supports NUM_SI == 2, but it is the only way I found to get
    // this interface construct to synthesize in Vivado.
    if (s == 0) begin

      assign AwAddr_D[ADDR_BIT_HIGH:ADDR_BIT_LOW] = Slave0_PS.aw_addr;
      assign ArAddr_D[ADDR_BIT_HIGH:ADDR_BIT_LOW] = Slave0_PS.ar_addr;

      assign AwValid_D[s]       = Slave0_PS.aw_valid;
      assign WValid_D[s]        = Slave0_PS.w_valid;
      assign Slave0_PS.b_valid  = BValid_D[s];
      assign ArValid_D[s]       = Slave0_PS.ar_valid;
      assign Slave0_PS.r_valid  = RValid_D[s];

      assign Slave0_PS.aw_ready = AwReady_D[s];
      assign Slave0_PS.w_ready  = WReady_D[s];
      assign BReady_D[s]        = Slave0_PS.b_ready;
      assign Slave0_PS.ar_ready = ArReady_D[s];
      assign RReady_D[s]        = Slave0_PS.r_ready;

      assign WData_D[DATA_BIT_HIGH:DATA_BIT_LOW]  = Slave0_PS.w_data;

      assign Slave0_PS.r_data  = RData_D[DATA_BIT_HIGH:DATA_BIT_LOW];

      assign Slave0_PS.b_resp  = BResp_D[RESP_BIT_HIGH:RESP_BIT_LOW];

      assign Slave0_PS.r_resp  = RResp_D[RESP_BIT_HIGH:RESP_BIT_LOW];

      assign WStrb_D[DATA_BYTE_HIGH:DATA_BYTE_LOW]  = Slave0_PS.w_strb;

    end
    else begin // s == 1

      assign AwAddr_D[ADDR_BIT_HIGH:ADDR_BIT_LOW] = Slave1_PS.aw_addr;
      assign ArAddr_D[ADDR_BIT_HIGH:ADDR_BIT_LOW] = Slave1_PS.ar_addr;

      assign AwValid_D[s]       = Slave1_PS.aw_valid;
      assign WValid_D[s]        = Slave1_PS.w_valid;
      assign Slave1_PS.b_valid  = BValid_D[s];
      assign ArValid_D[s]       = Slave1_PS.ar_valid;
      assign Slave1_PS.r_valid  = RValid_D[s];

      assign Slave1_PS.aw_ready = AwReady_D[s];
      assign Slave1_PS.w_ready  = WReady_D[s];
      assign BReady_D[s]        = Slave1_PS.b_ready;
      assign Slave1_PS.ar_ready = ArReady_D[s];
      assign RReady_D[s]        = Slave1_PS.r_ready;

      assign WData_D[DATA_BIT_HIGH:DATA_BIT_LOW]  = Slave1_PS.w_data;

      assign Slave1_PS.r_data  = RData_D[DATA_BIT_HIGH:DATA_BIT_LOW];

      assign Slave1_PS.b_resp  = BResp_D[RESP_BIT_HIGH:RESP_BIT_LOW];

      assign Slave1_PS.r_resp  = RResp_D[RESP_BIT_HIGH:RESP_BIT_LOW];

      assign WStrb_D[DATA_BYTE_HIGH:DATA_BYTE_LOW]  = Slave1_PS.w_strb;

    end

  end
  // }}}

  // Wrapped Xilinx AXI Crossbar {{{
  xilinx_axi_xbar_rab_cfg i_xilinx_axi_xbar_rab_cfg
    (
      .aclk           ( Clk_CI              ),
      .aresetn        ( Rst_RBI             ),

      .s_axi_awaddr   ( AwAddr_D            ),
      .s_axi_awprot   ( 'b0                 ),
      .s_axi_awvalid  ( AwValid_D           ),
      .s_axi_awready  ( AwReady_D           ),
      .s_axi_wdata    ( WData_D             ),
      .s_axi_wstrb    ( WStrb_D             ),
      .s_axi_wvalid   ( WValid_D            ),
      .s_axi_wready   ( WReady_D            ),
      .s_axi_bresp    ( BResp_D             ),
      .s_axi_bvalid   ( BValid_D            ),
      .s_axi_bready   ( BReady_D            ),
      .s_axi_araddr   ( ArAddr_D            ),
      .s_axi_arprot   ( 'b0                 ),
      .s_axi_arvalid  ( ArValid_D           ),
      .s_axi_arready  ( ArReady_D           ),
      .s_axi_rdata    ( RData_D             ),
      .s_axi_rresp    ( RResp_D             ),
      .s_axi_rvalid   ( RValid_D            ),
      .s_axi_rready   ( RReady_D            ),

      .m_axi_awaddr   ( Master_PM.aw_addr   ),
      .m_axi_awprot   (                     ),
      .m_axi_awvalid  ( Master_PM.aw_valid  ),
      .m_axi_awready  ( Master_PM.aw_ready  ),
      .m_axi_wdata    ( Master_PM.w_data    ),
      .m_axi_wstrb    ( Master_PM.w_strb    ),
      .m_axi_wvalid   ( Master_PM.w_valid   ),
      .m_axi_wready   ( Master_PM.w_ready   ),
      .m_axi_bresp    ( Master_PM.b_resp    ),
      .m_axi_bvalid   ( Master_PM.b_valid   ),
      .m_axi_bready   ( Master_PM.b_ready   ),
      .m_axi_araddr   ( Master_PM.ar_addr   ),
      .m_axi_arprot   (                     ),
      .m_axi_arvalid  ( Master_PM.ar_valid  ),
      .m_axi_arready  ( Master_PM.ar_ready  ),
      .m_axi_rdata    ( Master_PM.r_data    ),
      .m_axi_rresp    ( Master_PM.r_resp    ),
      .m_axi_rvalid   ( Master_PM.r_valid   ),
      .m_axi_rready   ( Master_PM.r_ready   )
    );
  // }}}

endmodule

// vim: ts=2 sw=2 sts=2 et nosmartindent autoindent foldmethod=marker tw=100
