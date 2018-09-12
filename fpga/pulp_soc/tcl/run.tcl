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

# create project
create_project pulp_soc . -force -part $::env(XILINX_PART)
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
remove_files $IPS/axi/axi_id_remap/axi_id_remap_wrap.sv
remove_files $IPS/axi/axi_slice_dc/axi_slice_dc_slave_wrap.sv
remove_files $IPS/axi/axi_slice_dc/axi_slice_dc_master_wrap.sv
remove_files $IPS/axi/axi_slice/axi_slice_wrap.sv
remove_files $IPS/axi/axi_node/axi_node_wrap.sv
remove_files $IPS/axi/axi_node/axi_node_wrap_with_slices.sv
remove_files $IPS/axi/axi_mem_if/axi_mem_if_wrap.sv

# Set Verilog Defines.
set DEFINES "FPGA_TARGET_XILINX=1 PULP_FPGA_EMUL=1 AXI4_XCHECK_OFF=1"
if { $BOARD == "zedboard" } {
    set DEFINES "$DEFINES ZEDBOARD=1"
} elseif { $BOARD == "juno" } {
    set DEFINES "$DEFINES HOST_IS_64_BIT=1 JUNO=1"
} elseif { $BOARD == "te0808" } {
    set DEFINES "$DEFINES HOST_IS_64_BIT=1 ZYNQMPSOC=1"
}

if { $::env(RAB_AX_LOG_EN) } { set DEFINES "$DEFINES RAB_AX_LOG_EN=1" }
set_property verilog_define $DEFINES [current_fileset]

# add Xilinx IPs
read_ip $FPGA_IPS/xilinx_mailbox/ip/xilinx_mailbox.xci
synth_ip [get_ips xilinx_mailbox]
read_ip $FPGA_IPS/xilinx_axi_xbar_rab_cfg/ip/xilinx_axi_xbar_rab_cfg.xci
synth_ip [get_ips xilinx_axi_xbar_rab_cfg]
if { ($BOARD != "juno") && ($BOARD != "te0808") } {
    read_ip $FPGA_IPS/xilinx_axi_dwidth_conv_rab_cfg/ip/xilinx_axi_dwidth_conv_rab_cfg.xci
    synth_ip [get_ips xilinx_axi_dwidth_conv_rab_cfg]
}

# add IP wrappers in FPGA_RTL
add_files -norecurse $FPGA_RTL/socbus_to_rab_cfg_conv.sv
add_files -norecurse $FPGA_RTL/xilinx_axi_xbar_rab_cfg_wrap.sv
add_files -norecurse $FPGA_RTL/xilinx_mailbox_wrap.sv
add_files -norecurse $FPGA_RTL/xilinx_mailbox_read_adaptor.sv
add_files -norecurse $FPGA_RTL/xilinx_mailbox_write_adaptor.sv

# add pulp_cluster
set FPGA_PULP_CLUSTER ../pulp_cluster
add_files -norecurse $FPGA_PULP_CLUSTER/pulp_cluster.edf
add_files -norecurse $FPGA_PULP_CLUSTER/pulp_cluster_stub.v

# add pulp_soc
add_files -norecurse $SRC_PULP_SOC

# set pulp_soc as top
set_property top pulp_soc [current_fileset]

# needed only if used in batch mode
update_compile_order -fileset sources_1

# elaborate design
#
#catch {synth_design -rtl -name rtl_1}
#update_compile_order -fileset sources_1
#
synth_design -rtl -name rtl_1

###############
# 
# constraints
#
###############

# constraints
# detect target clock
if [info exists ::env(CLK_PERIOD_NS)] {
    set CLK_PERIOD_NS $::env(CLK_PERIOD_NS)
} else {
    set CLK_PERIOD_NS 10.000
}
set CLK_HALFPERIOD_NS [expr ${CLK_PERIOD_NS} / 2.0]

# clocks
create_clock -period ${CLK_PERIOD_NS} -name ClkSocGated_C     -waveform "0.0 ${CLK_HALFPERIOD_NS}" [get_ports clk_soc_i          ]
create_clock -period ${CLK_PERIOD_NS} -name ClkSocNonGated_C  -waveform "0.0 ${CLK_HALFPERIOD_NS}" [get_ports clk_soc_non_gated_i]
create_clock -period ${CLK_PERIOD_NS} -name ClkClusterGated_C -waveform "0.0 ${CLK_HALFPERIOD_NS}" [get_ports clk_cluster_i      ]

# false paths
set_false_path -from [get_clocks ClkSocGated_C]     -to [get_clocks ClkSocNonGated_C ]
set_false_path -from [get_clocks ClkSocGated_C]     -to [get_clocks ClkClusterGated_C]
set_false_path -from [get_clocks ClkSocNonGated_C]  -to [get_clocks ClkSocGated_C    ]
set_false_path -from [get_clocks ClkSocNonGated_C]  -to [get_clocks ClkClusterGated_C]
set_false_path -from [get_clocks ClkClusterGated_C] -to [get_clocks ClkSocGated_C    ]
set_false_path -from [get_clocks ClkClusterGated_C] -to [get_clocks ClkSocNonGated_C ]

# avoid automatic insertion of IBUFs and BUFGs, these will be inserted in the top level
set_property CLOCK_BUFFER_TYPE NONE [get_nets clk_soc_i          ]
set_property CLOCK_BUFFER_TYPE NONE [get_nets clk_soc_non_gated_i]
set_property CLOCK_BUFFER_TYPE NONE [get_nets clk_cluster_i      ]
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1]

# save
exec mkdir -p xdc
exec touch xdc/constraints.xdc
set_property target_constrs_file xdc/constraints.xdc [current_fileset -constrset]
save_constraints -force

# needed only if used in batch mode
update_compile_order -fileset sources_1

# synthesize design
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]
launch_runs synth_1
wait_on_run synth_1

# save EDIF netlist
open_run synth_1
write_edif -force pulp_soc.edf
write_verilog -mode synth_stub -force pulp_soc_stub.v

# reports
exec mkdir -p reports/
exec rm -rf reports/*
check_timing                                                            -file reports/pulp_soc.check_timing.rpt 
report_timing -max_paths 100 -nworst 100 -delay_type max -sort_by slack -file reports/pulp_soc.timing_WORST_100.rpt
report_timing -nworst 1 -delay_type max -sort_by group                  -file reports/pulp_soc.timing.rpt
report_utilization -hierarchical                                        -file reports/pulp_soc.utilization.rpt
