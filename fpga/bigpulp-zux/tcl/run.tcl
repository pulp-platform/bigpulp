if [info exists ::env(BOARD)] {
    set BOARD $::env(BOARD)
}
if [info exists ::env(XILINX_BOARD)] {
    set XILINX_BOARD $::env(XILINX_BOARD)
}

# set path for Trenz board files -> should go into Vivado setup
if { $BOARD == "te0808" } {
    set_param board.repoPaths "/usr/scratch/larain/vogelpi/te0808/petalinux/TEBF0808_Release_2017.1/board_files"
    set XILINX_BOARD "trenz.biz:te0808_2es2_tebf0808:part0:2.0"
}

set RTL ../../fe/rtl
set IPS ../../fe/ips
set FPGA_IPS ../ips
set FPGA_RTL ../rtl
set FPGA_PULP_SOC ../pulp_soc

# create project
create_project bigpulp-zux . -part $::env(XILINX_PART) -force
set_property board_part $XILINX_BOARD [current_project]

# add CfMath package
add_files -norecurse $IPS/pkg/cfmath/CfMath.sv

# set up include directory
set_property include_dirs " \
    $RTL/components \
    $RTL/includes \
" [current_fileset]

set_property include_dirs " \
    $RTL/components \
    $RTL/includes \
" [current_fileset -simset]

# UART and clock divider are not supported on TE0808.
set DEBUG_CLK  0
set DEBUG_UART 0

# Set Verilog Defines.
set DEFINES "FPGA_TARGET_XILINX=1 PULP_FPGA_EMUL=1"
if { $DEBUG_CLK }            { set DEFINES "$DEFINES DEBUG_CLK=1" }
if { $DEBUG_UART }           { set DEFINES "$DEFINES DEBUG_UART=1" }
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

# create block design
source tcl/zusys_bd.tcl

if [info exists ::env(SDK_WORKSPACE)] {
    set SDK_WORKSPACE $::env(SDK_WORKSPACE)
}

# validate
validate_bd_design

# generate
generate_target all [get_files ./bigpulp-zux.srcs/sources_1/bd/zusys/zusys.bd]
export_ip_user_files -of_objects [get_files ./bigpulp-zux.srcs/sources_1/bd/zusys/zusys.bd] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ./bigpulp-zux.srcs/sources_1/bd/zusys/zusys.bd]
launch_runs -jobs 4 {\
  zusys_zynq_ultra_ps_e_0_0_synth_1 \
  zusys_axi_xbar_host2pulp_0_synth_1 \
  zusys_axi_dwidth_conv_host_clk_0_0_synth_1 \
  zusys_axi2lite_conv_host_clk_0_synth_1 \
  zusys_axilite_xbar_host_clk_0_synth_1 \
  zusys_rab_ar_bram_ctrl_host_0_synth_1 \
  zusys_rab_aw_bram_ctrl_host_0_synth_1 \
  zusys_axi_dwidth_conv_host_clk_1_0_synth_1 \
  zusys_axi_dwidth_conv_host_clk_2_0_synth_1 \
  zusys_axi_clk_conv_host2pulp_1_0_synth_1 \
  zusys_axi_clk_conv_host2pulp_2_0_synth_1 \
  zusys_axi2lite_conv_pulp_clk_1_0_synth_1 \
  zusys_axi2lite_conv_pulp_clk_2_0_synth_1 \
  zusys_axilite_xbar_pulp_clk_0_synth_1 \
  zusys_axi_pulp_ctrl_0_synth_1 \
  zusys_axi_dwidth_conv_host_clk_3_0_synth_1 \
  zusys_axi_clk_conv_host2pulp_3_0_synth_1 \
  zusys_axi_dwidth_conv_rab_master_0_synth_1 \
  zusys_axi_dwidth_conv_rab_acp_0_synth_1\
}

wait_on_run zusys_zynq_ultra_ps_e_0_0_synth_1
wait_on_run zusys_axi_xbar_host2pulp_0_synth_1
wait_on_run zusys_axi_dwidth_conv_host_clk_0_0_synth_1
wait_on_run zusys_axi2lite_conv_host_clk_0_synth_1
wait_on_run zusys_axilite_xbar_host_clk_0_synth_1
wait_on_run zusys_rab_ar_bram_ctrl_host_0_synth_1
wait_on_run zusys_rab_aw_bram_ctrl_host_0_synth_1
wait_on_run zusys_axi_dwidth_conv_host_clk_1_0_synth_1
wait_on_run zusys_axi_dwidth_conv_host_clk_2_0_synth_1
wait_on_run zusys_axi_clk_conv_host2pulp_1_0_synth_1
wait_on_run zusys_axi_clk_conv_host2pulp_2_0_synth_1
wait_on_run zusys_axi2lite_conv_pulp_clk_1_0_synth_1
wait_on_run zusys_axi2lite_conv_pulp_clk_2_0_synth_1
wait_on_run zusys_axilite_xbar_pulp_clk_0_synth_1
wait_on_run zusys_axi_pulp_ctrl_0_synth_1
wait_on_run zusys_axi_dwidth_conv_host_clk_3_0_synth_1
wait_on_run zusys_axi_clk_conv_host2pulp_3_0_synth_1
wait_on_run zusys_axi_dwidth_conv_rab_master_0_synth_1
wait_on_run zusys_axi_dwidth_conv_rab_acp_0_synth_1

# create and add wrapper
make_wrapper -files [get_files ./bigpulp-zux.srcs/sources_1/bd/zusys/zusys.bd] -top
add_files -norecurse ./bigpulp-zux.srcs/sources_1/bd/zusys/hdl/zusys_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add bigpulp-zux_top
add_files -norecurse $FPGA_RTL/clk_rst_gen.sv
add_files -norecurse $FPGA_RTL/axi_intr_reg.sv
add_files -norecurse $RTL/components/pulp_interfaces.sv
add_files -norecurse rtl/bigpulp-zux_top.sv
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add pulp_soc
add_files -norecurse ../pulp_soc/pulp_soc.edf \
                     ../pulp_soc/pulp_soc_stub.v

# add clock_manager
read_ip $FPGA_IPS/xilinx_clock_manager/ip/xilinx_clock_manager.xci
synth_ip [get_ips xilinx_clock_manager]

# set top
set_property top bigpulp_zux_top [current_fileset]

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
    write_hwdef -force -file $SDK_WORKSPACE/bigpulp-zux.hdf
} else {
    write_hwdef -force -file ./bigpulp-zux.hwdef
}

# run implementation
source tcl/impl.tcl
