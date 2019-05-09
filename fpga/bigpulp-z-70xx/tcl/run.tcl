set RTL ../../fe/rtl
set IPS ../../fe/ips
set FPGA_IPS ../ips
set FPGA_RTL ../rtl
set FPGA_PULP_SOC ../pulp_soc

# create project
create_project bigpulp-z-70xx . -part $::env(XILINX_PART) -force
set_property board_part $::env(XILINX_BOARD) [current_project]

# set up include directory
set_property include_dirs " \
  $RTL/components \
  $RTL/includes \
" [current_fileset]

set_property include_dirs " \
  $RTL/components \
  $RTL/includes \
" [current_fileset -simset]

# add CfMath package
add_files -norecurse $IPS/pkg/cfmath/CfMath.sv

# detect board
if [info exists ::env(BOARD)] {
    set BOARD $::env(BOARD)
}

if { $BOARD == "zedboard" } {
  # UART and clock divider are not supported on zedboard.
  set DEBUG_CLK  0
  set DEBUG_UART 0
} else {
  set DEBUG_CLK  1
  set DEBUG_UART 1
}

# Set Verilog Defines.
set DEFINES "FPGA_TARGET_XILINX=1 PULP_FPGA_EMUL=1"
if { $DEBUG_CLK }            { set DEFINES "$DEFINES DEBUG_CLK=1" }
if { $DEBUG_UART }           { set DEFINES "$DEFINES DEBUG_UART=1" }
if { $BOARD == "zedboard" }  { set DEFINES "$DEFINES ZEDBOARD=1" }
if { $::env(RAB_AX_LOG_EN) } { set DEFINES "$DEFINES RAB_AX_LOG_EN=1" }
set_property verilog_define $DEFINES [current_fileset]

# detect target clock
if [info exists ::env(CLK_PERIOD_NS)] {
  set CLK_PERIOD_NS $::env(CLK_PERIOD_NS)
} else {
  set CLK_PERIOD_NS 10.000
}
set CLK_HALFPERIOD_NS [expr ${CLK_PERIOD_NS} / 2.0]
set FREQ_HZ  [expr 1000000000 / ${CLK_PERIOD_NS}]
set FREQ_MHZ [expr ${FREQ_HZ} / 1000000]

# define host interconnect and reference clock for clock manager IP core inside bigpulp-zux_top
set IC_CLK_PERIOD_NS 10.000
set IC_CLK_HALFPERIOD_NS [expr ${IC_CLK_PERIOD_NS} / 2.0]
set IC_FREQ_HZ  [expr 1000000000 / ${IC_CLK_PERIOD_NS}]
set IC_FREQ_MHZ [expr ${IC_FREQ_HZ} / 1000000]

# detect host target clock
if [info exists ::env(HOST_CLK_MHZ)] {
  set HOST_CLK_MHZ $::env(HOST_CLK_MHZ)
} else {
  set HOST_CLK_MHZ 666 ;# default for Zynq-7000
}

# create block design
source tcl/ps7_bd.tcl

if [info exists ::env(SDK_WORKSPACE)] {
  set SDK_WORKSPACE $::env(SDK_WORKSPACE)
}
if [info exists ::env(XILINX_BOARD)] {
  set XILINX_BOARD $::env(XILINX_BOARD)
}

# validate
validate_bd_design

# generate
generate_target all [get_files ./bigpulp-z-70xx.srcs/sources_1/bd/ps7/ps7.bd]
export_ip_user_files -of_objects [get_files ./bigpulp-z-70xx.srcs/sources_1/bd/ps7/ps7.bd] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ./bigpulp-z-70xx.srcs/sources_1/bd/ps7/ps7.bd]
launch_runs -jobs 4 {\
  ps7_axi_clock_converter_0_0_synth_1 \
  ps7_axi_clock_converter_1_0_synth_1 \
  ps7_axi_clock_converter_acp_0_synth_1 \
  ps7_axi_crossbar_0_0_synth_1 \
  ps7_axi_crossbar_1_0_synth_1 \
  ps7_axi_dwidth_converter_0_0_synth_1 \
  ps7_axi_protocol_converter_0_0_synth_1 \
  ps7_axi_protocol_converter_1_0_synth_1 \
  ps7_axi_protocol_converter_2_0_synth_1 \
  ps7_axi_protocol_converter_3_0_synth_1 \
  ps7_axi_protocol_converter_acp_0_synth_1 \
  ps7_axi_pulp_control_0_synth_1 \
  ps7_processing_system7_0_0_synth_1 \
}
if { $::env(RAB_AX_LOG_EN) } {
  launch_runs -jobs 4 {\
    ps7_axi_protocol_conv_ar_log_0_synth_1 \
    ps7_axi_protocol_conv_aw_log_0_synth_1 \
    ps7_rab_ar_bram_ctrl_host_0_synth_1 \
    ps7_rab_aw_bram_ctrl_host_0_synth_1 \
  }
}

