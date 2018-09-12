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
// ██╗    ██╗██████╗ ██╗████████╗███████╗     █████╗ ██████╗  █████╗ ██████╗ ████████╗
// ██║    ██║██╔══██╗██║╚══██╔══╝██╔════╝    ██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝
// ██║ █╗ ██║██████╔╝██║   ██║   █████╗      ███████║██║  ██║███████║██████╔╝   ██║
// ██║███╗██║██╔══██╗██║   ██║   ██╔══╝      ██╔══██║██║  ██║██╔══██║██╔═══╝    ██║
// ╚███╔███╔╝██║  ██║██║   ██║   ███████╗    ██║  ██║██████╔╝██║  ██║██║        ██║
//  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝        ╚═╝
//
// --=========================================================================--
/**
 * Write Channels Adaptor for Xilinx Mailbox
 *
 * Current Maintainers:
 * - Pirmin Vogel   <vogelpi@iis.ee.ethz.ch>
 *
 * AXI-to-AXI-Lite protocol conversion, including data width conversion, ID reflection logic,
 * and mailbox interface arbitration.
 *
 * Since Xilinx AXI-Lite slaves want the aw and w channel signals simultaneously, this
 * converter fakes the aw_ready and accepts the aw_addr whenever no transaction is currently
 * ongoing.
 *
 * This adaptor also properly handles multi-beat write transactions as they occur when, e.g.,
 * a 64-bit master interfaced through a Xilinx data width converter issues a 32-bit write.
 *
 * IMPORTANT NOTE: Only 1 word in 1 data beat is supposed to have non-zero wstrb.
 */

