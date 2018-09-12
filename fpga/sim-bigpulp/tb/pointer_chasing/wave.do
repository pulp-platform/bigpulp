onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/ACLK
add wave -noupdate /testbench/ARESETn
add wave -noupdate /testbench/m_axi_sim_araddr
add wave -noupdate /testbench/m_axi_sim_arburst
add wave -noupdate /testbench/m_axi_sim_arcache
add wave -noupdate /testbench/m_axi_sim_arid
add wave -noupdate /testbench/m_axi_sim_arlen
add wave -noupdate /testbench/m_axi_sim_arlock
add wave -noupdate /testbench/m_axi_sim_arprot
add wave -noupdate /testbench/m_axi_sim_arqos
add wave -noupdate /testbench/m_axi_sim_arready
add wave -noupdate /testbench/m_axi_sim_arregion
add wave -noupdate /testbench/m_axi_sim_arsize
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
add wave -noupdate /testbench/m_axi_sim_awregion
add wave -noupdate /testbench/m_axi_sim_awsize
add wave -noupdate /testbench/m_axi_sim_awvalid
add wave -noupdate /testbench/m_axi_sim_bid
add wave -noupdate /testbench/m_axi_sim_bready
add wave -noupdate /testbench/m_axi_sim_bresp
add wave -noupdate /testbench/m_axi_sim_bvalid
add wave -noupdate /testbench/m_axi_sim_rdata
add wave -noupdate /testbench/m_axi_sim_rid
add wave -noupdate /testbench/m_axi_sim_rlast
add wave -noupdate /testbench/m_axi_sim_rready
add wave -noupdate /testbench/m_axi_sim_rresp
add wave -noupdate /testbench/m_axi_sim_rvalid
add wave -noupdate /testbench/m_axi_sim_wdata
add wave -noupdate /testbench/m_axi_sim_wlast
add wave -noupdate /testbench/m_axi_sim_wready
add wave -noupdate /testbench/m_axi_sim_wstrb
add wave -noupdate /testbench/m_axi_sim_wvalid
add wave -noupdate /testbench/pulp2host_intr
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_addr
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_prot
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_region
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_len
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_size
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_burst
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_lock
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_cache
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_qos
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_id
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_user
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_ready
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/aw_valid
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_addr
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_prot
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_region
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_len
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_size
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_burst
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_lock
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_cache
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_qos
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_id
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_user
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_ready
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/ar_valid
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/w_valid
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/w_data
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/w_strb
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/w_user
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/w_last
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/w_ready
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/r_data
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/r_resp
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/r_last
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/r_id
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/r_user
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/r_ready
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/r_valid
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/b_resp
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/b_id
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/b_user
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/b_ready
add wave -noupdate -expand -group rab_slave /testbench/DUT/pulp_soc_i/s_rab_slave/b_valid
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_addr
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_prot
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_region
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_len
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_size
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_burst
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_lock
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_cache
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_qos
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_id
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_user
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_ready
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/aw_valid
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_addr
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_prot
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_region
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_len
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_size
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_burst
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_lock
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_cache
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_qos
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_id
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_user
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_ready
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/ar_valid
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/w_valid
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/w_data
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/w_strb
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/w_user
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/w_last
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/w_ready
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/r_data
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/r_resp
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/r_last
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/r_id
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/r_user
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/r_ready
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/r_valid
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/b_resp
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/b_id
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/b_user
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/b_ready
add wave -noupdate -expand -group rab_master /testbench/DUT/pulp_soc_i/s_rab_master/b_valid
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_addr
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_prot
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_region
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_len
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_size
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_burst
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_lock
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_cache
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_qos
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_id
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_user
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_ready
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/aw_valid
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_addr
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_prot
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_region
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_len
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_size
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_burst
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_lock
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_cache
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_qos
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_id
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_user
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_ready
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/ar_valid
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/w_valid
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/w_data
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/w_strb
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/w_user
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/w_last
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/w_ready
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/r_data
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/r_resp
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/r_last
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/r_id
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/r_user
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/r_ready
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/r_valid
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/b_resp
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/b_id
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/b_user
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/b_ready
add wave -noupdate -expand -group socbus_to_rab /testbench/DUT/pulp_soc_i/s_socbus_to_rab/b_valid
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_addr
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_prot
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_region
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_len
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_size
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_burst
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_lock
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_cache
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_qos
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_id
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_user
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_ready
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/aw_valid
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_addr
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_prot
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_region
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_len
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_size
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_burst
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_lock
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_cache
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_qos
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_id
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_user
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_ready
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/ar_valid
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/w_valid
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/w_data
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/w_strb
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/w_user
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/w_last
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/w_ready
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/r_data
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/r_resp
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/r_last
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/r_id
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/r_user
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/r_ready
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/r_valid
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/b_resp
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/b_id
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/b_user
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/b_ready
add wave -noupdate -expand -group socbus_to_rab_cfg /testbench/DUT/pulp_soc_i/s_socbus_to_rab_cfg/b_valid
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/aw_addr
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/aw_valid
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/aw_ready
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/w_data
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/w_valid
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/w_ready
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/w_strb
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/b_resp
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/b_valid
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/b_ready
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/ar_addr
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/ar_valid
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/ar_ready
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/r_data
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/r_resp
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/r_valid
add wave -noupdate -expand -group rab_lite /testbench/DUT/pulp_soc_i/axi_rab_wrap_i/rab_lite/r_ready
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_addr
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_prot
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_region
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_len
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_size
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_burst
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_lock
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_cache
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_qos
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_id
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_user
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_ready
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/aw_valid
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_addr
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_prot
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_region
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_len
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_size
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_burst
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_lock
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_cache
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_qos
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_id
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_user
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_ready
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/ar_valid
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/w_valid
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/w_data
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/w_strb
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/w_user
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/w_last
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/w_ready
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/r_data
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/r_resp
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/r_last
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/r_id
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/r_user
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/r_ready
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/r_valid
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/b_resp
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/b_id
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/b_user
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/b_ready
add wave -noupdate -expand -group rab_to_socbus /testbench/DUT/pulp_soc_i/s_rab_to_socbus/b_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/clk
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/rst_n
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/test_en_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/start_addr_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/end_addr_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/valid_rule_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/connectivity_map_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/clk
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/rst_n
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/test_en_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/start_addr_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/end_addr_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/valid_rule_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/connectivity_map_i
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_id
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_addr
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_len
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_size
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_burst
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_lock
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_cache
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_prot
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_region
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_qos
add wave -noupdate -expand -group socbus -expand /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_aw_ready
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_id
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_addr
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_len
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_size
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_burst
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_lock
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_cache
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_prot
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_region
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_qos
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_ar_ready
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_w_data
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_w_strb
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_w_last
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_w_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_w_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_w_ready
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_b_id
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_b_resp
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_b_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_b_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_b_ready
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_r_id
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_r_data
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_r_resp
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_r_last
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_r_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_r_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_master_r_ready
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_id
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_addr
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_len
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_size
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_burst
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_lock
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_cache
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_prot
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_region
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_qos
add wave -noupdate -expand -group socbus -expand /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_aw_ready
add wave -noupdate -expand -group socbus -expand /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_id
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_addr
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_len
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_size
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_burst
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_lock
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_cache
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_prot
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_region
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_qos
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_ar_ready
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_w_data
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_w_strb
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_w_last
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_w_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_w_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_w_ready
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_b_id
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_b_resp
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_b_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_b_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_b_ready
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_r_id
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_r_data
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_r_resp
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_r_last
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_r_user
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_r_valid
add wave -noupdate -expand -group socbus /testbench/DUT/pulp_soc_i/i_soc_bus_wrap/axi_interconnect_i/i_axi_node_intf_wrap/s_slave_r_ready
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_addr
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_prot
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_region
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_len
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_size
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_burst
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_lock
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_cache
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_qos
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_id
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_user
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_ready
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/aw_valid
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_addr
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_prot
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_region
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_len
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_size
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_burst
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_lock
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_cache
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_qos
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_id
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_user
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_ready
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/ar_valid
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/w_valid
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/w_data
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/w_strb
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/w_user
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/w_last
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/w_ready
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/r_data
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/r_resp
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/r_last
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/r_id
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/r_user
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/r_ready
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/r_valid
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/b_resp
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/b_id
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/b_user
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/b_ready
add wave -noupdate -expand -group socbus_to_mailbox /testbench/DUT/pulp_soc_i/s_socbus_to_mailbox/b_valid
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_addr}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_prot}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_region}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_len}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_size}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_burst}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_lock}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_cache}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_qos}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_id}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_user}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_ready}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/aw_valid}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_addr}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_prot}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_region}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_len}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_size}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_burst}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_lock}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_cache}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_qos}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_id}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_user}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_ready}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/ar_valid}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/w_valid}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/w_data}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/w_strb}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/w_user}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/w_last}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/w_ready}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/r_data}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/r_resp}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/r_last}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/r_id}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/r_user}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/r_ready}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/r_valid}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/b_resp}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/b_id}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/b_user}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/b_ready}
add wave -noupdate -expand -group slave_0 {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/s_data_slave/b_valid}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_addr}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_prot}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_region}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_len}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_size}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_burst}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_lock}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_cache}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_qos}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_id}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_user}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_ready}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/aw_valid}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_addr}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_prot}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_region}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_len}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_size}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_burst}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_lock}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_cache}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_qos}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_id}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_user}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_ready}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/ar_valid}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/w_valid}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/w_data}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/w_strb}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/w_user}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/w_last}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/w_ready}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/r_data}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/r_resp}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/r_last}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/r_id}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/r_user}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/r_ready}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/r_valid}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/b_resp}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/b_id}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/b_user}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/b_ready}
add wave -noupdate -expand -group slave_1 {/testbench/DUT/pulp_soc_i/CLUSTER[1]/cluster_i/pulp_cluster_i/s_data_slave/b_valid}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_addr}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_prot}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_region}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_len}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_size}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_burst}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_lock}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_cache}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_qos}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_id}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_user}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_ready}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/aw_valid}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_addr}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_prot}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_region}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_len}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_size}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_burst}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_lock}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_cache}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_qos}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_id}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_user}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_ready}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/ar_valid}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/w_valid}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/w_data}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/w_strb}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/w_user}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/w_last}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/w_ready}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/r_data}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/r_resp}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/r_last}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/r_id}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/r_user}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/r_ready}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/r_valid}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/b_resp}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/b_id}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/b_user}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/b_ready}
add wave -noupdate -expand -group slave_2 {/testbench/DUT/pulp_soc_i/CLUSTER[2]/cluster_i/pulp_cluster_i/s_data_slave/b_valid}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_addr}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_prot}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_region}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_len}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_size}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_burst}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_lock}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_cache}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_qos}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_id}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_user}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_ready}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/aw_valid}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_addr}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_prot}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_region}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_len}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_size}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_burst}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_lock}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_cache}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_qos}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_id}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_user}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_ready}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/ar_valid}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/w_valid}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/w_data}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/w_strb}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/w_user}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/w_last}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/w_ready}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/r_data}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/r_resp}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/r_last}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/r_id}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/r_user}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/r_ready}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/r_valid}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/b_resp}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/b_id}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/b_user}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/b_ready}
add wave -noupdate -expand -group slave_3 {/testbench/DUT/pulp_soc_i/CLUSTER[3]/cluster_i/pulp_cluster_i/s_data_slave/b_valid}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11119999 ps} 1} {{Cursor 2} {11319999 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 214
configure wave -valuecolwidth 206
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
WaveRestoreZoom {7906023 ps} {14226458 ps}
