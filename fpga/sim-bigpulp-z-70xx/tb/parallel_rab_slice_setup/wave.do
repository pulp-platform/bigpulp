onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /glbl/GSR
add wave -noupdate /testbench/FCLK_CLK0
add wave -noupdate /testbench/FCLK_RESET0_N
add wave -noupdate /testbench/FCLK_RESET1_N
add wave -noupdate /testbench/m_axi_sim_araddr
add wave -noupdate /testbench/m_axi_sim_arburst
add wave -noupdate /testbench/m_axi_sim_arcache
add wave -noupdate /testbench/m_axi_sim_arid
add wave -noupdate /testbench/m_axi_sim_arlen
add wave -noupdate /testbench/m_axi_sim_arlock
add wave -noupdate /testbench/m_axi_sim_arprot
add wave -noupdate /testbench/m_axi_sim_arqos
add wave -noupdate /testbench/m_axi_sim_arready
add wave -noupdate /testbench/m_axi_sim_arsize
add wave -noupdate /testbench/m_axi_sim_aruser
add wave -noupdate /testbench/m_axi_sim_arvalid
add wave -noupdate /testbench/m_axi_sim_awaddr
add wave -noupdate /testbench/m_axi_sim_awburst
add wave -noupdate /testbench/m_axi_sim_awcache
add wave -noupdate /testbench/m_axi_sim_awid
add wave -noupdate /testbench/m_axi_sim_awlen
add wave -noupdate /testbench/m_axi_sim_awlock
add wave -noupdate /testbench/m_axi_sim_awprot
add wave -noupdate /testbench/m_axi_sim_awqos
add wave -noupdate /testbench/m_axi_sim_awready
add wave -noupdate /testbench/m_axi_sim_awsize
add wave -noupdate /testbench/m_axi_sim_awuser
add wave -noupdate /testbench/m_axi_sim_awvalid
add wave -noupdate /testbench/m_axi_sim_bid
add wave -noupdate /testbench/m_axi_sim_bready
add wave -noupdate /testbench/m_axi_sim_bresp
add wave -noupdate /testbench/m_axi_sim_buser
add wave -noupdate /testbench/m_axi_sim_bvalid
add wave -noupdate /testbench/m_axi_sim_rdata
add wave -noupdate /testbench/m_axi_sim_rid
add wave -noupdate /testbench/m_axi_sim_rlast
add wave -noupdate /testbench/m_axi_sim_rready
add wave -noupdate /testbench/m_axi_sim_rresp
add wave -noupdate /testbench/m_axi_sim_ruser
add wave -noupdate /testbench/m_axi_sim_rvalid
add wave -noupdate /testbench/m_axi_sim_wdata
add wave -noupdate /testbench/m_axi_sim_wid
add wave -noupdate /testbench/m_axi_sim_wlast
add wave -noupdate /testbench/m_axi_sim_wready
add wave -noupdate /testbench/m_axi_sim_wstrb
add wave -noupdate /testbench/m_axi_sim_wuser
add wave -noupdate /testbench/m_axi_sim_wvalid
add wave -noupdate /testbench/pulp2host_intr
add wave -noupdate /testbench/j
add wave -noupdate /glbl/GSR
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/aw_addr
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/aw_id
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/aw_ready
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/aw_valid
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/w_valid
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/w_data
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/w_ready
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/ar_addr
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/ar_id
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/ar_ready
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/ar_valid
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/r_data
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/r_id
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/r_ready
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/r_valid
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/b_id
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/b_ready
add wave -noupdate -expand -group {socbus_to_rab_cfg (AXI_BUS)} /testbench/DUT/ulpsoc_i/s_socbus_to_rab_cfg/b_valid
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/aw_addr
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/aw_id
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/aw_ready
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/aw_valid
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/w_valid
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/w_data
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/w_ready
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/ar_addr
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/ar_id
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/ar_ready
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/ar_valid
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/r_data
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/r_id
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/r_user
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/r_ready
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/b_id
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/b_ready
add wave -noupdate -expand -group Axi_PS /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/Axi_PS/b_valid
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/aw_addr
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/aw_valid
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/aw_ready
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/w_data
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/w_valid
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/w_ready
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/ar_addr
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/ar_valid
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/ar_ready
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/r_data
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/r_valid
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/r_ready
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/b_valid
add wave -noupdate -expand -group AxiLite_PM /testbench/DUT/ulpsoc_i/i_socbus_to_rab_cfg_conv/prot_conv/AxiLite_PM/b_ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {213759999 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
configure wave -valuecolwidth 178
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
configure wave -timelineunits ps
update
WaveRestoreZoom {213169523 ps} {213990475 ps}
