// Copyright 2014-2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "soc_bus_defines.sv"

`ifdef JUNO
  `define USE_AXI_NODE_WITH_SLICES
`endif

module soc_bus_wrap
#(
  parameter AXI_ADDR_WIDTH   = 32,
  parameter AXI_DATA_WIDTH   = 32,
  parameter AXI_ID_IN_WIDTH  = 7,
  parameter AXI_ID_OUT_WIDTH = 10,
  parameter AXI_USER_WIDTH   = 6,
  parameter NB_CLUSTERS      = 4
)
(
  input logic       clk_i,
  input logic       rst_ni,
  input logic       test_en_i,

  AXI_BUS.Slave     cluster_data_slave[NB_CLUSTERS],
  AXI_BUS.Master    cluster_data_master[NB_CLUSTERS],
  AXI_BUS.Slave     soc_rab_slave,
  AXI_BUS.Master    soc_rab_master,
  AXI_BUS.Master    soc_rab_cfg_master,
  AXI_BUS.Master    mailbox_master,
`ifdef JUNO
  AXI_BUS.Master    soc_stdout_master,
`endif    
  AXI_BUS.Master    soc_l2_master,
  AXI_BUS.Master    soc_apb_master
);

  localparam NB_MASTER      = `NB_MASTER;
  localparam NB_SLAVE       = `NB_SLAVE;
  localparam NB_REGION      = `NB_REGION;
  int unsigned j;

  logic [NB_REGION-1:0][NB_MASTER-1:0][AXI_ADDR_WIDTH-1:0] s_start_addr;
  logic [NB_REGION-1:0][NB_MASTER-1:0][AXI_ADDR_WIDTH-1:0] s_end_addr;
  logic [NB_REGION-1:0][NB_MASTER-1:0]                     s_valid_rule;
  logic [ NB_SLAVE-1:0][NB_MASTER-1:0]                     s_connectivity_map;

  AXI_BUS #(
    .AXI_ADDR_WIDTH  ( AXI_ADDR_WIDTH   ),
    .AXI_DATA_WIDTH  ( AXI_DATA_WIDTH   ),
    .AXI_ID_WIDTH    ( AXI_ID_OUT_WIDTH ),
    .AXI_USER_WIDTH  ( AXI_USER_WIDTH   )
  ) masters[NB_MASTER-1:0]();

  AXI_BUS #(
    .AXI_ADDR_WIDTH  ( AXI_ADDR_WIDTH   ),
    .AXI_DATA_WIDTH  ( AXI_DATA_WIDTH   ),
    .AXI_ID_WIDTH    ( AXI_ID_IN_WIDTH  ),
    .AXI_USER_WIDTH  ( AXI_USER_WIDTH   )
  ) slaves[NB_SLAVE-1:0]();

  genvar i;

  generate
    for(i=0;i<NB_CLUSTERS;i++)
      begin : SLAVE_CLUSTER_BIND
        `AXI_ASSIGN_SLAVE(slaves[i], cluster_data_slave[i]);
      end

    `AXI_ASSIGN_SLAVE(slaves[NB_CLUSTERS], soc_rab_slave);

    for(i=0;i<NB_CLUSTERS;i++)
      begin : MASTER_CLUSTER_BIND
        `AXI_ASSIGN_MASTER(masters[i], cluster_data_master[i]);
        assign s_start_addr[0][i] = `CLUSTER_DATA_START_ADDR + 32'h0040_0000*i;
        assign s_end_addr[0][i]   = `CLUSTER_DATA_END_ADDR   + 32'h0040_0000*i;
      end

    `AXI_ASSIGN_MASTER(masters[NB_CLUSTERS], soc_l2_master);
    assign s_start_addr[0][NB_CLUSTERS] = `SOC_L2_START_ADDR;
    assign s_end_addr[0][NB_CLUSTERS]   = `SOC_L2_END_ADDR;

    `AXI_ASSIGN_MASTER(masters[NB_CLUSTERS+1], soc_rab_master);
    assign s_start_addr [0][NB_CLUSTERS+1]  = `SOC_RAB_START_ADDR;
    assign s_end_addr   [0][NB_CLUSTERS+1]  = `SOC_RAB_END_ADDR;
    assign s_start_addr [1][NB_CLUSTERS+1]  = `SOC_RAB_HIGH_START_ADDR;
    assign s_end_addr   [1][NB_CLUSTERS+1]  = `SOC_RAB_HIGH_END_ADDR;

    `AXI_ASSIGN_MASTER(masters[NB_CLUSTERS+2], mailbox_master);
    assign s_start_addr[0][NB_CLUSTERS+2] = `MAILBOX_START_ADDR;
    assign s_end_addr[0][NB_CLUSTERS+2]   = `MAILBOX_END_ADDR;

    `AXI_ASSIGN_MASTER(masters[NB_CLUSTERS+3], soc_apb_master);
    assign s_start_addr[0][NB_CLUSTERS+3] = `SOC_APB_START_ADDR;
    assign s_end_addr[0][NB_CLUSTERS+3]   = `SOC_APB_END_ADDR;

    `AXI_ASSIGN_MASTER(masters[NB_CLUSTERS+4], soc_rab_cfg_master);
    assign s_start_addr[0][NB_CLUSTERS+4] = `SOC_RAB_CFG_START_ADDR;
    assign s_end_addr  [0][NB_CLUSTERS+4] = `SOC_RAB_CFG_END_ADDR;

