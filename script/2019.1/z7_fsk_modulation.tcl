## Script name:   project1
## Script version:  1.0
## Author:  P.Trujillo (pablo@controlpaths.com)
## Date:    Jun20
## Description: Script for create eclypsez7_adc_dac project

set projectDir ../../project
set projectName eclypsez7_fsk
set srcDir ../../src_z7
set xdcDir ../../xdc

## Create project in ../project
create_project -force $projectDir/$projectName.xpr

## Set current board eclypsez7.
set_property BOARD_PART digilentinc.com:eclypse-z7:part0:1.0 [current_project]

## Set verilog as default language
set_property target_language Verilog [current_project]

## Adding verilog files
add_file [glob $srcDir/clk_wiz_0.v]
add_file [glob $srcDir/zmod_dac_driver_v1_1.v]
add_file [glob $srcDir/top_fsk_modulation.v]

## Adding memory files
add_file [glob ../../memory_content/signal_goertzel.mem]

## Adding constraints files
read_xdc $xdcDir/eclypse_z7_fsk.xdc

## Open vivado for verify
start_gui
