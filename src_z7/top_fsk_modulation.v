/**
  Module name:  top_fsk_modulation_v1_0
  Author: P Trujillo (pablo@controlpaths.com)
  Date: Jun 2020
  Description: Top module for generate fsk modulation according btn states.
  Revision: 1.0 Module created.
**/

module top_fsk_modulation_v1_0 (
  input clk125mhz,

  output o_zmod_dac_relay, /* ZMOD DAC out relay */
  output [13:0] o14_dac_data, /* Parallel DAC data out */
  output o_dac_clkout, /* DAC clock out */
  output o_dac_dclkio, /* DAC output select */
  output o_dac_fsadji, /* DAC full scale select for ch i out*/
  output o_dac_fsadjq, /* DAC full scale select for ch q out*/
  output o_dac_sck, /* DAC SPI clk out*/
  output o_dac_sdio, /* DAC SPI data IO out*/
  output o_dac_cs, /* DAC SPI cs out*/
  output o_dac_rst, /* DAC reset out*/

  input [1:0] i2_btn,
  output o_f_change
);

  wire clk100mhz;
  wire clk50mhz;
  wire pll_locked;

  reg rst;
  reg rst_1;

  always @(posedge clk100mhz)
    if (pll_locked) begin
      rst_1 <= 1'b0;
      rst <= rst_1;
    end
    else begin
      rst_1 <= 1'b1;
      rst <= 1'b1;
    end

  reg [13:0] r14x64_signal [63:0];
  wire [13:0] w14_signal2write;
  reg [5:0] r6_mem_index;

  initial $readmemh("signal_goertzel.mem", r14x64_signal);

  always @(posedge clk100mhz)
    if (rst)
      r6_mem_index <= 6'd0;
    else
      if (i2_btn[0])
        r6_mem_index <= r6_mem_index+6'd10;
      else if (i2_btn[1])
        r6_mem_index <= r6_mem_index+6'd5;
      else
        r6_mem_index <= r6_mem_index+6'd1;

  assign w14_signal2write = r14x64_signal[r6_mem_index];

  assign o_f_change = i2_btn[0];

  clk_wiz_0 clk_wiz (
  .clk_out1(clk100mhz),
  .clk_out2(clk50mhz),
  .reset(1'b0),
  .locked(pll_locked),
  .clk_in1(clk125mhz)
  );

  /* Clock forwarding for DAC. Single ended clock */
  ODDR #(
  .DDR_CLK_EDGE("SAME_EDGE"),
  .INIT(1'b0),
  .SRTYPE("SYNC")
  )ODDR_CLKDAC(
  .Q(o_dac_clkout),
  .C(clk100mhz),
  .CE(1'b1),
  .D1(1'b0),
  .D2(1'b1),
  .R(rst),
  .S(1'b0)
  );

  ODDR #(
  .DDR_CLK_EDGE("SAME_EDGE"),
  .INIT(1'b0),
  .SRTYPE("SYNC")
  )ODDR_DCLKIO(
  .Q(o_dac_dclkio),
  .C(clk100mhz),
  .CE(1'b1),
  .D1(1'b0),
  .D2(1'b1),
  .R(rst),
  .S(1'b0)
  );

  /* DAC driver */
  zmod_dac_driver_v1_1 zmod_dac_driver_inst (
  .clk(clk100mhz), /* Clock input. This signal is corresponding with sample frequency */
  .rstn(!rst), /* Reset input */
  .is14_data_i(w14_signal2write), /* Data for ch i*/
  .is14_data_q(w14_signal2write), /* Data for ch q*/
  .i_run(1'b1), /* DAC enable input */
  .os14_data(o14_dac_data), /* Parallel DDR data for ADC*/
  .rst_spi(o_dac_rst), /* DAC reset out*/
  .or_sck(o_dac_sck), /* DAC SPI clk out*/
  .or_cs(o_dac_cs), /* DAC SPI cs out*/
  .o_sdo(o_dac_sdio), /* DAC SPI data IO out*/
  .o_relay(o_zmod_dac_relay), /* Output relay */
  .o_dac_fsadji(o_dac_fsadji), /* Full scale selection */
  .o_dac_fsadjq(o_dac_fsadjq) /* Full scale selection */
  );


endmodule
