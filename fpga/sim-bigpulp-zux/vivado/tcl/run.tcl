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

# Set relative path variables
set RTL ../../../fe/rtl
set IPS ../../../fe/ips
set FPGA_IPS ../../ips
set FPGA_RTL ../../rtl

# create project
create_project sim-bigpulp-zux . -part $::env(XILINX_PART) -force
set_property board_part $XILINX_BOARD [current_project]

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

if { $BOARD == "zedboard" } {
    set DEBUG_CLK   0
} else {
    set DEBUG_CLK   1
}

# Set Verilog Defines.
set DEFINES "FPGA_TARGET_XILINX=1 PULP_FPGA_EMUL=1 PULP_FPGA_SIM=1"
if { $DEBUG_CLK     } { set DEFINES "$DEFINES DEBUG_CLK=1" }
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

# define host interconnect and reference clock for clock manager IP core inside bigpulp-zux_top
set IC_CLK_PERIOD_NS 10.000
set IC_CLK_HALFPERIOD_NS [expr ${IC_CLK_PERIOD_NS} / 2]
set IC_FREQ_HZ  [expr 1000000000 / ${IC_CLK_PERIOD_NS}]
set IC_FREQ_MHZ [expr ${IC_FREQ_HZ} / 1000000]

##################################################################
#
#                          BIGPULP
#
##################################################################
set BIGPULP ../../bigpulp-zux
source $BIGPULP/tcl/zusys_bd.tcl

# Clocks and Resets replacement
disconnect_bd_net /zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
disconnect_bd_net /zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins zynq_ultra_ps_e_0/saxihpc0_fpd_aclk]
disconnect_bd_net /zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]

set pl_clk0     [ create_bd_port -dir I pl_clk0 -type CLK]
disconnect_bd_net /zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net -net [get_bd_nets zynq_ultra_ps_e_0_pl_clk0] [get_bd_ports pl_clk0]

set pl_resetn0 [ create_bd_port -dir I pl_resetn0 -type RST]
delete_bd_objs [get_bd_nets zynq_ultra_ps_e_0_pl_resetn0]
connect_bd_net [get_bd_ports RstIcHost_RBO] [get_bd_ports pl_resetn0]

set pl_resetn1 [ create_bd_port -dir I pl_resetn1 -type RST]
delete_bd_objs [get_bd_nets zynq_ultra_ps_e_0_pl_resetn1]
connect_bd_net [get_bd_ports RstPulp_RBO] [get_bd_ports pl_resetn1]

set_property CONFIG.ASSOCIATED_BUSIF {rab_lite:rab_slave} [get_bd_ports /ClkIcPulp_CI]
set_property CONFIG.ASSOCIATED_BUSIF {rab_master:rab_acp} [get_bd_ports /ClkIcPulpGated_CI]
set_property CONFIG.ASSOCIATED_BUSIF {clking_axi}         [get_bd_ports /pl_clk0]
set_property CONFIG.ASSOCIATED_RESET {RstIcPulp_RBI}      [get_bd_ports /ClkIcPulp_CI]
set_property CONFIG.ASSOCIATED_RESET {RstIcHost_RBI}      [get_bd_ports /ClkIcHost_CO]

# It seems that the simulation model for the combined Xilinx clock and data width converter
# is not working. In particular, the read data returned to the slave side is always 0.
#
# Thus, we replace it with clock conversion only for simulation.
set REPLACE_XILINX_DWIDTH_CONV 1

# remove DDR
delete_bd_objs [get_bd_intf_nets axi_dwidth_conv_rab_master_M_AXI]
delete_bd_objs [get_bd_intf_nets axi_dwidth_conv_rab_acp_M_AXI]

delete_bd_objs [get_bd_addr_segs rab_master/SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW]
delete_bd_objs [get_bd_addr_segs rab_acp/SEG_zynq_ultra_ps_e_0_HPC0_DDR_LOW]

