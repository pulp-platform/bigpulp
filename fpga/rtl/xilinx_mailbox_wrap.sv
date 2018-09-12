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
// ███╗   ███╗██████╗  ██████╗ ██╗  ██╗    ██╗    ██╗██████╗  █████╗ ██████╗ 
// ████╗ ████║██╔══██╗██╔═══██╗╚██╗██╔╝    ██║    ██║██╔══██╗██╔══██╗██╔══██╗
// ██╔████╔██║██████╔╝██║   ██║ ╚███╔╝     ██║ █╗ ██║██████╔╝███████║██████╔╝
// ██║╚██╔╝██║██╔══██╗██║   ██║ ██╔██╗     ██║███╗██║██╔══██╗██╔══██║██╔═══╝ 
// ██║ ╚═╝ ██║██████╔╝╚██████╔╝██╔╝ ██╗    ╚███╔███╔╝██║  ██║██║  ██║██║     
// ╚═╝     ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     
//                                                                           
// --=========================================================================-- 
/**
 * Wrapper Around the Xilinx Mailbox
 *
 * Current Maintainers:
 * - Pirmin Vogel   <vogelpi@iis.ee.ethz.ch>
 *
 * Includes read and write channel adaptor for AXI-to-AXI-Lite protocol
 * conversion, data width conversion, and mailbox interface arbitration.
 *
 * This adaptor also handles multi-beat write transactions as they occur when,
 *  e.g., a 64-bit master interfaced through a Xilinx data width converter
 * issues a 32-bit write.
 *
 * IMPORTANT NOTES:
 *
 * - As the mailbox is a 32-bit AXI-Lite slave, only 1 32-bit word per
 *   data beat is written. Additional write data in other beats with non-zero
 *   wstrb is written, too.
 *
 * - Multi-beat read transactions are not supported. The master is supposed
 *   specify arsize accordingly when connecting through Xilinx data width
 *   converters.
 */

