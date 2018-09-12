create_bd_design "ic"
set design_name ic

# Set IP versions
if { [version -short] == "2016.3" } {
  set PS7_VERSION "5.5"
  set XLCONCAT_VERSION "2.1"
  set BLK_MEM_GEN_VERSION "8.3"
  set MB_VERSION "10.0"
} else { 
  # 2017.2
  set PS7_VERSION "5.5"
  set XLCONCAT_VERSION "2.1"
  set BLK_MEM_GEN_VERSION "8.3"
  set MB_VERSION "10.0"
}

# Create ports
set pulp2host_gpio [ create_bd_port -dir I -from 31 -to 0 pulp2host_gpio ]
set host2pulp_gpio [ create_bd_port -dir O -from 31 -to 0 host2pulp_gpio ]

set ClkIcPulp_CI  [ create_bd_port -dir I ClkIcPulp_CI -type CLK  ]
set RstIcPulp_RBI [ create_bd_port -dir I RstIcPulp_RBI -type RST ]

set ClkIcPulpGated_CI  [ create_bd_port -dir I -type clk ClkIcPulpGated_CI  ]
set RstIcPulpGated_RBI [ create_bd_port -dir I -type rst RstIcPulpGated_RBI ]

set ClkIcHost_CI         [ create_bd_port -dir I ClkIcHost_CI -type CLK         ]
set ClkIcHostClkConv_CI  [ create_bd_port -dir I ClkIcHostClkConv_CI -type CLK  ]
set RstIcHost_RBI        [ create_bd_port -dir I RstIcHost_RBI -type RST        ]
set RstIcHostClkConv_RBI [ create_bd_port -dir I RstIcHostClkConv_RBI -type RST ]

set RstMaster_RBI [ create_bd_port -dir I RstMaster_RBI -type RST ]
set RstDebug_RO  [ create_bd_port -dir O RstDebug_RO -type RST ]

set_property CONFIG.ASSOCIATED_RESET RstIcPulp_RBI        [get_bd_ports ClkIcPulp_CI]
set_property CONFIG.ASSOCIATED_RESET RstIcPulpGated_RBI   [get_bd_ports ClkIcPulpGated_CI]
set_property CONFIG.ASSOCIATED_RESET RstIcHost_RBI        [get_bd_ports ClkIcHost_CI]
set_property CONFIG.ASSOCIATED_RESET RstIcHostClkConv_RBI [get_bd_ports ClkIcHostClkConv_CI]

# Create interface ports
set clking_axi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 clking_axi ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32} CONFIG.DATA_WIDTH {32} CONFIG.FREQ_HZ {100000000} CONFIG.PROTOCOL {AXI4LITE}  ] $clking_axi
set intr_axi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 intr_axi ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32} CONFIG.DATA_WIDTH {64} CONFIG.FREQ_HZ {100000000} CONFIG.PROTOCOL {AXI4LITE}  ] $intr_axi
set rab_lite [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_lite ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32} CONFIG.DATA_WIDTH {64} CONFIG.FREQ_HZ {100000000} CONFIG.PROTOCOL {AXI4LITE}  ] $rab_lite

set tsif [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 tsif ]
set_property -dict [ list CONFIG.ADDR_WIDTH {40} CONFIG.CLK_DOMAIN {} CONFIG.DATA_WIDTH {128} CONFIG.FREQ_HZ {100000000} CONFIG.NUM_READ_OUTSTANDING {16} CONFIG.NUM_WRITE_OUTSTANDING {16} CONFIG.PROTOCOL {AXI4}                                                                CONFIG.READ_WRITE_MODE {READ_WRITE} CONFIG.PHASE {0.000}                     ] $tsif
set rab_master [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_master ]
set_property -dict [ list CONFIG.ADDR_WIDTH {40} CONFIG.CLK_DOMAIN {} CONFIG.DATA_WIDTH {64}  CONFIG.FREQ_HZ {100000000} CONFIG.NUM_READ_OUTSTANDING {16} CONFIG.NUM_WRITE_OUTSTANDING {16} CONFIG.PROTOCOL {AXI4} CONFIG.SUPPORTS_NARROW_BURST {1} CONFIG.MAX_BURST_LENGTH {256} CONFIG.READ_WRITE_MODE {READ_WRITE} CONFIG.PHASE {0.000} CONFIG.ID_WIDTH {6} ] $rab_master