module xilinx_mailbox_write_adaptor
  #(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_ID_WIDTH   = 10,
    parameter AXI_USER_WIDTH = 6,
    parameter AXI_STRB_WIDTH = 8
   )
  (
    input logic                       Clk_CI,
    input logic                       Rst_RBI,

    // AXI4 interface
    input  logic [AXI_ADDR_WIDTH-1:0] AwAddr_DI,
    input  logic                      AwValid_SI,
    output logic                      AwReady_SO,
    input  logic                [7:0] AwLen_SI,
    input  logic   [AXI_ID_WIDTH-1:0] AwId_DI,

    input  logic [AXI_DATA_WIDTH-1:0] WData_DI,
    input  logic [AXI_STRB_WIDTH-1:0] WStrb_DI,
    input  logic                      WValid_SI,
    output logic                      WReady_SO,

    output logic                      BValid_SO,
    input  logic                      BReady_SI,
    output logic   [AXI_ID_WIDTH-1:0] BId_DO,
    output logic                [1:0] BResp_DO,
    output logic [AXI_USER_WIDTH-1:0] BUser_DO,

    // AXI4-Lite interfaces
    output logic [AXI_ADDR_WIDTH-1:0] If0_AwAddr_DO,
    output logic                      If0_AwValid_SO,
    input  logic                      If0_AwReady_SI, // not used
    output logic               [31:0] If0_WData_DO,
    output logic                [3:0] If0_WStrb_DO,
    output logic                      If0_WValid_SO,
    input  logic                      If0_WReady_SI,
    input  logic                      If0_BValid_SI,
    output logic                      If0_BReady_SO,
    input  logic                [1:0] If0_BResp_DI,

    output logic [AXI_ADDR_WIDTH-1:0] If1_AwAddr_DO,
    output logic                      If1_AwValid_SO,
    input  logic                      If1_AwReady_SI, // not used
    output logic               [31:0] If1_WData_DO,
    output logic                [3:0] If1_WStrb_DO,
    output logic                      If1_WValid_SO,
    input  logic                      If1_WReady_SI,
    input  logic                      If1_BValid_SI,
    output logic                      If1_BReady_SO,
    input  logic                [1:0] If1_BResp_DI
  );

  logic                      WAccept_S;
  logic                      WSel_SN, WSel_SP;
  logic                      HighWordSel_S;
  logic                      AddrAligned_S;
  logic                [7:0] BeatCnt_SN, BeatCnt_SP;
  logic [AXI_ADDR_WIDTH-1:0] AwAddr_DN, AwAddr_DP;
  logic   [AXI_ID_WIDTH-1:0] WId_DN, WId_DP;
  logic               [31:0] WData_D;
  logic                [3:0] WStrb_D;

  enum logic [1:0] {IDLE, WRITE, RESP} State_SN, State_SP;

  /*
   * Constant outputs
   */
  assign If0_WData_DO  = WData_D;
  assign If0_WStrb_DO  = WStrb_D;
  assign If1_WData_DO  = WData_D;
  assign If1_WStrb_DO  = WStrb_D;
  assign BUser_DO      = 'b0;

  /*
   *  ID reflection logic
   */
  assign WId_DN = AwId_DI;
  assign BId_DO = WId_DP;

  /*
   *  Mailbox interface arbitration based on Bit 12
   *  - Address 0x0000 - 0x0FFF: Port 0
   *  - Address 0x1000 - 0x1FFF: Port 1
   */
  assign WSel_SN = AwAddr_DI[12];

  /*
   *  Data width conversion
   */
  generate
    if (AXI_DATA_WIDTH == 64) begin

      // byte-lane steering
      assign HighWordSel_S = |WStrb_DI[7:4];
      always_comb begin
        if ( HighWordSel_S == 1'b1 ) begin
          WData_D = WData_DI[63:32];
          WStrb_D = WStrb_DI[7:4];
        end else begin
          WData_D = WData_DI[31:0];
          WStrb_D = WStrb_DI[3:0];
        end
      end

    end else begin

      assign HighWordSel_S = 0;
      always_comb begin
        WData_D = WData_DI;
        WStrb_D = WStrb_DI;
      end

    end
  endgenerate

  /*
   *  Transaction acceptance
   *
   *  Registering of aw channel for compatibility with Xilinx AXI4-Lite slaves:
   *
   *  Xilinx AXI4-Lite slaves want the aw and w channel signals simultaneously!
   */
  // aw/w/b channel FSM
  always_comb begin
    // default assignments
    If0_AwAddr_DO  =  'b0;
    If1_AwAddr_DO  =  'b0;
    WAccept_S      = 1'b0;
    AwAddr_DN      = AwAddr_DP;
    AddrAligned_S  = ~AwAddr_DP[2];
    BeatCnt_SN     = BeatCnt_SP;
    AwReady_SO     = 1'b0;
    If0_AwValid_SO = 1'b0;
    If0_WValid_SO  = 1'b0;
    If1_AwValid_SO = 1'b0;
    If1_WValid_SO  = 1'b0;
    WReady_SO      = 1'b0;
    BValid_SO      = 1'b0;
    If0_BReady_SO  = 1'b0;
    If1_BReady_SO  = 1'b0;
    BResp_DO       = If0_BResp_DI;
    State_SN       = State_SP;

    case (State_SP)

      IDLE: begin
        AwAddr_DN  = AwAddr_DI;
        AwReady_SO = 1'b1; // prepare hand shake, recommended by AXI protocol specification
        if (AwValid_SI == 1'b1) begin
          WAccept_S  = 1'b1; // store ID, addr, select and byte-lane steering flag
          BeatCnt_SN = AwLen_SI;
          State_SN   = WRITE;
        end
      end

      WRITE: begin
        if (WValid_SI == 1'b1) begin

          if (WStrb_D == 'b0) begin // nothing to write downstream, skip this beat
            WReady_SO  = 1'b1;                         // hand shake with master
            AwAddr_DN  = AwAddr_DP + AXI_DATA_WIDTH/8; // increment address for next beat
            BeatCnt_SN = BeatCnt_SP-1;                 // decrement beat counter
            if (BeatCnt_SP == 'b0) begin
              State_SN     = RESP;
            end

          end else begin

            if ( ~WSel_SP ) begin
              if ( HighWordSel_S & AddrAligned_S ) begin
                If0_AwAddr_DO = AwAddr_DP + AXI_DATA_WIDTH/8/2;
              end else begin
                If0_AwAddr_DO = AwAddr_DP;
              end
              If0_AwValid_SO = 1'b1; // apply aw and w channel simultaneously
              If0_WValid_SO  = 1'b1;
              if (If0_WReady_SI == 1'b1) begin
                WReady_SO    = 1'b1;
                AwAddr_DN    = AwAddr_DP + AXI_DATA_WIDTH/8;
                BeatCnt_SN   = BeatCnt_SP-1;
                if (BeatCnt_SP == 'b0) begin
                  State_SN     = RESP;
                end
              end
            end else begin // WSel_SP
              if ( HighWordSel_S & AddrAligned_S ) begin
                If1_AwAddr_DO = AwAddr_DP + AXI_DATA_WIDTH/8/2;
              end else begin
                If1_AwAddr_DO = AwAddr_DP;
              end
              If1_AwValid_SO = 1'b1;
              If1_WValid_SO  = 1'b1;
              if (If1_WReady_SI == 1'b1) begin
                WReady_SO    = 1'b1;
                AwAddr_DN    = AwAddr_DP + AXI_DATA_WIDTH/8;
                BeatCnt_SN   = BeatCnt_SP-1;
                if (BeatCnt_SP == 'b0) begin
                  State_SN     = RESP;
                end
              end
            end // WSel_SP

          end // WStrb_D
        end // WValid
      end

      RESP: begin
        BValid_SO = (If0_BValid_SI & ~WSel_SP) | (If1_BValid_SI & WSel_SP);
        if (BReady_SI == 1'b1) begin
          if          (If0_BValid_SI & ~WSel_SP) begin
            If0_BReady_SO = 1'b1;
            BResp_DO      = If0_BResp_DI;
            State_SN      = IDLE;
          end else if (If1_BValid_SI &  WSel_SP) begin
            If1_BReady_SO = 1'b1;
            BResp_DO      = If1_BResp_DI;
            State_SN      = IDLE;
          end
        end
      end

      default: begin
        State_SN = IDLE;
      end
    endcase // State_SP
  end

  always_ff @(posedge Clk_CI, negedge Rst_RBI) begin
    if (Rst_RBI == 1'b0) begin
      WSel_SP <= 1'b0;
      WId_DP  <=  'b0;
    end else if (WAccept_S == 1'b1) begin
      WSel_SP <= WSel_SN;
      WId_DP  <= WId_DN;
    end
  end

  always_ff @(posedge Clk_CI, negedge Rst_RBI) begin
    if (Rst_RBI == 1'b0) begin
      BeatCnt_SP <= 'b0;
      AwAddr_DP  <= 'b0;
    end else begin
      BeatCnt_SP <= BeatCnt_SN;
      AwAddr_DP  <= AwAddr_DN;
    end
  end

  always_ff @(posedge Clk_CI, negedge Rst_RBI) begin
    if (Rst_RBI == 1'b0) begin
      State_SP <= IDLE;
    end else begin
      State_SP <= State_SN;
    end
  end

endmodule
