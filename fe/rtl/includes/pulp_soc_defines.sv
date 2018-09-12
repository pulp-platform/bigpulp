// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

/*
 * pulp_soc_defines.sv
 * Davide Rossi <davide.rossi@unibo.it>
 * Antonio Pullini <pullinia@iis.ee.ethz.ch>
 * Igor Loi <igor.loi@unibo.it>
 * Francesco Conti <fconti@iis.ee.ethz.ch>
 * Pasquale Davide Schiavone <pschiavo@iss.ee.ethz.ch>
 * Pirmin Vogel <vogelpi@iis.ee.ethz.ch>
 * Andreas Kurth <akurth@iis.ee.ethz.ch>
 */

`ifndef PULP_SOC_DEFINES_SV
`define PULP_SOC_DEFINES_SV

import CfMath::log2;

// define if the 0x0000_0000 to 0x0040_0000 is the alias of the current cluster address space (eg cluster 0 is from  0x1000_0000 to 0x1040_0000)
`define CLUSTER_ALIAS

// To use new icache use this define
`define MP_ICACHE
//`define SP_ICACHE
//`define PRIVATE_ICACHE

// To use The L2 Multibank Feature, please decomment this define
`define USE_L2_MULTIBANK
`define NB_L2_CHANNELS 4

// Hardware Accelerator selection
//`define HWCRYPT

// Uncomment if the SCM is not present (it will still be in the memory map)
//`define NO_SCM -> anyway not active in Mr. Wolf cluster

// Uncomment to enable APU/FPU, also apu_package.sv needs to be adapted!
//`define APU_CLUSTER

// uncomment if you want to place the DEMUX peripherals (EU, MCHAN) right before the Test and set region.
// This will steal 16KB from the 1MB TCDM reegion.
// EU is mapped           from 0x10100000 - 0x400
// MCHAN regs are mapped  from 0x10100000 - 0x800
// remember to change the defines in the pulp.h as well to be coherent with this approach
//`define DEM_PER_BEFORE_TCDM_TS

// uncomment if FPGA emulator
// `define PULP_FPGA_EMUL 1
// uncomment if using Vivado for ulpcluster synthesis
`define VIVADO

// Enables memory mapped register and counters to extract statistic on instruction cache
`define FEATURE_ICACHE_STAT

`ifdef PULP_FPGA_EMUL
  // `undef  FEATURE_ICACHE_STAT
  `define SCM_BASED_ICACHE
`endif

// Platform-Dependent Parameters {{{
`ifdef ZEDBOARD
  // SOC
  `define NB_CLUSTERS            1
  `define AXI_ID_EXT_S_WIDTH     6 // AXI ID of external slaves
  `define AXI_ID_EXT_S_ACP_WIDTH 3 // AXI ID of external ACP slave
  `define AXI_ID_EXT_M_WIDTH     6 // AXI ID of external masters
  `define AXI_ID_SOC_S_WIDTH     6 // AXI ID of SoC Bus slaves
  `define AXI_ID_SOC_M_WIDTH     7 // AXI ID of SoC Bus masters
  `define L2_SIZE          64*1024 // Bytes    
  // CLUSTER
  `define NB_CORES               2
  `define NB_TCDM_BANKS          4
  `define TCDM_SIZE        32*1024 // Bytes
  `define MCHAN_BURST_LENGTH   256 // max burst size in Bytes - any power of 2 value from 8 to 2048
  `define NB_OUTSND_BURSTS       8 // max number of outstanding burst transactions
   // CACHE
  `define NB_CACHE_BANKS         1
  `define CACHE_SIZE          1024
    // RAB
  `define AXI_EXT_ADDR_WIDTH    32
  `define AXI_LITE_DATA_WIDTH   32
  `define EN_L2TLB_ARRAY     {0,0} // Port 1, Port 0
  `define N_SLICES_ARRAY     {8,4}
  `define N_SLICES_MAX           8
  `define EN_ACP                 1
  //`define RAB_AX_LOG_EN          1 deactivated for zedboard (unsupported by bigpulp-z-70xx_top)
  `define RAB_AX_LOG_ENTRIES     0
`elsif JUNO
  // SOC
  `define NB_CLUSTERS            4
  `define AXI_ID_EXT_S_WIDTH     6 // AXI ID of external slaves
  `define AXI_ID_EXT_S_ACP_WIDTH 6 // AXI ID of external ACP slave -- actually not existing in JUNO
  `define AXI_ID_EXT_M_WIDTH    15 // AXI ID of external masters // 14b tmif, 1b crossbar
  `define AXI_ID_SOC_S_WIDTH     6 // AXI ID of SoC Bus slaves
  `define AXI_ID_SOC_M_WIDTH     9 // AXI ID of SoC Bus masters
  `define L2_SIZE         256*1024 // Bytes 
  // CLUSTER
  `define NB_CORES               8
  `define NB_TCDM_BANKS         16
  `define TCDM_SIZE       256*1024 // Bytes
  `define MCHAN_BURST_LENGTH   256 // max burst size in Bytes - any power of 2 value from 8 to 2048
  `define NB_OUTSND_BURSTS       8 // 16 // max number of outstanding burst transactions
  // CACHE
  `define NB_CACHE_BANKS         2
  `define CACHE_SIZE          4096
  // RAB
  `define AXI_EXT_ADDR_WIDTH    40
  `define AXI_LITE_DATA_WIDTH   64
  `define EN_L2TLB_ARRAY     {1,0}  // Port 1, Port 0
  `define N_SLICES_ARRAY    {32,4}
  `define N_SLICES_MAX          32
  //`define EN_ACP               1
  `define RAB_AX_LOG_EN          1
  `define RAB_AX_LOG_ENTRIES     8*1024
