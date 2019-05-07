create_bd_design "ps7"
set design_name ps7

source ../tcl/versions.tcl

# Create interface ports
set clking_axi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 clking_axi ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32}              ] $clking_axi
set_property -dict [ list CONFIG.DATA_WIDTH {32}              ] $clking_axi
set_property -dict [ list CONFIG.PROTOCOL   {AXI4LITE}        ] $clking_axi
set_property              CONFIG.FREQ_HZ    $IC_FREQ_HZ         $clking_axi

set intr_axi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 intr_axi ]
set_property CONFIG.ADDR_WIDTH {32}        $intr_axi
set_property CONFIG.DATA_WIDTH {32}        $intr_axi
set_property CONFIG.FREQ_HZ    $FREQ_HZ    $intr_axi
set_property CONFIG.PROTOCOL   {AXI4LITE}  $intr_axi

set rab_lite [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_lite ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32}              ] $rab_lite
set_property -dict [ list CONFIG.DATA_WIDTH {32}              ] $rab_lite
set_property -dict [ list CONFIG.PROTOCOL   {AXI4LITE}        ] $rab_lite
set_property              CONFIG.FREQ_HZ    $FREQ_HZ            $rab_lite

set rab_master [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_master ]
set_property -dict [ list CONFIG.ADDR_WIDTH            {32}         ] $rab_master
set_property -dict [ list CONFIG.ARUSER_WIDTH          {6}          ] $rab_master
set_property -dict [ list CONFIG.AWUSER_WIDTH          {6}          ] $rab_master
set_property -dict [ list CONFIG.BUSER_WIDTH           {6}          ] $rab_master
set_property -dict [ list CONFIG.DATA_WIDTH            {64}         ] $rab_master
set_property -dict [ list CONFIG.ID_WIDTH              {6}          ] $rab_master
set_property -dict [ list CONFIG.MAX_BURST_LENGTH      {256}        ] $rab_master
set_property -dict [ list CONFIG.NUM_READ_OUTSTANDING  {8}          ] $rab_master
set_property -dict [ list CONFIG.NUM_WRITE_OUTSTANDING {8}          ] $rab_master
set_property -dict [ list CONFIG.PHASE                 {0.000}      ] $rab_master
set_property -dict [ list CONFIG.PROTOCOL              {AXI4}       ] $rab_master
set_property -dict [ list CONFIG.READ_WRITE_MODE       {READ_WRITE} ] $rab_master
set_property -dict [ list CONFIG.RUSER_WIDTH           {6}          ] $rab_master
set_property -dict [ list CONFIG.SUPPORTS_NARROW_BURST {1}          ] $rab_master
set_property -dict [ list CONFIG.WUSER_WIDTH           {6}          ] $rab_master
set_property              CONFIG.FREQ_HZ               $FREQ_HZ       $rab_master

set rab_acp [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_acp ]
set_property -dict [ list CONFIG.ADDR_WIDTH            {32}         ] $rab_acp
set_property -dict [ list CONFIG.ARUSER_WIDTH          {6}          ] $rab_acp
set_property -dict [ list CONFIG.AWUSER_WIDTH          {6}          ] $rab_acp
set_property -dict [ list CONFIG.BUSER_WIDTH           {6}          ] $rab_acp
set_property -dict [ list CONFIG.DATA_WIDTH            {64}         ] $rab_acp
set_property -dict [ list CONFIG.ID_WIDTH              {3}          ] $rab_acp
set_property -dict [ list CONFIG.MAX_BURST_LENGTH      {256}        ] $rab_acp
set_property -dict [ list CONFIG.NUM_READ_OUTSTANDING  {1}          ] $rab_acp
set_property -dict [ list CONFIG.NUM_WRITE_OUTSTANDING {1}          ] $rab_acp
set_property -dict [ list CONFIG.PHASE                 {0.000}      ] $rab_acp
set_property -dict [ list CONFIG.PROTOCOL              {AXI4}       ] $rab_acp
set_property -dict [ list CONFIG.READ_WRITE_MODE       {READ_WRITE} ] $rab_acp
set_property -dict [ list CONFIG.RUSER_WIDTH           {6}          ] $rab_acp
set_property -dict [ list CONFIG.SUPPORTS_NARROW_BURST {1}          ] $rab_acp
set_property -dict [ list CONFIG.WUSER_WIDTH           {6}          ] $rab_acp
set_property              CONFIG.FREQ_HZ               $FREQ_HZ       $rab_acp

