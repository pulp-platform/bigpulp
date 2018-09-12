set partNumber $::env(XILINX_PART)
set boardName  $::env(XILINX_BOARD)

set xilinxIpName  "axi_crossbar"
set extIpName     "xilinx_axi_xbar_rab_cfg"

create_project $extIpName . -part $partNumber
set_property board_part $boardName [current_project]

create_ip -name $xilinxIpName -vendor xilinx.com -library ip -module_name $extIpName

if { ($::env(BOARD) == "juno") || ($::env(BOARD) == "te0808") } {
    set AXI_LITE_DATA_WIDTH 64
} else {
    set AXI_LITE_DATA_WIDTH 32
}
set AXI_LITE_ADDR_WIDTH 16
set_property -dict [list \
    CONFIG.NUM_SI                                {2} \
    CONFIG.NUM_MI                                {1} \
    CONFIG.PROTOCOL                       {AXI4LITE} \
    CONFIG.S00_SINGLE_THREAD                     {1} \
    CONFIG.S01_SINGLE_THREAD                     {1} \
    CONFIG.DATA_WIDTH           $AXI_LITE_DATA_WIDTH \
    CONFIG.ADDR_WIDTH                           {32} \
    CONFIG.M00_A00_ADDR_WIDTH   $AXI_LITE_ADDR_WIDTH \
    CONFIG.M00_A01_ADDR_WIDTH   $AXI_LITE_ADDR_WIDTH \
    CONFIG.CONNECTIVITY_MODE                  {SASD} \
    CONFIG.R_REGISTER                            {1} \
] [get_ips $extIpName]

generate_target {instantiation_template} [get_files ./$extIpName.srcs/sources_1/ip/$extIpName/$extIpName.xci]
generate_target all [get_files  ./$extIpName.srcs/sources_1/ip/$extIpName/$extIpName.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] ./$extIpName.srcs/sources_1/ip/$extIpName/$extIpName.xci]
launch_run -jobs 8 ${extIpName}_synth_1
wait_on_run ${extIpName}_synth_1
