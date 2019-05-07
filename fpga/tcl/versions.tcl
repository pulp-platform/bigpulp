# Set IP versions
if { [version -short] == "2017.2" } {
  set BLK_MEM_GEN_VERSION "8.3"
  set BRAM_CONTROLLER_VERSION "4.0"
  set MB_VERSION "10.0"
  set PS7_VERSION "5.5"
  set PS_VERSION "3.0"
  set XLCONCAT_VERSION "2.1"
} elseif { [version -short] == "2018.3" } {
  set BLK_MEM_GEN_VERSION "8.4"
  set BRAM_CONTROLLER_VERSION "4.1"
  set MB_VERSION "11.0"
  set PS7_VERSION "5.5"
  set PS_VERSION "3.2"
  set XLCONCAT_VERSION "2.1"
} else {
  error "Error: Unsupported Vivado version!"
  return 1
}
