![image](logo.png)
#  obufds_inst 
 **File:** ../../genesyszu/src/obufds_inst.v  
**Module name**\: obufds_inst  
**Author**\: P Trujillo (pablo@controlpaths.com\)  
**Date**\: May 2020  
**Description**\: Instantiation for differential output buffer  
**Revision**\: 1.0 Module created.  

### Input list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|clk_in|[0:0]|Input clock|  

### Output list  
|**Name**|**Width**|**Description**|  
|-|-|-|  
|clk_out|[0:0]|Positive output clock|  
|clk_outn|[0:0]|Negative output clock|  

### Instantiation example 
 ```verilog   
obufds_inst obufds_inst_inst0(  
.clk_in(),  
.clk_out(),  
.clk_outn()   
);   
```

Automatic documentation generator. (https://github.com/controlpaths/verilog_parser)