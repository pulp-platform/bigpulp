delete wave *
onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate /testbench/pulp2host_intr

quietly set ULPSOC  /testbench/DUT/ulpsoc_i
quietly set IC      /testbench/DUT/ic_wrapper_i/ic_i

quietly set RAB_TOP $ULPSOC/axi_rab_wrap_i/axi_rab_top_i

quietly set AXILOGGER $RAB_TOP/u_ar_logger
quietly set LOGGER $AXILOGGER/bramLogger
add wave -noupdate -group logger $LOGGER/Clk_CI
add wave -noupdate -group logger $LOGGER/TimestampClk_CI
add wave -noupdate -group logger $LOGGER/Rst_RBI
add wave -noupdate -group logger $LOGGER/Clear_SI
add wave -noupdate -group logger $LOGGER/LogEn_SI
add wave -noupdate -group logger $LOGGER/Full_SO
add wave -noupdate -group logger $LOGGER/Ready_SO
add wave -noupdate -group logger $LOGGER/State_SP
add wave -noupdate -group logger $LOGGER/WrCntA_SP
add wave -noupdate -group logger $LOGGER/WrEnA_S
add wave -noupdate -group logger $LOGGER/Timestamp_SP
add wave -noupdate -group logger $AXILOGGER/AxiAddr_DI
add wave -noupdate -group logger $AXILOGGER/AxiId_DI
add wave -noupdate -group logger $AXILOGGER/AxiLen_DI
add wave -noupdate -group logger $AXILOGGER/AxiReady_SI
add wave -noupdate -group logger $AXILOGGER/AxiValid_SI

quietly set BRAM_ARR $LOGGER/bramArr

quietly set RAM00 $BRAM_ARR/genblk1\[0\]/genblk1\[0\]/BRAM_TDP_MACRO_inst
quietly set RAM01 $BRAM_ARR/genblk1\[0\]/genblk1\[1\]/BRAM_TDP_MACRO_inst
quietly set RAM02 $BRAM_ARR/genblk1\[0\]/genblk1\[2\]/BRAM_TDP_MACRO_inst

add wave -noupdate -group RAM00/PortA $RAM00/DIA
add wave -noupdate -group RAM00/PortA $RAM00/DOA
add wave -noupdate -group RAM00/PortA $RAM00/ADDRA
add wave -noupdate -group RAM00/PortA $RAM00/WEA

add wave -noupdate -group RAM01/PortA $RAM01/DIA
add wave -noupdate -group RAM01/PortA $RAM01/DOA
add wave -noupdate -group RAM01/PortA $RAM01/ADDRA
add wave -noupdate -group RAM01/PortA $RAM01/WEA

add wave -noupdate -group RAM02/PortA $RAM02/DIA
add wave -noupdate -group RAM02/PortA $RAM02/DOA
add wave -noupdate -group RAM02/PortA $RAM02/ADDRA
add wave -noupdate -group RAM02/PortA $RAM02/WEA

add wave -noupdate -group RAM00/PortB $RAM00/DIB
add wave -noupdate -group RAM00/PortB $RAM00/DOB
add wave -noupdate -group RAM00/PortB $RAM00/ADDRB
add wave -noupdate -group RAM00/PortB $RAM00/WEB

add wave -noupdate -group RAM01/PortB $RAM01/DIB
add wave -noupdate -group RAM01/PortB $RAM01/DOB
add wave -noupdate -group RAM01/PortB $RAM01/ADDRB
add wave -noupdate -group RAM01/PortB $RAM01/WEB

add wave -noupdate -group RAM02/PortB $RAM02/DIB
add wave -noupdate -group RAM02/PortB $RAM02/DOB
add wave -noupdate -group RAM02/PortB $RAM02/ADDRB
add wave -noupdate -group RAM02/PortB $RAM02/WEB

quietly set RAM10 $BRAM_ARR/genblk1\[1\]/genblk1\[0\]/BRAM_TDP_MACRO_inst
quietly set RAM11 $BRAM_ARR/genblk1\[1\]/genblk1\[1\]/BRAM_TDP_MACRO_inst
quietly set RAM12 $BRAM_ARR/genblk1\[1\]/genblk1\[2\]/BRAM_TDP_MACRO_inst

add wave -noupdate -group RAM10/PortA $RAM10/DIA
add wave -noupdate -group RAM10/PortA $RAM10/DOA
add wave -noupdate -group RAM10/PortA $RAM10/ADDRA
add wave -noupdate -group RAM10/PortA $RAM10/WEA

add wave -noupdate -group RAM11/PortA $RAM11/DIA
add wave -noupdate -group RAM11/PortA $RAM11/DOA
add wave -noupdate -group RAM11/PortA $RAM11/ADDRA
add wave -noupdate -group RAM11/PortA $RAM11/WEA

