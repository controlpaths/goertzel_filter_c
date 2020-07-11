## Script name:   project1
## Script version:  1.0
## Author:  P.Trujillo (pablo@controlpaths.com)
## Date:    Mar20
## Description: Script for create eclypsez7_adc_dac project

set projectDir ../../project
set projectName genesys_goertzel_rtu_2020.1
set bdName genesys_goertzel_bd
set srcDir ../../src_zu
set xdcDir ../../xdc

## Create project in ../project
create_project -force $projectDir/$projectName.xpr

## Set current board eclypsez7.
set_property BOARD_PART digilentinc.com:gzu_3eg:part0:1.0 [current_project]

## Set verilog as default language
set_property target_language Verilog [current_project]

## Adding verilog files
add_file [glob $srcDir/vadj_set_genesys_v1_0.v]
add_file [glob $srcDir/obufds_inst.v]
add_file [glob $srcDir/zmod_adc_driver_v1_1.v]

## Adding constraints files
read_xdc $xdcDir/genesyszu_zmod.xdc

## Create block design
create_bd_design $bdName

## Add ip repo
set_property ip_repo_paths {../../ip_repo} [current_project]
update_ip_catalog

## Configure block design through external file
source ./bd/genesys_goertzel_rtu_2020.1.tcl

## Regenerate block design layout
regenerate_bd_layout

## Validate block design design
validate_bd_design

## Generate and add wrapper file for synthesis
make_wrapper -files [get_files $projectDir/$projectName.srcs/sources_1/bd/$bdName/$bdName.bd] -top

## Add wrapper
add_files -norecurse $projectDir/$projectName.srcs/sources_1/bd/$bdName/hdl/$bdName\_wrapper.v

## Open vivado for verify
start_gui
