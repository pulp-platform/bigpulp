# detect board
if [info exists ::env(BOARD)] {
    set BOARD $::env(BOARD)
}

# Set relative path variables
set RTL ../../../fe/rtl
set IPS ../../../fe/ips
set FPGA_IPS ../../ips
set FPGA_RTL ../../rtl

# create project
create_project sim-bigpulp . -part $::env(XILINX_PART) -force
set_property board_part $::env(XILINX_BOARD) [current_project]

set PULP_FPGA_SIM 1

##################################################################
#
#                          PULP_CLUSTER
#
##################################################################
set PULP_CLUSTER ../../pulp_cluster

# setup and add source IP files
source $PULP_CLUSTER/tcl/ips_src_files.tcl
source $PULP_CLUSTER/tcl/ips_add_files.tcl

# setup and add source RTL files
source $PULP_CLUSTER/tcl/rtl_src_files.tcl
source $PULP_CLUSTER/tcl/rtl_add_files.tcl

# add FPGA files
add_files -norecurse $FPGA_RTL/cluster_clock_gating.sv
add_files -norecurse $FPGA_RTL/glitch_free_clk_mux.sv

##################################################################
#
#                           PULP_SOC
#
##################################################################
set PULP_SOC ../../pulp_soc

# setup and add source IP files
source $PULP_SOC/tcl/ips_src_files.tcl
source $PULP_SOC/tcl/ips_add_files.tcl

# setup and add source RTL files
source $PULP_SOC/tcl/rtl_src_files.tcl
source $PULP_SOC/tcl/rtl_add_files.tcl

# add Xilinx IPs
read_ip $FPGA_IPS/xilinx_mailbox/ip/xilinx_mailbox.xci
synth_ip [get_ips xilinx_mailbox]
read_ip $FPGA_IPS/xilinx_axi_xbar_rab_cfg/ip/xilinx_axi_xbar_rab_cfg.xci
synth_ip [get_ips xilinx_axi_xbar_rab_cfg]

# add IP wrappers in FPGA_RTL
add_files -norecurse $FPGA_RTL/socbus_to_rab_cfg_conv.sv
add_files -norecurse $FPGA_RTL/xilinx_axi_xbar_rab_cfg_wrap.sv
add_files -norecurse $FPGA_RTL/xilinx_mailbox_wrap.sv
add_files -norecurse $FPGA_RTL/xilinx_mailbox_read_adaptor.sv
add_files -norecurse $FPGA_RTL/xilinx_mailbox_write_adaptor.sv

# generic L2 memory for simulation
add_files -norecurse $RTL/components/generic_memory.sv

# add riscv_tracer.sv this should be added through the IPApprox infrastructure
add_files -norecurse $IPS/riscv/riscv_tracer.sv

# remove unneeded files - we have our own wrappers
remove_files $IPS/axi/axi_id_remap/axi_id_remap_wrap.sv
remove_files $IPS/axi/axi_slice_dc/axi_slice_dc_slave_wrap.sv
remove_files $IPS/axi/axi_slice_dc/axi_slice_dc_master_wrap.sv
remove_files $IPS/axi/axi_slice/axi_slice_wrap.sv
remove_files $IPS/axi/axi_node/axi_node_wrap.sv
remove_files $IPS/axi/axi_node/axi_node_wrap_with_slices.sv

# include dirs
source $PULP_CLUSTER/tcl/ips_inc_dirs.tcl
source $PULP_SOC/tcl/ips_inc_dirs.tcl

cd ..
set_property include_dirs $INCLUDE_DIRS [current_fileset]
set_property include_dirs $INCLUDE_DIRS [current_fileset -simset]
cd vivado

# Set Verilog Defines.
set DEFINES "FPGA_TARGET_XILINX=1 PULP_FPGA_EMUL=1 PULP_FPGA_SIM=1"
if { $BOARD == "zedboard" } {
    set DEFINES "$DEFINES ZEDBOARD=1"
} elseif { $BOARD == "juno" } {
    set DEFINES "$DEFINES HOST_IS_64_BIT=1 JUNO=1"
} elseif { $BOARD == "te0808" } {
    set DEFINES "$DEFINES HOST_IS_64_BIT=1 ZYNQMPSOC=1"
}
if { $::env(RAB_AX_LOG_EN) } { set DEFINES "$DEFINES RAB_AX_LOG_EN=1" }
set_property verilog_define $DEFINES [current_fileset]
set_property verilog_define $DEFINES [current_fileset -simset]

##################################################################
#
#                          BIGPULP
#
##################################################################
set BIGPULP ../../bigpulp
source $BIGPULP/tcl/ic_wrapper_bd.tcl

