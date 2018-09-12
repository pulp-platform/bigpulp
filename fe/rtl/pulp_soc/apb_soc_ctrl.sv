// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`define REG_PADFUN0     6'b000000 //BASEADDR+0x00
//`define REG_PADFUN1     6'b000001 //BASEADDR+0x04
`define REG_CLKDIV0     6'b000010 //BASEADDR+0x08
`define REG_CLKDIV1     6'b000011 //BASEADDR+0x0C
`define REG_INFO        6'b000100 //BASEADDR+0x10
`define REG_INFOEXTD    6'b000101 //BASEADDR+0x14
`define REG_MMARGIN     6'b000110 //BASEADDR+0x18
`define REG_PADCFG0     6'b000111 //BASEADDR+0x1C
`define REG_PADCFG1     6'b001000 //BASEADDR+0x20
`define REG_PADCFG2     6'b001001 //BASEADDR+0x24
`define REG_PADCFG3     6'b001010 //BASEADDR+0x28
`define REG_PADCFG4     6'b001011 //BASEADDR+0x2C
`define REG_PADCFG5     6'b001100 //BASEADDR+0x30
`define REG_PADCFG6     6'b001101 //BASEADDR+0x34
`define REG_PADCFG7     6'b001110 //BASEADDR+0x38
//`define REG_PADCFG8     6'b001111 //BASEADDR+0x3C
`define REG_PWRCMD      6'b010000 //BASEADDR+0x40
`define REG_PWRCFG      6'b010001 //BASEADDR+0x44
`define REG_PWRREG      6'b010010 //BASEADDR+0x48
`define REG_CLKDIV2     6'b010011 //BASEADDR+0x4C
`define REG_CLKDIV3     6'b010100 //BASEADDR+0x50
`define REG_HS_LS_L2    6'b010101 //BASEADDR+0x54
`define REG_L2_SLEEP    6'b010110 //BASEADDR+0x58
`define REG_CLKDIV4     6'b010111 //BASEADDR+0x5C

`define REG_RES_CORE0   6'b100000 //BASEADDR+0x80
`define REG_RES_CORE1   6'b100001 //BASEADDR+0x84
`define REG_RES_CORE2   6'b100010 //BASEADDR+0x88
`define REG_RES_CORE3   6'b100011 //BASEADDR+0x8C

module apb_soc_ctrl_multicluster
#(
  parameter APB_ADDR_WIDTH = 12,   //APB slaves are 4KB by default
  parameter NB_CLUSTERS     = 1,   //N_CLUSTERS
  parameter NB_CORES        = 4    //N_CORES
)
(
  input  logic                      HCLK,
  input  logic                      HRESETn,
  input  logic [APB_ADDR_WIDTH-1:0] PADDR,
  input  logic               [31:0] PWDATA,
  input  logic                      PWRITE,
  input  logic                      PSEL,
  input  logic                      PENABLE,
  output logic               [31:0] PRDATA,
  output logic                      PREADY,
  output logic                      PSLVERR
);

  logic [7:0]                        r_res_core0;
  logic [7:0]                        r_res_core1;
  logic [7:0]                        r_res_core2;
  logic [7:0]                        r_res_core3;

  logic [5:0]                        s_apb_addr;

  logic [15:0]                       n_cores;
  logic [15:0]                       n_clusters;

  assign s_apb_addr = PADDR[7:2];

  always_ff @ (posedge HCLK, negedge HRESETn) 
    begin
      if(~HRESETn) 
        begin
          r_res_core0          <=  'h0;
          r_res_core1          <=  'h0;
          r_res_core2          <=  'h0;
          r_res_core3          <=  'h0;
        end
      else 
        begin
          if (PSEL && PENABLE && PWRITE)
            begin
              case (s_apb_addr)
                `REG_RES_CORE0:
                  begin
                    r_res_core0      <= PWDATA[7:0];
                  end                    
                `REG_RES_CORE1:
                  begin
                    r_res_core1      <= PWDATA[7:0];
                  end                    
                `REG_RES_CORE2:
                  begin
                    r_res_core2      <= PWDATA[7:0];
                  end                    
                `REG_RES_CORE3:
                  begin
                    r_res_core3      <= PWDATA[7:0];
                  end                    
              endcase
            end
        end
    end

  always_comb
    begin
      case (s_apb_addr)
        `REG_INFO:
          PRDATA = {n_cores,n_clusters};
        `REG_RES_CORE0:
          PRDATA = {24'h0,r_res_core0};
        `REG_RES_CORE1:
          PRDATA = {24'h0,r_res_core1};
        `REG_RES_CORE2:
          PRDATA = {24'h0,r_res_core2};
        `REG_RES_CORE3:
          PRDATA = {24'h0,r_res_core3};
        default:
          PRDATA = 'h0;
      endcase
    end

  assign n_cores    = NB_CORES;
  assign n_clusters = NB_CLUSTERS;

  assign PREADY  = 1'b1;
  assign PSLVERR = 1'b0;

endmodule
