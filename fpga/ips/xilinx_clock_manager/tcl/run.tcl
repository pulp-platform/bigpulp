set partNumber $::env(XILINX_PART)

if [info exists ::env(BOARD)] {
    set BOARD $::env(BOARD)
}
if [info exists ::env(XILINX_BOARD)] {
	set boardName  $::env(XILINX_BOARD)
}

# set path for Trenz board files -> should go into Vivado setup
if { $BOARD == "te0808" } {
    set_param board.repoPaths "/usr/scratch/larain/vogelpi/te0808/petalinux/TEBF0808_Release_2017.1/board_files"
    set boardName "trenz.biz:te0808_2es2_tebf0808:part0:2.0"
}

set ipName xilinx_clock_manager

create_project $ipName . -part $partNumber
set_property board_part $boardName [current_project]

create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name $ipName

set_property -dict [list CONFIG.USE_DYN_RECONFIG {true} CONFIG.CLKOUT2_USED {true} CONFIG.NUM_OUT_CLKS {2} ] [get_ips xilinx_clock_manager]

if { $BOARD == "zedboard" } {
  # bigpulp-z-7020: default 50 -> 25 MHz
  set_property -dict [list \
    CONFIG.PRIM_IN_FREQ               {50} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {25} \
    CONFIG.CLKIN1_JITTER_PS           {200.0} \
    CONFIG.MMCM_DIVCLK_DIVIDE         {1} \
    CONFIG.MMCM_CLKFBOUT_MULT_F       {20.000} \
    CONFIG.MMCM_CLKIN1_PERIOD         {20.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F      {40.000} \
    CONFIG.MMCM_CLKOUT1_DIVIDE        {40} \
    CONFIG.CLKOUT1_JITTER             {236.428} \
    CONFIG.CLKOUT1_PHASE_ERROR        {164.985} \
    CONFIG.CLKOUT2_JITTER             {236.428} \
    CONFIG.CLKOUT2_PHASE_ERROR        {164.985} \
  ] [get_ips xilinx_clock_manager]
} elseif { $BOARD == "juno" } {
  # bigpulp: default 100 -> 25 MHz
  set_property -dict [list \
    CONFIG.PRIM_IN_FREQ               {100} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {25} \
    CONFIG.MMCM_DIVCLK_DIVIDE         {1} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F      {40.000} \
    CONFIG.MMCM_CLKOUT1_DIVIDE        {40} \
    CONFIG.CLKOUT1_JITTER             {175.402} \
    CONFIG.CLKOUT2_JITTER             {175.402} \
    CONFIG.CLKOUT2_PHASE_ERROR        {98.575} \
  ] [get_ips xilinx_clock_manager]
} elseif { $BOARD == "te0808" || $BOARD == "zcu102" } {
  # bigpulp-zux: default 100 -> 50 MHz
  set_property -dict [list \
    CONFIG.PRIM_IN_FREQ               {100} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} \
    CONFIG.MMCM_DIVCLK_DIVIDE         {1} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F      {24.000} \
    CONFIG.MMCM_CLKOUT1_DIVIDE        {24} \
    CONFIG.CLKOUT1_JITTER             {132.683} \
    CONFIG.CLKOUT2_JITTER             {132.683} \
  ] [get_ips xilinx_clock_manager]
  ## bigpulp-zux: default 300 -> 50 MHz
  #set_property -dict [list \
  #  CONFIG.PRIM_IN_FREQ               {300.000} \
  #  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000} \
  #  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} \
  #  CONFIG.CLKIN1_JITTER_PS           {33.330000000000005} \
  #  CONFIG.MMCM_DIVCLK_DIVIDE         {1} \
  #  CONFIG.MMCM_CLKFBOUT_MULT_F       {4.000} \
  #  CONFIG.MMCM_CLKIN1_PERIOD         {3.333} \
  #  CONFIG.MMCM_CLKIN2_PERIOD         {10.0} \
  #  CONFIG.MMCM_CLKOUT0_DIVIDE_F      {24.000} \
  #  CONFIG.MMCM_CLKOUT1_DIVIDE        {24} \
  #  CONFIG.CLKOUT1_JITTER             {116.415} \
  #  CONFIG.CLKOUT1_PHASE_ERROR        {77.836} \
  #  CONFIG.CLKOUT2_JITTER             {116.415} \
  #  CONFIG.CLKOUT2_PHASE_ERROR        {77.836} \
  #] [get_ips xilinx_clock_manager]
} else { 
  # bigpulp-z-7045, default 100 -> 50 MHz
  set_property -dict [list \
    CONFIG.PRIM_IN_FREQ               {100} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50} \
    CONFIG.CLKIN1_JITTER_PS           {100.0} \
    CONFIG.MMCM_DIVCLK_DIVIDE         {1} \
    CONFIG.MMCM_CLKFBOUT_MULT_F       {10.000} \
    CONFIG.MMCM_CLKIN1_PERIOD         {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F      {20.000} \
    CONFIG.MMCM_CLKOUT1_DIVIDE        {20} \
    CONFIG.CLKOUT1_JITTER             {151.636} \
    CONFIG.CLKOUT1_PHASE_ERROR        {98.575} \
    CONFIG.CLKOUT2_JITTER             {151.636} \
    CONFIG.CLKOUT2_PHASE_ERROR        {98.575} \
  ] [get_ips xilinx_clock_manager]
}

generate_target all [get_files  ./$ipName.srcs/sources_1/ip/$ipName/$ipName.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ipName.srcs/sources_1/ip/$ipName/$ipName.xci]
launch_run -jobs 8 ${ipName}_synth_1
wait_on_run ${ipName}_synth_1
