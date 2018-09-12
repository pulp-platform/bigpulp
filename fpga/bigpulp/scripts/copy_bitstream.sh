#!/bin/bash

# Script to copy the bigpulp bitstream to the machine connected
# to the Juno ARM Development Platform from where it can be deployed.
#
# Source sourceme.sh from the hsa_support repository to set up
# the required environment variables. 

# Create folder on target
ssh ${SCP_TARGET_MACHINE} "mkdir -p ~/juno/imgs/bitstream/bigpulp"

# Copy
scp -r ${JUNO_SUPPORT_PATH}/SITE2 ${SCP_TARGET_MACHINE}:~/juno/imgs/bitstream/bigpulp/.