add wave -noupdate -group RAM12/PortA $RAM12/DIA
add wave -noupdate -group RAM12/PortA $RAM12/DOA
add wave -noupdate -group RAM12/PortA $RAM12/ADDRA
add wave -noupdate -group RAM12/PortA $RAM12/WEA

add wave -noupdate -group RAM10/PortB $RAM10/DIB
add wave -noupdate -group RAM10/PortB $RAM10/DOB
add wave -noupdate -group RAM10/PortB $RAM10/ADDRB
add wave -noupdate -group RAM10/PortB $RAM10/WEB

add wave -noupdate -group RAM11/PortB $RAM11/DIB
add wave -noupdate -group RAM11/PortB $RAM11/DOB
add wave -noupdate -group RAM11/PortB $RAM11/ADDRB
add wave -noupdate -group RAM11/PortB $RAM11/WEB

add wave -noupdate -group RAM12/PortB $RAM12/DIB
add wave -noupdate -group RAM12/PortB $RAM12/DOB
add wave -noupdate -group RAM12/PortB $RAM12/ADDRB
add wave -noupdate -group RAM12/PortB $RAM12/WEB

add wave -noupdate -group bramArr/A_PS $BRAM_ARR/A_PS/Clk_C
add wave -noupdate -group bramArr/A_PS $BRAM_ARR/A_PS/Rst_R
add wave -noupdate -group bramArr/A_PS $BRAM_ARR/A_PS/En_S
add wave -noupdate -group bramArr/A_PS $BRAM_ARR/A_PS/Addr_S
add wave -noupdate -group bramArr/A_PS $BRAM_ARR/A_PS/Rd_D
add wave -noupdate -group bramArr/A_PS $BRAM_ARR/A_PS/Wr_D
add wave -noupdate -group bramArr/A_PS $BRAM_ARR/A_PS/WrEn_S

add wave -noupdate -group bramArr/B_PS $BRAM_ARR/B_PS/Clk_C
add wave -noupdate -group bramArr/B_PS $BRAM_ARR/B_PS/Rst_R
add wave -noupdate -group bramArr/B_PS $BRAM_ARR/B_PS/En_S
add wave -noupdate -group bramArr/B_PS $BRAM_ARR/B_PS/Addr_S
add wave -noupdate -group bramArr/B_PS $BRAM_ARR/B_PS/Rd_D
add wave -noupdate -group bramArr/B_PS $BRAM_ARR/B_PS/Wr_D
add wave -noupdate -group bramArr/B_PS $BRAM_ARR/B_PS/WrEn_S

add wave -noupdate -group bramArr/ARes $BRAM_ARR/WordAddrA_S
add wave -noupdate -group bramArr/ARes $BRAM_ARR/SerIdxA_S
add wave -noupdate -group bramArr/ARes $BRAM_ARR/WordIdxA_S

add wave -noupdate -group bramArr/BRes $BRAM_ARR/WordAddrB_S
add wave -noupdate -group bramArr/BRes $BRAM_ARR/SerIdxB_S
add wave -noupdate -group bramArr/BRes $BRAM_ARR/WordIdxB_S

add wave -noupdate -group logger/Bram_PS $LOGGER/Bram_PS/Clk_C
add wave -noupdate -group logger/Bram_PS $LOGGER/Bram_PS/Rst_R
add wave -noupdate -group logger/Bram_PS $LOGGER/Bram_PS/En_S
add wave -noupdate -group logger/Bram_PS $LOGGER/Bram_PS/Addr_S
add wave -noupdate -group logger/Bram_PS $LOGGER/Bram_PS/Rd_D
add wave -noupdate -group logger/Bram_PS $LOGGER/Bram_PS/Wr_D
add wave -noupdate -group logger/Bram_PS $LOGGER/Bram_PS/WrEn_S

add wave -noupdate -group TbAxi/Rd /testbench/m_axi_sim_araddr
add wave -noupdate -group TbAxi/Rd /testbench/m_axi_sim_arready
add wave -noupdate -group TbAxi/Rd /testbench/m_axi_sim_arvalid
add wave -noupdate -group TbAxi/Rd /testbench/m_axi_sim_arid
add wave -noupdate -group TbAxi/Rd /testbench/m_axi_sim_rid
add wave -noupdate -group TbAxi/Rd /testbench/m_axi_sim_rdata
add wave -noupdate -group TbAxi/Rd /testbench/m_axi_sim_rresp
add wave -noupdate -group TbAxi/Rd /testbench/m_axi_sim_rready
add wave -noupdate -group TbAxi/Rd /testbench/m_axi_sim_rvalid

add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_awaddr
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_awid
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_awready
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_awvalid
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_wdata
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_wready
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_wvalid
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_bresp
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_bid
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_bready
add wave -noupdate -group TbAxi/Wr /testbench/m_axi_sim_bvalid