set rab_slave [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_slave ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32}              ] $rab_slave
set_property -dict [ list CONFIG.DATA_WIDTH {64}              ] $rab_slave
set_property -dict [ list CONFIG.PROTOCOL {AXI4}              ] $rab_slave

set UART_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_0 ]

if { $::env(RAB_AX_LOG_EN) } {
    set rab_ar_bram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:bram_rtl:1.0 rab_ar_bram ]
    set_property -dict [ list CONFIG.MASTER_TYPE {BRAM_CTRL}  ] $rab_ar_bram

    set rab_aw_bram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:bram_rtl:1.0 rab_aw_bram ]
    set_property -dict [ list CONFIG.MASTER_TYPE {BRAM_CTRL}  ] $rab_aw_bram
}

# Create ports
set pulp2host_intr [ create_bd_port -dir I pulp2host_intr ]

set host2pulp_gpio [ create_bd_port -dir O -from 31 -to 0 host2pulp_gpio ]
set pulp2host_gpio [ create_bd_port -dir I -from 31 -to 0 pulp2host_gpio ]

set ClkIcHost_CO   [ create_bd_port -dir O -type clk ClkIcHost_CO  ]
set RstIcHost_RBI  [ create_bd_port -dir I -type rst RstIcHost_RBI ]
set RstIcHost_RBO  [ create_bd_port -dir O -type rst RstIcHost_RBO ]
set RstPulp_RBO    [ create_bd_port -dir O -type rst RstPulp_RBO   ]

set ClkIcPulp_CI   [ create_bd_port -dir I -type clk ClkIcPulp_CI  ]
set RstIcPulp_RBI  [ create_bd_port -dir I -type rst RstIcPulp_RBI ]

set ClkIcPulpGated_CI  [ create_bd_port -dir I -type clk ClkIcPulpGated_CI  ]
set RstIcPulpGated_RBI [ create_bd_port -dir I -type rst RstIcPulpGated_RBI ]

set_property -dict [ list CONFIG.ASSOCIATED_BUSIF {rab_lite:rab_slave} ] $ClkIcPulp_CI
set_property -dict [ list CONFIG.ASSOCIATED_BUSIF {rab_master:rab_acp} ] $ClkIcPulpGated_CI
set_property -dict [ list CONFIG.ASSOCIATED_RESET {RstIcPulp_RBI}      ] $ClkIcPulp_CI
set_property -dict [ list CONFIG.ASSOCIATED_RESET {RstIcPulpGated_RBI} ] $ClkIcPulpGated_CI
set_property -dict [ list CONFIG.ASSOCIATED_RESET {RstIcHost_RBI}      ] $ClkIcHost_CO

# Create instance: axi_clock_converter_0, and set properties
set axi_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_0 ]
set_property -dict [ list CONFIG.ACLK_ASYNC {1}  ] $axi_clock_converter_0

# Create instance: axi_clock_converter_1, and set properties
set axi_clock_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_1 ]
set_property -dict [ list CONFIG.ACLK_ASYNC {1}  ] $axi_clock_converter_1

# Create instance: axi_clock_converter_acp, and set properties
set axi_clock_converter_acp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_acp ]
set_property -dict [ list CONFIG.ACLK_ASYNC {1}  ] $axi_clock_converter_acp

