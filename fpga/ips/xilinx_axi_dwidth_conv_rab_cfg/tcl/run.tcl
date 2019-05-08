set partNumber $::env(XILINX_PART)
set boardName  $::env(XILINX_BOARD)

set xilinxIpName  "axi_dwidth_converter"
set extIpName     "xilinx_axi_dwidth_conv_rab_cfg"

create_project $extIpName . -part $partNumber
set_property board_part $boardName [current_project]

create_ip -name $xilinxIpName -vendor xilinx.com -library ip -module_name $extIpName

if { ($::env(BOARD) == "juno") || ($::env(BOARD) == "te0808") || ($::env(BOARD) == "zcu102") } {
    # This IP is not used on 64-bit hosts, because the RAB Config AXI Lite port is 64 bit as well.
    exit
}

set_property -dict [list \
    CONFIG.ADDR_WIDTH                  {32} \
    CONFIG.MI_DATA_WIDTH               {32} \
    CONFIG.SI_DATA_WIDTH               {64} \
    CONFIG.PROTOCOL              {AXI4LITE} \
    CONFIG.READ_WRITE_MODE     {READ_WRITE} \
] [get_ips $extIpName]

generate_target {instantiation_template} [get_files ./$extIpName.srcs/sources_1/ip/$extIpName/$extIpName.xci]
generate_target all [get_files  ./$extIpName.srcs/sources_1/ip/$extIpName/$extIpName.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] ./$extIpName.srcs/sources_1/ip/$extIpName/$extIpName.xci]
launch_run -jobs 8 ${extIpName}_synth_1
wait_on_run ${extIpName}_synth_1