quietly set HOST2PULP_DWC $IC/axi_dwidth_converter_host2pulp

add wave -noupdate -group host2pulp_dwc/M_AXI $HOST2PULP_DWC/m_axi_awaddr
add wave -noupdate -group host2pulp_dwc/M_AXI $HOST2PULP_DWC/m_axi_wdata
add wave -noupdate -group host2pulp_dwc/M_AXI $HOST2PULP_DWC/m_axi_wstrb
add wave -noupdate -group host2pulp_dwc/M_AXI $HOST2PULP_DWC/m_axi_wready
add wave -noupdate -group host2pulp_dwc/M_AXI $HOST2PULP_DWC/m_axi_wvalid

add wave -noupdate -group host2pulp_dwc/M_AXI $HOST2PULP_DWC/m_axi_araddr
add wave -noupdate -group host2pulp_dwc/M_AXI $HOST2PULP_DWC/m_axi_rdata
add wave -noupdate -group host2pulp_dwc/M_AXI $HOST2PULP_DWC/m_axi_rready
add wave -noupdate -group host2pulp_dwc/M_AXI $HOST2PULP_DWC/m_axi_rvalid

add wave -noupdate -group host2pulp_dwc/S_AXI $HOST2PULP_DWC/s_axi_awaddr
add wave -noupdate -group host2pulp_dwc/S_AXI $HOST2PULP_DWC/s_axi_wdata
add wave -noupdate -group host2pulp_dwc/S_AXI $HOST2PULP_DWC/s_axi_wstrb
add wave -noupdate -group host2pulp_dwc/S_AXI $HOST2PULP_DWC/s_axi_wready
add wave -noupdate -group host2pulp_dwc/S_AXI $HOST2PULP_DWC/s_axi_wvalid

add wave -noupdate -group host2pulp_dwc/S_AXI $HOST2PULP_DWC/s_axi_araddr
add wave -noupdate -group host2pulp_dwc/S_AXI $HOST2PULP_DWC/s_axi_rdata
add wave -noupdate -group host2pulp_dwc/S_AXI $HOST2PULP_DWC/s_axi_rready
add wave -noupdate -group host2pulp_dwc/S_AXI $HOST2PULP_DWC/s_axi_rvalid

quietly set PULP2HOST_DWC $IC/axi_dwidth_converter_pulp2host

add wave -noupdate -group pulp2host_dwc/M_AXI $PULP2HOST_DWC/m_axi_awaddr
add wave -noupdate -group pulp2host_dwc/M_AXI $PULP2HOST_DWC/m_axi_wdata
add wave -noupdate -group pulp2host_dwc/M_AXI $PULP2HOST_DWC/m_axi_wstrb
add wave -noupdate -group pulp2host_dwc/M_AXI $PULP2HOST_DWC/m_axi_wready
add wave -noupdate -group pulp2host_dwc/M_AXI $PULP2HOST_DWC/m_axi_wvalid

add wave -noupdate -group pulp2host_dwc/S_AXI $PULP2HOST_DWC/s_axi_awaddr
add wave -noupdate -group pulp2host_dwc/S_AXI $PULP2HOST_DWC/s_axi_wdata
add wave -noupdate -group pulp2host_dwc/S_AXI $PULP2HOST_DWC/s_axi_wstrb
add wave -noupdate -group pulp2host_dwc/S_AXI $PULP2HOST_DWC/s_axi_wready
add wave -noupdate -group pulp2host_dwc/S_AXI $PULP2HOST_DWC/s_axi_wvalid

quietly set AXI2LITE_HOST_CLK_PC $IC/axi_protocol_converter_axi2lite_host_clk

add wave -noupdate -group axi2lite_host_clk_pc/M_AXI $AXI2LITE_HOST_CLK_PC/m_axi_wdata
add wave -noupdate -group axi2lite_host_clk_pc/M_AXI $AXI2LITE_HOST_CLK_PC/m_axi_wstrb

add wave -noupdate -group axi2lite_host_clk_pc/S_AXI $AXI2LITE_HOST_CLK_PC/s_axi_wdata
add wave -noupdate -group axi2lite_host_clk_pc/S_AXI $AXI2LITE_HOST_CLK_PC/s_axi_wstrb

quietly set HOST2PULP_CB $IC/axi_clock_converter_host2pulp

add wave -noupdate -group host2pulp_cb/M_AXI $HOST2PULP_CB/m_axi_wdata
add wave -noupdate -group host2pulp_cb/M_AXI $HOST2PULP_CB/m_axi_wstrb

quietly set AR_BRAM_CTRL $IC/rab_ar_bram_ctrl_host

