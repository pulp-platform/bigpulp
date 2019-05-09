create_bd_design "zusys"
set design_name zusys

source ../tcl/versions.tcl

# Create instance: zynq_ultra_ps_e_0, and set properties
set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:$PS_VERSION zynq_ultra_ps_e_0 ]

# Apply Trenz board preset
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  $zynq_ultra_ps_e_0
if { $::env(BOARD) == "te0808" } {
  source tcl/TEBF0808_diff_TE0808_preset.tcl
}

# Disable PCIE, USB, DP, CAN
set_property CONFIG.PSU__PCIE__PERIPHERAL__ENABLE        {0} $zynq_ultra_ps_e_0
set_property CONFIG.PSU__USB0__PERIPHERAL__ENABLE        {0} $zynq_ultra_ps_e_0
set_property CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {0} $zynq_ultra_ps_e_0
set_property CONFIG.PSU__CAN1__PERIPHERAL__ENABLE        {0} $zynq_ultra_ps_e_0

# Disable unneeded clock, video and audio
set_property CONFIG.PSU__FPGA_PL1_ENABLE {0} $zynq_ultra_ps_e_0
set_property CONFIG.PSU__USE__AUDIO      {0} $zynq_ultra_ps_e_0
set_property CONFIG.PSU__USE__VIDEO      {0} $zynq_ultra_ps_e_0

# Enable proper master interfaces
set_property CONFIG.PSU__USE__M_AXI_GP0 {1} $zynq_ultra_ps_e_0
set_property CONFIG.PSU__USE__M_AXI_GP1 {0} $zynq_ultra_ps_e_0
set_property CONFIG.PSU__USE__M_AXI_GP2 {0} $zynq_ultra_ps_e_0

# Enable proper slave interfaces
set_property CONFIG.PSU__USE__S_AXI_GP0 {1} $zynq_ultra_ps_e_0
set_property CONFIG.PSU__USE__S_AXI_GP1 {0} $zynq_ultra_ps_e_0
set_property CONFIG.PSU__USE__S_AXI_GP2 {1} $zynq_ultra_ps_e_0

# Enable HW coherency for HPC0
set_property CONFIG.PSU__AFI0_COHERENCY {1} $zynq_ultra_ps_e_0

# Enable additional reset
set_property CONFIG.PSU__NUM_FABRIC_RESETS {2} $zynq_ultra_ps_e_0

# Enable UART_1
set_property -dict [list \
  CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__UART1__PERIPHERAL__IO {EMIO} \
  CONFIG.PSU__UART1__MODEM__ENABLE {1}] \
$zynq_ultra_ps_e_0

# define host interconnect and reference clock for clock manager IP core inside bigpulp-zux_top
set_property CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ "$IC_FREQ_MHZ" $zynq_ultra_ps_e_0
set IC_FREQ_MHZ [get_property CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ $zynq_ultra_ps_e_0]
set IC_FREQ_HZ [expr ${IC_FREQ_MHZ} * 1000000]

# Create interface ports
set clking_axi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 clking_axi ]
set_property CONFIG.ADDR_WIDTH {32}        $clking_axi
set_property CONFIG.DATA_WIDTH {32}        $clking_axi
set_property CONFIG.PROTOCOL   {AXI4LITE}  $clking_axi

set intr_axi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 intr_axi ]
set_property CONFIG.ADDR_WIDTH {32}        $intr_axi
set_property CONFIG.DATA_WIDTH {64}        $intr_axi
set_property CONFIG.FREQ_HZ    $FREQ_HZ    $intr_axi
set_property CONFIG.PROTOCOL   {AXI4LITE}  $intr_axi

set rab_lite [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_lite ]
set_property CONFIG.ADDR_WIDTH {32}        $rab_lite
set_property CONFIG.DATA_WIDTH {64}        $rab_lite
set_property CONFIG.FREQ_HZ    $FREQ_HZ    $rab_lite
set_property CONFIG.PROTOCOL   {AXI4LITE}  $rab_lite

