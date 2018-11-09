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
create_project sim-bigpulp-z-70xx . -part $::env(XILINX_PART) -force
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
read_ip $FPGA_IPS/xilinx_axi_dwidth_conv_rab_cfg/ip/xilinx_axi_dwidth_conv_rab_cfg.xci
synth_ip [get_ips xilinx_axi_dwidth_conv_rab_cfg]

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

if { $BOARD == "zedboard" } {
  set DEBUG_CLK   0
} else {
  set DEBUG_CLK   1
}

# Set Verilog Defines.
set DEFINES "FPGA_TARGET_XILINX=1 PULP_FPGA_EMUL=1 PULP_FPGA_SIM=1"
if { $DEBUG_CLK } { set DEFINES "$DEFINES DEBUG_CLK=1" }
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

# detect target clock
if [info exists ::env(CLK_PERIOD_NS)] {
  set CLK_PERIOD_NS $::env(CLK_PERIOD_NS)
} else {
  set CLK_PERIOD_NS 10.000
}
set CLK_HALFPERIOD_NS [expr ${CLK_PERIOD_NS} / 2]
set FREQ_HZ  [expr 1000000000 / ${CLK_PERIOD_NS}]
set FREQ_MHZ [expr ${FREQ_HZ} / 1000000]

# define host interconnect and reference clock for clock manager IP core inside bigpulp-z-70xx_top
set IC_CLK_PERIOD_NS 10.000
set IC_CLK_HALFPERIOD_NS [expr ${IC_CLK_PERIOD_NS} / 2]
set IC_FREQ_HZ  [expr 1000000000 / ${IC_CLK_PERIOD_NS}]
set IC_FREQ_MHZ [expr ${IC_FREQ_HZ} / 1000000]

# detect host target clock
if [info exists ::env(HOST_CLK_MHZ)] {
  set HOST_CLK_MHZ $::env(HOST_CLK_MHZ)
} else {
  set HOST_CLK_MHZ 666 # default for Zynq-7000
}

##################################################################
#
#                          BIGPULP
#
##################################################################
set BIGPULP ../../bigpulp-z-70xx
source $BIGPULP/tcl/ps7_bd.tcl

# Clocks and Resets replacement
disconnect_bd_net /processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
disconnect_bd_net /processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK]

set FLCK_CLK0     [ create_bd_port -dir I FCLK_CLK0 -type CLK]
disconnect_bd_net /processing_system7_0_FCLK_CLK0 [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_CLK0] [get_bd_ports FCLK_CLK0]

set FLCK_RESET0_N [ create_bd_port -dir I FCLK_RESET0_N -type RST]
disconnect_bd_net /processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N]
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_RESET0_N] [get_bd_ports FCLK_RESET0_N]

set FLCK_RESET1_N [ create_bd_port -dir I FCLK_RESET1_N -type RST]
disconnect_bd_net /processing_system7_0_FCLK_RESET1_N [get_bd_pins processing_system7_0/FCLK_RESET1_N]
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_RESET1_N] [get_bd_ports FCLK_RESET1_N]

set_property CONFIG.ASSOCIATED_BUSIF {rab_lite:rab_slave} [get_bd_ports /ClkIcPulp_CI]
set_property CONFIG.ASSOCIATED_BUSIF {rab_master:rab_acp} [get_bd_ports /ClkIcPulpGated_CI]
set_property CONFIG.ASSOCIATED_BUSIF {clking_axi} [get_bd_ports /FCLK_CLK0]

