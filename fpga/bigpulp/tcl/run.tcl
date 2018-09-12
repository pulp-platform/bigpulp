# Set relative path variables
set RTL ../../fe/rtl
set IPS ../../fe/ips
set FPGA_IPS ../ips
set FPGA_RTL ../rtl
set FPGA_PULP_SOC ../pulp_soc
set JUNO_SUPPORT_PATH $::env(JUNO_SUPPORT_PATH)
if ![file exists $JUNO_SUPPORT_PATH] {
  error "ERROR: Could not find juno-support repository. Please download it and configure sourceme.sh as shown in README.md!"
}

# create project
create_project bigpulp . -part $::env(XILINX_PART) -force
set_property board_part $::env(XILINX_BOARD) [current_project]

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

# Set Verilog Defines.
set DEFINES "FPGA_TARGET_XILINX=1 PULP_FPGA_EMUL=1"
if { $::env(RAB_AX_LOG_EN) } { set DEFINES "$DEFINES RAB_AX_LOG_EN=1" }
set_property verilog_define $DEFINES [current_fileset]

# detect target clock
if [info exists ::env(CLK_PERIOD_NS)] {
    set CLK_PERIOD_NS $::env(CLK_PERIOD_NS)
} else {
    set CLK_PERIOD_NS 10.000
}
set CLK_HALFPERIOD_NS [expr ${CLK_PERIOD_NS} / 2.0]

# create block design
source tcl/ic_wrapper_bd.tcl

# validate
validate_bd_design

# generate
generate_target all [get_files ./bigpulp.srcs/sources_1/bd/ic/ic.bd]
export_ip_user_files -of_objects [get_files ./bigpulp.srcs/sources_1/bd/ic/ic.bd] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ./bigpulp.srcs/sources_1/bd/ic/ic.bd]
launch_runs -jobs 4 {\
  ic_axi_dwidth_converter_pulp2host_0_synth_1 \
  ic_axi_crossbar_host2pulp_0_synth_1 \
  ic_axi_clock_converter_host2pulp_0_synth_1 \
  ic_axi_crossbar_liteORaxi_0_synth_1 \
  ic_axi_protocol_converter_axi2lite_0_synth_1 \
  ic_axi_crossbar_lite_pulp_clk_0_synth_1 \
  ic_axi_dwidth_converter_ctrl_0_synth_1 \
  ic_axi_pulp_control_0_synth_1 \
  ic_axi_dwidth_converter_host2pulp_0_synth_1 \
  ic_axi_crossbar_lite_host_clk_0_synth_1 \
  ic_axi_protocol_converter_axi2lite_host_clk_0_synth_1 \
  ic_rab_ar_bram_ctrl_host_0_synth_1 \
  ic_rab_aw_bram_ctrl_host_0_synth_1 \
  ic_mdm_0_0_synth_1 \
  ic_microblaze_0_0_synth_1 \
  ic_proc_sys_reset_0_0_synth_1 \
  ic_lmb_bram_if_cntlr_0_0_synth_1 \
  ic_blk_mem_gen_0_0_synth_1 \
  ic_axi_protocol_converter_axi2lite_stdout_0_synth_1 \
  ic_axi_dwidth_converter_stdout_0_synth_1 \
  ic_auto_pc_0_synth_1 ic_auto_us_0_synth_1\
}

wait_on_run ic_axi_dwidth_converter_pulp2host_0_synth_1
wait_on_run ic_axi_crossbar_host2pulp_0_synth_1
wait_on_run ic_axi_clock_converter_host2pulp_0_synth_1
wait_on_run ic_axi_crossbar_liteORaxi_0_synth_1
wait_on_run ic_axi_protocol_converter_axi2lite_0_synth_1
wait_on_run ic_axi_crossbar_lite_pulp_clk_0_synth_1
wait_on_run ic_axi_dwidth_converter_ctrl_0_synth_1
wait_on_run ic_axi_pulp_control_0_synth_1
wait_on_run ic_axi_dwidth_converter_host2pulp_0_synth_1
wait_on_run ic_axi_crossbar_lite_host_clk_0_synth_1
wait_on_run ic_axi_protocol_converter_axi2lite_host_clk_0_synth_1
wait_on_run ic_rab_ar_bram_ctrl_host_0_synth_1
wait_on_run ic_rab_aw_bram_ctrl_host_0_synth_1
wait_on_run ic_mdm_0_0_synth_1
wait_on_run ic_microblaze_0_0_synth_1
wait_on_run ic_proc_sys_reset_0_0_synth_1
wait_on_run ic_lmb_bram_if_cntlr_0_0_synth_1
wait_on_run ic_blk_mem_gen_0_0_synth_1
wait_on_run ic_axi_protocol_converter_axi2lite_stdout_0_synth_1
wait_on_run ic_axi_dwidth_converter_stdout_0_synth_1
wait_on_run ic_auto_pc_0_synth_1
wait_on_run ic_auto_us_0_synth_1