set tmif [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 tmif ]
set_property -dict [ list CONFIG.ADDR_WIDTH {40} CONFIG.CLK_DOMAIN {} CONFIG.DATA_WIDTH {64}  CONFIG.FREQ_HZ {100000000} CONFIG.NUM_READ_OUTSTANDING {16} CONFIG.NUM_WRITE_OUTSTANDING {16} CONFIG.PROTOCOL {AXI4} CONFIG.SUPPORTS_NARROW_BURST {1} CONFIG.MAX_BURST_LENGTH {256} CONFIG.READ_WRITE_MODE {READ_WRITE} CONFIG.ID_WIDTH {14} ] $tmif
set rab_slave [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_slave ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32} CONFIG.CLK_DOMAIN {} CONFIG.DATA_WIDTH {64}  CONFIG.FREQ_HZ {100000000} CONFIG.NUM_READ_OUTSTANDING {16} CONFIG.NUM_WRITE_OUTSTANDING {16} CONFIG.PROTOCOL {AXI4}                                                                CONFIG.READ_WRITE_MODE {READ_WRITE}                      ] $rab_slave

set stdout_slave [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 stdout_slave ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32} CONFIG.CLK_DOMAIN {} CONFIG.DATA_WIDTH {64}  CONFIG.FREQ_HZ {100000000} CONFIG.NUM_READ_OUTSTANDING {0} CONFIG.NUM_WRITE_OUTSTANDING {0} CONFIG.PROTOCOL {AXI4} CONFIG.SUPPORTS_NARROW_BURST {1} CONFIG.MAX_BURST_LENGTH {256} CONFIG.READ_WRITE_MODE {READ_WRITE} CONFIG.PHASE {0.000} CONFIG.ID_WIDTH {10} CONFIG.ARUSER_WIDTH {0} CONFIG.AWUSER_WIDTH {0} CONFIG.BUSER_WIDTH {0} CONFIG.RUSER_WIDTH {0} CONFIG.WUSER_WIDTH {0} ] $stdout_slave

if { $::env(RAB_AX_LOG_EN) } {
    set rab_ar_bram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:bram_rtl:1.0 rab_ar_bram ]
    set_property -dict [ list CONFIG.MASTER_TYPE {BRAM_CTRL}  ] $rab_ar_bram

    set rab_aw_bram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:bram_rtl:1.0 rab_aw_bram ]
    set_property -dict [ list CONFIG.MASTER_TYPE {BRAM_CTRL}  ] $rab_aw_bram
}

set_property CONFIG.ASSOCIATED_BUSIF {rab_lite:rab_slave} [get_bd_ports ClkIcPulp_CI]
set_property CONFIG.ASSOCIATED_BUSIF {rab_master}         [get_bd_ports ClkIcPulpGated_CI]
set_property CONFIG.ASSOCIATED_BUSIF {tsif}               [get_bd_ports ClkIcHostClkConv_CI]
set_property CONFIG.ASSOCIATED_BUSIF {tmif}               [get_bd_ports ClkIcHost_CI]

###############
#
# PULP-to-JUNO
#
###############  
# Create instance: axi_dwidth_converter_pulp2host, and set properties
set axi_dwidth_converter_pulp2host [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_converter_pulp2host ]
set_property -dict [list CONFIG.ACLK_ASYNC.VALUE_SRC USER CONFIG.ACLK_ASYNC {1} CONFIG.FIFO_MODE {2} CONFIG.MI_DATA_WIDTH.VALUE_SRC USER CONFIG.MI_DATA_WIDTH {128} CONFIG.SI_DATA_WIDTH.VALUE_SRC USER CONFIG.SI_DATA_WIDTH {64} CONFIG.SI_ID_WIDTH.VALUE_SRC USER CONFIG.SI_ID_WIDTH {6}] $axi_dwidth_converter_pulp2host

connect_bd_intf_net [get_bd_intf_ports tsif] [get_bd_intf_pins axi_dwidth_converter_pulp2host/M_AXI]
connect_bd_intf_net [get_bd_intf_ports rab_master] [get_bd_intf_pins axi_dwidth_converter_pulp2host/S_AXI]

connect_bd_net [get_bd_ports ClkIcPulpGated_CI] [get_bd_pins axi_dwidth_converter_pulp2host/s_axi_aclk]
connect_bd_net [get_bd_ports RstIcPulpGated_RBI] [get_bd_pins axi_dwidth_converter_pulp2host/s_axi_aresetn]
connect_bd_net [get_bd_ports ClkIcHostClkConv_CI] [get_bd_pins axi_dwidth_converter_pulp2host/m_axi_aclk]
connect_bd_net [get_bd_ports RstIcHostClkConv_RBI] [get_bd_pins axi_dwidth_converter_pulp2host/m_axi_aresetn]