`ifdef JUNO
    `AXI_ASSIGN_MASTER(masters[NB_CLUSTERS+5], soc_stdout_master);
    assign s_start_addr[0][NB_CLUSTERS+5] = `SOC_STDOUT_START_ADDR;
    assign s_end_addr[0][NB_CLUSTERS+5]   = `SOC_STDOUT_END_ADDR;
`endif

    assign s_connectivity_map = {NB_MASTER*NB_SLAVE{1'b1}};

    always_comb
      begin
        s_valid_rule = '0;
        // REGION 0
        for(j=0;j<NB_CLUSTERS;j++)
          begin
            s_valid_rule[0][j] = 1;
          end
        s_valid_rule[0][NB_CLUSTERS]   = 1;
        s_valid_rule[0][NB_CLUSTERS+1] = 1;
        s_valid_rule[0][NB_CLUSTERS+2] = 1;
        s_valid_rule[0][NB_CLUSTERS+3] = 1;
        s_valid_rule[0][NB_CLUSTERS+4] = 1;
`ifdef JUNO
        s_valid_rule[0][NB_CLUSTERS+5] = 1;
`endif    
        // REGION 1
        s_valid_rule[1][NB_CLUSTERS+1] = 1;
      end

  endgenerate

  //********************************************************
  //**************** SOC BUS *******************************
  //********************************************************

`ifndef USE_AXI_NODE_WITH_SLICES  
  axi_node_intf_wrap #(
    .NB_MASTER        ( NB_MASTER         ),
    .NB_SLAVE         ( NB_SLAVE          ),
    .NB_REGION        ( NB_REGION         ),
    .AXI_ADDR_WIDTH   ( AXI_ADDR_WIDTH    ),
    .AXI_DATA_WIDTH   ( AXI_DATA_WIDTH    ),
    .AXI_ID_IN_WIDTH  ( AXI_ID_IN_WIDTH   ),
    .AXI_ID_OUT_WIDTH ( AXI_ID_OUT_WIDTH  ),
    .AXI_USER_WIDTH   ( AXI_USER_WIDTH    )
  ) axi_interconnect_i (
    .clk                ( clk_i              ),
    .rst_n              ( rst_ni             ),
    .test_en_i          ( test_en_i          ),

    .slave              ( slaves             ),
    .master             ( masters            ),

    .start_addr_i       ( s_start_addr       ),
    .end_addr_i         ( s_end_addr         ),
    .valid_rule_i       ( s_valid_rule       ),
    .connectivity_map_i ( s_connectivity_map )
  );
`else
  axi_node_intf_wrap_with_slices #(
    .NB_MASTER          ( NB_MASTER        ),
    .NB_SLAVE           ( NB_SLAVE         ),
    .NB_REGION          ( NB_REGION        ),
    .AXI_ADDR_WIDTH     ( AXI_ADDR_WIDTH   ),
    .AXI_DATA_WIDTH     ( AXI_DATA_WIDTH   ),
    .AXI_ID_IN_WIDTH    ( AXI_ID_IN_WIDTH  ),
    .AXI_ID_OUT_WIDTH   ( AXI_ID_OUT_WIDTH ),
    .AXI_USER_WIDTH     ( AXI_USER_WIDTH   ),
    .MASTER_SLICE_DEPTH ( 2                ),
    .SLAVE_SLICE_DEPTH  ( 2                )
  ) axi_interconnect_i (
    .clk                ( clk_i              ),
    .rst_n              ( rst_ni             ),
    .test_en_i          ( test_en_i          ),

    .slave              ( slaves             ),
    .master             ( masters            ),

    .start_addr_i       ( s_start_addr       ),
    .end_addr_i         ( s_end_addr         ),
    .valid_rule_i       ( s_valid_rule       ),
    .connectivity_map_i ( s_connectivity_map )
  );
`endif

endmodule

// vim: ts=2 sw=2 sts=2 et nosmartindent autoindent foldmethod=marker