# replace DDR with BRAM
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0
set_property -dict [list CONFIG.DATA_WIDTH {64} CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_1
set_property -dict [list CONFIG.DATA_WIDTH {64} CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_1]
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:${BLK_MEM_GEN_VERSION} blk_mem_gen_0
set_property -dict [list \
  CONFIG.Memory_Type {True_Dual_Port_RAM} \
  CONFIG.Write_Depth_A {131072} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Write_Rate {50} \
  CONFIG.Port_B_Enable_Rate {100} \
] [get_bd_cells blk_mem_gen_0]
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_1/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_4
set_property -dict [list CONFIG.MI_PROTOCOL.VALUE_SRC USER CONFIG.SI_PROTOCOL.VALUE_SRC USER] [get_bd_cells axi_protocol_converter_4]
set_property -dict [list CONFIG.SI_PROTOCOL {AXI3} CONFIG.MI_PROTOCOL {AXI4}] [get_bd_cells axi_protocol_converter_4]
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_protocol_converter_4/M_AXI]
connect_bd_net [get_bd_ports FCLK_CLK0] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
connect_bd_net [get_bd_ports FCLK_RESET0_N] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
connect_bd_net [get_bd_ports FCLK_CLK0] [get_bd_pins axi_protocol_converter_4/aclk]
connect_bd_net [get_bd_ports FCLK_RESET0_N] [get_bd_pins axi_protocol_converter_4/aresetn]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_5
set_property -dict [list CONFIG.MI_PROTOCOL.VALUE_SRC USER CONFIG.SI_PROTOCOL.VALUE_SRC USER] [get_bd_cells axi_protocol_converter_5]
set_property -dict [list CONFIG.SI_PROTOCOL {AXI3} CONFIG.MI_PROTOCOL {AXI4}] [get_bd_cells axi_protocol_converter_5]
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_1/S_AXI] [get_bd_intf_pins axi_protocol_converter_5/M_AXI]
connect_bd_net [get_bd_ports FCLK_CLK0] [get_bd_pins axi_bram_ctrl_1/s_axi_aclk]
connect_bd_net [get_bd_ports FCLK_RESET0_N] [get_bd_pins axi_bram_ctrl_1/s_axi_aresetn]
connect_bd_net [get_bd_ports FCLK_CLK0] [get_bd_pins axi_protocol_converter_5/aclk]
connect_bd_net [get_bd_ports FCLK_RESET0_N] [get_bd_pins axi_protocol_converter_5/aresetn]

delete_bd_objs [get_bd_intf_nets axi_protocol_converter_3_M_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_protocol_converter_3/M_AXI] [get_bd_intf_pins axi_protocol_converter_4/S_AXI]
set_property -dict [list CONFIG.MI_PROTOCOL.VALUE_SRC USER CONFIG.MI_PROTOCOL {AXI3}] [get_bd_cells axi_protocol_converter_3]

delete_bd_objs [get_bd_intf_nets axi_protocol_converter_acp_M_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_protocol_converter_acp/M_AXI] [get_bd_intf_pins axi_protocol_converter_5/S_AXI]
set_property -dict [list CONFIG.MI_PROTOCOL.VALUE_SRC USER CONFIG.MI_PROTOCOL {AXI3}] [get_bd_cells axi_protocol_converter_acp]

# replace M_AXI_GP0 with AXI3 Master
set m_axi_sim [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_sim ]
set_property -dict [ list \
  CONFIG.ADDR_WIDTH            {32} \
  CONFIG.ARUSER_WIDTH          {6} \
  CONFIG.AWUSER_WIDTH          {6} \
  CONFIG.BUSER_WIDTH           {6} \
  CONFIG.CLK_DOMAIN            {} \
  CONFIG.DATA_WIDTH            {32} \
  CONFIG.FREQ_HZ               $IC_FREQ_HZ \
  CONFIG.ID_WIDTH              {6} \
  CONFIG.MAX_BURST_LENGTH      {16} \
  CONFIG.NUM_READ_OUTSTANDING  {1} \
  CONFIG.NUM_WRITE_OUTSTANDING {1} \
  CONFIG.PHASE                 {0.000} \
  CONFIG.PROTOCOL              {AXI3} \
  CONFIG.READ_WRITE_MODE       {READ_WRITE} \
  CONFIG.RUSER_WIDTH           {6} \
  CONFIG.SUPPORTS_NARROW_BURST {1} \
  CONFIG.WUSER_WIDTH           {6} \
] $m_axi_sim

delete_bd_objs [get_bd_intf_nets processing_system7_0_M_AXI_GP0]
connect_bd_intf_net [get_bd_intf_ports m_axi_sim] [get_bd_intf_pins axi_protocol_converter_0/S_AXI]