# It seems that the simulation model for the combined Xilinx clock and data width converter
# is not working. In particular, the read data returned to the slave side is always 0.
#
# Thus, we replace it with clock conversion only for simulation.
set REPLACE_XILINX_DWIDTH_CONV 1

# remove tsif
delete_bd_objs [get_bd_intf_nets axi_dwidth_converter_pulp2host_M_AXI]
delete_bd_objs [get_bd_intf_ports tsif]

# replace Xilinx DWIDTH converters
if { $REPLACE_XILINX_DWIDTH_CONV } {
  delete_bd_objs [get_bd_intf_nets rab_master_1]
  delete_bd_objs [get_bd_nets ClkIcPulpGated_CI_1] [get_bd_nets ClkIcHostClkConv_CI_1]
  delete_bd_objs [get_bd_nets RstIcPulpGated_RBI_1] [get_bd_nets RstIcHostClkConv_RBI_1]
  delete_bd_objs [get_bd_cells axi_dwidth_converter_pulp2host]

  set axi_clk_conv_rab_master [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_conv_rab_master ]

  connect_bd_intf_net [get_bd_intf_ports rab_master] [get_bd_intf_pins axi_clock_conv_rab_master/S_AXI]

  connect_bd_net [get_bd_ports RstIcHostClkConv_RBI] [get_bd_pins axi_clock_conv_rab_master/m_axi_aresetn]
  connect_bd_net [get_bd_ports RstIcPulpGated_RBI]   [get_bd_pins axi_clock_conv_rab_master/s_axi_aresetn]
  connect_bd_net [get_bd_ports ClkIcPulpGated_CI]    [get_bd_pins axi_clock_conv_rab_master/s_axi_aclk]
  connect_bd_net [get_bd_ports ClkIcHostClkConv_CI]  [get_bd_pins axi_clock_conv_rab_master/m_axi_aclk]
}

# replace tsif with BRAM
if { $REPLACE_XILINX_DWIDTH_CONV } {
  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_tsif_replacement
  set_property -dict [list CONFIG.DATA_WIDTH {64} CONFIG.SINGLE_PORT_BRAM {1} CONFIG.ECC_TYPE {0}] [get_bd_cells axi_bram_ctrl_tsif_replacement]

  create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:${BLK_MEM_GEN_VERSION} blk_mem_gen_tsif_replacement

  connect_bd_intf_net [get_bd_intf_pins axi_clock_conv_rab_master/M_AXI] [get_bd_intf_pins axi_bram_ctrl_tsif_replacement/S_AXI]
} else {
  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_tsif_replacement
  set_property -dict [list CONFIG.DATA_WIDTH {128} CONFIG.SINGLE_PORT_BRAM {1} CONFIG.ECC_TYPE {0}] [get_bd_cells axi_bram_ctrl_tsif_replacement]

  create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:${BLK_MEM_GEN_VERSION} blk_mem_gen_tsif_replacement

  connect_bd_intf_net [get_bd_intf_pins axi_dwidth_converter_pulp2host/M_AXI] [get_bd_intf_pins axi_bram_ctrl_tsif_replacement/S_AXI]
}

connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_tsif_replacement/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_tsif_replacement/BRAM_PORTA]

connect_bd_net -net [get_bd_nets ClkIcHostClkConv_CI_1]  [get_bd_ports ClkIcHostClkConv_CI]  [get_bd_pins axi_bram_ctrl_tsif_replacement/s_axi_aclk]
connect_bd_net -net [get_bd_nets RstIcHostClkConv_RBI_1] [get_bd_ports RstIcHostClkConv_RBI] [get_bd_pins axi_bram_ctrl_tsif_replacement/s_axi_aresetn]

assign_bd_address [get_bd_addr_segs {axi_bram_ctrl_tsif_replacement/S_AXI/Mem0 }]
set_property offset 0x9F8000000 [get_bd_addr_segs {rab_master/SEG_axi_bram_ctrl_tsif_replacement_Mem0}]
set_property range 1M [get_bd_addr_segs {rab_master/SEG_axi_bram_ctrl_tsif_replacement_Mem0}]

# replace tmif with AXI4 Master
set m_axi_sim [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_sim ]
set_property -dict [ list CONFIG.ADDR_WIDTH {32} CONFIG.ARUSER_WIDTH {0} CONFIG.AWUSER_WIDTH {0} CONFIG.BUSER_WIDTH {0} CONFIG.CLK_DOMAIN {} CONFIG.DATA_WIDTH {64} CONFIG.FREQ_HZ {100000000} CONFIG.ID_WIDTH {14} CONFIG.MAX_BURST_LENGTH {256} CONFIG.NUM_READ_OUTSTANDING {0} CONFIG.NUM_WRITE_OUTSTANDING {0} CONFIG.PHASE {0.000} CONFIG.PROTOCOL {AXI4} CONFIG.READ_WRITE_MODE {READ_WRITE} CONFIG.RUSER_WIDTH {0} CONFIG.SUPPORTS_NARROW_BURST {1} CONFIG.WUSER_WIDTH {0}  ] $m_axi_sim