# replace Xilinx DWIDTH converters
if { $REPLACE_XILINX_DWIDTH_CONV } {
  delete_bd_objs [get_bd_intf_nets rab_acp_1]    [get_bd_cells axi_dwidth_conv_rab_acp]
  delete_bd_objs [get_bd_intf_nets rab_master_1] [get_bd_cells axi_dwidth_conv_rab_master]

  set axi_clk_conv_rab_acp    [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_conv_rab_acp ]
  set axi_clk_conv_rab_master [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_conv_rab_master ]

  connect_bd_intf_net [get_bd_intf_ports rab_acp]    [get_bd_intf_pins axi_clock_conv_rab_acp/S_AXI]
  connect_bd_intf_net [get_bd_intf_ports rab_master] [get_bd_intf_pins axi_clock_conv_rab_master/S_AXI]

  connect_bd_net [get_bd_ports RstIcHostClkConv_RBI] [get_bd_pins axi_clock_conv_rab_acp/m_axi_aresetn]
  connect_bd_net [get_bd_ports RstIcHostClkConv_RBI] [get_bd_pins axi_clock_conv_rab_master/m_axi_aresetn]

  connect_bd_net [get_bd_ports RstIcPulpGated_RBI] [get_bd_pins axi_clock_conv_rab_acp/s_axi_aresetn]
  connect_bd_net [get_bd_ports RstIcPulpGated_RBI] [get_bd_pins axi_clock_conv_rab_master/s_axi_aresetn]

  connect_bd_net [get_bd_ports ClkIcPulpGated_CI] [get_bd_pins axi_clock_conv_rab_acp/s_axi_aclk]
  connect_bd_net [get_bd_ports ClkIcPulpGated_CI] [get_bd_pins axi_clock_conv_rab_master/s_axi_aclk]

  connect_bd_net [get_bd_ports pl_clk0] [get_bd_pins axi_clock_conv_rab_acp/m_axi_aclk]
  connect_bd_net [get_bd_ports pl_clk0] [get_bd_pins axi_clock_conv_rab_master/m_axi_aclk]
}

# replace DDR with BRAM
if { $REPLACE_XILINX_DWIDTH_CONV } {
  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0
  set_property -dict [list CONFIG.DATA_WIDTH {64} CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_0]
  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_1
  set_property -dict [list CONFIG.DATA_WIDTH {64} CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_1]
  create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:${BLK_MEM_GEN_VERSION} blk_mem_gen_0
  set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Write_Depth_A {16384} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Use_RSTB_Pin {true} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100}] [get_bd_cells blk_mem_gen_0]

  connect_bd_intf_net [get_bd_intf_pins axi_clock_conv_rab_acp/M_AXI]    [get_bd_intf_pins axi_bram_ctrl_1/S_AXI]
  connect_bd_intf_net [get_bd_intf_pins axi_clock_conv_rab_master/M_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
} else {
  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0
  set_property -dict [list CONFIG.DATA_WIDTH {128} CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_0]
  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_1
  set_property -dict [list CONFIG.DATA_WIDTH {128} CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_1]
  create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:${BLK_MEM_GEN_VERSION} blk_mem_gen_0
  set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Write_Depth_A {8192} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Use_RSTB_Pin {true} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100}] [get_bd_cells blk_mem_gen_0]

  connect_bd_intf_net [get_bd_intf_pins axi_dwidth_conv_rab_acp/M_AXI]    [get_bd_intf_pins axi_bram_ctrl_1/S_AXI]
  connect_bd_intf_net [get_bd_intf_pins axi_dwidth_conv_rab_master/M_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
}

connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_1/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
connect_bd_net [get_bd_ports pl_clk0] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
connect_bd_net [get_bd_ports pl_clk0] [get_bd_pins axi_bram_ctrl_1/s_axi_aclk]
connect_bd_net [get_bd_ports RstIcHostClkConv_RBI] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
connect_bd_net [get_bd_ports RstIcHostClkConv_RBI] [get_bd_pins axi_bram_ctrl_1/s_axi_aresetn]

assign_bd_address [get_bd_addr_segs {axi_bram_ctrl_0/S_AXI/Mem0 }]
set_property offset 0x078000000 [get_bd_addr_segs {rab_master/SEG_axi_bram_ctrl_0_Mem0}]
set_property range 1M [get_bd_addr_segs {rab_master/SEG_axi_bram_ctrl_0_Mem0}]

assign_bd_address [get_bd_addr_segs {axi_bram_ctrl_1/S_AXI/Mem0 }]
set_property offset 0x078000000 [get_bd_addr_segs {rab_acp/SEG_axi_bram_ctrl_1_Mem0}]
set_property range 1M [get_bd_addr_segs {rab_acp/SEG_axi_bram_ctrl_1_Mem0}]