`elsif ZYNQMPSOC // te0808
  // SOC
  `define NB_CLUSTERS            1
  `define AXI_ID_EXT_S_WIDTH     6 // AXI ID of external slaves
  `define AXI_ID_EXT_S_ACP_WIDTH 6 // AXI ID of external ACP slave
  `define AXI_ID_EXT_M_WIDTH     6 // AXI ID of external masters
  `define AXI_ID_SOC_S_WIDTH     6 // AXI ID of SoC Bus slaves
  `define AXI_ID_SOC_M_WIDTH     7 // AXI ID of SoC Bus masters
  `define L2_SIZE         256*1024 // Bytes 
  // CLUSTER
  `define NB_CORES               8
  `define NB_TCDM_BANKS         16
  `define TCDM_SIZE       256*1024 // Bytes
  `define MCHAN_BURST_LENGTH   256 // max burst size in Bytes - any power of 2 value from 8 to 2048
  `define NB_OUTSND_BURSTS       8 // 16 // max number of outstanding burst transactions
  // CACHE
  `define NB_CACHE_BANKS         4
  `define CACHE_SIZE          4096
   // RAB
  `define AXI_EXT_ADDR_WIDTH    48
  `define AXI_LITE_DATA_WIDTH   64
  `define EN_L2TLB_ARRAY      {1,0} // Port 1, Port 0
  `define N_SLICES_ARRAY     {32,4}
  `define N_SLICES_MAX          32
  `define EN_ACP                 1
  `define RAB_AX_LOG_EN          1
  `define RAB_AX_LOG_ENTRIES     2*1024
`else // mini-itx, zc-706
  // SOC
  `define NB_CLUSTERS            1
  `define AXI_ID_EXT_S_WIDTH     6 // AXI ID of external slaves
  `define AXI_ID_EXT_S_ACP_WIDTH 3 // AXI ID of external ACP slave
  `define AXI_ID_EXT_M_WIDTH     6 // AXI ID of external masters
  `define AXI_ID_SOC_S_WIDTH     6 // AXI ID of SoC Bus slaves
  `define AXI_ID_SOC_M_WIDTH     7 // AXI ID of SoC Bus masters
  `define L2_SIZE         256*1024 // Bytes 
  // CLUSTER
  `define NB_CORES               8
  `define NB_TCDM_BANKS         16
  `define TCDM_SIZE       256*1024 // Bytes
  `define MCHAN_BURST_LENGTH   256 // max burst size in Bytes - any power of 2 value from 8 to 2048
  `define NB_OUTSND_BURSTS       8 // max number of outstanding burst transactions
  // CACHE
  `define NB_CACHE_BANKS         4
  `define CACHE_SIZE          4096
   // RAB
  `define AXI_EXT_ADDR_WIDTH    32
  `define AXI_LITE_DATA_WIDTH   32
  `define EN_L2TLB_ARRAY      {1,0} // Port 1, Port 0
  `define N_SLICES_ARRAY     {32,4}
  `define N_SLICES_MAX          32
  `define EN_ACP                 1
  `define RAB_AX_LOG_EN          1
  `define RAB_AX_LOG_ENTRIES     2*1024
`endif
// }}}

// Platform-Independent / Derived Parameters {{{
`define RAB_AX_LOG_ADDR_BITW    log2(`RAB_AX_LOG_ENTRIES * 3 * 4)   // 3 32-bit words per entry

`define RAB_N_PORTS              2
`define RAB_L2_N_SETS           32
`define RAB_L2_N_SET_ENTRIES    32
`define RAB_L2_N_PAR_VA_RAMS     4
// }}}

// DEFINES
`define MPER_EXT_ID   0

`define NB_SPERIPH_PLUGS_EU 2

`define SPER_EOC_ID      0
`define SPER_TIMER_ID    1
`define SPER_EVENT_U_ID  2
`define SPER_HWCE_ID     4
`define SPER_ICACHE_CTRL 5
`define SPER_RPIPE_ID    6
`define SPER_EXT_ID      7

`define RVT 0
`define LVT 1

`ifndef PULP_FPGA_EMUL
  `define LEVEL_SHIFTER
`endif

// Comment to use bheavioral memories, uncomment to use stdcell latches. If uncommented, simulations slowdown occuor
`ifdef SYNTHESIS
 `define SCM_IMPLEMENTED
 `define SCM_BASED_ICACHE
`endif
//////////////////////
// MMU DEFINES
//
// switch for including implementation of MMUs
//`define MMU_IMPLEMENTED
// number of logical TCDM banks (regarding interleaving)
`define MMU_TCDM_BANKS 8
// switch to enable local copy registers of
// the control signals in every MMU
//`define MMU_LOCAL_COPY_REGS
//
//////////////////////

// Width of byte enable for a given data width
`define EVAL_BE_WIDTH(DATAWIDTH) (DATAWIDTH/8)

// LOG2()
`define LOG2(VALUE) ((VALUE) < ( 1 ) ? 0 : (VALUE) < ( 2 ) ? 1 : (VALUE) < ( 4 ) ? 2 : (VALUE)< (8) ? 3:(VALUE) < ( 16 )  ? 4 : (VALUE) < ( 32 )  ? 5 : (VALUE) < ( 64 )  ? 6 : (VALUE) < ( 128 ) ? 7 : (VALUE) < ( 256 ) ? 8 : (VALUE) < ( 512 ) ? 9 : 10)

`endif

// vim: ts=2 sw=2 sts=2 et nosmartindent autoindent foldmethod=marker tw=100
