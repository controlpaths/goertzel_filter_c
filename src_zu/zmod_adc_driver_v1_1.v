/**
  Module name:  zmod_adc_driver
  Author: P Trujillo (pablo@controlpaths.com)
  Date: Jun 2020
  Description: Driver for ad9648. ZMOD ADC from Digilent. Module uses 2 different clock, so it's neccesary use synchronizers
  Revision: 1.1 Added ultrascale support.
**/

module zmod_adc_driver_v1_1 (
  input clk, /* Clock input */
  input rstn, /* Reset input */

  output signed [13:0] o14_data_a, /* Parallel converted ADC ch A */
  output signed [13:0] o14_data_b, /* Parallel converted ADC ch B */
  output reg o_adc_configured, /* Adc configuration complete signal */

  input i_vadj_configured,

  input signed [13:0] i14_data, /* Parallel input data from ADC */
  input i_dco, /* Input ch select*/

  input i_gain_a_h_nl,
  input i_gain_b_h_nl,
  input i_coupling_a_dc_nac,
  input i_coupling_b_dc_nac,

  input clk_spi, /* Input clock for SPI. or_sclk = clk_spi/4*/
  output reg or_sck, /* ADC SPI clk out */
  output reg or_cs, /* ADC SPI data IO  */
  output o_sdio, /* ADC SPI cs out */

  output o_zmod_adc_coupling_h_a, /* ZMOD ADC input coupling select for of channel A. Differential driver */
  output o_zmod_adc_coupling_l_a, /* ZMOD ADC input coupling select for of channel A. Differential driver */
  output o_zmod_adc_coupling_h_b, /* ZMOD ADC input coupling select for of channel B. Differential driver */
  output o_zmod_adc_coupling_l_b, /* ZMOD ADC input coupling select for of channel B. Differential driver */
  output o_zmod_adc_gain_h_a, /* ZMOD ADC input gain select for of channel A. Differential driver */
  output o_zmod_adc_gain_l_a, /* ZMOD ADC input gain select for of channel A. Differential driver */
  output o_zmod_adc_gain_h_b, /* ZMOD ADC input gain select for of channel B. Differential driver */
  output o_zmod_adc_gain_l_b, /* ZMOD ADC input gain select for of channel B. Differential driver */
  output o_zmod_adc_com_h, /* ZMOD ADC commom signal. Differential driver*/
  output o_zmod_adc_com_l, /* ZMOD ADC commom signal. Differential driver*/
  output o_adc_sync /* ADC SYNC out. Signal used for select configuration mode */
  );

  localparam p_spi_pwrmode_add = 13'h08;
  localparam p_spi_pwrmode_value_reset = 8'h3c;
  localparam p_spi_pwrmode_value_release = 8'h00;
  localparam p_spi_chipid_add = 13'h01;
  localparam p_spi_chselect_add = 13'h05;
  localparam p_spi_chselect_value_cha = 8'h01; /* cha select */
  localparam p_spi_chselect_value_chb = 8'h02; /* chb select */
  localparam p_spi_chselect_value_both = 8'h03; /* BOTH SELECT */
  localparam p_spi_omode_add = 13'h14;
  localparam p_spi_omode_value_cha = 8'h31; /* CMOS | INTERLEAVED | DISABLED OPORT | 2s COMPLEMENT*/
  localparam p_spi_omode_value_chb = 8'h21; /* CMOS | INTERLEAVED | ENABLED OPORT | 2s COMPLEMENT*/
  localparam p_spi_testmode_add = 13'h0D;
  localparam p_spi_testmode_value_ramp = 8'h4f; /* REPEAT PATTERN | PATTERN RAMP */
  localparam p_spi_testmode_value_disabled = 8'h40; /* REPEAT PATTERN | TEST DISABLED*/

  /* ADC controller */
  reg [23:0] r24_spi_data_out;    /* Synchronizer 0 spi_data_out. RW | W[1:0] | A[12:0] | DATA[7:0]*/
  reg [23:0] r24_spi_data_out_1;  /* Synchronizer 1 spi_data_out. RW | W[1:0] | A[12:0] | DATA[7:0]*/
  reg [23:0] r24_spi_data_out_2;   /* Synchronizer 2 spi_data_out. RW | W[1:0] | A[12:0] | DATA[7:0]*/
  reg r_spi_start; /* Sychronyzer 0 spi_start */
  reg r_spi_start_1; /* Synchronizer 1 spi start */
  reg r_spi_start_2; /* Synchronizer 2 spi start */
  reg [26:0] r27_delay_1ms_counter; /* Initial 1ms delay counter*/
  reg [29:0] r30_delay_3s_counter; /* Initial 3 seconds delay counter. Only for Debug.*/
  reg [4:0] r5_adc_config_state; /* ADC controller state */
  reg r_cmd_read; /* Read command signal */
  wire w_spi_busy; /* SPI busy signal */

  /* ADC input configuration */
  assign o_zmod_adc_coupling_h_a = i_coupling_a_dc_nac;
  assign o_zmod_adc_coupling_l_a = !i_coupling_a_dc_nac;
  assign o_zmod_adc_coupling_h_b = i_coupling_b_dc_nac;
  assign o_zmod_adc_coupling_l_b = !i_coupling_b_dc_nac;
  assign o_zmod_adc_gain_h_a = i_gain_a_h_nl;
  assign o_zmod_adc_gain_l_a = !i_gain_a_h_nl;
  assign o_zmod_adc_gain_h_b = i_gain_b_h_nl;
  assign o_zmod_adc_gain_l_b = !i_gain_b_h_nl;
  assign o_zmod_adc_com_h = 1'b0;
  assign o_zmod_adc_com_l = 1'b1;
  assign o_adc_sync = 1'b0;

  always @(posedge clk)
    if (!rstn) begin
      r5_adc_config_state <= 5'd0;
      r24_spi_data_out <= 24'd0;
      r_spi_start <= 1'b0;
      r27_delay_1ms_counter <= 27'd0;
      o_adc_configured <= 1'b0;
      r_cmd_read <= 1'b0;
    end
    else
      case (r5_adc_config_state)
        0: begin
          if (r27_delay_1ms_counter == 27'd100000) r5_adc_config_state <= 5'd1;
          else r5_adc_config_state <= 5'd0;

          r27_delay_1ms_counter <= i_vadj_configured? r27_delay_1ms_counter+27'd1:0;
        end
        // 0: begin
        //   if (r30_delay_3s_counter == 30'd300000000) r5_adc_config_state <= 5'd10;
        //   else r5_adc_config_state <= 5'd0;
        //
        //   r30_delay_3s_counter <= r30_delay_3s_counter+27'd1;
        // end
        1: begin
          r5_adc_config_state <= 5'd2;

          r24_spi_data_out <= {1'b0, 2'b00, p_spi_chselect_add, p_spi_chselect_value_both};
          r_spi_start <= 1'b1;
          r_cmd_read <= 1'b0;
        end
        2: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd3;
          else r5_adc_config_state <= 5'd2;

          r_spi_start <= 1'b0;
        end
        3: begin
          r5_adc_config_state <= 5'd4;

          r24_spi_data_out <= {1'b0, 2'b00, p_spi_pwrmode_add, p_spi_pwrmode_value_reset};
          r_spi_start <= 1'b1;
          r_cmd_read <= 1'b0;
        end
        4: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd5;
          else r5_adc_config_state <= 5'd4;

          r_spi_start <= 1'b0;
        end
        5: begin /* Select chA */
          r5_adc_config_state <= 5'd6;

          r24_spi_data_out <= {1'b0, 2'b00, p_spi_chselect_add, p_spi_chselect_value_cha};
          r_spi_start <= 1'b1;
          r_cmd_read <= 1'b0;
        end
        6: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd7;
          else r5_adc_config_state <= 5'd6;

          r_spi_start <= 1'b0;
        end
        7: begin /* Output mode*/
          r5_adc_config_state <= 5'd8;

          r24_spi_data_out <= {1'b0, 2'b00, p_spi_omode_add, p_spi_omode_value_cha};
          r_spi_start <= 1'b1;
        end
        8: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd9;
          else r5_adc_config_state <= 5'd8;

          r_spi_start <= 1'b0;
        end
        9: begin /* Select chB */
          r5_adc_config_state <= 5'd10;

          r24_spi_data_out <= {1'b0, 2'b00, p_spi_chselect_add, p_spi_chselect_value_chb};
          r_spi_start <= 1'b1;
        end
        10: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd11;
          else r5_adc_config_state <= 5'd10;

          r_spi_start <= 1'b0;
        end
        11: begin /* Output mode */
          r5_adc_config_state <= 5'd12;

          r24_spi_data_out <= {1'b0, 2'b00, p_spi_omode_add, p_spi_omode_value_chb};
          r_spi_start <= 1'b1;
        end
        12: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd13;
          else r5_adc_config_state <= 5'd12;

          r_spi_start <= 1'b0;
        end
        18: begin /* Select chA*/
          r5_adc_config_state <= 5'd19;

          r24_spi_data_out <= {1'b0, 2'b00, p_spi_chselect_add, p_spi_chselect_value_cha};
          r_spi_start <= 1'b1;
          r_cmd_read <= 1'b0;
        end
        19: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd20;
          else r5_adc_config_state <= 5'd19;

          r_spi_start <= 1'b0;
        end
        20: begin /* Test mode enabled Ramp*/
          r5_adc_config_state <= 5'd21;

          // r24_spi_data_out <= {1'b0, 2'b00, p_spi_testmode_add, p_spi_testmode_value_ramp};
          r24_spi_data_out <= {1'b0, 2'b00, p_spi_testmode_add, p_spi_testmode_value_disabled};
          r_spi_start <= 1'b1;
          r_cmd_read <= 1'b0;
        end
        21: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd13;
          else r5_adc_config_state <= 5'd21;

          r_spi_start <= 1'b0;
        end
        13: begin /* Select both channels */
          r5_adc_config_state <= 5'd14;

          r24_spi_data_out <= {1'b0, 2'b00, p_spi_chselect_add, p_spi_chselect_value_both};
          r_spi_start <= 1'b1;
          r_cmd_read <= 1'b0;
        end
        14: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd15;
          else r5_adc_config_state <= 5'd14;

          r_spi_start <= 1'b0;
        end
        15: begin /* Release reset */
          r5_adc_config_state <= 5'd16;

          r24_spi_data_out <= {1'b0, 2'b00, p_spi_pwrmode_add, p_spi_pwrmode_value_release};
          r_spi_start <= 1'b1;
          r_cmd_read <= 1'b0;
        end
        16: begin
          if (!w_spi_busy) r5_adc_config_state <= 5'd17;
          else r5_adc_config_state <= 5'd16;

          r_spi_start <= 1'b0;
        end
        17: begin
          r5_adc_config_state <= 5'd17;
          /* Configuration completed */
          o_adc_configured <= 1'b1;
        end
        default:
          r5_adc_config_state <= 5'd0;
      endcase

  /* Output data */

  // BUFG BUFG_inst (
  // .O(w_dco_bufg), // 1-bit output: Clock output
  // .I(i_dco)  // 1-bit input: Clock input
  // );

  generate for(genvar i=0; i<=13; i=i+1)
    /* Zynq Ultrascale+ */
    IDDRE1 #(
    .DDR_CLK_EDGE("SAME_EDGE"),
    .IS_CB_INVERTED(1'b1),
    .IS_C_INVERTED(1'b0)
    )
    IDDRE1_inst (
    .Q1(o14_data_a[i]),
    .Q2(o14_data_b[i]),
    .C(i_dco),
    .CB(i_dco),
    .D(i14_data[i]),
    .R(!rstn)
    );
    /* Zynq7000 */
    // IDDR #(
    // .DDR_CLK_EDGE("OPPOSITE_EDGE"),
    // .INIT_Q1(1'b0),
    // .INIT_Q2(1'b0),
    // .SRTYPE("SYNC")
    // ) IDDR_ADCDATA (
    // .Q1(o14_data_a[i]),
    // .Q2(o14_data_b[i]),
    // .C(i_dco),
    // .CE(1'b1),
    // .D(i14_data[i]),
    // .R(rst),
    // .S(1'b0)
    // );
  endgenerate

  /* Synchronizers */
  always @(posedge clk_spi)
    if (!rstn) begin
      r_spi_start_1 <= 1'b0;
      r_spi_start_2 <= 1'b0;
      r24_spi_data_out_1 <= 24'd0;
      r24_spi_data_out_2 <= 24'd0;
    end
    else begin
      r_spi_start_1 <= r_spi_start;
      r_spi_start_2 <= r_spi_start_1;
      r24_spi_data_out_1 <= r24_spi_data_out;
      r24_spi_data_out_2 <= r24_spi_data_out_1;
    end

  /* SPI controller */
  reg [3:0] r4_spi_state; /* SPI controller state */
  reg [4:0] r5_data_counter; /* SPI data to write signal */

  assign w_spi_busy = (r_spi_start | r_spi_start_1 | r_spi_start_2 | (r4_spi_state != 4'd0))? 1'b1:1'b0;

  always @(posedge clk_spi)
    if (!rstn) begin
      r4_spi_state <= 3'd0;
      or_sck <= 1'b1;
      or_cs <= 1'b1;
      r5_data_counter <= 5'd23;
    end
    else
      case (r4_spi_state)
        3'd0: begin
          if (r_spi_start_2) r4_spi_state <= 3'd1;
          else r4_spi_state <= 3'd0;

          or_sck <= 1'b1;
          or_cs <= 1'b1;
          r5_data_counter <= 5'd23;
        end
        3'd1: begin
          r4_spi_state <= 3'd2;

          or_sck <= 1'b1;
          or_cs <= 1'b0;
        end
        3'd2: begin
          r4_spi_state <= 3'd3;

          or_sck <= 1'b1;
          or_cs <= 1'b0;
        end
        3'd3: begin
          r4_spi_state <= 3'd4;

          or_sck <= 1'b0;
          or_cs <= 1'b0;
        end
        3'd4: begin
          r4_spi_state <= 3'd5;

          or_sck <= 1'b0;
          or_cs <= 1'b0;
        end
        3'd5: begin
          r4_spi_state <= 3'd6;

          or_sck <= 1'b1;
          or_cs <= 1'b0;
        end
        3'd6: begin
          if (r5_data_counter == 0) r4_spi_state <= 3'd0;
          else r4_spi_state <= 3'd3;

          or_sck <= 1'b1;
          or_cs <= 1'b0;
          r5_data_counter <= (r5_data_counter>0)? r5_data_counter-5'd1: 0;
        end
      endcase

  assign o_sdio = r24_spi_data_out_2[r5_data_counter];

endmodule
