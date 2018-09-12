ips: rab clk hsa-periph

rab:
	cd ips/xilinx_axi_xbar_rab_cfg; make clean all
	cd ips/xilinx_axi_dwidth_conv_rab_cfg; make clean all

clk:
	cd ips/xilinx_clock_manager; make clean all

hsa-periph:
	cd ips/xilinx_mailbox; make clean all

synth: synth-pulp_cluster synth-pulp_soc

synth-pulp_cluster:
	cd pulp_cluster; make clean gui

synth-pulp_cluster-nogui:
	cd pulp_cluster; make clean all

synth-pulp_soc:
	cd pulp_soc; make clean gui

synth-pulp_soc-nogui:
	cd pulp_soc; make clean all

clean-all: clean-ips clean-pulp_cluster clean-pulp_soc

clean-pulp_cluster:
	cd pulp_cluster; make clean

clean-pulp_soc:
	cd pulp_soc; make clean

clean-ips: clean-rab clean-clk clean-hsa-periph

clean-rab:
	cd ips/xilinx_axi_xbar_rab_cfg; make clean
	cd ips/xilinx_axi_dwidth_conv_rab_cfg; make clean

clean-clk:
	cd ips/xilinx_clock_manager; make clean

clean-hsa-periph:
	cd ips/xilinx_mailbox; make clean