# Create instance: axi_crossbar_0, and set properties
set axi_crossbar_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_0 ]
set_property -dict [ list CONFIG.DATA_WIDTH {32}          ] $axi_crossbar_0
if  { $::env(RAB_AX_LOG_EN) } {
  set_property -dict [ list CONFIG.NUM_MI {5}             ] $axi_crossbar_0
} else {
  set_property -dict [ list CONFIG.NUM_MI {3}             ] $axi_crossbar_0
}
set_property -dict [ list CONFIG.S01_BASE_ID {0x00001000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S02_BASE_ID {0x00002000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S03_BASE_ID {0x00003000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S04_BASE_ID {0x00004000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S05_BASE_ID {0x00005000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S06_BASE_ID {0x00006000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S07_BASE_ID {0x00007000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S08_BASE_ID {0x00008000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S09_BASE_ID {0x00009000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S10_BASE_ID {0x0000a000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S11_BASE_ID {0x0000b000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S12_BASE_ID {0x0000c000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S13_BASE_ID {0x0000d000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S14_BASE_ID {0x0000e000} ] $axi_crossbar_0
set_property -dict [ list CONFIG.S15_BASE_ID {0x0000f000} ] $axi_crossbar_0
if { $BOARD == "zedboard" } {
  set_property -dict [ list CONFIG.STRATEGY {1}             ] $axi_crossbar_0
  set_property -dict [ list CONFIG.CONNECTIVITY_MODE {SASD} ] $axi_crossbar_0
} else {
  set_property -dict [ list CONFIG.STRATEGY {2}             ] $axi_crossbar_0
}

# Create instance: axi_crossbar_1, and set properties
set axi_crossbar_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_1 ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32}          ] $axi_crossbar_1
set_property -dict [ list CONFIG.CONNECTIVITY_MODE {SASD} ] $axi_crossbar_1
set_property -dict [ list CONFIG.NUM_MI {3}               ] $axi_crossbar_1
set_property -dict [ list CONFIG.PROTOCOL {AXI4LITE}      ] $axi_crossbar_1
set_property -dict [ list CONFIG.R_REGISTER {1}           ] $axi_crossbar_1
set_property -dict [ list CONFIG.S00_SINGLE_THREAD {1}    ] $axi_crossbar_1
if { $BOARD == "zedboard" } {
  set_property -dict [ list CONFIG.STRATEGY {1}           ] $axi_crossbar_1
  set_property -dict [ list CONFIG.R_REGISTER {0}         ] $axi_crossbar_1
}

# Create instance: axi_dwidth_converter_0, and set properties
set axi_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_converter_0 ]
set_property -dict [ list CONFIG.FIFO_MODE {2}      ] $axi_dwidth_converter_0
set_property -dict [ list CONFIG.MI_DATA_WIDTH {64} ] $axi_dwidth_converter_0
set_property -dict [ list CONFIG.SI_DATA_WIDTH {32} ] $axi_dwidth_converter_0
set_property -dict [ list CONFIG.ACLK_ASYNC {1}     ] $axi_dwidth_converter_0

# Create instance: axi_protocol_converter_0, and set properties
set axi_protocol_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_0 ]
set_property -dict [ list CONFIG.SI_PROTOCOL {AXI3} ] $axi_protocol_converter_0
set_property -dict [ list CONFIG.MI_PROTOCOL {AXI4} ] $axi_protocol_converter_0

# Create instance: axi_protocol_converter_1, and set properties
set axi_protocol_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_1 ]
set_property -dict [ list CONFIG.MI_PROTOCOL {AXI4LITE} ] $axi_protocol_converter_1
set_property -dict [ list CONFIG.SI_PROTOCOL {AXI4}     ] $axi_protocol_converter_1
if { $BOARD == "zedboard" } {
  set_property -dict [ list CONFIG.TRANSLATION_MODE {0} ] $axi_protocol_converter_1
} else {
  set_property -dict [ list CONFIG.TRANSLATION_MODE {2} ] $axi_protocol_converter_1
}

# Create instance: axi_protocol_converter_2, and set properties
set axi_protocol_converter_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_2 ]
set_property -dict [ list CONFIG.MI_PROTOCOL {AXI4LITE} ] $axi_protocol_converter_2
set_property -dict [ list CONFIG.SI_PROTOCOL {AXI4}     ] $axi_protocol_converter_2
if { $BOARD == "zedboard" } {
  set_property -dict [ list CONFIG.TRANSLATION_MODE {0} ] $axi_protocol_converter_2
} else {
  set_property -dict [ list CONFIG.TRANSLATION_MODE {2} ] $axi_protocol_converter_2
}


# Create instance: axi_protocol_converter_3, and set properties
set axi_protocol_converter_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_3 ]
if { $BOARD == "zedboard" } {
  set_property -dict [list CONFIG.TRANSLATION_MODE {0}] $axi_protocol_converter_3
}

# Create instance: axi_protocol_converter_acp, and set properties
set axi_protocol_converter_acp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_acp ]
if { $BOARD == "zedboard" } {
  set_property -dict [ list CONFIG.TRANSLATION_MODE {0} ] $axi_protocol_converter_acp
}

if { $::env(RAB_AX_LOG_EN) } {
    # Create instance: axi_protocol_conv_ax_log, and set properties
    set axi_protocol_conv_ar_log [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_conv_ar_log ]
    set_property -dict [ list CONFIG.MI_PROTOCOL {AXI4LITE} ] $axi_protocol_conv_ar_log
    set_property -dict [ list CONFIG.SI_PROTOCOL {AXI4}     ] $axi_protocol_conv_ar_log
    set_property -dict [ list CONFIG.TRANSLATION_MODE {2}   ] $axi_protocol_conv_ar_log

    set axi_protocol_conv_aw_log [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_conv_aw_log ]
    set_property -dict [ list CONFIG.MI_PROTOCOL {AXI4LITE} ] $axi_protocol_conv_aw_log
    set_property -dict [ list CONFIG.SI_PROTOCOL {AXI4}     ] $axi_protocol_conv_aw_log
    set_property -dict [ list CONFIG.TRANSLATION_MODE {2}   ] $axi_protocol_conv_aw_log
}

# Create instance: axi_pulp_control, and set properties
set axi_pulp_control [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_pulp_control ]
set_property -dict [ list CONFIG.C_ALL_INPUTS {1}              ] $axi_pulp_control
set_property -dict [ list CONFIG.C_IS_DUAL {1}                 ] $axi_pulp_control
set_property -dict [ list CONFIG.C_ALL_OUTPUTS_2 {1}           ] $axi_pulp_control
set_property -dict [ list CONFIG.C_DOUT_DEFAULT_2 {0xC0000000} ] $axi_pulp_control

# Create instance: processing_system7_0, and set properties
set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:$PS7_VERSION processing_system7_0 ]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" } $processing_system7_0
set_property -dict [ list CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} ] $processing_system7_0
set_property -dict [ list CONFIG.PCW_EN_RST1_PORT {1}                     ] $processing_system7_0
set_property -dict [ list CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64}            ] $processing_system7_0
set_property -dict [ list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}             ] $processing_system7_0
set_property -dict [ list CONFIG.PCW_USE_M_AXI_GP0 {1}                    ] $processing_system7_0
set_property -dict [ list CONFIG.PCW_USE_M_AXI_GP1 {0}                    ] $processing_system7_0
set_property -dict [ list CONFIG.PCW_USE_S_AXI_HP0 {1}                    ] $processing_system7_0
set_property -dict [ list CONFIG.PCW_USE_S_AXI_ACP {1}                    ] $processing_system7_0
set_property -dict [ list CONFIG.PCW_IRQ_F2P_INTR {1}                     ] $processing_system7_0
set_property -dict [ list CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {1}         ] $processing_system7_0
set_property              CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ $IC_FREQ_MHZ  $processing_system7_0
# for PULP-2-HOST UART
#set_property -dict [ list CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1}] [get_bd_cells processing_system7_0]
set_property -dict [ list CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} CONFIG.PCW_UART0_GRP_FULL_ENABLE {1}] [get_bd_cells processing_system7_0]