set rab_master [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_master ]
set_property CONFIG.ADDR_WIDTH            {48}         $rab_master
set_property CONFIG.ARUSER_WIDTH          {0}          $rab_master
set_property CONFIG.AWUSER_WIDTH          {0}          $rab_master
set_property CONFIG.BUSER_WIDTH           {0}          $rab_master
set_property CONFIG.DATA_WIDTH            {64}         $rab_master
set_property CONFIG.FREQ_HZ               $FREQ_HZ     $rab_master
set_property CONFIG.ID_WIDTH              {6}          $rab_master
set_property CONFIG.MAX_BURST_LENGTH      {256}        $rab_master
set_property CONFIG.NUM_READ_OUTSTANDING  {16}         $rab_master
set_property CONFIG.NUM_WRITE_OUTSTANDING {16}         $rab_master
set_property CONFIG.PHASE                 {0.000}      $rab_master
set_property CONFIG.PROTOCOL              {AXI4}       $rab_master
set_property CONFIG.READ_WRITE_MODE       {READ_WRITE} $rab_master
set_property CONFIG.RUSER_WIDTH           {0}          $rab_master
set_property CONFIG.SUPPORTS_NARROW_BURST {1}          $rab_master
set_property CONFIG.WUSER_WIDTH           {0}          $rab_master

set rab_acp [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_acp ]
set_property CONFIG.ADDR_WIDTH            {48}         $rab_acp
set_property CONFIG.ARUSER_WIDTH          {0}          $rab_acp
set_property CONFIG.AWUSER_WIDTH          {0}          $rab_acp
set_property CONFIG.BUSER_WIDTH           {0}          $rab_acp
set_property CONFIG.DATA_WIDTH            {64}         $rab_acp
set_property CONFIG.FREQ_HZ               $FREQ_HZ     $rab_acp
set_property CONFIG.ID_WIDTH              {6}          $rab_acp
set_property CONFIG.MAX_BURST_LENGTH      {256}        $rab_acp
set_property CONFIG.NUM_READ_OUTSTANDING  {16}         $rab_acp
set_property CONFIG.NUM_WRITE_OUTSTANDING {16}         $rab_acp
set_property CONFIG.PHASE                 {0.000}      $rab_acp
set_property CONFIG.PROTOCOL              {AXI4}       $rab_acp
set_property CONFIG.READ_WRITE_MODE       {READ_WRITE} $rab_acp
set_property CONFIG.RUSER_WIDTH           {0}          $rab_acp
set_property CONFIG.SUPPORTS_NARROW_BURST {1}          $rab_acp
set_property CONFIG.WUSER_WIDTH           {0}          $rab_acp

set rab_slave [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 rab_slave ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32}              ] $rab_slave
set_property -dict [ list CONFIG.DATA_WIDTH {64}              ] $rab_slave
set_property -dict [ list CONFIG.PROTOCOL {AXI4}              ] $rab_slave

set UART_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_1 ]

if { $::env(RAB_AX_LOG_EN) } {
    set rab_ar_bram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:bram_rtl:1.0 rab_ar_bram ]
    set_property -dict [ list CONFIG.MASTER_TYPE {BRAM_CTRL}  ] $rab_ar_bram

    set rab_aw_bram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:bram_rtl:1.0 rab_aw_bram ]
    set_property -dict [ list CONFIG.MASTER_TYPE {BRAM_CTRL}  ] $rab_aw_bram
}

# Create ports
set pulp2host_intr        [ create_bd_port -dir I pulp2host_intr ]

set host2pulp_gpio        [ create_bd_port -dir O -from 31 -to 0 host2pulp_gpio ]
set pulp2host_gpio        [ create_bd_port -dir I -from 31 -to 0 pulp2host_gpio ]

