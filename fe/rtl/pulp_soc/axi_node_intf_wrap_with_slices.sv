// Copyright 2014-2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module axi_node_intf_wrap_with_slices
#(
  parameter NB_MASTER          = 8,
  parameter NB_SLAVE           = 4,
  parameter NB_REGION          = 2,
  parameter AXI_ADDR_WIDTH     = 32,
  parameter AXI_DATA_WIDTH     = 64,
  parameter AXI_ID_IN_WIDTH    = 4,
  parameter AXI_ID_OUT_WIDTH   = AXI_ID_IN_WIDTH + $clog2(NB_SLAVE),
  parameter AXI_USER_WIDTH     = 6,
  parameter MASTER_SLICE_DEPTH = 2,
  parameter SLAVE_SLICE_DEPTH  = 2
)
(
  input logic                                       clk,
  input logic                                       rst_n,
  input logic                                       test_en_i,

  AXI_BUS.Slave                                     slave  [NB_SLAVE-1:0],
  AXI_BUS.Master                                    master [NB_MASTER-1:0],

  input  logic [NB_REGION-1:0][NB_MASTER-1:0][AXI_ADDR_WIDTH-1:0] start_addr_i,
  input  logic [NB_REGION-1:0][NB_MASTER-1:0][AXI_ADDR_WIDTH-1:0] end_addr_i,
  input  logic [NB_REGION-1:0][NB_MASTER-1:0]                     valid_rule_i,
  input  logic [NB_SLAVE-1:0] [NB_MASTER-1:0]                     connectivity_map_i
);

  genvar i;

  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH  ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH  ),
    .AXI_ID_WIDTH   ( AXI_ID_IN_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH  )
  ) int_slave[NB_SLAVE-1:0]();

  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH   ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH   ),
    .AXI_ID_WIDTH   ( AXI_ID_OUT_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH   )
  ) int_master[NB_MASTER-1:0]();

  axi_node_intf_wrap #(
    .NB_MASTER        ( NB_MASTER        ),
    .NB_SLAVE         ( NB_SLAVE         ),
    .NB_REGION        ( NB_REGION        ),
    .AXI_ADDR_WIDTH   ( AXI_ADDR_WIDTH   ),
    .AXI_DATA_WIDTH   ( AXI_DATA_WIDTH   ),
    .AXI_USER_WIDTH   ( AXI_USER_WIDTH   ),
    .AXI_ID_IN_WIDTH  ( AXI_ID_IN_WIDTH  ),
    .AXI_ID_OUT_WIDTH ( AXI_ID_OUT_WIDTH )
  ) i_axi_node_intf_wrap (
    .clk                ( clk                ),
    .rst_n              ( rst_n              ),
    .test_en_i          ( test_en_i          ),

    .slave              ( int_slave          ),
    .master             ( int_master         ),

    .start_addr_i       ( start_addr_i       ),
    .end_addr_i         ( end_addr_i         ),
    .valid_rule_i       ( valid_rule_i       ),
    .connectivity_map_i ( connectivity_map_i )
  );

  generate
    for( i=0; i<NB_MASTER; i++ ) begin : AXI_SLICE_MASTER_PORT
      axi_slice_wrap #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH     ),
        .AXI_DATA_WIDTH ( AXI_DATA_WIDTH     ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH     ),
        .AXI_ID_WIDTH   ( AXI_ID_OUT_WIDTH   ),
        .SLICE_DEPTH    ( MASTER_SLICE_DEPTH )
      ) i_axi_slice_wrap_master (
        .clk_i      ( clk           ),
        .rst_ni     ( rst_n         ),
        .test_en_i  ( test_en_i     ),

        .axi_slave  ( int_master[i] ), // from the node
        .axi_master ( master[i]     )  // to IO ports
      );
    end

    for( i=0; i<NB_SLAVE; i++ ) begin : AXI_SLICE_SLAVE_PORT
      axi_slice_wrap #(
        .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH    ),
        .AXI_DATA_WIDTH ( AXI_DATA_WIDTH    ),
        .AXI_USER_WIDTH ( AXI_USER_WIDTH    ),
        .AXI_ID_WIDTH   ( AXI_ID_IN_WIDTH   ),
        .SLICE_DEPTH    ( SLAVE_SLICE_DEPTH )
      ) i_axi_slice_wrap_slave (
        .clk_i      ( clk          ),
        .rst_ni     ( rst_n        ),
        .test_en_i  ( test_en_i    ),

        .axi_slave  ( slave[i]     ), // from IO_ports
        .axi_master ( int_slave[i] )  // to axi_node
      );
    end
  endgenerate

endmodule