###############
#
# JUNO-to-PULP
#
###############
# Create instance: axi_crossbar_host2pulp, and set properties
set axi_crossbar_host2pulp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_host2pulp ]
set_property -dict [ list CONFIG.STRATEGY {2} CONFIG.DATA_WIDTH {64} CONFIG.NUM_MI {2} CONFIG.NUM_SI {2} CONFIG.S01_BASE_ID {0x00001000} CONFIG.S02_BASE_ID {0x00002000} CONFIG.S03_BASE_ID {0x00003000} CONFIG.S04_BASE_ID {0x00004000} CONFIG.S05_BASE_ID {0x00005000} CONFIG.S06_BASE_ID {0x00006000} CONFIG.S07_BASE_ID {0x00007000} CONFIG.S08_BASE_ID {0x00008000} CONFIG.S09_BASE_ID {0x00009000} CONFIG.S10_BASE_ID {0x0000a000} CONFIG.S11_BASE_ID {0x0000b000} CONFIG.S12_BASE_ID {0x0000c000} CONFIG.S13_BASE_ID {0x0000d000} CONFIG.S14_BASE_ID {0x0000e000} CONFIG.S15_BASE_ID {0x0000f000}  ] $axi_crossbar_host2pulp

# AXI4 & AXI-LITE @ ClkIcPulp_C
# Create instance: axi_clock_converter_host2pulp, and set properties
set axi_clock_converter_host2pulp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_host2pulp ]
set_property -dict [list CONFIG.ACLK_ASYNC.VALUE_SRC USER CONFIG.ACLK_ASYNC {1}] $axi_clock_converter_host2pulp

# Create instance: axi_crossbar_liteORaxi, and set properties
set axi_crossbar_liteORaxi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_liteORaxi ]
set_property -dict [ list CONFIG.NUM_MI {2} CONFIG.PROTOCOL.VALUE_SRC USER CONFIG.PROTOCOL {AXI4} CONFIG.ADDR_WIDTH.VALUE_SRC USER CONFIG.ADDR_WIDTH {32} CONFIG.CONNECTIVITY_MODE {SAMD} CONFIG.R_REGISTER {0} CONFIG.S00_SINGLE_THREAD {1} ] $axi_crossbar_liteORaxi

# Create instance: axi_protocol_converter_axi2lite, and set properties
set axi_protocol_converter_axi2lite [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_axi2lite ]
set_property -dict [list CONFIG.SI_PROTOCOL {AXI4} CONFIG.MI_PROTOCOL {AXI4LITE} CONFIG.TRANSLATION_MODE {2}] $axi_protocol_converter_axi2lite

# Create instance: axi_crossbar_lite_pulp_clk, and set properties
set axi_crossbar_lite_pulp_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_lite_pulp_clk ]
set_property -dict [ list CONFIG.NUM_MI {3} CONFIG.PROTOCOL.VALUE_SRC USER CONFIG.PROTOCOL {AXI4LITE} CONFIG.ADDR_WIDTH.VALUE_SRC USER CONFIG.ADDR_WIDTH {32} CONFIG.CONNECTIVITY_MODE {SASD} CONFIG.R_REGISTER {1} CONFIG.S00_SINGLE_THREAD {1} ] $axi_crossbar_lite_pulp_clk

connect_bd_intf_net [get_bd_intf_ports tmif] [get_bd_intf_pins axi_crossbar_host2pulp/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_crossbar_host2pulp/M00_AXI] [get_bd_intf_pins axi_clock_converter_host2pulp/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_clock_converter_host2pulp/M_AXI] [get_bd_intf_pins axi_crossbar_liteORaxi/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_crossbar_liteORaxi/M00_AXI] [get_bd_intf_pins axi_protocol_converter_axi2lite/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_protocol_converter_axi2lite/M_AXI] [get_bd_intf_pins axi_crossbar_lite_pulp_clk/S00_AXI]
connect_bd_intf_net [get_bd_intf_ports rab_slave] [get_bd_intf_pins axi_crossbar_liteORaxi/M01_AXI]