set ClkIcHost_CO          [ create_bd_port -dir O -type clk ClkIcHost_CO  ]
set RstIcHost_RBI         [ create_bd_port -dir I -type rst RstIcHost_RBI ]
set RstIcHostClkConv_RBI  [ create_bd_port -dir I -type rst RstIcHostClkConv_RBI ]
set RstIcHost_RBO         [ create_bd_port -dir O -type rst RstIcHost_RBO ]
set RstPulp_RBO           [ create_bd_port -dir O -type rst RstPulp_RBO   ]

set ClkIcPulp_CI          [ create_bd_port -dir I -type clk ClkIcPulp_CI  ]
set RstIcPulp_RBI         [ create_bd_port -dir I -type rst RstIcPulp_RBI ]

set ClkIcPulpGated_CI     [ create_bd_port -dir I -type clk ClkIcPulpGated_CI  ]
set RstIcPulpGated_RBI    [ create_bd_port -dir I -type rst RstIcPulpGated_RBI ]

set_property CONFIG.ASSOCIATED_BUSIF {rab_lite:rab_slave} $ClkIcPulp_CI
set_property CONFIG.ASSOCIATED_BUSIF {rab_master:rab_acp} $ClkIcPulpGated_CI
set_property CONFIG.ASSOCIATED_BUSIF {clking_axi}         $ClkIcHost_CO
set_property CONFIG.ASSOCIATED_RESET {RstIcPulp_RBI}      $ClkIcPulp_CI
set_property CONFIG.ASSOCIATED_RESET {RstIcPulpGated_RBI} $ClkIcPulpGated_CI
set_property CONFIG.ASSOCIATED_RESET {RstIcHost_RBI}      $ClkIcHost_CO
set_property CONFIG.ASSOCIATED_RESET {RstIcHostClkConv_RBI} [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

###############
#
# Modify host clocks, e.g., for benchmarking PULP as an ASIC.
#
###############
if { $::env(MOD_HOST_CLKS) } {
    # DDR frequency and timing
    set_property -dict [list CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {400} \
                             CONFIG.PSU__DDRC__SPEED_BIN     {DDR4_1600J} \
                             CONFIG.PSU__DDRC__CL                    {10} \
                             CONFIG.PSU__DDRC__T_RCD                 {10} \
                             CONFIG.PSU__DDRC__T_RP                  {10} \
                             CONFIG.PSU__DDRC__CWL                    {9} \
                             CONFIG.PSU__DDRC__T_RAS_MIN             {35} ] $zynq_ultra_ps_e_0

    # APU and interconnect (SMMU) frequency - The effective APU freuency of 300 MHz is set through sysfs at runtime.
    set_property -dict [list CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ       {1200} \
                             CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ   {71}] $zynq_ultra_ps_e_0
}

###############
#
# Host-to-PULP
#
###############

# axi_xbar_host2pulp
set axi_xbar_host2pulp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_xbar_host2pulp ]
set_property CONFIG.NUM_SI                 {1}    $axi_xbar_host2pulp
set_property CONFIG.NUM_MI                 {4}    $axi_xbar_host2pulp
set_property CONFIG.STRATEGY               {2}    $axi_xbar_host2pulp
set_property CONFIG.CONNECTIVITY_MODE      {SAMD} $axi_xbar_host2pulp
set_property CONFIG.AWUSER_WIDTH.VALUE_SRC USER   $axi_xbar_host2pulp
set_property CONFIG.ARUSER_WIDTH.VALUE_SRC USER   $axi_xbar_host2pulp
set_property CONFIG.WUSER_WIDTH.VALUE_SRC  USER   $axi_xbar_host2pulp
set_property CONFIG.BUSER_WIDTH.VALUE_SRC  USER   $axi_xbar_host2pulp
set_property CONFIG.RUSER_WIDTH.VALUE_SRC  USER   $axi_xbar_host2pulp
set_property CONFIG.AWUSER_WIDTH           {0}    $axi_xbar_host2pulp
set_property CONFIG.ARUSER_WIDTH           {0}    $axi_xbar_host2pulp
set_property CONFIG.WUSER_WIDTH            {0}    $axi_xbar_host2pulp
set_property CONFIG.BUSER_WIDTH            {0}    $axi_xbar_host2pulp
set_property CONFIG.RUSER_WIDTH            {0}    $axi_xbar_host2pulp