###############
#
# Modify host clocks, e.g., for benchmarking PULP as an ASIC.
#
###############
if { $::env(MOD_HOST_CLKS) } {
    # DDR frequency
    set_property CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ   {303} $processing_system7_0
    # APU and interconnect frequency - The effective APU freuency of 400/333 MHz is set through sysfs at runtime.
}
# Max host clock
set_property CONFIG.PCW_APU_PERIPHERAL_FREQMHZ $HOST_CLK_MHZ $processing_system7_0

# Create interface connections
connect_bd_intf_net -intf_net axi_clock_converter_0_M_AXI [get_bd_intf_pins axi_clock_converter_0/M_AXI] [get_bd_intf_pins axi_crossbar_1/S00_AXI]
connect_bd_intf_net -intf_net axi_clock_converter_1_M_AXI [get_bd_intf_pins axi_clock_converter_1/M_AXI] [get_bd_intf_pins axi_protocol_converter_3/S_AXI]
connect_bd_intf_net -intf_net axi_clock_converter_acp_M_AXI [get_bd_intf_pins axi_clock_converter_acp/M_AXI] [get_bd_intf_pins axi_protocol_converter_acp/S_AXI]
connect_bd_intf_net -intf_net axi_crossbar_0_M00_AXI [get_bd_intf_pins axi_crossbar_0/M00_AXI] [get_bd_intf_pins axi_protocol_converter_1/S_AXI]
connect_bd_intf_net -intf_net axi_crossbar_0_M02_AXI [get_bd_intf_pins axi_crossbar_0/M01_AXI] [get_bd_intf_pins axi_dwidth_converter_0/S_AXI]
connect_bd_intf_net -intf_net axi_crossbar_0_M03_AXI [get_bd_intf_pins axi_crossbar_0/M02_AXI] [get_bd_intf_pins axi_protocol_converter_2/S_AXI]
connect_bd_intf_net -intf_net axi_crossbar_1_M00_AXI [get_bd_intf_pins axi_crossbar_1/M00_AXI] [get_bd_intf_pins axi_pulp_control/S_AXI]
connect_bd_intf_net -intf_net axi_crossbar_1_M01_AXI [get_bd_intf_ports rab_lite] [get_bd_intf_pins axi_crossbar_1/M01_AXI]
connect_bd_intf_net -intf_net axi_crossbar_1_M02_AXI [get_bd_intf_ports intr_axi] [get_bd_intf_pins axi_crossbar_1/M02_AXI]
connect_bd_intf_net -intf_net axi_dwidth_converter_0_M_AXI [get_bd_intf_ports rab_slave] [get_bd_intf_pins axi_dwidth_converter_0/M_AXI]
connect_bd_intf_net -intf_net axi_protocol_converter_0_M_AXI [get_bd_intf_pins axi_crossbar_0/S00_AXI] [get_bd_intf_pins axi_protocol_converter_0/M_AXI]
connect_bd_intf_net -intf_net axi_protocol_converter_1_M_AXI [get_bd_intf_ports clking_axi] [get_bd_intf_pins axi_protocol_converter_1/M_AXI]
connect_bd_intf_net -intf_net axi_protocol_converter_2_M_AXI [get_bd_intf_pins axi_clock_converter_0/S_AXI] [get_bd_intf_pins axi_protocol_converter_2/M_AXI]
connect_bd_intf_net -intf_net axi_protocol_converter_3_M_AXI [get_bd_intf_pins axi_protocol_converter_3/M_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
connect_bd_intf_net -intf_net axi_protocol_converter_acp_M_AXI [get_bd_intf_pins axi_protocol_converter_acp/M_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_ACP]
connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_protocol_converter_0/S_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]
connect_bd_intf_net -intf_net rab_master_1 [get_bd_intf_ports rab_master] [get_bd_intf_pins axi_clock_converter_1/S_AXI]
connect_bd_intf_net -intf_net rab_master_acp [get_bd_intf_ports rab_acp] [get_bd_intf_pins axi_clock_converter_acp/S_AXI]
connect_bd_intf_net [get_bd_intf_ports UART_0] [get_bd_intf_pins processing_system7_0/UART_0]