connect_bd_net -net [get_bd_nets ClkIcPulp_CI_1] [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_clock_converter_host2pulp/m_axi_aclk]
connect_bd_net -net [get_bd_nets ClkIcPulp_CI_1] [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_crossbar_liteORaxi/aclk]
connect_bd_net -net [get_bd_nets ClkIcPulp_CI_1] [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_crossbar_lite_pulp_clk/aclk]
connect_bd_net -net [get_bd_nets ClkIcPulp_CI_1] [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_protocol_converter_axi2lite/aclk]
connect_bd_net -net [get_bd_nets RstIcPulp_RBI_1] [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_clock_converter_host2pulp/m_axi_aresetn]
connect_bd_net -net [get_bd_nets RstIcPulp_RBI_1] [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_crossbar_liteORaxi/aresetn]
connect_bd_net -net [get_bd_nets RstIcPulp_RBI_1] [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_crossbar_lite_pulp_clk/aresetn]
connect_bd_net -net [get_bd_nets RstIcPulp_RBI_1] [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_protocol_converter_axi2lite/aresetn]
connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins axi_clock_converter_host2pulp/s_axi_aclk]
connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins axi_crossbar_host2pulp/aclk]
connect_bd_net -net [get_bd_nets RstIcHost_RBI_1] [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_clock_converter_host2pulp/s_axi_aresetn]
connect_bd_net -net [get_bd_nets RstIcHost_RBI_1] [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_crossbar_host2pulp/aresetn]

# Create instance: axi_dwidth_converter_ctrl, and set properties
set axi_dwidth_converter_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_converter_ctrl ]
set_property -dict [list CONFIG.ACLK_ASYNC {0} CONFIG.FIFO_MODE {0} CONFIG.MI_DATA_WIDTH.VALUE_SRC USER CONFIG.MI_DATA_WIDTH {32} CONFIG.SI_DATA_WIDTH.VALUE_SRC USER CONFIG.SI_DATA_WIDTH {64}] $axi_dwidth_converter_ctrl

# Create instance: axi_pulp_control, and set properties
set axi_pulp_control [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_pulp_control ]
set_property -dict [ list CONFIG.C_ALL_INPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1} CONFIG.C_IS_DUAL {1} CONFIG.C_DOUT_DEFAULT_2 {0xC0000000} ] $axi_pulp_control

connect_bd_intf_net [get_bd_intf_pins axi_dwidth_converter_ctrl/S_AXI] [get_bd_intf_pins axi_crossbar_lite_pulp_clk/M02_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_pulp_control/S_AXI] [get_bd_intf_pins axi_dwidth_converter_ctrl/M_AXI]
connect_bd_intf_net [get_bd_intf_ports rab_lite] [get_bd_intf_pins axi_crossbar_lite_pulp_clk/M01_AXI]
connect_bd_intf_net [get_bd_intf_ports intr_axi] [get_bd_intf_pins axi_crossbar_lite_pulp_clk/M00_AXI]

connect_bd_net [get_bd_ports pulp2host_gpio] [get_bd_pins axi_pulp_control/gpio_io_i]
connect_bd_net [get_bd_ports host2pulp_gpio] [get_bd_pins axi_pulp_control/gpio2_io_o]

connect_bd_net -net [get_bd_nets ClkIcPulp_CI_1] [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_dwidth_converter_ctrl/s_axi_aclk]
connect_bd_net -net [get_bd_nets ClkIcPulp_CI_1] [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_pulp_control/s_axi_aclk]
connect_bd_net -net [get_bd_nets RstIcPulp_RBI_1] [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_dwidth_converter_ctrl/s_axi_aresetn]
connect_bd_net -net [get_bd_nets RstIcPulp_RBI_1] [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_pulp_control/s_axi_aresetn]

# AXI4 & AXI-LITE @ ClkIcHost_C
# Create instance: axi_dwidth_converter_host2pulp, and set properties
set axi_dwidth_converter_host2pulp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_converter_host2pulp ]
set_property -dict [list CONFIG.ACLK_ASYNC {0} CONFIG.FIFO_MODE {0} CONFIG.MI_DATA_WIDTH.VALUE_SRC USER CONFIG.MI_DATA_WIDTH {32} CONFIG.SI_DATA_WIDTH.VALUE_SRC USER CONFIG.SI_DATA_WIDTH {64}] $axi_dwidth_converter_host2pulp

