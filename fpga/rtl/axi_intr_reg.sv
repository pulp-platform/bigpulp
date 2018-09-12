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
//  █████╗ ██╗  ██╗██╗    ██╗███╗   ██╗████████╗██████╗     ██████╗ ███████╗ ██████╗ 
// ██╔══██╗╚██╗██╔╝██║    ██║████╗  ██║╚══██╔══╝██╔══██╗    ██╔══██╗██╔════╝██╔════╝ 
// ███████║ ╚███╔╝ ██║    ██║██╔██╗ ██║   ██║   ██████╔╝    ██████╔╝█████╗  ██║  ███╗
// ██╔══██║ ██╔██╗ ██║    ██║██║╚██╗██║   ██║   ██╔══██╗    ██╔══██╗██╔══╝  ██║   ██║
// ██║  ██║██╔╝ ██╗██║    ██║██║ ╚████║   ██║   ██║  ██║    ██║  ██║███████╗╚██████╔╝
// ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝    ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝ ╚═════╝ 
//
// 
// Author: Pirmin Vogel - vogelpi@iis.ee.ethz.ch
// 
// Purpose : AXI4-Lite interrupt register with clear on read
//           Writes are completely ignored!
//
//           The interrupt remains high until cleared.
//
//           Edge detection on input interrupts.
// 
// --=========================================================================--