# Create port connections
connect_bd_net -net axi_pulp_control_gpio2_io_o [get_bd_ports host2pulp_gpio] [get_bd_pins axi_pulp_control/gpio2_io_o]
connect_bd_net -net axi_pulp_control_gpio_io_i [get_bd_ports pulp2host_gpio] [get_bd_pins axi_pulp_control/gpio_io_i]

connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_ports ClkIcHost_CO]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_clock_converter_0/s_axi_aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_clock_converter_1/m_axi_aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_clock_converter_acp/m_axi_aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_crossbar_0/aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dwidth_converter_0/s_axi_aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_protocol_converter_0/aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_protocol_converter_1/aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_protocol_converter_2/aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_protocol_converter_3/aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_protocol_converter_acp/aclk]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/S_AXI_ACP_ACLK]

connect_bd_net [get_bd_ports RstIcHost_RBO] [get_bd_pins processing_system7_0/FCLK_RESET0_N]

connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_clock_converter_0/s_axi_aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_clock_converter_1/m_axi_aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_clock_converter_acp/m_axi_aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_crossbar_0/aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_dwidth_converter_0/s_axi_aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_protocol_converter_0/aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_protocol_converter_1/aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_protocol_converter_2/aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_protocol_converter_3/aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_protocol_converter_acp/aresetn]