# Create instance: axi_crossbar_lite_host_clk, and set properties
set axi_crossbar_lite_host_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_lite_host_clk ]
set_property -dict [ list CONFIG.NUM_MI {3} CONFIG.PROTOCOL.VALUE_SRC USER CONFIG.PROTOCOL {AXI4LITE} CONFIG.ADDR_WIDTH.VALUE_SRC USER CONFIG.ADDR_WIDTH {32} CONFIG.CONNECTIVITY_MODE {SASD} CONFIG.R_REGISTER {1} CONFIG.S00_SINGLE_THREAD {1} ] $axi_crossbar_lite_host_clk

# Create instance: axi_protocol_converter_axi2lite_host_clk, and set properties
set axi_protocol_converter_axi2lite_host_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_axi2lite_host_clk ]
set_property -dict [list CONFIG.SI_PROTOCOL {AXI4} CONFIG.MI_PROTOCOL {AXI4LITE} CONFIG.TRANSLATION_MODE {2}] $axi_protocol_converter_axi2lite_host_clk

connect_bd_intf_net [get_bd_intf_pins axi_crossbar_host2pulp/M01_AXI] [get_bd_intf_pins axi_protocol_converter_axi2lite_host_clk/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_protocol_converter_axi2lite_host_clk/M_AXI] [get_bd_intf_pins axi_dwidth_converter_host2pulp/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dwidth_converter_host2pulp/M_AXI] [get_bd_intf_pins axi_crossbar_lite_host_clk/S00_AXI]
connect_bd_intf_net [get_bd_intf_ports clking_axi] [get_bd_intf_pins axi_crossbar_lite_host_clk/M00_AXI]

connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins axi_protocol_converter_axi2lite_host_clk/aclk]
connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins axi_dwidth_converter_host2pulp/s_axi_aclk]
connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins axi_crossbar_lite_host_clk/aclk]
connect_bd_net -net [get_bd_nets RstIcHost_RBI_1] [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_protocol_converter_axi2lite_host_clk/aresetn]
connect_bd_net -net [get_bd_nets RstIcHost_RBI_1] [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_dwidth_converter_host2pulp/s_axi_aresetn]
connect_bd_net -net [get_bd_nets RstIcHost_RBI_1] [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_crossbar_lite_host_clk/aresetn]

# Create rab_ar_bram_ctrl_host, set properties, and connect
if { $::env(RAB_AX_LOG_EN) } {
    set rab_ar_bram_ctrl_host \
        [ create_bd_cell \
            -type ip \
            -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 \
            rab_ar_bram_ctrl_host \
        ]
    set_property -dict [ list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE} ] $rab_ar_bram_ctrl_host
    connect_bd_intf_net \
        [ get_bd_intf_pins axi_crossbar_lite_host_clk/M01_AXI ] \
        [ get_bd_intf_pins rab_ar_bram_ctrl_host/S_AXI ]
    connect_bd_net \
        -net [ get_bd_nets ClkIcHost_CI_1 ] \
        [ get_bd_ports ClkIcHost_CI ] \
        [ get_bd_pins rab_ar_bram_ctrl_host/s_axi_aclk ]
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
            -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 \
            rab_aw_bram_ctrl_host \
        ]
    set_property -dict [ list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE} ] $rab_aw_bram_ctrl_host
    connect_bd_intf_net \
        [ get_bd_intf_pins axi_crossbar_lite_host_clk/M02_AXI ] \
        [ get_bd_intf_pins rab_aw_bram_ctrl_host/S_AXI ]
    connect_bd_net \
        -net [ get_bd_nets ClkIcHost_CI_1 ] \
        [ get_bd_ports ClkIcHost_CI ] \
        [ get_bd_pins rab_aw_bram_ctrl_host/s_axi_aclk ]
    connect_bd_net \
        -net [ get_bd_nets RstIcHost_RBI_1 ] \
        [ get_bd_ports RstIcHost_RBI ] \
        [ get_bd_pins rab_aw_bram_ctrl_host/s_axi_aresetn ]
    connect_bd_intf_net \
        [ get_bd_intf_pins rab_aw_bram_ctrl_host/BRAM_PORTA ] \
        [ get_bd_intf_ports rab_aw_bram ]
}

###############
#
# MB
#
###############
create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_0
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:$MB_VERSION microblaze_0
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr_0
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:$BLK_MEM_GEN_VERSION blk_mem_gen_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_mb

