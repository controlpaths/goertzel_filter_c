/**
  Module name:  acquisition_control
  Author: P Trujillo (pablo@controlpaths.com)
  Date: Jun 2020
  Description: Module for store adc data in to externa bram.
  Revision: 1.0 Module created
**/

module acquisition_control_v1_0 (
  input clk, /* Input clock signal */
  input rstn, /* Input reset signal */

  input i_we, /* Write enable signal.*/
  input i_acquire_window, /* Adquire complete window */
  input [9:0] i10_window_length, /* Window length */

  input [13:0] i14_data, /* 14 bit input adc signal. */

  output reg [3:0] or4_bram_we, /* BRAM write enable */
  output reg [31:0] or32_bram_data, /* BRAM data bus */
  output reg [31:0] or32_bram_add, /* BRAM address */
  output o_bram_en, /* BRAM enable */
  output o_bram_rst, /* BRAM reset */

  output o_bram_data_valid
  );

  assign o_bram_rst = !rstn;
  assign o_bram_en = 1'b1;

  reg [9:0] r10_add_aux; /* Address index */

  always @(posedge clk)
    if (!rstn) begin
      or4_bram_we <= 4'b0000;
      or32_bram_add <= 32'd0;
      or32_bram_data <= 32'd0;
    end
    else
      if (i_acquire_window || (r10_add_aux != 0))
        if (i_we) begin
          or32_bram_data <= {18'd0, i14_data};
          or32_bram_add <= {22'b0, r10_add_aux};
          r10_add_aux <= (r10_add_aux < ((i10_window_length*4)-1))? r10_add_aux+4:0;
          or4_bram_we <= 4'b1111;
        end
        else
          or4_bram_we <= 4'b0000;

  assign o_bram_data_valid = (or32_bram_add == 32'd0)? 1'b1:1'b0;

endmodule