# connect
connect_bd_intf_net [get_bd_intf_pins axi_xbar_host2pulp/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_xbar_host2pulp/aclk]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_xbar_host2pulp/aresetn]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]

####
# clking_axi, rab_ax_bram
####
# axi_dwidth_conv_host_clk_0
set axi_dwidth_conv_host_clk_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_conv_host_clk_0 ]
set_property CONFIG.SI_DATA_WIDTH {128} $axi_dwidth_conv_host_clk_0
set_property CONFIG.MI_DATA_WIDTH {32}  $axi_dwidth_conv_host_clk_0

# axi2lite_conv_host_clk
set axi2lite_conv_host_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi2lite_conv_host_clk ]
set_property CONFIG.MI_PROTOCOL.VALUE_SRC USER       $axi2lite_conv_host_clk
set_property CONFIG.SI_PROTOCOL.VALUE_SRC USER       $axi2lite_conv_host_clk
set_property CONFIG.MI_PROTOCOL           {AXI4LITE} $axi2lite_conv_host_clk
set_property CONFIG.SI_PROTOCOL           {AXI4}     $axi2lite_conv_host_clk

# axilite_xbar_host_clk
set axilite_xbar_host_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axilite_xbar_host_clk ]
if { $::env(RAB_AX_LOG_EN) } {
  set_property CONFIG.NUM_MI {3} $axilite_xbar_host_clk
} else {
  set_property CONFIG.NUM_MI {1} $axilite_xbar_host_clk
}

# connect
connect_bd_intf_net [get_bd_intf_pins  axi_xbar_host2pulp/M00_AXI]     [get_bd_intf_pins axi_dwidth_conv_host_clk_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins  axi_dwidth_conv_host_clk_0/M_AXI] [get_bd_intf_pins axi2lite_conv_host_clk/S_AXI]
connect_bd_intf_net [get_bd_intf_pins  axi2lite_conv_host_clk/M_AXI]   [get_bd_intf_pins axilite_xbar_host_clk/S00_AXI]
connect_bd_intf_net [get_bd_intf_ports clking_axi]                     [get_bd_intf_pins axilite_xbar_host_clk/M00_AXI]

connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axilite_xbar_host_clk/aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi2lite_conv_host_clk/aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_dwidth_conv_host_clk_0/s_axi_aresetn]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_dwidth_conv_host_clk_0/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi2lite_conv_host_clk/aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axilite_xbar_host_clk/aclk]

# rab_ax_bram
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
        [ get_bd_intf_pins axilite_xbar_host_clk/M01_AXI ] \
        [ get_bd_intf_pins rab_ar_bram_ctrl_host/S_AXI ]
    connect_bd_net \
        [ get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
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
        [ get_bd_intf_pins axilite_xbar_host_clk/M02_AXI ] \
        [ get_bd_intf_pins rab_aw_bram_ctrl_host/S_AXI ]
    connect_bd_net \
        [ get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
        [ get_bd_pins rab_aw_bram_ctrl_host/s_axi_aclk ]
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

####
# intr_axi, gpio_axi, rab_lite
####
# axi_dwidth_conv_host_clk_1
set axi_dwidth_conv_host_clk_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_conv_host_clk_1 ]
set_property CONFIG.SI_DATA_WIDTH {128} $axi_dwidth_conv_host_clk_1
set_property CONFIG.MI_DATA_WIDTH {32}  $axi_dwidth_conv_host_clk_1

# axi_dwidth_conv_host_clk_2
set axi_dwidth_conv_host_clk_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_conv_host_clk_2 ]
set_property CONFIG.SI_DATA_WIDTH {128} $axi_dwidth_conv_host_clk_2
set_property CONFIG.MI_DATA_WIDTH {64}  $axi_dwidth_conv_host_clk_2

# axi_clk_conv_host2pulp_1
set axi_clk_conv_host2pulp_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clk_conv_host2pulp_1 ]