add wave -noupdate -group ar_bram_ctrl/S_AXI $AR_BRAM_CTRL/s_axi_awaddr
add wave -noupdate -group ar_bram_ctrl/S_AXI $AR_BRAM_CTRL/s_axi_wdata
add wave -noupdate -group ar_bram_ctrl/S_AXI $AR_BRAM_CTRL/s_axi_wstrb
add wave -noupdate -group ar_bram_ctrl/S_AXI $AR_BRAM_CTRL/s_axi_wready
add wave -noupdate -group ar_bram_ctrl/S_AXI $AR_BRAM_CTRL/s_axi_wvalid

add wave -noupdate -group ar_bram_ctrl/M $AR_BRAM_CTRL/bram_wrdata_a
add wave -noupdate -group ar_bram_ctrl/M $AR_BRAM_CTRL/bram_we_a
add wave -noupdate -group ar_bram_ctrl/M $AR_BRAM_CTRL/bram_addr_a

quietly set RAB_CFG $RAB_TOP/u_rab_core/u_axi_rab_cfg

add wave -noupdate $RAB_CFG/L1Cfg_DO
add wave -noupdate $RAB_CFG/L1Cfg_DP

add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_awaddr
add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_awready
add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_awvalid
add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_wdata
add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_wstrb
add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_wready
add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_wvalid
add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_bresp
add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_bready
add wave -noupdate -group rab_cfg/S_AXI/Wr $RAB_CFG/s_axi_bvalid

add wave -noupdate -group rab_cfg/S_AXI/Rd $RAB_CFG/s_axi_araddr
add wave -noupdate -group rab_cfg/S_AXI/Rd $RAB_CFG/s_axi_arready
add wave -noupdate -group rab_cfg/S_AXI/Rd $RAB_CFG/s_axi_arvalid
add wave -noupdate -group rab_cfg/S_AXI/Rd $RAB_CFG/s_axi_rdata
add wave -noupdate -group rab_cfg/S_AXI/Rd $RAB_CFG/s_axi_rready
add wave -noupdate -group rab_cfg/S_AXI/Rd $RAB_CFG/s_axi_rvalid
add wave -noupdate -group rab_cfg/S_AXI/Rd $RAB_CFG/s_axi_rresp

add wave -noupdate -group rab_cfg/Internal $RAB_CFG/awaddr_reg
add wave -noupdate -group rab_cfg/Internal $RAB_CFG/wren
add wave -noupdate -group rab_cfg/Internal $RAB_CFG/wren_l1
add wave -noupdate -group rab_cfg/Internal $RAB_CFG/wren_l2
add wave -noupdate -group rab_cfg/Internal $RAB_CFG/wstrb_reg

quietly set TLB_L2 $RAB_TOP/genblk2\[1\]/genblk1/u_tlb_l2
add wave -noupdate -group tlb_l2/Internal $TLB_L2/we
add wave -noupdate -group tlb_l2/Internal $TLB_L2/waddr
add wave -noupdate -group tlb_l2/Internal $TLB_L2/wdata
add wave -noupdate -group tlb_l2/Internal $TLB_L2/ram_we
add wave -noupdate -group tlb_l2/Internal $TLB_L2/ram_waddr
add wave -noupdate -group tlb_l2/Internal $TLB_L2/port0_addr
add wave -noupdate -group tlb_l2/Internal $TLB_L2/pa_ram_we
add wave -noupdate -group tlb_l2/Internal $TLB_L2/pa_port0_waddr
add wave -noupdate -group tlb_l2/Internal $TLB_L2/pa_port0_addr
add wave -noupdate -group tlb_l2/Internal $TLB_L2/pa_ram/ram

for {set i 0} {$i < 4} {incr i} {
    add wave -noupdate -group tlb_l2/RAM$i $TLB_L2/genblk2\[$i\]/u_check_ram/ram_0/ram
    add wave -noupdate -group tlb_l2/RAM$i $TLB_L2/genblk2\[$i\]/u_check_ram/ram_0/addr0
    add wave -noupdate -group tlb_l2/RAM$i $TLB_L2/genblk2\[$i\]/u_check_ram/ram_0/addr1
    add wave -noupdate -group tlb_l2/RAM$i $TLB_L2/genblk2\[$i\]/u_check_ram/ram_0/d_i
    add wave -noupdate -group tlb_l2/RAM$i $TLB_L2/genblk2\[$i\]/u_check_ram/ram_0/we
}

quietly set XBAR_RAB_CFG $ULPSOC/i_xilinx_axi_xbar_rab_cfg_wrap

add wave -noupdate -group xbar_rab_cfg/Slave0_PS $XBAR_RAB_CFG/Slave0_PS/\*_\*
add wave -noupdate -group xbar_rab_cfg/Slave1_PS $XBAR_RAB_CFG/Slave1_PS/\*_\*
add wave -noupdate -group xbar_rab_cfg/Master_PM $XBAR_RAB_CFG/Master_PM/\*_\*

TreeUpdate [SetDefaultTree]
quietly wave cursor active 1
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