# replace M_AXI_HPM0_FPD with AXI4 Master
set m_axi_sim [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_sim ]
set_property -dict [ list \
  CONFIG.ADDR_WIDTH            {32} \
  CONFIG.ARUSER_WIDTH          {0} \
  CONFIG.AWUSER_WIDTH          {0} \
  CONFIG.BUSER_WIDTH           {0} \
  CONFIG.RUSER_WIDTH           {0} \
  CONFIG.WUSER_WIDTH           {0} \
  CONFIG.CLK_DOMAIN            {} \
  CONFIG.DATA_WIDTH            {128} \
  CONFIG.FREQ_HZ               $IC_FREQ_HZ \
  CONFIG.ID_WIDTH              {6} \
  CONFIG.MAX_BURST_LENGTH      {256} \
  CONFIG.NUM_READ_OUTSTANDING  {1} \
  CONFIG.NUM_WRITE_OUTSTANDING {1} \
  CONFIG.PHASE                 {0.000} \
  CONFIG.PROTOCOL              {AXI4} \
  CONFIG.READ_WRITE_MODE       {READ_WRITE} \
  CONFIG.SUPPORTS_NARROW_BURST {1} \
] $m_axi_sim

delete_bd_objs [get_bd_intf_nets zynq_ultra_ps_e_0_M_AXI_HPM0_FPD]
connect_bd_intf_net [get_bd_intf_ports m_axi_sim] [get_bd_intf_pins axi_xbar_host2pulp/S00_AXI]

set_property CONFIG.ASSOCIATED_BUSIF {m_axi_sim} [get_bd_ports /pl_clk0]

# Interrupt
delete_bd_objs [get_bd_ports pulp2host_intr]

# Remove zusys
delete_bd_objs [get_bd_intf_nets zynq_ultra_ps_e_0_UART_1] [get_bd_cells zynq_ultra_ps_e_0]
delete_bd_objs [get_bd_intf_ports UART_1]

# Create address segments
create_bd_addr_seg -range 0x10000 -offset 0xAE000000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs axi_pulp_ctrl/S_AXI/Reg] SEG_axi_pulp_ctrl_Reg
create_bd_addr_seg -range 0x10000 -offset 0xAE010000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs clking_axi/Reg] SEG_clking_axi_Reg
create_bd_addr_seg -range 0x10000 -offset 0xAE030000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_lite/Reg] SEG_rab_lite_Reg
create_bd_addr_seg -range 0x10000 -offset 0xAE050000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs intr_axi/Reg] SEG_intr_axi_Reg
if { $::env(RAB_AX_LOG_EN) } {
    create_bd_addr_seg -range 0x100000 -offset 0xAE100000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_ar_bram_ctrl_host/S_AXI/Mem0] SEG_rab_ar_bram_ctrl_host_Mem0
    create_bd_addr_seg -range 0x100000 -offset 0xAE200000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_aw_bram_ctrl_host/S_AXI/Mem0] SEG_rab_aw_bram_ctrl_host_Mem0
}
create_bd_addr_seg -range 0x8000000 -offset 0xA0000000 [get_bd_addr_spaces m_axi_sim] [get_bd_addr_segs rab_slave/Reg] SEG_rab_slave_Reg

# finish
regenerate_bd_layout
save_bd_design

# validate
validate_bd_design

# generate
generate_target all [get_files ./sim-bigpulp-zux.srcs/sources_1/bd/zusys/zusys.bd]
make_wrapper -files [get_files ./sim-bigpulp-zux.srcs/sources_1/bd/zusys/zusys.bd] -top
add_files -norecurse ./sim-bigpulp-zux.srcs/sources_1/bd/zusys/hdl/zusys_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add bigpulp_top
add_files -norecurse $FPGA_RTL/clk_rst_gen.sv
add_files -norecurse $FPGA_RTL/axi_intr_reg.sv
add_files -norecurse ../../bigpulp-zux/rtl/bigpulp-zux_top.sv

# add clock_manager
read_ip $FPGA_IPS/xilinx_clock_manager/ip/xilinx_clock_manager.xci
synth_ip [get_ips xilinx_clock_manager]

# set top
set_property top bigpulp_zux_top [current_fileset]

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