# axi_clk_conv_host2pulp_2
set axi_clk_conv_host2pulp_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clk_conv_host2pulp_2 ]

# axi2lite_conv_pulp_clk_1
set axi2lite_conv_pulp_clk_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi2lite_conv_pulp_clk_1 ]
set_property CONFIG.MI_PROTOCOL.VALUE_SRC USER       $axi2lite_conv_pulp_clk_1
set_property CONFIG.SI_PROTOCOL.VALUE_SRC USER       $axi2lite_conv_pulp_clk_1
set_property CONFIG.MI_PROTOCOL           {AXI4LITE} $axi2lite_conv_pulp_clk_1
set_property CONFIG.SI_PROTOCOL           {AXI4}     $axi2lite_conv_pulp_clk_1

# axi2lite_conv_pulp_clk_2
set axi2lite_conv_pulp_clk_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi2lite_conv_pulp_clk_2 ]
set_property CONFIG.MI_PROTOCOL.VALUE_SRC USER       $axi2lite_conv_pulp_clk_2
set_property CONFIG.SI_PROTOCOL.VALUE_SRC USER       $axi2lite_conv_pulp_clk_2
set_property CONFIG.MI_PROTOCOL           {AXI4LITE} $axi2lite_conv_pulp_clk_2
set_property CONFIG.SI_PROTOCOL           {AXI4}     $axi2lite_conv_pulp_clk_2

# axilite_xbar_pulp_clk
set axilite_xbar_pulp_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axilite_xbar_pulp_clk ]
set_property CONFIG.NUM_MI {2} $axilite_xbar_pulp_clk

# axi_pulp_ctrl
set axi_pulp_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_pulp_ctrl ]
set_property CONFIG.C_IS_DUAL        {1}          $axi_pulp_ctrl
set_property CONFIG.C_ALL_INPUTS     {1}          $axi_pulp_ctrl
set_property CONFIG.C_ALL_OUTPUTS_2  {1}          $axi_pulp_ctrl
set_property CONFIG.C_DOUT_DEFAULT_2 {0xC0000000} $axi_pulp_ctrl

# connect
connect_bd_intf_net [get_bd_intf_pins axi_xbar_host2pulp/M01_AXI] [get_bd_intf_pins axi_dwidth_conv_host_clk_1/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dwidth_conv_host_clk_1/M_AXI] [get_bd_intf_pins axi_clk_conv_host2pulp_1/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_clk_conv_host2pulp_1/M_AXI] [get_bd_intf_pins axi2lite_conv_pulp_clk_1/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi2lite_conv_pulp_clk_1/M_AXI] [get_bd_intf_pins axi_pulp_ctrl/S_AXI]

connect_bd_intf_net [get_bd_intf_pins axi_xbar_host2pulp/M02_AXI] [get_bd_intf_pins axi_dwidth_conv_host_clk_2/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dwidth_conv_host_clk_2/M_AXI] [get_bd_intf_pins axi_clk_conv_host2pulp_2/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_clk_conv_host2pulp_2/M_AXI] [get_bd_intf_pins axi2lite_conv_pulp_clk_2/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi2lite_conv_pulp_clk_2/M_AXI] [get_bd_intf_pins axilite_xbar_pulp_clk/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins axilite_xbar_pulp_clk/M00_AXI] [get_bd_intf_ports intr_axi]
connect_bd_intf_net [get_bd_intf_pins axilite_xbar_pulp_clk/M01_AXI] [get_bd_intf_ports rab_lite]

connect_bd_net [get_bd_ports pulp2host_gpio] [get_bd_pins axi_pulp_ctrl/gpio_io_i]
connect_bd_net [get_bd_ports host2pulp_gpio] [get_bd_pins axi_pulp_ctrl/gpio2_io_o]

