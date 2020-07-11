/**
  Module name:  zmod_dac_driver
  Author: P Trujillo (pablo@controlpaths.com)
  Date: May 2020
  Description: Driver for ad9717. ZMOD DAC from Digilent
  Revision: 1.1 All in one driver. Include Relay and gpio configuration.
**/

module zmod_dac_driver_v1_1 (
  input clk, /* Clock input. This signal is corresponding with sample frequency */
  input rstn, /* Reset input */

  input signed [13:0] is14_data_i, /* Data for ch i*/
  input signed [13:0] is14_data_q, /* Data for ch q*/
  input i_run, /* DAC enable input */

  output signed [13:0] os14_data, /* Parallel DDR data for ADC*/

  output rst_spi, /* DAC reset out*/
  output or_sck, /* DAC SPI clk out*/
  output or_cs, /* DAC SPI cs out*/
  output o_sdo, /* DAC SPI data IO out*/
  output o_relay, /* Output relay */
  output o_dac_fsadji, /* Full scale selection */
  output o_dac_fsadjq /* Full scale selection */
  );

  /* Output data management */
  generate for(genvar i=0; i<=13; i=i+1)
    ODDR #(
    .DDR_CLK_EDGE("OPPOSITE_EDGE"),
    .INIT(1'b0),
    .SRTYPE("SYNC")
    )ODDR_DACDATA(
    .Q(os14_data[i]),
    .C(clk),
    .CE(1'b1),
    .D1(is14_data_i[i]),
    .D2(is14_data_q[i]),
    .R(!i_run),
    .S(1'b0)
    );
  endgenerate

  /* Configure dac by gpio */
  assign rst_spi = 1'b1; /* SPI_MODE = OFF*/
  assign or_sck = 1'b0; /* CLKIN = DCLKIO*/
  assign or_cs = 1'b0; /* PWRDWN = 0 */
  assign o_sdo = 1'b1; /* INPUT FORMAT = 2's complement */

  /* Output relay management */
  assign o_relay = 1'b1;

  /* Full scale configuration */
  assign o_dac_fsadji = 1'b0;
  assign o_dac_fsadjq = 1'b0;

endmodule