# Create instance: axi_protocol_converter_axi2lite_stdout, and set properties
set axi_protocol_converter_axi2lite_stdout [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_axi2lite_stdout ]
set_property -dict [list CONFIG.SI_PROTOCOL {AXI4} CONFIG.MI_PROTOCOL {AXI4LITE} CONFIG.TRANSLATION_MODE {0}] $axi_protocol_converter_axi2lite_stdout

# Create instance: axi_dwidth_converter_ctrl, and set properties
set axi_dwidth_converter_stdout [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_converter_stdout ]
set_property -dict [list CONFIG.ACLK_ASYNC {0} CONFIG.FIFO_MODE {0} CONFIG.MI_DATA_WIDTH.VALUE_SRC USER CONFIG.MI_DATA_WIDTH {32} CONFIG.SI_DATA_WIDTH.VALUE_SRC USER CONFIG.SI_DATA_WIDTH {64}] $axi_dwidth_converter_stdout

set_property -dict [list CONFIG.C_USE_UART {1} CONFIG.C_DBG_REG_ACCESS {0}] [get_bd_cells mdm_0]
set_property -dict [list CONFIG.C_D_AXI {1} CONFIG.C_I_AXI {0} CONFIG.C_USE_REORDER_INSTR {0} CONFIG.C_DEBUG_ENABLED {1}] [get_bd_cells microblaze_0]
set_property -dict [list CONFIG.C_NUM_LMB {2}] [get_bd_cells lmb_bram_if_cntlr_0]
set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_mb]

connect_bd_intf_net [get_bd_intf_ports stdout_slave] [get_bd_intf_pins axi_protocol_converter_axi2lite_stdout/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dwidth_converter_stdout/S_AXI] [get_bd_intf_pins axi_protocol_converter_axi2lite_stdout/M_AXI]
connect_bd_intf_net [get_bd_intf_pins mdm_0/S_AXI] [get_bd_intf_pins axi_dwidth_converter_stdout/M_AXI]

connect_bd_intf_net [get_bd_intf_pins mdm_0/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]

connect_bd_intf_net [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr_0/BRAM_PORT]
connect_bd_intf_net [get_bd_intf_pins lmb_bram_if_cntlr_0/SLMB] [get_bd_intf_pins microblaze_0/DLMB]
connect_bd_intf_net [get_bd_intf_pins lmb_bram_if_cntlr_0/SLMB1] [get_bd_intf_pins microblaze_0/ILMB]
connect_bd_intf_net [get_bd_intf_pins microblaze_0/M_AXI_DP] -boundary_type upper [get_bd_intf_pins axi_interconnect_mb/S00_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_mb/M00_AXI] [get_bd_intf_pins axi_crossbar_host2pulp/S01_AXI]

connect_bd_net [get_bd_ports ClkIcHost_CI] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins proc_sys_reset_0/mb_debug_sys_rst] [get_bd_pins mdm_0/Debug_SYS_Rst]
connect_bd_net [get_bd_pins proc_sys_reset_0/mb_reset] [get_bd_pins microblaze_0/Reset]
connect_bd_net [get_bd_ports RstMaster_RBI] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins lmb_bram_if_cntlr_0/LMB_Rst] [get_bd_pins proc_sys_reset_0/mb_reset]
connect_bd_net [get_bd_ports RstDebug_RO] [get_bd_pins proc_sys_reset_0/mb_reset]

connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins microblaze_0/Clk]
connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins lmb_bram_if_cntlr_0/LMB_Clk]
connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins axi_interconnect_mb/ACLK]
connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins axi_interconnect_mb/S00_ACLK]
connect_bd_net -net [get_bd_nets ClkIcHost_CI_1] [get_bd_ports ClkIcHost_CI] [get_bd_pins axi_interconnect_mb/M00_ACLK]
connect_bd_net -net [get_bd_nets RstIcHost_RBI_1] [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_interconnect_mb/ARESETN]
connect_bd_net -net [get_bd_nets RstIcHost_RBI_1] [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_interconnect_mb/S00_ARESETN]
connect_bd_net -net [get_bd_nets RstIcHost_RBI_1] [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_interconnect_mb/M00_ARESETN]

