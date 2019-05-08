#!/bin/bash

# either "zedboard", "zc706", "mini-itx", "te0808" or "juno"
if [ -z "${BOARD}" ]; then
    export BOARD="zc706"
fi

echo -n "Configuring for "
echo ${BOARD}

if [ "$BOARD" = "zedboard" ]; then
  export XILINX_PART="xc7z020clg484-1"
  export XILINX_BOARD="em.avnet.com:zed:part0:1.1"
  export CLK_PERIOD_NS="20"
  export RAB_AX_LOG_EN="0"
  export MOD_HOST_CLKS="0"
  export SDK_WORKSPACE="/scratch/$USER/$BOARD/zynqlinux/sdk"
elif [ "$BOARD" = "zc706" ]; then
  export XILINX_PART="xc7z045ffg900-2"
  export XILINX_BOARD="xilinx.com:zc706:part0:1.2"
  export CLK_PERIOD_NS="10"
  export RAB_AX_LOG_EN="1"
  export MOD_HOST_CLKS="0"
  export HOST_CLK_MHZ="800"
  export SDK_WORKSPACE="/scratch/$USER/$BOARD/zynqlinux/sdk"
elif [ "$BOARD" = "mini-itx" ]; then
  export XILINX_PART="xc7z045ffg900-2"
  export XILINX_BOARD="em.avnet.com:mini_itx_7z045:part0:1.2"
  export CLK_PERIOD_NS="10"
  export RAB_AX_LOG_EN="1"
  export MOD_HOST_CLKS="0"
  export SDK_WORKSPACE="/scratch/$USER/$BOARD/zynqlinux/sdk"
elif [ "$BOARD" = "zcu102" -o "$BOARD" = "te0808" ]; then
  if [ "$BOARD" = "zcu102" ]; then
    export XILINX_PART="xczu9eg-ffvb1156-2-i"
    export XILINX_BOARD="xilinx.com:zcu102:part0:3.0"
  else
    export XILINX_PART="xczu9eg-ffvc900-2-i-es2"
    export XILINX_BOARD=""
  fi
  export CLK_PERIOD_NS="10"
  export RAB_AX_LOG_EN="1"
  export MOD_HOST_CLKS="0"
  export SDK_WORKSPACE="/scratch/$USER/$BOARD/workspace/sdk"
else # juno
  export XILINX_PART="xc7v2000tflg1925-1"
  export XILINX_BOARD=""
  export CLK_PERIOD_NS="25"
  export RAB_AX_LOG_EN="1"
  export JUNO_SUPPORT_PATH="/scratch/$USER/$BOARD/juno-support"
  export SDK_WORKSPACE="/scratch/$USER/$BOARD/workspace/sdk"
fi

export VIVADO_VERSION="2018.3"
if [ "$VIVADO_VERSION" = "2017.2" ]; then
  export COMPXLIB_PATH="/usr/pack/vivado-2017.2-kgf/DZ_STUFF/compxlib/modelsim-10.6b"
elif [ "$VIVADO_VERSION" = "2018.3" ]; then
  export COMPXLIB_PATH="/usr/pack/vivado-2018.3-kgf/DZ_STUFF/compxlib/modelsim-10.7b"
fi

export AXI4LITE_VIP_PATH="/scratch/$USER/$BOARD/axi4lite_vip"