connect_bd_net [get_bd_ports ClkIcPulp_CI] [get_bd_pins axilite_xbar_pulp_clk/aclk]
connect_bd_net [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi2lite_conv_pulp_clk_1/aclk]
connect_bd_net [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi2lite_conv_pulp_clk_2/aclk]
connect_bd_net [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_pulp_ctrl/s_axi_aclk]
connect_bd_net [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_clk_conv_host2pulp_1/m_axi_aclk]
connect_bd_net [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_clk_conv_host2pulp_2/m_axi_aclk]
connect_bd_net [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi2lite_conv_pulp_clk_1/aresetn]
connect_bd_net [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi2lite_conv_pulp_clk_2/aresetn]
connect_bd_net [get_bd_ports RstIcPulp_RBI] [get_bd_pins axilite_xbar_pulp_clk/aresetn]
connect_bd_net [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_pulp_ctrl/s_axi_aresetn]
connect_bd_net [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_clk_conv_host2pulp_1/m_axi_aresetn]
connect_bd_net [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_clk_conv_host2pulp_2/m_axi_aresetn]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_clk_conv_host2pulp_1/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_dwidth_conv_host_clk_1/s_axi_aclk]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_clk_conv_host2pulp_1/s_axi_aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_dwidth_conv_host_clk_1/s_axi_aresetn]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_clk_conv_host2pulp_2/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_dwidth_conv_host_clk_2/s_axi_aclk]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_clk_conv_host2pulp_2/s_axi_aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_dwidth_conv_host_clk_2/s_axi_aresetn]

####
# rab_slave
####

# axi_dwidth_conv_host_clk_3
set axi_dwidth_conv_host_clk_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_conv_host_clk_3 ]
set_property CONFIG.SI_DATA_WIDTH {128} $axi_dwidth_conv_host_clk_3
set_property CONFIG.MI_DATA_WIDTH {64}  $axi_dwidth_conv_host_clk_3

# axi_clk_conv_host2pulp_3
set axi_clk_conv_host2pulp_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clk_conv_host2pulp_3 ]

# connect
connect_bd_intf_net [get_bd_intf_pins axi_xbar_host2pulp/M03_AXI] [get_bd_intf_pins axi_dwidth_conv_host_clk_3/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dwidth_conv_host_clk_3/M_AXI] [get_bd_intf_pins axi_clk_conv_host2pulp_3/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_clk_conv_host2pulp_3/M_AXI] [get_bd_intf_ports rab_slave]

connect_bd_net [get_bd_ports ClkIcPulp_CI] [get_bd_pins axi_clk_conv_host2pulp_3/m_axi_aclk]
connect_bd_net [get_bd_ports RstIcPulp_RBI] [get_bd_pins axi_clk_conv_host2pulp_3/m_axi_aresetn]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_clk_conv_host2pulp_3/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_dwidth_conv_host_clk_3/s_axi_aclk]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_clk_conv_host2pulp_3/s_axi_aresetn]
connect_bd_net [get_bd_ports RstIcHost_RBI] [get_bd_pins axi_dwidth_conv_host_clk_3/s_axi_aresetn]

###
# clock and reset
###
connect_bd_net [get_bd_ports ClkIcHost_CO]  [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_ports RstIcHost_RBO] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
connect_bd_net [get_bd_ports RstPulp_RBO]   [get_bd_pins zynq_ultra_ps_e_0/pl_resetn1]

###
# UART_1
###
connect_bd_intf_net [get_bd_intf_ports UART_1] [get_bd_intf_pins zynq_ultra_ps_e_0/UART_1]

###############
#
# PULP-to-Host
#
###############

###
# Interrupt
###
connect_bd_net [get_bd_ports pulp2host_intr] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]

###
# rab_acp, rab_master
###

# axi_dwidth_conv_rab_master
set axi_dwidth_conv_rab_master [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_conv_rab_master ]
set_property CONFIG.SI_DATA_WIDTH.VALUE_SRC USER  $axi_dwidth_conv_rab_master
set_property CONFIG.MI_DATA_WIDTH.VALUE_SRC USER  $axi_dwidth_conv_rab_master
set_property CONFIG.SI_DATA_WIDTH           {64}  $axi_dwidth_conv_rab_master
set_property CONFIG.MI_DATA_WIDTH           {128} $axi_dwidth_conv_rab_master
set_property CONFIG.FIFO_MODE               {2}   $axi_dwidth_conv_rab_master

