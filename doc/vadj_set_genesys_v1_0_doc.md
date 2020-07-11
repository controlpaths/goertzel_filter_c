![image](logo.png)
#  vadj_set_genesys_v1_0 
 **File:** ../../genesyszu/src/vadj_set_genesys_v1_0.v  
**Module name**\: vadj_set_genesys_v1_0  
**Author**\: P Trujillo (pablo@controlpaths.com\)  
**Date**\: Jun 2020  
**Description**\: V adjust management.  
**Revision**\: 1.0 Module created.  

### Input list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|clk|[0:0]|Input clock|  
|rstn|[0:0]|Reset input|  

### Output list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|o_lvl_adj0|[0:0]|VADJ_LEVEL0 pin|  
|o_lvl_adj1|[0:0]|VADJ_LEVEL1 pin|  
|o_auto_vadj|[0:0]|VADJ_AUTO pin|  
|or_rstn|[0:0]|Reset output for ADC driver|  

### Register list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|r18_delay_counter|[17:0]|Register for delay|  

### Instantiation example 
 ```verilog   
vadj_set_genesys_v1_0 vadj_set_genesys_v1_0_inst0(  
.clk(),  
.rstn(),  
.o_lvl_adj0(),  
.o_lvl_adj1(),  
.o_auto_vadj(),  
.or_rstn()   
);   
```

Automatic documentation generator. (https://github.com/controlpaths/verilog_parser)