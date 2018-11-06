onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate /testbench/FCLK_CLK0
add wave -noupdate /testbench/FCLK_RESET0_N
add wave -noupdate /testbench/FCLK_RESET1_N

add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arvalid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arready
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_araddr
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arburst
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arcache
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arlen
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arlock
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arprot
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arqos
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_arsize
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AR /testbench/m_axi_sim_aruser
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.R /testbench/m_axi_sim_rvalid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.R /testbench/m_axi_sim_rready
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.R /testbench/m_axi_sim_rdata
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.R /testbench/m_axi_sim_rid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.R /testbench/m_axi_sim_rlast
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.R /testbench/m_axi_sim_rresp
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.R /testbench/m_axi_sim_ruser
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awvalid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awready
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awaddr
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awburst
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awcache
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awlen
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awlock
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awprot
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awqos
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awsize
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.AW /testbench/m_axi_sim_awuser
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.W /testbench/m_axi_sim_wvalid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.W /testbench/m_axi_sim_wready
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.W /testbench/m_axi_sim_wdata
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.W /testbench/m_axi_sim_wid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.W /testbench/m_axi_sim_wlast
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.W /testbench/m_axi_sim_wstrb
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.W /testbench/m_axi_sim_wuser
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.B /testbench/m_axi_sim_bvalid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.B /testbench/m_axi_sim_bready
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.B /testbench/m_axi_sim_bid
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.B /testbench/m_axi_sim_bresp
add wave -noupdate -expand -group m_axi_sim -group m_axi_sim.B /testbench/m_axi_sim_buser

add wave -noupdate /testbench/pulp2host_intr
add wave -noupdate /testbench/j
add wave -noupdate /glbl/GSR

add wave -noupdate -group uart_rx /testbench/i_uarx_rx/clk_i
add wave -noupdate -group uart_rx /testbench/i_uarx_rx/rst_ni
add wave -noupdate -group uart_rx /testbench/i_uarx_rx/rx_i
add wave -noupdate -group uart_rx /testbench/i_uarx_rx/oup_valid_o
add wave -noupdate -group uart_rx /testbench/i_uarx_rx/oup_data_o
add wave -noupdate -group uart_rx /testbench/i_uarx_rx/bit_idx_q
add wave -noupdate -group uart_rx /testbench/i_uarx_rx/cnt_q
add wave -noupdate -group uart_rx /testbench/i_uarx_rx/state_q
add wave -noupdate -group uart_rx /testbench/i_uarx_rx/data_q

for {set i 0} {$i < 8} {incr i} {
    set core_name [format {Core[%u]} $i]
    set core_path [format \
        {/testbench/DUT/pulp_soc_i/CLUSTER[0]/cluster_i/pulp_cluster_i/CORE[%u]/core_region_i} $i]
    foreach sig [list clk_i rst_ni init_ni base_addr_i cluster_id_i irq_req_i irq_ack_o irq_id_i \
        irq_ack_id_o clock_en_i fetch_en_i fregfile_disable_i boot_addr_i test_mode_i core_busy_o \
        instr_req_o instr_gnt_i instr_addr_o instr_r_rdata_i instr_r_valid_i debug_core_halted_o \
        debug_core_halt_i debug_core_resume_i perf_counters clk_int reg_cache_refill] {
        add wave -noupdate -group $core_name $core_path/$sig
    }
}

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1330659 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 362
configure wave -valuecolwidth 310
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
WaveRestoreZoom {1273691 ps} {1386783 ps}
