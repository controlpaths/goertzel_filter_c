## This file is a general .xdc for the Eclypse Z7 Rev. B.0
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## 125MHz Clock from Ethernet PHY
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports clk125mhz]
create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clk125mhz]

## Buttons
set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { i2_btn[0] }]; #IO_L11P_T1_SRCC Sch=btn[0]
set_property -dict { PACKAGE_PIN C18   IOSTANDARD LVCMOS33 } [get_ports { i2_btn[1] }]; #IO_L11N_T1_SRCC Sch=btn[1]

## Pmod Header JB
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { o_f_change }]; #IO_L4N_T0 Sch=jb1_fpga

## Syzygy Port A
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS18} [get_ports o_dac_clkout]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS18} [get_ports o_dac_fsadjq]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS18} [get_ports o_dac_fsadji]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[12]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[13]}]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS18} [get_ports o_dac_sck]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS18} [get_ports o_dac_rst]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[10]}]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[11]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS18} [get_ports o_dac_cs]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS18} [get_ports o_dac_sdio]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[8]}]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[9]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18} [get_ports o_zmod_dac_relay]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[6]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[7]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS18} [get_ports o_dac_dclkio]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[4]}]
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[5]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[1]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[0]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS18} [get_ports {o14_dac_data[3]}]
