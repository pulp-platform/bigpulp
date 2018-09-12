PROJECT:=sim-bigpulp-z-70xx

all:
	vivado -mode batch -source tcl/run.tcl 

gui:
	vivado -mode gui -source tcl/run.tcl

clean:
	rm -rf ${PROJECT}*
	rm -rf reports
	rm -rf component.xml
	rm -rf vivado*
	rm -rf .Xil
	rm -rf xgui
	rm -rf ps_clock_registers.log
	rm -rf webtalk.*