connect_bd_net -net [get_bd_nets ClkIcPulp_CI_1] [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_protocol_converter_axi2lite_stdout/aclk]
connect_bd_net -net [get_bd_nets ClkIcPulp_CI_1] [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_dwidth_converter_stdout/s_axi_aclk]
connect_bd_net -net [get_bd_nets ClkIcPulp_CI_1] [get_bd_ports ClkIcPulp_CI] [get_bd_pins mdm_0/S_AXI_ACLK]
connect_bd_net -net [get_bd_nets RstIcPulp_RBI_1] [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_protocol_converter_axi2lite_stdout/aresetn]
connect_bd_net -net [get_bd_nets RstIcPulp_RBI_1] [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_dwidth_converter_stdout/s_axi_aresetn]
connect_bd_net -net [get_bd_nets RstIcPulp_RBI_1] [get_bd_ports RstIcPulp_RBI] [get_bd_pins mdm_0/S_AXI_ARESETN]

# Create address segments
# JUNO-to-PULP
create_bd_addr_seg -range  0x10000 -offset 0x6E000000 [get_bd_addr_spaces tmif] [get_bd_addr_segs axi_pulp_control/S_AXI/Reg] SEG_axi_pulp_control_Reg
create_bd_addr_seg -range  0x10000 -offset 0x6E010000 [get_bd_addr_spaces tmif] [get_bd_addr_segs clking_axi/Reg] SEG_clking_axi_Reg
create_bd_addr_seg -range  0x10000 -offset 0x6E030000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_lite/Reg] SEG_rab_lite_Reg
create_bd_addr_seg -range  0x10000 -offset 0x6E050000 [get_bd_addr_spaces tmif] [get_bd_addr_segs intr_axi/Reg] SEG_intr_axi_Reg
if { $::env(RAB_AX_LOG_EN) } {
    create_bd_addr_seg -range 0x100000 -offset 0x6E100000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_ar_bram_ctrl_host/S_AXI/Mem0] SEG_rab_ar_bram_ctrl_host_Mem0
    create_bd_addr_seg -range 0x100000 -offset 0x6E200000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_aw_bram_ctrl_host/S_AXI/Mem0] SEG_rab_aw_bram_ctrl_host_Mem0
}

create_bd_addr_seg -range 0x8000000 -offset 0x60000000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_slave/Reg] SEG_0_rab_slave_Reg
#create_bd_addr_seg -range 0x4000000 -offset 0x68000000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_slave/Reg] SEG_1_rab_slave_Reg
#create_bd_addr_seg -range 0x2000000 -offset 0x6C000000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_slave/Reg] SEG_2_rab_slave_Reg

# PULP-to-JUNO
create_bd_addr_seg -range 0x1000000000 -offset 0x0 [get_bd_addr_spaces rab_master] [get_bd_addr_segs tsif/Reg] SEG_0_tsif_Reg
#create_bd_addr_seg -range 0x80000000 -offset 0x880000000 [get_bd_addr_spaces rab_master] [get_bd_addr_segs tsif/Reg] SEG_1_tsif_Reg
#create_bd_addr_seg -range 0x100000000 -offset 0x900000000 [get_bd_addr_spaces rab_master] [get_bd_addr_segs tsif/Reg] SEG_2_tsif_Reg
create_bd_addr_seg -range 0x10000 -offset 0x1A110000 [get_bd_addr_spaces stdout_slave] [get_bd_addr_segs mdm_0/S_AXI/Reg] SEG_mdm_0_Reg

# MB-to-PULP
create_bd_addr_seg -range  0x10000 -offset 0x6E000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_pulp_control/S_AXI/Reg] MB_SEG_axi_pulp_control_Reg
create_bd_addr_seg -range  0x10000 -offset 0x6E010000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs clking_axi/Reg] MB_SEG_clking_axi_Reg
create_bd_addr_seg -range  0x10000 -offset 0x6E030000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_lite/Reg] MB_SEG_rab_lite_Reg
create_bd_addr_seg -range  0x10000 -offset 0x6E050000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs intr_axi/Reg] MB_SEG_intr_axi_Reg
if { $::env(RAB_AX_LOG_EN) } {
    create_bd_addr_seg -range 0x100000 -offset 0x6E100000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_ar_bram_ctrl_host/S_AXI/Mem0] MB_SEG_rab_ar_bram_ctrl_host_Mem0
    create_bd_addr_seg -range 0x100000 -offset 0x6E200000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_aw_bram_ctrl_host/S_AXI/Mem0] MB_SEG_rab_aw_bram_ctrl_host_Mem0
}

