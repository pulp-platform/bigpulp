# detect board
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

set IPS      ../../fe/ips
set FPGA_RTL ../rtl

# create project
create_project pulp_cluster . -force -part $::env(XILINX_PART)
set_property board_part $XILINX_BOARD [current_project]

# set up includes
source tcl/ips_inc_dirs.tcl
set_property include_dirs $INCLUDE_DIRS [current_fileset]
set_property include_dirs $INCLUDE_DIRS [current_fileset -simset]

# setup and add source IP files
source tcl/ips_src_files.tcl
source tcl/ips_add_files.tcl

# setup and add source RTL files
source tcl/rtl_src_files.tcl
source tcl/rtl_add_files.tcl

# remove unneeded files - we have our own wrappers
remove_files $IPS/axi/axi_slice_dc/axi_slice_dc_slave_wrap.sv
remove_files $IPS/axi/axi_slice_dc/axi_slice_dc_master_wrap.sv
remove_files $IPS/axi/axi_slice/axi_slice_wrap.sv

# add FPGA files
add_files -norecurse $FPGA_RTL/cluster_clock_gating.sv
add_files -norecurse $FPGA_RTL/glitch_free_clk_mux.sv

# Set Verilog Defines.
set DEFINES "FPGA_TARGET_XILINX=1 PULP_FPGA_EMUL=1 AXI4_XCHECK_OFF=1"
if { $BOARD == "zedboard" } {
    set DEFINES "$DEFINES ZEDBOARD=1"
} elseif { $BOARD == "juno" } {
    set DEFINES "$DEFINES JUNO=1"
} elseif { $BOARD == "te0808" } {
    set DEFINES "$DEFINES ZYNQMPSOC=1"
}

set_property verilog_define $DEFINES [current_fileset]

# set pulp_cluster as top
set_property top pulp_cluster [current_fileset]

# needed only if used in batch mode
update_compile_order -fileset sources_1

# Vivado fails to recognize that CfMath is indeed referenced -> fix compile order
set_property source_mgmt_mode DisplayOnly [current_project]
reorder_files -front $IPS/pkg/cfmath/CfMath.sv

# elaborate design
synth_design -rtl -name rtl_1

###############
# 
# constraints
#
###############

# detect target clock
if [info exists ::env(CLK_PERIOD_NS)] {
    set CLK_PERIOD_NS $::env(CLK_PERIOD_NS)
} else {
  set CLK_PERIOD_NS 10.000
}
set CLK_HALFPERIOD_NS [expr ${CLK_PERIOD_NS} / 2.0]

# clocks
create_clock -period ${CLK_PERIOD_NS} -name ClkCluster_C -waveform "0.0 ${CLK_HALFPERIOD_NS}" [get_ports clk_i]
create_clock -period ${CLK_PERIOD_NS} -name ClkRef_C     -waveform "0.0 ${CLK_HALFPERIOD_NS}" [get_ports ref_clk_i]

# false paths
set_false_path -from [get_clocks ClkCluster_C] -to [get_clocks ClkRef_C     ]
set_false_path -from [get_clocks ClkRef_C    ] -to [get_clocks ClkCluster_C ]
set_false_path -from [all_inputs]
set_false_path -to   [all_outputs]

# avoid automatic insertion of IBUFs and BUFGs, these will be inserted in the top level
set_property CLOCK_BUFFER_TYPE NONE [get_nets clk_i]
set_property CLOCK_BUFFER_TYPE NONE [get_nets ref_clk_i]
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1]

# create path groups
add_files -fileset constrs_1 -norecurse xdc/create_path_groups.xdc

# save
exec mkdir -p xdc
exec touch xdc/constraints.xdc
set_property target_constrs_file xdc/constraints.xdc [current_fileset -constrset]
save_constraints -force

# needed only if used in batch mode
update_compile_order -fileset sources_1

# synthesize design
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.GATED_CLOCK_CONVERSION on [get_runs synth_1]
launch_runs synth_1
wait_on_run synth_1

# modify EDIF netlist
open_run synth_1

# save EDIF netlist
write_edif -force pulp_cluster.edf
write_verilog -force -mode synth_stub pulp_cluster_stub.v
write_verilog -force -mode funcsim pulp_cluster_funcsim.v

# reports
exec mkdir -p reports/
exec rm -rf reports/*
check_timing                                                            -file reports/pulp_cluster.check_timing.rpt 
report_timing -max_paths 100 -nworst 100 -delay_type max -sort_by slack -file reports/pulp_cluster.timing_WORST_100.rpt
report_timing -nworst 1 -delay_type max -sort_by group                  -file reports/pulp_cluster.timing.rpt
report_utilization -hierarchical                                        -file reports/pulp_cluster.utilization.rpt
