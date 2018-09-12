set ILA "no"
if { $ILA == "yes" } {
  # ILA on rab_master port
  create_debug_core u_ila_0_0 ila
  set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0_0]
  set_property C_TRIGIN_EN false [get_debug_cores u_ila_0_0]
  set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0_0]
  set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0_0]
  set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0_0]
  set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0_0]
  set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0_0]
  set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0_0]
  startgroup
  set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0_0 ]
  set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0_0 ]
  set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0_0 ]
  set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0_0 ]
  endgroup
  set_property port_width 1 [get_debug_ports u_ila_0_0/clk]
  connect_debug_port u_ila_0_0/clk [get_nets [list clk_rst_gen_i/clk_manager_i/inst/CLK_CORE_DRP_I/clk_inst/clk_out1 ]]
  set_property port_width 6 [get_debug_ports u_ila_0_0/probe0]
  connect_debug_port u_ila_0_0/probe0 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_id[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_id[1]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_id[2]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_id[3]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_id[4]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_id[5]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 8 [get_debug_ports u_ila_0_0/probe1]
  connect_debug_port u_ila_0_0/probe1 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_len[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_len[1]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_len[2]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_len[3]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_len[4]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_len[5]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_len[6]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_len[7]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 32 [get_debug_ports u_ila_0_0/probe2]
  connect_debug_port u_ila_0_0/probe2 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[1]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[2]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[3]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[4]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[5]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[6]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[7]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[8]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[9]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[10]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[11]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[12]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[13]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[14]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[15]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[16]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[17]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[18]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[19]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[20]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[21]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[22]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[23]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[24]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[25]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[26]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[27]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[28]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[29]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[30]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_addr[31]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 6 [get_debug_ports u_ila_0_0/probe3]
  connect_debug_port u_ila_0_0/probe3 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_id[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_id[1]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_id[2]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_id[3]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_id[4]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_id[5]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 2 [get_debug_ports u_ila_0_0/probe4]
  connect_debug_port u_ila_0_0/probe4 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_resp[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_resp[1]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 2 [get_debug_ports u_ila_0_0/probe5]
  connect_debug_port u_ila_0_0/probe5 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_resp[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_resp[1]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 6 [get_debug_ports u_ila_0_0/probe6]
  connect_debug_port u_ila_0_0/probe6 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_id[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_id[1]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_id[2]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_id[3]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_id[4]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_id[5]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 6 [get_debug_ports u_ila_0_0/probe7]
  connect_debug_port u_ila_0_0/probe7 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_id[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_id[1]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_id[2]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_id[3]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_id[4]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_id[5]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 8 [get_debug_ports u_ila_0_0/probe8]
  connect_debug_port u_ila_0_0/probe8 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_len[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_len[1]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_len[2]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_len[3]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_len[4]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_len[5]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_len[6]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_len[7]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 32 [get_debug_ports u_ila_0_0/probe9]
  connect_debug_port u_ila_0_0/probe9 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[0]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[1]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[2]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[3]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[4]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[5]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[6]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[7]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[8]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[9]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[10]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[11]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[12]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[13]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[14]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[15]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[16]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[17]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[18]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[19]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[20]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[21]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[22]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[23]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[24]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[25]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[26]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[27]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[28]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[29]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[30]} {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_addr[31]} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe10]
  connect_debug_port u_ila_0_0/probe10 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_ready} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe11]
  connect_debug_port u_ila_0_0/probe11 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.ar_valid} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe12]
  connect_debug_port u_ila_0_0/probe12 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_ready} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe13]
  connect_debug_port u_ila_0_0/probe13 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.aw_valid} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe14]
  connect_debug_port u_ila_0_0/probe14 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_ready} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe15]
  connect_debug_port u_ila_0_0/probe15 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.b_valid} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe16]
  connect_debug_port u_ila_0_0/probe16 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_last} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe17]
  connect_debug_port u_ila_0_0/probe17 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_ready} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe18]
  connect_debug_port u_ila_0_0/probe18 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.r_valid} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe19]
  connect_debug_port u_ila_0_0/probe19 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.w_last} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe20]
  connect_debug_port u_ila_0_0/probe20 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.w_ready} ]]
  create_debug_port u_ila_0_0 probe
  set_property port_width 1 [get_debug_ports u_ila_0_0/probe21]
  connect_debug_port u_ila_0_0/probe21 [get_nets [list {ulpsoc_i/axi_rab_wrap_i/rab_master\\.w_valid} ]]
}

# set for RuntimeOptimized implementation
set_property "steps.opt_design.args.directive" "RuntimeOptimized" [get_runs impl_1]
set_property "steps.place_design.args.directive" "RuntimeOptimized" [get_runs impl_1]
set_property "steps.route_design.args.directive" "RuntimeOptimized" [get_runs impl_1]

launch_runs impl_1
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

open_run impl_1

# report area utilization
report_utilization -hierarchical -hierarchical_depth 1 -file bigpulp-z-70xx.txt
report_utilization -hierarchical -hierarchical_depth 2 -cells pulp_soc_i -file pulp_soc.txt
report_utilization -hierarchical -hierarchical_depth 2 -cells pulp_soc_i/CLUSTER[0].cluster_i/pulp_cluster_i -file pulp_cluster.txt

# copy bitstream
exec cp bigpulp-z-70xx.runs/impl_1/bigpulp_z_70xx_top.bit bigpulp-z-70xx.bit
if [info exists ::env(SDK_WORKSPACE)] {
    exec cp bigpulp-z-70xx.bit $SDK_WORKSPACE/.
}