connect_bd_net -net processing_system7_0_FCLK_RESET1_N [get_bd_ports RstPulp_RBO]
connect_bd_net -net processing_system7_0_FCLK_RESET1_N [get_bd_pins processing_system7_0/FCLK_RESET1_N]

connect_bd_net -net ClkIcPulp_CI_1 [get_bd_ports ClkIcPulp_CI]
connect_bd_net -net ClkIcPulp_CI_1 [get_bd_pins axi_clock_converter_0/m_axi_aclk]
connect_bd_net -net ClkIcPulp_CI_1 [get_bd_pins axi_crossbar_1/aclk]
connect_bd_net -net ClkIcPulp_CI_1 [get_bd_pins axi_dwidth_converter_0/m_axi_aclk]
connect_bd_net -net ClkIcPulp_CI_1 [get_bd_pins axi_pulp_control/s_axi_aclk]

connect_bd_net -net ClkIcPulpGated_CI_1 [get_bd_ports ClkIcPulpGated_CI]
connect_bd_net -net ClkIcPulpGated_CI_1 [get_bd_pins axi_clock_converter_1/s_axi_aclk]
connect_bd_net -net ClkIcPulpGated_CI_1 [get_bd_pins axi_clock_converter_acp/s_axi_aclk]

connect_bd_net -net RstIcPulp_RBI_1 [get_bd_ports RstIcPulp_RBI]
connect_bd_net -net RstIcPulp_RBI_1 [get_bd_pins axi_clock_converter_0/m_axi_aresetn]
connect_bd_net -net RstIcPulp_RBI_1 [get_bd_pins axi_crossbar_1/aresetn]
connect_bd_net -net RstIcPulp_RBI_1 [get_bd_pins axi_dwidth_converter_0/m_axi_aresetn]
connect_bd_net -net RstIcPulp_RBI_1 [get_bd_pins axi_pulp_control/s_axi_aresetn]

connect_bd_net -net RstIcPulpGated_RBI_1 [get_bd_ports RstIcPulpGated_RBI]
connect_bd_net -net RstIcPulpGated_RBI_1 [get_bd_pins axi_clock_converter_1/s_axi_aresetn]
connect_bd_net -net RstIcPulpGated_RBI_1 [get_bd_pins axi_clock_converter_acp/s_axi_aresetn]

connect_bd_net [get_bd_ports pulp2host_intr] [get_bd_pins processing_system7_0/IRQ_F2P]

