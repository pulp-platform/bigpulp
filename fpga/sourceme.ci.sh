#!/bin/bash

# either "zedboard" or "zc706"
export BOARD "zc706"

if [ "$BOARD" = "zedboard" ]; then
  export XILINX_PART="xc7z020clg484-1"
  export XILINX_BOARD="em.avnet.com:zynq:zed:c"
  export RAB_AX_LOG_EN="0"
else # zc706
  export XILINX_PART="xc7z045ffg900-2"
  export XILINX_BOARD="xilinx.com:zc706:part0:0.9"
  export RAB_AX_LOG_EN="0"
fi