create_bd_addr_seg -range 0x8000000 -offset 0x60000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_slave/Reg] MB_SEG_0_rab_slave_Reg
#create_bd_addr_seg -range 0x4000000 -offset 0x68000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_slave/Reg] MB_SEG_1_rab_slave_Reg
#create_bd_addr_seg -range 0x2000000 -offset 0x6C000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_slave/Reg] MB_SEG_2_rab_slave_Reg

# MB
create_bd_addr_seg -range 0x2000 -offset 0x0 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs lmb_bram_if_cntlr_0/SLMB/Mem] SEG_lmb_bram_if_cntlr_0_Mem
create_bd_addr_seg -range 0x2000 -offset 0x0 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs lmb_bram_if_cntlr_0/SLMB1/Mem] SEG_lmb_bram_if_cntlr_0_Mem

## JUNO-to-PULP
#create_bd_addr_seg -range 0x10000 -offset 0x6E000000 [get_bd_addr_spaces tmif] [get_bd_addr_segs axi_pulp_control/S_AXI/Reg] SEG_axi_pulp_control_Reg
#create_bd_addr_seg -range 0x10000 -offset 0x6E010000 [get_bd_addr_spaces tmif] [get_bd_addr_segs clking_axi/Reg] SEG_clking_axi_Reg
#create_bd_addr_seg -range 0x10000 -offset 0x6E030000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_lite/Reg] SEG_rab_lite_Reg
#create_bd_addr_seg -range 0x10000 -offset 0x6E050000 [get_bd_addr_spaces tmif] [get_bd_addr_segs intr_axi/Reg] SEG_intr_axi_Reg
#
#create_bd_addr_seg -range 0x8000000 -offset 0x60000000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_slave/Reg] SEG_0_rab_slave_Reg
#create_bd_addr_seg -range 0x4000000 -offset 0x68000000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_slave/Reg] SEG_1_rab_slave_Reg
#create_bd_addr_seg -range 0x2000000 -offset 0x6C000000 [get_bd_addr_spaces tmif] [get_bd_addr_segs rab_slave/Reg] SEG_2_rab_slave_Reg
#
## PULP-to-JUNO
#create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces rab_master] [get_bd_addr_segs tsif/Reg] SEG_0_tsif_Reg
#create_bd_addr_seg -range 0x80000000 -offset 0x880000000 [get_bd_addr_spaces rab_master] [get_bd_addr_segs tsif/Reg] SEG_1_tsif_Reg
#create_bd_addr_seg -range 0x100000000 -offset 0x900000000 [get_bd_addr_spaces rab_master] [get_bd_addr_segs tsif/Reg] SEG_2_tsif_Reg
#create_bd_addr_seg -range 0x10000 -offset 0xC0000000 [get_bd_addr_spaces stdout_slave] [get_bd_addr_segs axi_stdout_controller_pulp/S_AXI/Mem0] SEG_axi_stdout_controller_pulp_Mem0
#
## MB-to-PULP
#create_bd_addr_seg -range 0x10000 -offset 0x6E000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_pulp_control/S_AXI/Reg] MB_SEG_axi_pulp_control_Reg
#create_bd_addr_seg -range 0x10000 -offset 0x6E010000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs clking_axi/Reg] MB_SEG_clking_axi_Reg
#create_bd_addr_seg -range 0x10000 -offset 0x6E020000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_stdout_controller_host/S_AXI/Mem0] MB_SEG_axi_stdout_controller_host_Mem0
#create_bd_addr_seg -range 0x10000 -offset 0x6E030000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_lite/Reg] MB_SEG_rab_lite_Reg
#create_bd_addr_seg -range 0x10000 -offset 0x6E050000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs intr_axi/Reg] MB_SEG_intr_axi_Reg
#
#create_bd_addr_seg -range 0x8000000 -offset 0x60000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_slave/Reg] MB_SEG_0_rab_slave_Reg
#create_bd_addr_seg -range 0x4000000 -offset 0x68000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_slave/Reg] MB_SEG_1_rab_slave_Reg
#create_bd_addr_seg -range 0x2000000 -offset 0x6C000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs rab_slave/Reg] MB_SEG_2_rab_slave_Reg
#
## MB
#create_bd_addr_seg -range 0x2000 -offset 0x0 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs lmb_bram_if_cntlr_0/SLMB/Mem] SEG_lmb_bram_if_cntlr_0_Mem
#create_bd_addr_seg -range 0x2000 -offset 0x0 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs lmb_bram_if_cntlr_0/SLMB1/Mem] SEG_lmb_bram_if_cntlr_0_Mem

regenerate_bd_layout
save_bd_design