module axi_intr_reg
  #(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64
   )
  (
    input  logic                      Clk_CI,
    input  logic                      Rst_RBI,
    
    AXI_LITE.Slave                    axi4lite,

    input  logic [AXI_DATA_WIDTH-1:0] IntrPulp_SI,
    output logic                      IntrHost_SO
  );

  //  █████╗ ██╗  ██╗██╗██╗  ██╗      ██╗     ██╗████████╗███████╗
  // ██╔══██╗╚██╗██╔╝██║██║  ██║      ██║     ██║╚══██╔══╝██╔════╝
  // ███████║ ╚███╔╝ ██║███████║█████╗██║     ██║   ██║   █████╗  
  // ██╔══██║ ██╔██╗ ██║╚════██║╚════╝██║     ██║   ██║   ██╔══╝  
  // ██║  ██║██╔╝ ██╗██║     ██║      ███████╗██║   ██║   ███████╗
  // ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝      ╚══════╝╚═╝   ╚═╝   ╚══════╝
  //    
  logic [AXI_ADDR_WIDTH-1:0]         awaddr_reg;
  logic                              awaddr_done_rise;
  logic                              awaddr_done_reg;
  logic                              awaddr_done_reg_dly;

  logic [AXI_DATA_WIDTH-1:0]         wdata_reg;
  logic [AXI_ADDR_WIDTH/8-1:0]       wstrb_reg;
  logic                              wdata_done_rise;
  logic                              wdata_done_reg;
  logic                              wdata_done_reg_dly;

  logic                              bresp_done_reg;
  logic                              bresp_running_reg;

  logic [AXI_ADDR_WIDTH-1:0]         araddr_reg;
  logic                              araddr_done_reg;

  logic [AXI_DATA_WIDTH-1:0]         rdata_reg;
  logic                              rresp_done_reg;
  logic                              rresp_running_reg;

  logic                              write_en;

  assign write_en         = ( wdata_done_rise & awaddr_done_reg ) | ( awaddr_done_rise & wdata_done_reg );
  assign wdata_done_rise  = wdata_done_reg  & ~wdata_done_reg_dly;
  assign awaddr_done_rise = awaddr_done_reg & ~awaddr_done_reg_dly;

  assign rdata_reg = '0; // not used
   
  // reg_dly
  always @(posedge Clk_CI or negedge Rst_RBI)
    begin
      if ( Rst_RBI == 1'b0 )
        begin
          wdata_done_reg_dly  <= 1'b0;
          awaddr_done_reg_dly <= 1'b0;
        end
      else
        begin
          wdata_done_reg_dly  <= wdata_done_reg;
          awaddr_done_reg_dly <= awaddr_done_reg;
        end
    end

  // AW Channel
  always @(posedge Clk_CI or negedge Rst_RBI)
    begin
      if ( Rst_RBI == 1'b0 )
        begin
          awaddr_done_reg   <= 1'b0;
          awaddr_reg        <= '0;
          axi4lite.aw_ready <= 1'b1;
        end
      else
        begin
          if (axi4lite.aw_ready && axi4lite.aw_valid)
            begin
              axi4lite.aw_ready <= 1'b0;
              awaddr_done_reg   <= 1'b1;
              awaddr_reg        <= axi4lite.aw_addr;
            end
          else if (awaddr_done_reg && bresp_done_reg)
            begin
              axi4lite.aw_ready <= 1'b1;
              awaddr_done_reg   <= 1'b0;
            end
        end
    end

  // W Channel
  always @(posedge Clk_CI or negedge Rst_RBI)
    begin
      if ( Rst_RBI == 1'b0 )
        begin
          wdata_done_reg   <= 1'b0;
          axi4lite.w_ready <= 1'b1;
          wdata_reg        <= '0;
          wstrb_reg        <= '0;
        end
      else
        begin
          if (axi4lite.w_ready && axi4lite.w_valid)
            begin
              axi4lite.w_ready <= 1'b0;
              wdata_done_reg   <= 1'b1;
              wdata_reg        <= axi4lite.w_data;
              wstrb_reg        <= axi4lite.w_strb;
            end
          else if (wdata_done_reg && bresp_done_reg)
            begin
              axi4lite.w_ready <= 1'b1;
              wdata_done_reg   <= 1'b0;
            end
        end
    end

  // B Channel
  always @(posedge Clk_CI or negedge Rst_RBI)
    begin
      if ( Rst_RBI == 1'b0 )
        begin
          axi4lite.b_valid  <= 1'b0;
          bresp_done_reg    <= 1'b0;
          bresp_running_reg <= 1'b0;
        end
      else
        begin
          if (awaddr_done_reg && wdata_done_reg && !bresp_done_reg)
            begin
              if ( bresp_running_reg == 1'b0 )
                begin
                  axi4lite.b_valid  <= 1'b1;
                  bresp_running_reg <= 1'b1;
                end
              else if ( axi4lite.b_ready == 1'b1 )
                begin
                  axi4lite.b_valid  <= 1'b0;
                  bresp_done_reg    <= 1'b1;
                  bresp_running_reg <= 1'b0;
                end
            end
          else
            begin
               axi4lite.b_valid  <= 1'b0;
               bresp_done_reg    <= 1'b0;
               bresp_running_reg <= 1'b0;
            end
        end
    end

  // AR Channel
  always @(posedge Clk_CI or negedge Rst_RBI)
    begin
      if ( Rst_RBI == 1'b0 )
        begin
          araddr_done_reg   <= 1'b0;
          axi4lite.ar_ready <= 1'b1;
          araddr_reg        <= '0;
        end
      else
        begin
          if (axi4lite.ar_ready && axi4lite.ar_valid)
            begin
              axi4lite.ar_ready <= 1'b0;
              araddr_done_reg   <= 1'b1;
              araddr_reg        <= axi4lite.ar_addr;
            end
          else if (araddr_done_reg && rresp_done_reg)
            begin
              axi4lite.ar_ready <= 1'b1;
              araddr_done_reg   <= 1'b0;
            end
        end
    end

  // R Channel
  always @(posedge Clk_CI or negedge Rst_RBI)
    begin
      if ( Rst_RBI == 1'b0 )
        begin
          rresp_done_reg    <= 1'b0;
          axi4lite.r_valid  <= 1'b0;
          rresp_running_reg <= 1'b0;
        end
      else
        begin
          if (araddr_done_reg && !rresp_done_reg)
            begin
              if ( rresp_running_reg == 1'b0 )
                begin
                  axi4lite.r_valid  <= 1'b1;
                  rresp_running_reg <= 1'b1;
                end
              else if (axi4lite.r_ready == 1'b1)
                begin
                  axi4lite.r_valid  <= 1'b0;
                  rresp_done_reg    <= 1'b1;
                  rresp_running_reg <= 1'b0;
                end
            end
          else
            begin
              axi4lite.r_valid  <= 1'b0;
              rresp_done_reg    <= 1'b0;
              rresp_running_reg <= 1'b0;
            end
        end
    end
   
  assign axi4lite.b_resp = 2'b00;
  assign axi4lite.r_resp = 2'b00;

  // ██╗███╗   ██╗████████╗██████╗     ██████╗ ███████╗ ██████╗ 
  // ██║████╗  ██║╚══██╔══╝██╔══██╗    ██╔══██╗██╔════╝██╔════╝ 
  // ██║██╔██╗ ██║   ██║   ██████╔╝    ██████╔╝█████╗  ██║  ███╗
  // ██║██║╚██╗██║   ██║   ██╔══██╗    ██╔══██╗██╔══╝  ██║   ██║
  // ██║██║ ╚████║   ██║   ██║  ██║    ██║  ██║███████╗╚██████╔╝
  // ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝ ╚═════╝ 
  //                                                              
  logic [AXI_DATA_WIDTH-1:0]         Intr_SP, Intr_SN;
  logic [AXI_DATA_WIDTH-1:0]         IntrPulp_SN, IntrPulp_SP;
  logic [AXI_DATA_WIDTH-1:0]         IntrEdge_S;
  logic                              IntrHost_SP, IntrHost_SN;

  logic                              IntrEn_S, IntrClr_S;

  // input
  assign IntrPulp_SN = IntrPulp_SI;

  // output
  assign IntrHost_SO = IntrHost_SP;

  // edge detection
  assign IntrEdge_S = (~IntrPulp_SP) & IntrPulp_SN;

  // enable
  assign IntrEn_S = |IntrEdge_S;

  // interrupt
  assign IntrHost_SN     = 1'b1;    // only latched upon IntrEn_S
  assign Intr_SN         = Intr_SP | IntrPulp_SN;
  assign axi4lite.r_data = Intr_SN; // don't miss interrupts arriving in the read cycle
  
  // clear on read
  assign IntrClr_S = axi4lite.r_valid & axi4lite.r_ready;

  // the registers
  always_ff @(posedge Clk_CI, negedge Rst_RBI)
    begin
      if ( Rst_RBI == 1'b0 )
        begin
          Intr_SP     <=  'b0;
          IntrHost_SP <= 1'b0;
          IntrPulp_SP <=  'b0;
        end
      else
        begin
          IntrPulp_SP <= IntrPulp_SN; 
          if      ( IntrClr_S == 1'b1 )
            begin
              Intr_SP     <=  'b0;
              IntrHost_SP <= 1'b0;
            end
          else if ( IntrEn_S  == 1'b1 )
            begin
              Intr_SP     <= Intr_SN;
              IntrHost_SP <= IntrHost_SN;
            end
        end
    end

endmodule