# Create rab_ar_bram_ctrl_host, set properties, and connect
if { $::env(RAB_AX_LOG_EN) } {
    set rab_ar_bram_ctrl_host \
        [ create_bd_cell \
            -type ip \
            -vlnv xilinx.com:ip:axi_bram_ctrl:$BRAM_CONTROLLER_VERSION \
            rab_ar_bram_ctrl_host \
        ]
    set_property -dict [ list \
        CONFIG.SINGLE_PORT_BRAM {1} \
        CONFIG.PROTOCOL {AXI4LITE} \
        CONFIG.C_SELECT_XPM {0} \
    ] $rab_ar_bram_ctrl_host
    set_property CONFIG.READ_WRITE_MODE READ_WRITE [get_bd_intf_pins $rab_ar_bram_ctrl_host/BRAM_PORTA]
    connect_bd_intf_net \
        [ get_bd_intf_pins axi_crossbar_0/M03_AXI ] \
        [ get_bd_intf_pins axi_protocol_conv_ar_log/S_AXI ]
    connect_bd_intf_net \
        [ get_bd_intf_pins axi_protocol_conv_ar_log/M_AXI ] \
        [ get_bd_intf_pins rab_ar_bram_ctrl_host/S_AXI ]
    connect_bd_net -net processing_system7_0_FCLK_CLK0 \
        [get_bd_pins axi_protocol_conv_ar_log/aclk]
    connect_bd_net -net processing_system7_0_FCLK_CLK0 \
        [ get_bd_pins rab_ar_bram_ctrl_host/s_axi_aclk ]
    connect_bd_net \
        -net [ get_bd_nets RstIcHost_RBI_1 ] \
        [ get_bd_ports RstIcHost_RBI ] \
        [ get_bd_pins axi_protocol_conv_ar_log/aresetn ]    
    connect_bd_net \
        -net [ get_bd_nets RstIcHost_RBI_1 ] \
        [ get_bd_ports RstIcHost_RBI ] \
        [ get_bd_pins rab_ar_bram_ctrl_host/s_axi_aresetn ]
    connect_bd_intf_net \
        [ get_bd_intf_pins rab_ar_bram_ctrl_host/BRAM_PORTA ] \
        [ get_bd_intf_ports rab_ar_bram ]

    # Create rab_aw_bram_ctrl_host, set properties, and connect
    set rab_aw_bram_ctrl_host \
        [ create_bd_cell \
            -type ip \
            -vlnv xilinx.com:ip:axi_bram_ctrl:$BRAM_CONTROLLER_VERSION \
            rab_aw_bram_ctrl_host \
        ]
    set_property -dict [ list \
        CONFIG.SINGLE_PORT_BRAM {1} \
        CONFIG.PROTOCOL {AXI4LITE} \
        CONFIG.C_SELECT_XPM {0} \
    ] $rab_aw_bram_ctrl_host
    set_property CONFIG.READ_WRITE_MODE READ_WRITE [get_bd_intf_pins $rab_aw_bram_ctrl_host/BRAM_PORTA]
    connect_bd_intf_net \
        [ get_bd_intf_pins axi_crossbar_0/M04_AXI ] \
        [ get_bd_intf_pins axi_protocol_conv_aw_log/S_AXI ]
    connect_bd_intf_net \
        [ get_bd_intf_pins axi_protocol_conv_aw_log/M_AXI ] \
        [ get_bd_intf_pins rab_aw_bram_ctrl_host/S_AXI ]
    connect_bd_net -net processing_system7_0_FCLK_CLK0 \
        [get_bd_pins axi_protocol_conv_aw_log/aclk]
    connect_bd_net -net processing_system7_0_FCLK_CLK0 \
        [ get_bd_pins rab_aw_bram_ctrl_host/s_axi_aclk ]
    connect_bd_net \
        -net [ get_bd_nets RstIcHost_RBI_1 ] \
        [ get_bd_ports RstIcHost_RBI ] \
        [ get_bd_pins axi_protocol_conv_aw_log/aresetn ]    
    connect_bd_net \
        -net [ get_bd_nets RstIcHost_RBI_1 ] \
        [ get_bd_ports RstIcHost_RBI ] \
        [ get_bd_pins rab_aw_bram_ctrl_host/s_axi_aresetn ]
    connect_bd_intf_net \
        [ get_bd_intf_pins rab_aw_bram_ctrl_host/BRAM_PORTA ] \
        [ get_bd_intf_ports rab_aw_bram ]
    
    if { [version -short] == "2018.3" } {
       set_property CONFIG.READ_WRITE_MODE READ_WRITE [get_bd_intf_ports /rab_ar_bram]
       set_property CONFIG.READ_WRITE_MODE READ_WRITE [get_bd_intf_ports /rab_aw_bram]
       }
}

# Create address segments
# HOST-to-PULP
create_bd_addr_seg -range 0x10000 -offset 0x51000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_pulp_control/S_AXI/Reg] SEG_axi_pulp_control_Reg
create_bd_addr_seg -range 0x10000 -offset 0x51010000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs clking_axi/Reg] SEG_clking_axi_Reg
create_bd_addr_seg -range 0x10000 -offset 0x51030000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs rab_lite/Reg] SEG_rab_lite_Reg
create_bd_addr_seg -range 0x10000 -offset 0x51050000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs intr_axi/Reg] SEG_intr_axi_Reg
if { $::env(RAB_AX_LOG_EN) } {
    create_bd_addr_seg -range 0x100000 -offset 0x51100000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs rab_ar_bram_ctrl_host/S_AXI/Mem0] SEG_rab_ar_bram_ctrl_host_Mem0
    create_bd_addr_seg -range 0x100000 -offset 0x51200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs rab_aw_bram_ctrl_host/S_AXI/Mem0] SEG_rab_aw_bram_ctrl_host_Mem0
}
create_bd_addr_seg -range 0x10000000 -offset 0x40000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs rab_slave/Reg] SEG_rab_slave_Reg

# PULP-to-HOST
create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces rab_master] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces rab_acp] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_processing_system7_0_ACP_DDR_LOWOCM

save_bd_design
