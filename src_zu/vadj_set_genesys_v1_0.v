/**
  Module name:  vadj_set_genesys_v1_0
  Author: P Trujillo (pablo@controlpaths.com)
  Date: Jun 2020
  Description: V adjust management.
  Revision: 1.0 Module created.
**/

module vadj_set_genesys_v1_0 (
  input clk, /* Input clock */
  input rstn, /* Reset input */

  output o_lvl_adj0, /* VADJ_LEVEL0 pin */
  output o_lvl_adj1, /* VADJ_LEVEL1 pin */
  output o_auto_vadj, /* VADJ_AUTO pin */
  output reg or_rstn /* Reset output for ADC driver */
);

  assign o_lvl_adj0 = 1'b1;
  assign o_lvl_adj1 = 1'b1;

  reg [17:0] r18_delay_counter; /* Register for delay */
  always @(posedge clk)
    if (!rstn)
      r18_delay_counter <= 18'd0;
    else
      r18_delay_counter <= (!(&r18_delay_counter))? r18_delay_counter+18'd1:r18_delay_counter;

  assign o_auto_vadj =  &r18_delay_counter[16:0];

  always @(posedge clk)
    or_rstn <= &r18_delay_counter? 1'b1:1'b0;

endmodule