delete_bd_objs [get_bd_intf_nets tmif_1]
delete_bd_objs [get_bd_intf_ports tmif]

set_property CONFIG.ASSOCIATED_BUSIF {m_axi_sim} [get_bd_ports ClkIcHost_CI]
connect_bd_intf_net [get_bd_intf_ports m_axi_sim] [get_bd_intf_pins axi_crossbar_host2pulp/S00_AXI]

create_bd_addr_seg -range  0x10000 -offset 0x6E000000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs axi_pulp_control/S_AXI/Reg] SEG_axi_pulp_control_Reg
create_bd_addr_seg -range  0x10000 -offset 0x6E010000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs clking_axi/Reg] SEG_clking_axi_Reg
create_bd_addr_seg -range  0x10000 -offset 0x6E030000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_lite/Reg] SEG_rab_lite_Reg
create_bd_addr_seg -range  0x10000 -offset 0x6E050000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs intr_axi/Reg] SEG_intr_axi_Reg
create_bd_addr_seg -range 0x100000 -offset 0x6E100000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_ar_bram_ctrl_host/S_AXI/Mem0] SEG_rab_ar_bram_ctrl_host_Mem0
create_bd_addr_seg -range 0x100000 -offset 0x6E200000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_aw_bram_ctrl_host/S_AXI/Mem0] SEG_rab_aw_bram_ctrl_host_Mem0

create_bd_addr_seg -range 0x8000000 -offset 0x60000000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_slave/Reg] SEG_0_rab_slave_Reg

# finish
regenerate_bd_layout
save_bd_design

# validate
validate_bd_design

# generate
generate_target all [get_files ./sim-bigpulp.srcs/sources_1/bd/ic/ic.bd]
make_wrapper -files [get_files ./sim-bigpulp.srcs/sources_1/bd/ic/ic.bd] -top
add_files -norecurse ./sim-bigpulp.srcs/sources_1/bd/ic/hdl/ic_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add bigpulp_top
add_files -norecurse $FPGA_RTL/clk_rst_gen.sv
add_files -norecurse $FPGA_RTL/axi_intr_reg.sv
add_files -norecurse ../../bigpulp/rtl/bigpulp_top.sv

# add clock_manager
read_ip $FPGA_IPS/xilinx_clock_manager/ip/xilinx_clock_manager.xci
synth_ip [get_ips xilinx_clock_manager]

# set top
set_property top bigpulp_top [current_fileset]

##################################################################
#
#                          TESTBENCH
#
##################################################################
add_files -norecurse ../tb/current/testbench.sv

# AXI4-Lite traffic generator
set AXI4LITE_VIP_PATH $::env(AXI4LITE_VIP_PATH)
if ![file exists $AXI4LITE_VIP_PATH] {
  error "ERROR: Could not find AMBA4 AXI-Lite Verification IP from SysWip. Please download it and configure sourceme.sh as shown in README.md!"
}
add_files -norecurse $AXI4LITE_VIP_PATH/verification_ip/axi4lite_m.sv $AXI4LITE_VIP_PATH/verification_ip/axi4lite_m_if.sv

# set top
set_property top testbench [current_fileset -simset]

# needed only if used in batch mode
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Vivado fails to recognize that CfMath is indeed referenced -> fix compile order
set_property source_mgmt_mode DisplayOnly [current_project]
reorder_files -front $IPS/pkg/cfmath/CfMath.sv
reorder_files -front $AXI4LITE_VIP_PATH/verification_ip/axi4lite_m.sv $AXI4LITE_VIP_PATH/verification_ip/axi4lite_m_if.sv

set_property target_simulator ModelSim [current_project]
set_property compxlib.modelsim_compiled_library_dir $::env(COMPXLIB_PATH) [current_project]
set_property -name modelsim.simulate.runtime -value {1000ns} -objects [get_filesets sim_1]
set_property -name modelsim.compile.vlog.more_options -value {-suppress 2583} -objects [get_filesets sim_1]

if [file exists ../tb/current/wave.do] {
  set_property -name {modelsim.simulate.custom_wave_do} -value {../../../../tb/current/wave.do} -objects [get_filesets sim_1]
}

launch_simulation -simset sim_1 -mode behavioral
