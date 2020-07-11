![image](logo.png)
#  zmod_adc_driver_v1_1 
 **File:** ../../genesyszu/src/zmod_adc_driver_v1_1.v  
**Module name**\: zmod_adc_driver  
**Author**\: P Trujillo (pablo@controlpaths.com\)  
**Date**\: Jun 2020  
**Description**\: Driver for ad9648. ZMOD ADC from Digilent. Module uses 2 different clock, so it's neccesary use synchronizers  
**Revision**\: 1.1 Added ultrascale support.  

### Input list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|clk|[0:0]|Clock input|  
|rstn|[0:0]|Reset input|  
|i_vadj_configured|[0:0]||  
|i14_data|[13:0]|Parallel input data from ADC|  
|i_dco|[0:0]|Input ch select|  
|i_gain_a_h_nl|[0:0]||  
|i_gain_b_h_nl|[0:0]||  
|i_coupling_a_dc_nac|[0:0]||  
|i_coupling_b_dc_nac|[0:0]||  
|clk_spi|[0:0]|Input clock for SPI. or_sclk = clk_spi/4|  

### Output list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|o14_data_a|[13:0]|Parallel converted ADC ch A|  
|o14_data_b|[13:0]|Parallel converted ADC ch B|  
|o_adc_configured|[0:0]|Adc configuration complete signal|  
|or_sck|[0:0]|ADC SPI clk out|  
|or_cs|[0:0]|ADC SPI data IO|  
|o_sdio|[0:0]|ADC SPI cs out|  
|o_zmod_adc_coupling_h_a|[0:0]|ZMOD ADC input coupling select for of channel A. Differential driver|  
|o_zmod_adc_coupling_l_a|[0:0]|ZMOD ADC input coupling select for of channel A. Differential driver|  
|o_zmod_adc_coupling_h_b|[0:0]|ZMOD ADC input coupling select for of channel B. Differential driver|  
|o_zmod_adc_coupling_l_b|[0:0]|ZMOD ADC input coupling select for of channel B. Differential driver|  
|o_zmod_adc_gain_h_a|[0:0]|ZMOD ADC input gain select for of channel A. Differential driver|  
|o_zmod_adc_gain_l_a|[0:0]|ZMOD ADC input gain select for of channel A. Differential driver|  
|o_zmod_adc_gain_h_b|[0:0]|ZMOD ADC input gain select for of channel B. Differential driver|  
|o_zmod_adc_gain_l_b|[0:0]|ZMOD ADC input gain select for of channel B. Differential driver|  
|o_zmod_adc_com_h|[0:0]|ZMOD ADC commom signal. Differential driver|  
|o_zmod_adc_com_l|[0:0]|ZMOD ADC commom signal. Differential driver|  
|o_adc_sync|[0:0]|ADC SYNC out. Signal used for select configuration mode|  

### Wire list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|w_spi_busy|[0:0]|SPI busy signal|  

### Register list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|r24_spi_data_out|[23:0]|Synchronizer 0 spi_data_out. RW | W[1:0] | A[12:0] | DATA[7:0]|  
|r24_spi_data_out_1|[23:0]|Synchronizer 1 spi_data_out. RW | W[1:0] | A[12:0] | DATA[7:0]|  
|r24_spi_data_out_2|[23:0]|Synchronizer 2 spi_data_out. RW | W[1:0] | A[12:0] | DATA[7:0]|  
|r_spi_start|[0:0]|Sychronyzer 0 spi_start|  
|r_spi_start_1|[0:0]|Synchronizer 1 spi start|  
|r_spi_start_2|[0:0]|Synchronizer 2 spi start|  
|r27_delay_1ms_counter|[26:0]|Initial 1ms delay counter|  
|r30_delay_3s_counter|[29:0]|Initial 3 seconds delay counter. Only for Debug.|  
|r5_adc_config_state|[4:0]|ADC controller state|  
|r_cmd_read|[0:0]|Read command signal|  
|r4_spi_state|[3:0]|SPI controller state|  
|r5_data_counter|[4:0]|SPI data to write signal|  

### Instantiation example 
 ```verilog   
zmod_adc_driver_v1_1 zmod_adc_driver_v1_1_inst0(  
.clk(),  
.rstn(),  
.o14_data_a(),  
.o14_data_b(),  
.o_adc_configured(),  
.i_vadj_configured(),  
.i14_data(),  
.i_dco(),  
.i_gain_a_h_nl(),  
.i_gain_b_h_nl(),  
.i_coupling_a_dc_nac(),  
.i_coupling_b_dc_nac(),  
.clk_spi(),  
.or_sck(),  
.or_cs(),  
.o_sdio(),  
.o_zmod_adc_coupling_h_a(),  
.o_zmod_adc_coupling_l_a(),  
.o_zmod_adc_coupling_h_b(),  
.o_zmod_adc_coupling_l_b(),  
.o_zmod_adc_gain_h_a(),  
.o_zmod_adc_gain_l_a(),  
.o_zmod_adc_gain_h_b(),  
.o_zmod_adc_gain_l_b(),  
.o_zmod_adc_com_h(),  
.o_zmod_adc_com_l(),  
.o_adc_sync()   
);   
```

Automatic documentation generator. (https://github.com/controlpaths/verilog_parser)