set_property CONFIG.ASSOCIATED_BUSIF {m_axi_sim} [get_bd_ports /FCLK_CLK0]

# Interrupt
delete_bd_objs [get_bd_ports pulp2host_intr]

# Remove PS7
delete_bd_objs [get_bd_intf_nets processing_system7_0_DDR] [get_bd_intf_nets processing_system7_0_FIXED_IO] [get_bd_cells processing_system7_0]
delete_bd_objs [get_bd_intf_ports FIXED_IO]
delete_bd_objs [get_bd_intf_ports DDR]
delete_bd_objs [get_bd_intf_nets processing_system7_0_UART_0] [get_bd_intf_ports UART_0]

# Create address segments
create_bd_addr_seg -range 0x10000    -offset 0x51000000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs axi_pulp_control/S_AXI/Reg] SEG_axi_pulp_control_Reg
create_bd_addr_seg -range 0x10000    -offset 0x51010000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs clking_axi/Reg] SEG_clking_axi_Reg
create_bd_addr_seg -range 0x10000    -offset 0x51030000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_lite/Reg] SEG_rab_lite_Reg
create_bd_addr_seg -range 0x10000    -offset 0x51050000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs intr_axi/Reg] SEG_intr_axi_Reg
if { $::env(RAB_AX_LOG_EN) } {
  create_bd_addr_seg -range 0x100000 -offset 0x51100000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_ar_bram_ctrl_host/S_AXI/Mem0] SEG_rab_ar_bram_ctrl_host_Mem0
  create_bd_addr_seg -range 0x100000 -offset 0x51200000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_aw_bram_ctrl_host/S_AXI/Mem0] SEG_rab_aw_bram_ctrl_host_Mem0
}
create_bd_addr_seg -range 0x10000000 -offset 0x40000000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_slave/Reg] SEG_rab_slave_Reg

assign_bd_address [get_bd_addr_segs {axi_bram_ctrl_0/S_AXI/Mem0 }]
set_property offset 0x38000000 [get_bd_addr_segs {rab_master/SEG_axi_bram_ctrl_0_Mem0}]
set_property range 1M [get_bd_addr_segs {rab_master/SEG_axi_bram_ctrl_0_Mem0}]

assign_bd_address [get_bd_addr_segs {axi_bram_ctrl_1/S_AXI/Mem0 }]
set_property offset 0x38000000 [get_bd_addr_segs {rab_acp/SEG_axi_bram_ctrl_1_Mem0}]
set_property range 1M [get_bd_addr_segs {rab_acp/SEG_axi_bram_ctrl_1_Mem0}]

# finish
regenerate_bd_layout
save_bd_design

# validate
validate_bd_design

# generate
generate_target all [get_files ./sim-bigpulp-z-70xx.srcs/sources_1/bd/ps7/ps7.bd]
make_wrapper -files [get_files ./sim-bigpulp-z-70xx.srcs/sources_1/bd/ps7/ps7.bd] -top
add_files -norecurse ./sim-bigpulp-z-70xx.srcs/sources_1/bd/ps7/hdl/ps7_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add bigpulp_top
add_files -norecurse $FPGA_RTL/clk_rst_gen.sv
add_files -norecurse $FPGA_RTL/axi_intr_reg.sv
add_files -norecurse ../../bigpulp-z-70xx/rtl/bigpulp-z-70xx_top.sv

# add clock_manager
read_ip $FPGA_IPS/xilinx_clock_manager/ip/xilinx_clock_manager.xci
synth_ip [get_ips xilinx_clock_manager]

# set top
set_property top bigpulp_z_70xx_top [current_fileset]

##################################################################
#
#                          TESTBENCH
#
##################################################################
add_files -norecurse [glob ../tb/current/*.sv]

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

if [file exists ../tb/current/run.do] {
  set_property -name {modelsim.simulate.custom_udo} -value {../../../../tb/current/run.do} \
    -objects [get_filesets sim_1]
}

launch_simulation -simset sim_1 -mode behavioral