# create and add wrapper
make_wrapper -files [get_files ./bigpulp.srcs/sources_1/bd/ic/ic.bd] -top
add_files -norecurse ./bigpulp.srcs/sources_1/bd/ic/hdl/ic_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add bigpulp_top
add_files -norecurse $FPGA_RTL/clk_rst_gen.sv
add_files -norecurse $FPGA_RTL/axi_intr_reg.sv
add_files -norecurse $RTL/components/pulp_interfaces.sv
add_files -norecurse rtl/bigpulp_top.sv
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add pulp_soc
exec scripts/patch_netlist.sh
add_files -norecurse pulp_soc.edf \
                     pulp_soc_stub.v

# add clock_manager
read_ip $FPGA_IPS/xilinx_clock_manager/ip/xilinx_clock_manager.xci
synth_ip [get_ips xilinx_clock_manager]

# add LogicTile RTL files
add_files -norecurse $JUNO_SUPPORT_PATH/ips/scc.v
add_files -norecurse $JUNO_SUPPORT_PATH/ips/Clock_gen_1_32.v
add_files -norecurse $JUNO_SUPPORT_PATH/ips/RESETsync.v

# add TLX
add_files -norecurse $JUNO_SUPPORT_PATH/ips/mod_nic400_tlx_axi_tmif_fpga_side.dcp
add_files -norecurse $JUNO_SUPPORT_PATH/ips/mod_nic400_tlx_axi_tsif_fpga_side.dcp

# add LogicTile Wrapper
add_files -norecurse $JUNO_SUPPORT_PATH/rtl/logictile_wrapper.v

# set top
set_property top logictile_wrapper [current_fileset]

# needed only if used in batch mode
update_compile_order -fileset sources_1

# Vivado fails to recognize that CfMath is indeed referenced -> fix compile order
set_property source_mgmt_mode DisplayOnly [current_project]
reorder_files -front $IPS/pkg/cfmath/CfMath.sv

# elaborate design
synth_design -rtl -name rtl_1

# clocks
create_clock -period ${CLK_PERIOD_NS} -name ClkSoc_C     -waveform "0.0 ${CLK_HALFPERIOD_NS}" [get_nets {bigpulp_top_i/clk_rst_gen_i/clk_manager_i/clk_out1}]
create_clock -period ${CLK_PERIOD_NS} -name ClkCluster_C -waveform "0.0 ${CLK_HALFPERIOD_NS}" [get_nets {bigpulp_top_i/clk_rst_gen_i/clk_manager_i/clk_out2}]

# false paths
set_false_path -from [get_clocks ClkCluster_C] -to [get_clocks ClkSoc_C     ]
set_false_path -from [get_clocks ClkSoc_C    ] -to [get_clocks ClkCluster_C ]

set_false_path -through [get_cells bigpulp_top_i/clk_rst_gen_i/clk_manager_i*]

# import LogicTile constraints
read_xdc $JUNO_SUPPORT_PATH/xdc/logictile_wrapper.xdc

set_false_path -from [get_clocks ClkSoc_C] -to [get_clocks tlx_out ]
set_false_path -from [get_clocks tlx_out ] -to [get_clocks ClkSoc_C]

set_false_path -from [get_clocks ClkSoc_C    ] -to [get_clocks tsif_x1_clk ]
set_false_path -from [get_clocks tsif_x1_clk ] -to [get_clocks ClkSoc_C    ]

#set_false_path -from [get_clocks ClkCluster_C] -to [get_clocks tlx_out     ]
#set_false_path -from [get_clocks tlx_out     ] -to [get_clocks ClkCluster_C]

#set_false_path -from [get_clocks ClkSoc_C] -to [get_clocks osc0    ]
#set_false_path -from [get_clocks osc0    ] -to [get_clocks ClkSoc_C]

#set_false_path -from [get_clocks ClkCluster_C] -to [get_clocks osc0        ]
#set_false_path -from [get_clocks osc0        ] -to [get_clocks ClkCluster_C]

set_false_path -through [get_cells bigpulp_top_i/clk_rst_gen_i/clk_manager_i*]

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

# run implementation
source tcl/impl.tcl
