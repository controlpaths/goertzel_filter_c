![image](logo.png)
#  acquisition_control_v1_0 
 **File:** ../../genesyszu/src/acquisition_control_v1_0.v  
**Module name**\: acquisition_control  
**Author**\: P Trujillo (pablo@controlpaths.com\)  
**Date**\: Jun 2020  
**Description**\: Module for store adc data in to externa bram.  
**Revision**\: 1.0 Module created  

### Input list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|clk|[0:0]|Input clock signal|  
|rstn|[0:0]|Input reset signal|  
|i_we|[0:0]|Write enable signal.|  
|i_acquire_window|[0:0]|Adquire complete window|  
|i10_window_length|[9:0]|Window length|  
|i14_data|[13:0]|14 bit input adc signal.|  

### Output list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|or4_bram_we|[3:0]|BRAM write enable|  
|or32_bram_data|[31:0]|BRAM data bus|  
|or32_bram_add|[31:0]|BRAM address|  
|o_bram_en|[0:0]|BRAM enable|  
|o_bram_rst|[0:0]|BRAM reset|  
|o_bram_data_valid|[0:0]||  

### Register list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|r10_add_aux|[9:0]|Address index|  

### Instantiation example 
 ```verilog   
acquisition_control_v1_0 acquisition_control_v1_0_inst0(  
.clk(),  
.rstn(),  
.i_we(),  
.i_acquire_window(),  
.i10_window_length(),  
.i14_data(),  
.or4_bram_we(),  
.or32_bram_data(),  
.or32_bram_add(),  
.o_bram_en(),  
.o_bram_rst(),  
.o_bram_data_valid()   
);   
```

Automatic documentation generator. (https://github.com/controlpaths/verilog_parser)