wait_on_run ps7_axi_clock_converter_0_0_synth_1
wait_on_run ps7_axi_clock_converter_1_0_synth_1
wait_on_run ps7_axi_clock_converter_acp_0_synth_1
wait_on_run ps7_axi_crossbar_0_0_synth_1
wait_on_run ps7_axi_crossbar_1_0_synth_1
wait_on_run ps7_axi_dwidth_converter_0_0_synth_1
wait_on_run ps7_axi_protocol_converter_0_0_synth_1
wait_on_run ps7_axi_protocol_converter_1_0_synth_1
wait_on_run ps7_axi_protocol_converter_2_0_synth_1
wait_on_run ps7_axi_protocol_converter_3_0_synth_1
wait_on_run ps7_axi_protocol_converter_acp_0_synth_1
wait_on_run ps7_axi_pulp_control_0_synth_1
wait_on_run ps7_processing_system7_0_0_synth_1
if { $::env(RAB_AX_LOG_EN) } {
  wait_on_run ps7_axi_protocol_conv_ar_log_0_synth_1
  wait_on_run ps7_axi_protocol_conv_aw_log_0_synth_1
  wait_on_run ps7_rab_ar_bram_ctrl_host_0_synth_1
  wait_on_run ps7_rab_aw_bram_ctrl_host_0_synth_1
}

# create and add wrapper
make_wrapper -files [get_files ./bigpulp-z-70xx.srcs/sources_1/bd/ps7/ps7.bd] -top
add_files -norecurse ./bigpulp-z-70xx.srcs/sources_1/bd/ps7/hdl/ps7_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add bigpulp-z-70xx_top
#add_files -norecurse ../../fe/ips/common_cells/generic_fifo.sv
add_files -norecurse $FPGA_RTL/clk_rst_gen.sv
add_files -norecurse $FPGA_RTL/axi_intr_reg.sv
add_files -norecurse $RTL/components/pulp_interfaces.sv
add_files -norecurse rtl/bigpulp-z-70xx_top.sv
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add pulp_soc
add_files -norecurse ../pulp_soc/pulp_soc.edf \
                     ../pulp_soc/pulp_soc_stub.v

# add clock_manager
read_ip $FPGA_IPS/xilinx_clock_manager/ip/xilinx_clock_manager.xci
synth_ip [get_ips xilinx_clock_manager]

# set top
set_property top bigpulp_z_70xx_top [current_fileset]

# needed only if used in batch mode
update_compile_order -fileset sources_1

# Vivado fails to recognize that CfMath is indeed referenced -> fix compile order
set_property source_mgmt_mode DisplayOnly [current_project]
reorder_files -front $IPS/pkg/cfmath/CfMath.sv

# elaborate
synth_design -rtl -name rtl_1

# clocks
create_clock -period ${CLK_PERIOD_NS} -name ClkSoc_C     -waveform "0.0 ${CLK_HALFPERIOD_NS}" [get_nets {clk_rst_gen_i/clk_manager_i/clk_out1}]
create_clock -period ${CLK_PERIOD_NS} -name ClkCluster_C -waveform "0.0 ${CLK_HALFPERIOD_NS}" [get_nets {clk_rst_gen_i/clk_manager_i/clk_out2}]

# false paths
set_false_path -from [get_clocks ClkCluster_C] -to [get_clocks ClkSoc_C     ]
set_false_path -from [get_clocks ClkSoc_C    ] -to [get_clocks ClkCluster_C ]

set_false_path -through [get_cells clk_rst_gen_i/clk_manager_i*]

# I/Os: FMC_LA
if { $DEBUG_UART } {
  set_property IOSTANDARD LVCMOS25 [get_ports {uart_tx_o uart_rx_o}]
  # FPGA P28 = FMC_LA32_N = FMC H38
  set_property PACKAGE_PIN P28 [get_ports uart_tx_o]
  # FPGA N29 = FMC_LA33_P = FMC G36
  set_property PACKAGE_PIN N29 [get_ports uart_rx_o]
}
if { $DEBUG_CLK } {
  set_property IOSTANDARD LVCMOS25 [get_ports {clk_div_o}]
  # FPGA P30 = FMC_LA30_P = FMC H34
  set_property PACKAGE_PIN P30 [get_ports clk_div_o]
}

# save
exec mkdir -p xdc
exec touch xdc/constraints.xdc
set_property target_constrs_file xdc/constraints.xdc [current_fileset -constrset]
save_constraints -force

# needed only if used in batch mode
update_compile_order -fileset sources_1

# Vivado fails to recognize that CfMath is indeed referenced -> fix compile order
set_property source_mgmt_mode DisplayOnly [current_project]
reorder_files -front $IPS/pkg/cfmath/CfMath.sv

# disable hierarchy flattening for debugging
#set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]

# launch synthesis
launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1
set_property needs_refresh false [get_runs synth_1]

# export hardware design for sdk
if [info exists ::env(SDK_WORKSPACE)] {
    exec mkdir -p $SDK_WORKSPACE/
    write_hwdef -force -file $SDK_WORKSPACE/bigpulp-z-70xx.hdf
} else {
    write_hwdef -force -file ./bigpulp-z-70xx.hwdef
}

# run implementation
source tcl/impl.tcl
