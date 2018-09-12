PROJECT:=bigpulp-zux

all:
	vivado -mode batch -source tcl/run.tcl

gui:
	vivado -mode gui -source tcl/run.tcl &

clean:
	rm -rf ${PROJECT}.*[^'bit']
	rm -rf *.log
	rm -rf vivado*
	rm -rf pulp_cluster*
	rm -rf pulp_soc*
	rm -rf webtalk*
	rm -rf *.btree
	rm -rf *.v
