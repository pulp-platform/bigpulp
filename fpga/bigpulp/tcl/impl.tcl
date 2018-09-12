## # floorplanning of TLX interfaces
## create_pblock pblock_u_nc40_tlx_ax_tmf_fpg_sd
## add_cells_to_pblock [get_pblocks pblock_u_nc40_tlx_ax_tmf_fpg_sd] [get_cells -quiet [list bigpulp_top_i/u_nic400_tlx_axi_tmif_fpga_side]]
## resize_pblock [get_pblocks pblock_u_nc40_tlx_ax_tmf_fpg_sd] -add {SLICE_X386Y450:SLICE_X425Y599}
## resize_pblock [get_pblocks pblock_u_nc40_tlx_ax_tmf_fpg_sd] -add {DSP48_X6Y180:DSP48_X6Y239}
## resize_pblock [get_pblocks pblock_u_nc40_tlx_ax_tmf_fpg_sd] -add {RAMB18_X7Y180:RAMB18_X7Y239}
## resize_pblock [get_pblocks pblock_u_nc40_tlx_ax_tmf_fpg_sd] -add {RAMB36_X7Y90:RAMB36_X7Y119}
## create_pblock pblock_u_nc40_tlx_ax_tsf_fpg_sd
## add_cells_to_pblock [get_pblocks pblock_u_nc40_tlx_ax_tsf_fpg_sd] [get_cells -quiet [list bigpulp_top_i/u_nic400_tlx_axi_tsif_fpga_side]]
## resize_pblock [get_pblocks pblock_u_nc40_tlx_ax_tsf_fpg_sd] -add {SLICE_X72Y300:SLICE_X135Y449}
## resize_pblock [get_pblocks pblock_u_nc40_tlx_ax_tsf_fpg_sd] -add {DSP48_X2Y120:DSP48_X3Y179}
## resize_pblock [get_pblocks pblock_u_nc40_tlx_ax_tsf_fpg_sd] -add {RAMB18_X2Y120:RAMB18_X3Y179}
## resize_pblock [get_pblocks pblock_u_nc40_tlx_ax_tsf_fpg_sd] -add {RAMB36_X2Y60:RAMB36_X3Y89}

# this is because tck_i could be used as direct or inverted - post-synthesis only
# set_clock_sense -positive adv_dbg_if_i/adv_dbg_if_i/cluster_tap_i/u_clk_mux/clk_o_INST_0/O

proc set_debug_nets {name_arr} {
    set debug_nets {}
    foreach name $name_arr {
        lappend debug_nets [list [get_nets $name]]
    }
    set_property mark_debug true [concat {*}$debug_nets]
    return $debug_nets
}

# Create an ILA Debug Core (see UG908).
proc create_ila_core {ila_name data_depth clk} {
    create_debug_core $ila_name ila

    # Advanced Trigger Mode (see Ch. 5).
    set adv_trigger     "true"
    # Basic Capture Control Mode (see Ch. 5).
    set en_strg_qual    "false"
    # Number of Comparators per 'PROBE' Input of the ILA Core (see Table 4-2).
    if {$adv_trigger == "false" && $en_strg_qual == "false"} {
        set all_probe_same_mu_cnt   1
    } elseif {$adv_trigger == "false" && $en_strg_qual == "true"} {
        set all_probe_same_mu_cnt   2
    } else {
        set all_probe_same_mu_cnt   4
    }

    set_property -dict [ list \
            C_DATA_DEPTH            $data_depth             \
            C_TRIGIN_EN             false                   \
            C_TRIGOUT_EN            false                   \
            C_INPUT_PIPE_STAGES     0                       \
            C_EN_STRG_QUAL          $en_strg_qual           \
            C_ADV_TRIGGER           $adv_trigger            \
            ALL_PROBE_SAME_MU       true                    \
            ALL_PROBE_SAME_MU_CNT   $all_probe_same_mu_cnt  \
        ] [get_debug_cores $ila_name]

    set_property port_width 1 [get_debug_ports $ila_name/clk]
    connect_debug_port $ila_name/clk [get_nets $clk]
}

proc connect_debug_nets_to_ila {ila_name debug_nets} {
    set i_net 0
    foreach net $debug_nets {
        if {$i_net > 0} {
            create_debug_port $ila_name probe
        }
        set probe_name [format "%s/probe%u" $ila_name $i_net]
        set num_signals_on_net [llength [concat {*}$net]]
        set_property port_width $num_signals_on_net [get_debug_ports $probe_name]
        connect_debug_port $probe_name $net
        incr i_net
    }
}

set ILA "no"
if { $ILA == "yes" } {
    # Insert ChipScope cores.  Corresponds to the following GUI steps:
    # 1. In Synthesized Design, open the netlist, select the relevant wires, right-click and Mark
    #    Debug.
    # 2. In the menu of Synthesized Design, Set Up Debug, ensure that Clock Domains are correct and
    #    activate Advanced Trigger.
    set rab_core "bigpulp_top_i/pulp_soc_i/axi_rab_wrap_i/axi_rab_top_i/u_rab_core"
    set slice_top "$rab_core/genblk2[1].u_slice_top"
    set debug_nets [set_debug_nets [list \
            "bigpulp_top_i/rab_master_araddr*"  \
            "bigpulp_top_i/rab_master_arburst*" \
            "bigpulp_top_i/rab_master_arcache*" \
            "bigpulp_top_i/rab_master_arlen*"   \
            "bigpulp_top_i/rab_master_arsize*"  \
            "bigpulp_top_i/rab_master_arready"  \
            "bigpulp_top_i/rab_master_arvalid"  \
                                                \
            "bigpulp_top_i/rab_master_awaddr*"  \
            "bigpulp_top_i/rab_master_awburst*" \
            "bigpulp_top_i/rab_master_awcache*" \
            "bigpulp_top_i/rab_master_awlen*"   \
            "bigpulp_top_i/rab_master_awsize*"  \
            "bigpulp_top_i/rab_master_awready"  \
            "bigpulp_top_i/rab_master_awvalid"  \
                                                \
            "bigpulp_top_i/rab_master_rdata*"   \
            "bigpulp_top_i/rab_master_rresp*"   \
            "bigpulp_top_i/rab_master_rlast"    \
            "bigpulp_top_i/rab_master_rready"   \
            "bigpulp_top_i/rab_master_rvalid"   \
                                                \
            "bigpulp_top_i/rab_master_wdata*"   \
            "bigpulp_top_i/rab_master_wstrb*"   \
            "bigpulp_top_i/rab_master_wlast"    \
            "bigpulp_top_i/rab_master_wready"   \
            "bigpulp_top_i/rab_master_wvalid"   \
                                                \
            "bigpulp_top_i/rab_master_bresp*"   \
            "bigpulp_top_i/rab_master_bready"   \
            "bigpulp_top_i/rab_master_bvalid"   \
                                                \
            "$slice_top/prot*"                  \
            "$rab_core/int_prot*"               \
            "$rab_core/port1_addr_valid*"       \
            "$rab_core/port2_addr_valid*"       \
            "$rab_core/no_prot*"                \
        ]]
    create_ila_core "u_ila_0" 2048 "bigpulp_top_i/ClkSoc_C"
    connect_debug_nets_to_ila "u_ila_0" $debug_nets
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

# copy bitstream
exec cp bigpulp.runs/impl_1/logictile_wrapper.bit bigpulp.bit
exec cp bigpulp.bit $JUNO_SUPPORT_PATH/SITE2/HBI0247C/BIGPULP/.