# axi_dwidth_conv_rab_acp
set axi_dwidth_conv_rab_acp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_conv_rab_acp ]
set_property CONFIG.SI_DATA_WIDTH.VALUE_SRC USER  $axi_dwidth_conv_rab_acp
set_property CONFIG.MI_DATA_WIDTH.VALUE_SRC USER  $axi_dwidth_conv_rab_acp
set_property CONFIG.SI_DATA_WIDTH           {64}  $axi_dwidth_conv_rab_acp
set_property CONFIG.MI_DATA_WIDTH           {128} $axi_dwidth_conv_rab_acp
set_property CONFIG.FIFO_MODE               {2}   $axi_dwidth_conv_rab_acp

# connect
connect_bd_intf_net [get_bd_intf_ports rab_master] [get_bd_intf_pins axi_dwidth_conv_rab_master/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dwidth_conv_rab_master/M_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]

connect_bd_intf_net [get_bd_intf_ports rab_acp] [get_bd_intf_pins axi_dwidth_conv_rab_acp/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dwidth_conv_rab_acp/M_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC0_FPD]

connect_bd_net [get_bd_ports ClkIcPulpGated_CI] [get_bd_pins axi_dwidth_conv_rab_master/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_dwidth_conv_rab_master/m_axi_aclk]
connect_bd_net [get_bd_ports RstIcHostClkConv_RBI] [get_bd_pins axi_dwidth_conv_rab_master/m_axi_aresetn]
connect_bd_net [get_bd_ports RstIcPulpGated_RBI] [get_bd_pins axi_dwidth_conv_rab_master/s_axi_aresetn]

connect_bd_net [get_bd_ports ClkIcPulpGated_CI] [get_bd_pins axi_dwidth_conv_rab_acp/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_dwidth_conv_rab_acp/m_axi_aclk]
connect_bd_net [get_bd_ports RstIcHostClkConv_RBI] [get_bd_pins axi_dwidth_conv_rab_acp/m_axi_aresetn]
connect_bd_net [get_bd_ports RstIcPulpGated_RBI] [get_bd_pins axi_dwidth_conv_rab_acp/s_axi_aresetn]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/saxihpc0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

###############
#
# Addressing
#
###############

# HOST-to-PULP
create_bd_addr_seg -range 0x10000 -offset 0xAE000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_pulp_ctrl/S_AXI/Reg] SEG_axi_pulp_ctrl_Reg
create_bd_addr_seg -range 0x10000 -offset 0xAE010000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs clking_axi/Reg] SEG_clking_axi_Reg
create_bd_addr_seg -range 0x10000 -offset 0xAE030000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rab_lite/Reg] SEG_rab_lite_Reg
create_bd_addr_seg -range 0x10000 -offset 0xAE050000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs intr_axi/Reg] SEG_intr_axi_Reg
if { $::env(RAB_AX_LOG_EN) } {
    create_bd_addr_seg -range 0x100000 -offset 0xAE100000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rab_ar_bram_ctrl_host/S_AXI/Mem0] SEG_rab_ar_bram_ctrl_host_Mem0
    create_bd_addr_seg -range 0x100000 -offset 0xAE200000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rab_aw_bram_ctrl_host/S_AXI/Mem0] SEG_rab_aw_bram_ctrl_host_Mem0
}
create_bd_addr_seg -range 0x8000000 -offset 0xA0000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rab_slave/Reg] SEG_rab_slave_Reg

# PULP-to-HOST
create_bd_addr_seg -range 64G -offset 0x0 [get_bd_addr_spaces rab_master] \
  [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] \
  SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
create_bd_addr_seg -range 64G -offset 0x0 [get_bd_addr_spaces rab_acp] \
  [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] \
  SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW

regenerate_bd_layout
save_bd_design
