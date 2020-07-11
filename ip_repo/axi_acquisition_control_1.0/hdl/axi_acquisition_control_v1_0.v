
`timescale 1 ns / 1 ps

	module axi_acquisition_control_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
		input i_we,
		input [13:0] i14_data,
		output o_acquire_window,
		output [3:0] o4_bram_we,
		output [31:0] o32_bram_data,
		output [31:0] o32_bram_add,
		output o_bram_en,
		output o_bram_rst,
		output o_bram_data_valid,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);

	wire [31:0] w32_acquire_window;
	wire [31:0] w32_window_length;

// Instantiation of Axi Bus Interface S00_AXI
	axi_acquisition_control_v1_0_S00_AXI # (
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) axi_acquisition_control_v1_0_S00_AXI_inst (
		.slv_reg0(w32_acquire_window),
		.slv_reg1(w32_window_length),
		.slv_reg2(),
		.data2ps(32'h11223344),
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	assign o_acquire_window = w32_acquire_window[0];
	// Add user logic here
	acquisition_control_v1_0 acquisition_control_inst (
  .clk(s00_axi_aclk), /* Input clock signal */
  .rstn(s00_axi_aresetn), /* Input reset signal */
  .i_we(i_we), /* Write enable signal.*/
  .i_acquire_window(w32_acquire_window[0]), /* Adquire complete window */
  .i10_window_length(w32_window_length[9:0]), /* Window length */
  .i14_data(i14_data), /* 14 bit input adc signal. */
  .or4_bram_we(o4_bram_we), /* BRAM write enable */
  .or32_bram_data(o32_bram_data), /* BRAM data bus */
  .or32_bram_add(o32_bram_add), /* BRAM address */
  .o_bram_en(o_bram_en), /* BRAM enable */
  .o_bram_rst(o_bram_rst), /* BRAM reset */
  .o_bram_data_valid(o_bram_data_valid) /* Data ready on buffer */
  );
	// User logic ends

	endmodule
