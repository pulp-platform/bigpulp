PROJECT:=xilinx_axi_dwidth_conv_rab_cfg

all:
ifneq (,$(filter $(BOARD),juno te0808 zcu102))
	@echo "'$(PROJECT)' is not used on 64-bit host platforms."
else
	vivado -mode batch -source tcl/run.tcl
	mkdir -p ip
	cp -r ${PROJECT}.srcs/sources_1/ip/${PROJECT}/* ip/.
	cp ${PROJECT}.runs/${PROJECT}_synth_1/${PROJECT}.dcp ip/.
endif

gui:
	vivado -mode gui -source tcl/run.tcl &

clean:
	rm -rf ip/*
	mkdir -p ip
	rm -rf ${PROJECT}.*
	rm -rf component.xml
	rm -rf vivado*.jou
	rm -rf vivado*.log
	rm -rf vivado*.str
	rm -rf xgui
	rm -rf .Xil
