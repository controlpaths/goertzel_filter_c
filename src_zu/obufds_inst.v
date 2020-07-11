/**
  Module name:  obufds_inst
  Author: P Trujillo (pablo@controlpaths.com)
  Date: May 2020
  Description: Instantiation for differential output buffer
  Revision: 1.0 Module created.
**/

module obufds_inst (
  input clk_in, /* Input clock */
  output clk_out, /* Positive output clock */
  output clk_outn /* Negative output clock */
  );

  OBUFDS #(
  .IOSTANDARD("DEFAULT"),
  .SLEW("SLOW")
  ) OBUFDS_CLKADC (
  .O(clk_out),
  .OB(clk_outn),
  .I(clk_in)
  );

endmodule
