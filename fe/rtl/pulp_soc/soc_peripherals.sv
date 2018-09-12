// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "pulp_soc_defines.sv"

module soc_peripherals_multicluster
#(
  parameter AXI_ADDR_WIDTH = 32,
  parameter AXI_DATA_WIDTH = 64,
  parameter AXI_USER_WIDTH = 6,
  parameter AXI_ID_WIDTH   = 6,
 
  parameter NB_CORES       = 4,
  parameter NB_CLUSTERS    = 1
)
(
  input logic   clk_i,
  input logic   rst_ni,

  input logic   test_mode_i,

  input  logic  uart_rx_i,
  output logic  uart_tx_o,
  output logic  uart_rts_no,  
  output logic  uart_dtr_no,
  input  logic  uart_cts_ni,  
  input  logic  uart_dsr_ni,

  // SLAVE PORTS
  AXI_BUS.Slave axi_slave
);

  localparam APB_NUM_SLAVES = 4;
  localparam APB_ADDR_WIDTH = 12;

  logic                             s_penable;
  logic                             s_pwrite;
  logic        [APB_ADDR_WIDTH-1:0] s_paddr;
  logic        [APB_NUM_SLAVES-1:0] s_psel;
  logic                      [31:0] s_pwdata;
  logic [APB_NUM_SLAVES-1:0] [31:0] s_prdata;
  logic        [APB_NUM_SLAVES-1:0] s_pready;
  logic        [APB_NUM_SLAVES-1:0] s_pslverr;

  logic                             uart_rts;
  logic                             uart_cts;
  logic                             uart_dtr;
  logic                             uart_dsr;

  axi2apb_wrap #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH ),
    .AXI_ID_WIDTH   ( AXI_ID_WIDTH   ),
    .APB_ADDR_WIDTH ( APB_ADDR_WIDTH ),
    .APB_NUM_SLAVES ( APB_NUM_SLAVES )
  ) axi2apb_i (
    .clk_i     ( clk_i       ),
    .rst_ni    ( rst_ni      ),
    .test_en_i ( test_mode_i ),

    .axi_slave ( axi_slave   ),

    .penable   ( s_penable   ),
    .pwrite    ( s_pwrite    ),
    .paddr     ( s_paddr     ),
    .psel      ( s_psel      ),
    .pwdata    ( s_pwdata    ),
    .prdata    ( s_prdata    ),
    .pready    ( s_pready    ),
    .pslverr   ( s_pslverr   )
  );

  assign s_prdata[0] = '0;
  assign s_prdata[1] = '0;

  assign s_pready[0] = '0;
  assign s_pready[1] = '0;

  assign s_pslverr[0] = '0;
  assign s_pslverr[1] = '0;

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 2: APB UART interface                            ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////
  apb_uart i_apb_uart (
    .CLK     ( clk_i        ),
    .RSTN    ( rst_ni       ),

    .PSEL    ( s_psel[2]    ),  // APB psel signal   
    .PENABLE ( s_penable    ),  // APB penable signal
    .PWRITE  ( s_pwrite     ),  // APB pwrite signal
    .PADDR   ( s_paddr[4:2] ),  // APB paddr signal
    .PWDATA  ( s_pwdata     ),  // APB pwdata signal
    .PRDATA  ( s_prdata[2]  ),  // APB prdata signal
    .PREADY  ( s_pready[2]  ),  // APB pready signal
    .PSLVERR ( s_pslverr[2] ),  // APB pslverr signal

    .INT     (              ),  // Interrupt output

    .OUT1N   (              ),  // Output 1
    .OUT2N   (              ),  // Output 2
    .RTSN    ( uart_rts_no  ),  // RTS output
    .DTRN    ( uart_dtr_no  ),  // DTR output
    .CTSN    ( uart_cts_ni  ),  // CTS input
    .DSRN    ( uart_dsr_ni  ),  // DSR input
    .DCDN    ( uart_dsr_ni  ),  // DCD input = DSR for null-modem wiring
    .RIN     ( 1'b1         ),  // RI input
    .SIN     ( uart_rx_i    ),  // Receiver input
    .SOUT    ( uart_tx_o    )   // Transmitter output
  );

  //////////////////////////////////////////////////////////////////
  ///                                                            ///
  /// APB Slave 3: APB SOC configuration                         ///
  ///                                                            ///
  //////////////////////////////////////////////////////////////////
  apb_soc_ctrl_multicluster #(
    .NB_CORES    ( NB_CORES    ),
    .NB_CLUSTERS ( NB_CLUSTERS )
  ) apb_soc_registers_i (
    .HCLK                 ( clk_i                ),
    .HRESETn              ( rst_ni               ),

    .PADDR                ( s_paddr              ),
    .PWDATA               ( s_pwdata             ),
    .PWRITE               ( s_pwrite             ),
    .PSEL                 ( s_psel[3]            ),
    .PENABLE              ( s_penable            ),
    .PRDATA               ( s_prdata[3]          ),
    .PREADY               ( s_pready[3]          ),
    .PSLVERR              ( s_pslverr[3]         )
  );

endmodule
