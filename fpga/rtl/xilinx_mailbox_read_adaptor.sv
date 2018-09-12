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
// ██████╗ ███████╗ █████╗ ██████╗      █████╗ ██████╗  █████╗ ██████╗ ████████╗
// ██╔══██╗██╔════╝██╔══██╗██╔══██╗    ██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝
// ██████╔╝█████╗  ███████║██║  ██║    ███████║██║  ██║███████║██████╔╝   ██║   
// ██╔══██╗██╔══╝  ██╔══██║██║  ██║    ██╔══██║██║  ██║██╔══██║██╔═══╝    ██║   
// ██║  ██║███████╗██║  ██║██████╔╝    ██║  ██║██████╔╝██║  ██║██║        ██║   
// ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝     ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝        ╚═╝   
//                                                                                               
// --=========================================================================--
/**
 * Read Channels Adaptor for Xilinx Mailbox
 *
 * Current Maintainers:
 * - Pirmin Vogel   <vogelpi@iis.ee.ethz.ch>
 *
 * AXI-to-AXI-Lite protocol conversion, including data width conversion, ID reflection logic,
 * and mailbox interface arbitration.
 *
 * The Xilinx Mailbox seems to latch the ar channel without proper hand shake (illegal) if the
 * master decides to apply another transaction after driving valid high but without hand shake
 * having happened (illegal). The safe solution to this issue performed by this adaptor is to
 * register the ar request and perform the handshake separately with the mailbox and the master.
 *
 * IMPORTANT NOTE: Bursts are NOT supported.
 */