module xilinx_mailbox_wrap
  #(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_ID_WIDTH   = 10,
    parameter AXI_USER_WIDTH = 6
   )
  (
    input  logic  Clk_CI,
    input  logic  Rst_RBI,
    
    AXI_BUS.Slave FromSoc_PS,

    output logic  Irq0_SO,
    output logic  Irq1_SO
  );

  localparam AXI_STRB_WIDTH = AXI_DATA_WIDTH/8;

  logic [AXI_ADDR_WIDTH-1:0] If0_ArAddr_D;
  logic                      If0_ArValid_S;
  logic                      If0_ArReady_S;
  logic               [31:0] If0_RData_D;
  logic                      If0_RValid_S;
  logic                      If0_RReady_S;
  logic                [1:0] If0_RResp_D;
  logic [AXI_ADDR_WIDTH-1:0] If0_AwAddr_D;
  logic                      If0_AwValid_S;
  logic                      If0_AwReady_S;
  logic               [31:0] If0_WData_D;
  logic                [3:0] If0_WStrb_D;
  logic                      If0_WValid_S;
  logic                      If0_WReady_S;
  logic                      If0_BValid_S;
  logic                      If0_BReady_S;
  logic                [1:0] If0_BResp_D;

  logic [AXI_ADDR_WIDTH-1:0] If1_ArAddr_D;
  logic                      If1_ArValid_S;
  logic                      If1_ArReady_S;
  logic               [31:0] If1_RData_D;
  logic                      If1_RValid_S;
  logic                      If1_RReady_S;
  logic                [1:0] If1_RResp_D;
  logic [AXI_ADDR_WIDTH-1:0] If1_AwAddr_D;
  logic                      If1_AwValid_S;
  logic                      If1_AwReady_S;
  logic               [31:0] If1_WData_D;
  logic                [3:0] If1_WStrb_D;
  logic                      If1_WValid_S;
  logic                      If1_WReady_S;
  logic                      If1_BValid_S;
  logic                      If1_BReady_S;
  logic                [1:0] If1_BResp_D;

  xilinx_mailbox_read_adaptor #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH  ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH  ),
    .AXI_ID_WIDTH   ( AXI_ID_WIDTH    ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH  )
  ) xilinx_mailbox_read_adaptor_i (
    .Clk_CI         ( Clk_CI              ),
    .Rst_RBI        ( Rst_RBI             ),
    .ArAddr_DI      ( FromSoc_PS.ar_addr  ),
    .ArValid_SI     ( FromSoc_PS.ar_valid ),
    .ArReady_SO     ( FromSoc_PS.ar_ready ),
    .ArLen_SI       ( FromSoc_PS.ar_len   ),
    .ArId_DI        ( FromSoc_PS.ar_id    ),
    .RData_DO       ( FromSoc_PS.r_data   ),
    .RValid_SO      ( FromSoc_PS.r_valid  ),
    .RReady_SI      ( FromSoc_PS.r_ready  ),
    .RId_DO         ( FromSoc_PS.r_id     ),
    .RResp_DO       ( FromSoc_PS.r_resp   ),
    .RUser_DO       ( FromSoc_PS.r_user   ),
    .RLast_SO       ( FromSoc_PS.r_last   ),
    .If0_ArAddr_DO  ( If0_ArAddr_D        ),
    .If0_ArValid_SO ( If0_ArValid_S       ),
    .If0_ArReady_SI ( If0_ArReady_S       ),
    .If0_RData_DI   ( If0_RData_D         ),
    .If0_RValid_SI  ( If0_RValid_S        ),
    .If0_RReady_SO  ( If0_RReady_S        ),
    .If0_RResp_DI   ( If0_RResp_D         ),
    .If1_ArAddr_DO  ( If1_ArAddr_D        ),
    .If1_ArValid_SO ( If1_ArValid_S       ),
    .If1_ArReady_SI ( If1_ArReady_S       ),
    .If1_RData_DI   ( If1_RData_D         ),
    .If1_RValid_SI  ( If1_RValid_S        ),
    .If1_RReady_SO  ( If1_RReady_S        ),
    .If1_RResp_DI   ( If1_RResp_D         )
  );

  xilinx_mailbox_write_adaptor #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH  ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH  ),
    .AXI_ID_WIDTH   ( AXI_ID_WIDTH    ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH  ),
    .AXI_STRB_WIDTH ( AXI_STRB_WIDTH  )
  ) xilinx_mailbox_write_adaptor_i (
    .Clk_CI         ( Clk_CI              ),
    .Rst_RBI        ( Rst_RBI             ),
    .AwAddr_DI      ( FromSoc_PS.aw_addr  ),
    .AwValid_SI     ( FromSoc_PS.aw_valid ),
    .AwReady_SO     ( FromSoc_PS.aw_ready ),
    .AwLen_SI       ( FromSoc_PS.aw_len   ),
    .AwId_DI        ( FromSoc_PS.aw_id    ),
    .WData_DI       ( FromSoc_PS.w_data   ),
    .WStrb_DI       ( FromSoc_PS.w_strb   ),
    .WValid_SI      ( FromSoc_PS.w_valid  ),
    .WReady_SO      ( FromSoc_PS.w_ready  ),
    .BValid_SO      ( FromSoc_PS.b_valid  ),
    .BReady_SI      ( FromSoc_PS.b_ready  ),
    .BId_DO         ( FromSoc_PS.b_id     ),
    .BResp_DO       ( FromSoc_PS.b_resp   ),
    .BUser_DO       ( FromSoc_PS.b_user   ),
    .If0_AwAddr_DO  ( If0_AwAddr_D        ),
    .If0_AwValid_SO ( If0_AwValid_S       ),
    .If0_AwReady_SI ( If0_AwReady_S       ),
    .If0_WData_DO   ( If0_WData_D         ),
    .If0_WStrb_DO   ( If0_WStrb_D         ),
    .If0_WValid_SO  ( If0_WValid_S        ),
    .If0_WReady_SI  ( If0_WReady_S        ),
    .If0_BValid_SI  ( If0_BValid_S        ),
    .If0_BReady_SO  ( If0_BReady_S        ),
    .If0_BResp_DI   ( If0_BResp_D         ),
    .If1_AwAddr_DO  ( If1_AwAddr_D        ),
    .If1_AwValid_SO ( If1_AwValid_S       ),
    .If1_AwReady_SI ( If1_AwReady_S       ),
    .If1_WData_DO   ( If1_WData_D         ),
    .If1_WStrb_DO   ( If1_WStrb_D         ),
    .If1_WValid_SO  ( If1_WValid_S        ),
    .If1_WReady_SI  ( If1_WReady_S        ),
    .If1_BValid_SI  ( If1_BValid_S        ),
    .If1_BReady_SO  ( If1_BReady_S        ),
    .If1_BResp_DI   ( If1_BResp_D         )
  );

  xilinx_mailbox xilinx_mailbox_i (
    .S0_AXI_ACLK    ( Clk_CI        ),
    .S0_AXI_ARESETN ( Rst_RBI       ),
    .S0_AXI_AWADDR  ( If0_AwAddr_D  ),
    .S0_AXI_AWVALID ( If0_AwValid_S ),
    .S0_AXI_AWREADY ( If0_AwReady_S ),
    .S0_AXI_WDATA   ( If0_WData_D   ),
    .S0_AXI_WSTRB   ( If0_WStrb_D   ),
    .S0_AXI_WVALID  ( If0_WValid_S  ),
    .S0_AXI_WREADY  ( If0_WReady_S  ),
    .S0_AXI_BRESP   ( If0_BResp_D   ),
    .S0_AXI_BVALID  ( If0_BValid_S  ),
    .S0_AXI_BREADY  ( If0_BReady_S  ),
    .S0_AXI_ARADDR  ( If0_ArAddr_D  ),
    .S0_AXI_ARVALID ( If0_ArValid_S ),
    .S0_AXI_ARREADY ( If0_ArReady_S ),
    .S0_AXI_RDATA   ( If0_RData_D   ),
    .S0_AXI_RRESP   ( If0_RResp_D   ),
    .S0_AXI_RVALID  ( If0_RValid_S  ),
    .S0_AXI_RREADY  ( If0_RReady_S  ),

    .S1_AXI_ACLK    ( Clk_CI        ),
    .S1_AXI_ARESETN ( Rst_RBI       ),
    .S1_AXI_AWADDR  ( If1_AwAddr_D  ),
    .S1_AXI_AWVALID ( If1_AwValid_S ),
    .S1_AXI_AWREADY ( If1_AwReady_S ),
    .S1_AXI_WDATA   ( If1_WData_D   ),
    .S1_AXI_WSTRB   ( If1_WStrb_D   ),
    .S1_AXI_WVALID  ( If1_WValid_S  ),
    .S1_AXI_WREADY  ( If1_WReady_S  ),
    .S1_AXI_BRESP   ( If1_BResp_D   ),
    .S1_AXI_BVALID  ( If1_BValid_S  ),
    .S1_AXI_BREADY  ( If1_BReady_S  ),
    .S1_AXI_ARADDR  ( If1_ArAddr_D  ),
    .S1_AXI_ARVALID ( If1_ArValid_S ),
    .S1_AXI_ARREADY ( If1_ArReady_S ),
    .S1_AXI_RDATA   ( If1_RData_D   ),
    .S1_AXI_RRESP   ( If1_RResp_D   ),
    .S1_AXI_RVALID  ( If1_RValid_S  ),
    .S1_AXI_RREADY  ( If1_RReady_S  ),

    .Interrupt_0    ( Irq0_SO       ),
    .Interrupt_1    ( Irq1_SO       )
  );

endmodule
