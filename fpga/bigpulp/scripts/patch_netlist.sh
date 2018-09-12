#!/bin/bash

# Script to patch the ulpsoc netlist. Required to include a MicroBlaze
# core into design for debugging.

# copy netlist and stub file
cp ../pulp_soc/pulp_soc.edf .
cp ../pulp_soc/pulp_soc_stub.v .

# patch the netlist using sed
sed -i -e s/"cell alu "/"cell alu__0 "/g pulp_soc.edf
sed -i -e s/"view alu "/"view alu__0 "/g pulp_soc.edf
sed -i -e s/"ref alu "/"ref alu__0 "/g pulp_soc.edf