module xilinx_mailbox_read_adaptor
  #(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_ID_WIDTH   = 10,
    parameter AXI_USER_WIDTH = 6
   )
  (
    input logic                       Clk_CI,
    input logic                       Rst_RBI,

    // AXI4 interface
    input  logic [AXI_ADDR_WIDTH-1:0] ArAddr_DI,
    input  logic                      ArValid_SI,
    output logic                      ArReady_SO,
    input  logic                [7:0] ArLen_SI,
    input  logic   [AXI_ID_WIDTH-1:0] ArId_DI,

    output logic [AXI_DATA_WIDTH-1:0] RData_DO,
    output logic                      RValid_SO,
    input  logic                      RReady_SI,
    output logic   [AXI_ID_WIDTH-1:0] RId_DO, 
    output logic                [1:0] RResp_DO,
    output logic [AXI_USER_WIDTH-1:0] RUser_DO,
    output logic                      RLast_SO,
    
    // AXI4-Lite interfaces
    output logic [AXI_ADDR_WIDTH-1:0] If0_ArAddr_DO,
    output logic                      If0_ArValid_SO,
    input  logic                      If0_ArReady_SI,
    input  logic               [31:0] If0_RData_DI,
    input  logic                      If0_RValid_SI,
    output logic                      If0_RReady_SO,
    input  logic                [1:0] If0_RResp_DI,

    output logic [AXI_ADDR_WIDTH-1:0] If1_ArAddr_DO,
    output logic                      If1_ArValid_SO,
    input  logic                      If1_ArReady_SI,
    input  logic               [31:0] If1_RData_DI,
    input  logic                      If1_RValid_SI,
    output logic                      If1_RReady_SO,
    input  logic                [1:0] If1_RResp_DI
  );

  logic                      RAccept_S;
  logic                      RSel_SN, RSel_SP;
  logic [AXI_ADDR_WIDTH-1:0] ArAddr_DN, ArAddr_DP;
  logic   [AXI_ID_WIDTH-1:0] RId_DN, RId_DP;
  logic               [31:0] RData_D;

  enum logic [1:0] {IDLE, READ, RESP} State_SN, State_SP;

  assign ArAddr_DN = ArAddr_DI;

  /*
   * Constant outputs
   */
  assign If0_ArAddr_DO = ArAddr_DP;
  assign If1_ArAddr_DO = ArAddr_DP;
  assign RLast_SO      = RValid_SO;
  assign RUser_DO      = 'b0;

  /*
   *  ID reflection logic
   */
  assign RId_DN = ArId_DI;
  assign RId_DO = RId_DP;

  /*
   *  Mailbox interface arbitration based on Bit 12
   *  - Address 0x0000 - 0x0FFF: Port 0
   *  - Address 0x1000 - 0x1FFF: Port 1
   */
  assign RSel_SN = ArAddr_DI[12];

  /*
   *  Data width conversion
   */
  generate
    if (AXI_DATA_WIDTH == 64) begin
      logic RDataSel_SN, RDataSel_SP;

      assign RDataSel_SN = ArAddr_DI[2];

      // register to buffer the relevant address bit
      always_ff @(posedge Clk_CI, negedge Rst_RBI) begin
        if (Rst_RBI == 1'b0) begin
          RDataSel_SP <= 1'b0;
        end else if (RAccept_S == 1'b1) begin
          RDataSel_SP <= RDataSel_SN;
        end
      end

      // byte-lane steering
      always_comb begin
        if (RDataSel_SP == 1'b1) begin
          RData_DO[63:32] = RData_D;
          RData_DO[31:0]  = 32'h00000000;
        end else begin
          RData_DO[63:32] = 32'h00000000;
          RData_DO[31:0]  = RData_D;
        end
      end

    end else begin
      always_comb begin
        RData_DO = RData_D;
      end
    end
  endgenerate

  /*
   *  Transaction acceptance
   *
   *  Registering of ar channel for compatibility with Xilinx Mailbox:
   *
   *  The Xilinx Mailbox seems to latch the ar channel without hand shake (illegal).
   *  This can cause deadlocks if master decides to apply another transaction after
   *  driving valid high but before a hand shake happened (illegal).
   */
  // ar/r channel FSM
  always_comb begin
    // default assignments
    RAccept_S      = 1'b0;
    ArReady_SO     = 1'b0;
    If0_ArValid_SO = 1'b0;
    If1_ArValid_SO = 1'b0;
    RValid_SO      = 1'b0;
    If0_RReady_SO  = 1'b0;
    If1_RReady_SO  = 1'b0;
    RData_D        = If0_RData_DI;
    RResp_DO       = If0_RResp_DI;
    State_SN       = State_SP;

    case (State_SP)

      IDLE: begin
        ArReady_SO   = 1'b1; // prepare hand shake, recommended by AXI protocol specification
        if (ArValid_SI == 1'b1) begin
          RAccept_S  = 1'b1; // store ID, addr, select and byte-lane steering flag
          State_SN   = READ;
          assert (ArLen_SI == 'b0)
            else $error("Multi-beat read transactions are not supported!");
        end
      end   
          
      READ: begin
        If0_ArValid_SO = ~RSel_SP; // the slave must see the valid
        If1_ArValid_SO =  RSel_SP;
        if ( (If0_ArReady_SI & ~RSel_SP) || (If1_ArReady_SI & RSel_SP) ) begin          
          State_SN     = RESP;
        end
      end

      RESP: begin
        RValid_SO = (If0_RValid_SI & ~RSel_SP) | (If1_RValid_SI & RSel_SP);
        if (RReady_SI == 1'b1) begin
          if          (If0_RValid_SI & ~RSel_SP) begin
            If0_RReady_SO = 1'b1;  
            RData_D       = If0_RData_DI;
            RResp_DO      = If0_RResp_DI;
            State_SN      = IDLE;
          end else if (If1_RValid_SI &  RSel_SP) begin
            If1_RReady_SO = 1'b1;
            RData_D       = If1_RData_DI;
            RResp_DO      = If1_RResp_DI;
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
      RSel_SP     <= 1'b0;
      RId_DP      <=  'b0;
      ArAddr_DP   <=  'b0;
    end else if (RAccept_S == 1'b1) begin
      RSel_SP     <= RSel_SN;
      RId_DP      <= RId_DN;
      ArAddr_DP   <= ArAddr_DN;
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
