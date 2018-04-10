// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: sfi5_ml623_demo.v
// -  /   /        
// - /___/   /\    Date Created: 07/14/2009 
// - \   \  /  \   
// -  \___\/\___\
// - 
// -Revision History:
// -----------------------------------------------------------------------------
/*
--------------------------------------------------------------------------------
Description of module:

This module contains the sfi5 interface logic, pattern generator and 
ChipScope Pro analyzer cores.
--------------------------------------------------------------------------------
*/
module sfi5_ml623_demo
(
	//SFI-5 Transmit Signals
	TXDATA_P,
	TXDATA_N,
	TXDSC_P,
	TXDSC_N,
	TXREFCK,
	TXREFCK_2,
	TXDCK,
	
	//SFI-5 Receive Signals
	RXDATA_P,
	RXDATA_N,
	RXDSC_P,
	RXDSC_N,
	
	//Switches and LED's
	PB_SW1,
	LED
);

input	[15:0]	RXDATA_P;
input	[15:0]	RXDATA_N;
input		RXDSC_P;
input		RXDSC_N;
input	[1:0]	TXREFCK;
input	[1:0]	TXREFCK_2;	// a 2nd refclk input is needed because each can only span 12 GTX's max
input		PB_SW1;

output	[15:0]	TXDATA_P;
output	[15:0]	TXDATA_N;
output		TXDSC_P;
output		TXDSC_N;
output	[1:0]	TXDCK;
output	[8:1]	LED;

wire		txusrclk2;
wire		rxusrclk2;
wire		rxrecclk_out;
wire		rxrecclk_oddr;
wire		sysclk;
wire	[15:0]	data_pat;
wire	[31:0]	frames_received;
wire	[31:0]	frame_errors;
wire	[31:0]	data_mismatches_ch00;
wire	[31:0]	data_mismatches_ch01;
wire	[31:0]	data_mismatches_ch02;
wire	[31:0]	data_mismatches_ch03;
wire	[31:0]	data_mismatches_ch04;
wire	[31:0]	data_mismatches_ch05;
wire	[31:0]	data_mismatches_ch06;
wire	[31:0]	data_mismatches_ch07;
wire	[31:0]	data_mismatches_ch08;
wire	[31:0]	data_mismatches_ch09;
wire	[31:0]	data_mismatches_ch10;
wire	[31:0]	data_mismatches_ch11;
wire	[31:0]	data_mismatches_ch12;
wire	[31:0]	data_mismatches_ch13;
wire	[31:0]	data_mismatches_ch14;
wire	[31:0]	data_mismatches_ch15;
wire	[5:0]	DSC_delay_setting;
wire	[5:0]	delay_setting_ch00;
wire	[5:0]	delay_setting_ch01;
wire	[5:0]	delay_setting_ch02;
wire	[5:0]	delay_setting_ch03;
wire	[5:0]	delay_setting_ch04;
wire	[5:0]	delay_setting_ch05;
wire	[5:0]	delay_setting_ch06;
wire	[5:0]	delay_setting_ch07;
wire	[5:0]	delay_setting_ch08;
wire	[5:0]	delay_setting_ch09;
wire	[5:0]	delay_setting_ch10;
wire	[5:0]	delay_setting_ch11;
wire	[5:0]	delay_setting_ch12;
wire	[5:0]	delay_setting_ch13;
wire	[5:0]	delay_setting_ch14;
wire	[5:0]	delay_setting_ch15;
wire	[15:0]	RXDATA00;
wire	[15:0]	RXDATA01;
wire	[15:0]	RXDATA02;
wire	[15:0]	RXDATA03;
wire	[15:0]	RXDATA04;
wire	[15:0]	RXDATA05;
wire	[15:0]	RXDATA06;
wire	[15:0]	RXDATA07;
wire	[15:0]	RXDATA08;
wire	[15:0]	RXDATA09;
wire	[15:0]	RXDATA10;
wire	[15:0]	RXDATA11;
wire	[15:0]	RXDATA12;
wire	[15:0]	RXDATA13;
wire	[15:0]	RXDATA14;
wire	[15:0]	RXDATA15;
wire		rxlof;
wire		rxlof_hist;
wire		rxooa;
wire		rxooa_hist;
wire	[7:0]	diagnostics;

wire		global_reset;
reg		global_reset2;
wire	[3:0]	DM_chan_sel;
wire	[3:0]	data_delay_chan_sel;
reg		capture_DSC_delay;
reg		capture_data_delay;
reg		capture_frames_received;
reg		capture_frame_errors;
reg		capture_data_mismatches;
reg	[3:0]	capture_DSC_delay_meta;
reg	[3:0]	capture_data_delay_meta;
reg	[3:0]	capture_frames_received_meta;
reg	[3:0]	capture_frame_errors_meta;
reg	[3:0]	capture_data_mismatches_meta;
reg	[3:0]	insert_frame_error_meta;
reg	[3:0]	insert_bit_error_meta;
reg		capture_DSC_delay_pulse;
reg		capture_data_delay_pulse;
reg		capture_frames_received_pulse;
reg		capture_frame_errors_pulse;
reg		capture_data_mismatches_pulse;
reg		insert_frame_error_pulse;
reg		insert_bit_error_pulse;
reg	[31:0]	frames_received_capture;
reg	[31:0]	frame_errors_capture;
reg	[31:0]	data_mismatches_capture;
reg	[31:0]	data_mismatches;
reg	[5:0]	DSC_delay_setting_capture;
reg	[5:0]	delay_setting;
reg	[5:0]	delay_setting_capture;

integer		I;

wire    [255:0] SYNC_IN;		// VIO signal
wire    [63:0]  SYNC_OUT;		// VIO signal
wire            ASYNC_OUT;		// VIO signal

assign LED[1]	= diagnostics[5];
assign LED[2]	= diagnostics[4];
assign LED[3]	= diagnostics[3];
assign LED[4]	= diagnostics[2];
assign LED[5]	= diagnostics[6];
assign LED[6]	= rxooa;
assign LED[7]	= rxlof;
assign LED[8]	= rxlof_hist;

assign	global_reset = SYNC_OUT[37];


always @(posedge txusrclk2)
begin
	global_reset2	<= global_reset;
end

sfi5_if_v6_16bit sfi5_if_v6_16bit_0 (
	//SFI-5 Transmit Signals
	.TXDATA_P     		(TXDATA_P),
	.TXDATA_N		(TXDATA_N),
	.TXDSC_P		(TXDSC_P),
	.TXDSC_N		(TXDSC_N),
	.TXREFCK		(TXREFCK),
	.TXREFCK_2		(TXREFCK_2),
	.TXDCK			(TXDCK),
	
	//SFI-5 Receive Signals
	.RXDATA_P		(RXDATA_P),
	.RXDATA_N		(RXDATA_N),
	.RXDSC_P		(RXDSC_P),
	.RXDSC_N		(RXDSC_N),
	.RXS			(TMP),
	
	//Global Signals
	.i_RST			(global_reset),
	.o_RESETDONE		(diagnostics[4]),
	.o_GTXPLL_LOCK		(diagnostics[5]),
	
	//System-side Transmit Data/Clock Signals
	.iv_TXDATA00_IN   	({16{data_pat[00]}}),
	.iv_TXDATA01_IN		({16{data_pat[01]}}),
	.iv_TXDATA02_IN		({16{data_pat[02]}}),
	.iv_TXDATA03_IN		({16{data_pat[03]}}),
	.iv_TXDATA04_IN		({16{data_pat[04]}}),
	.iv_TXDATA05_IN		({16{data_pat[05]}}),
	.iv_TXDATA06_IN		({16{data_pat[06]}}),
	.iv_TXDATA07_IN		({16{data_pat[07]}}),
	.iv_TXDATA08_IN		({16{data_pat[08]}}),
	.iv_TXDATA09_IN		({16{data_pat[09]}}),
	.iv_TXDATA10_IN		({16{data_pat[10]}}),
	.iv_TXDATA11_IN		({16{data_pat[11]}}),
	.iv_TXDATA12_IN		({16{data_pat[12]}}),
	.iv_TXDATA13_IN		({16{data_pat[13]}}),
	.iv_TXDATA14_IN		({16{data_pat[14]}}),
	.iv_TXDATA15_IN		({16{data_pat[15]}}),
	.o_TXUSRCLK2		(txusrclk2),
	
	//System-side Receive Data/Clock Signals
	.ov_RXDATA00_OUT	(RXDATA00),
	.ov_RXDATA01_OUT	(RXDATA01),
	.ov_RXDATA02_OUT	(RXDATA02),
	.ov_RXDATA03_OUT	(RXDATA03),
	.ov_RXDATA04_OUT	(RXDATA04),
	.ov_RXDATA05_OUT	(RXDATA05),
	.ov_RXDATA06_OUT	(RXDATA06),
	.ov_RXDATA07_OUT	(RXDATA07),
	.ov_RXDATA08_OUT	(RXDATA08),
	.ov_RXDATA09_OUT	(RXDATA09),
	.ov_RXDATA10_OUT	(RXDATA10),
	.ov_RXDATA11_OUT	(RXDATA11),
	.ov_RXDATA12_OUT	(RXDATA12),
	.ov_RXDATA13_OUT	(RXDATA13),
	.ov_RXDATA14_OUT	(RXDATA14),
	.ov_RXDATA15_OUT	(RXDATA15),
	.o_RXRECCLK		(rxrecclk_out),
	.o_RXUSRCLK2		(rxusrclk2),
	
	//System-side Transmit Diagnostics
	.o_TX_INIT_DONE		(diagnostics[3]),
	.i_INSERT_FRAME_ERROR	(insert_frame_error_pulse),
	.i_INSERT_DATA_ERROR	(insert_bit_error_pulse),
	.i_LOOPBACK		(SYNC_OUT[2:0]),
	
	//System-side Receive Diagnostics
	.o_RXOOA		(rxooa),
	.o_RXOOA_HISTORY	(rxooa_hist),
	.o_RXLOF		(rxlof),
	.o_RXLOF_HISTORY	(rxlof_hist),
	.i_CLEAR_FRAME_ERRORS	(SYNC_OUT[3]),
	.i_CLEAR_MISMATCHES	(SYNC_OUT[4]),
	.ov_FRAME_ERRORS	(frame_errors),
	.ov_FRAMES_RECEIVED	(frames_received),
	.ov_DATA_MISMATCHES_CH00(data_mismatches_ch00),
	.ov_DATA_MISMATCHES_CH01(data_mismatches_ch01),
	.ov_DATA_MISMATCHES_CH02(data_mismatches_ch02),
	.ov_DATA_MISMATCHES_CH03(data_mismatches_ch03),
	.ov_DATA_MISMATCHES_CH04(data_mismatches_ch04),
	.ov_DATA_MISMATCHES_CH05(data_mismatches_ch05),
	.ov_DATA_MISMATCHES_CH06(data_mismatches_ch06),
	.ov_DATA_MISMATCHES_CH07(data_mismatches_ch07),
	.ov_DATA_MISMATCHES_CH08(data_mismatches_ch08),
	.ov_DATA_MISMATCHES_CH09(data_mismatches_ch09),
	.ov_DATA_MISMATCHES_CH10(data_mismatches_ch10),
	.ov_DATA_MISMATCHES_CH11(data_mismatches_ch11),
	.ov_DATA_MISMATCHES_CH12(data_mismatches_ch12),
	.ov_DATA_MISMATCHES_CH13(data_mismatches_ch13),
	.ov_DATA_MISMATCHES_CH14(data_mismatches_ch14),
	.ov_DATA_MISMATCHES_CH15(data_mismatches_ch15),
	.ov_RXFRAME_SHIFT	(DSC_delay_setting),
	.ov_RXDATA_SHIFT_CH00	(delay_setting_ch00),
	.ov_RXDATA_SHIFT_CH01	(delay_setting_ch01),
	.ov_RXDATA_SHIFT_CH02	(delay_setting_ch02),
	.ov_RXDATA_SHIFT_CH03	(delay_setting_ch03),
	.ov_RXDATA_SHIFT_CH04	(delay_setting_ch04),
	.ov_RXDATA_SHIFT_CH05	(delay_setting_ch05),
	.ov_RXDATA_SHIFT_CH06	(delay_setting_ch06),
	.ov_RXDATA_SHIFT_CH07	(delay_setting_ch07),
	.ov_RXDATA_SHIFT_CH08	(delay_setting_ch08),
	.ov_RXDATA_SHIFT_CH09	(delay_setting_ch09),
	.ov_RXDATA_SHIFT_CH10	(delay_setting_ch10),
	.ov_RXDATA_SHIFT_CH11	(delay_setting_ch11),
	.ov_RXDATA_SHIFT_CH12	(delay_setting_ch12),
	.ov_RXDATA_SHIFT_CH13	(delay_setting_ch13),
	.ov_RXDATA_SHIFT_CH14	(delay_setting_ch14),
	.ov_RXDATA_SHIFT_CH15	(delay_setting_ch15),
	.o_RX_INIT_DONE		(diagnostics[2]),
	.o_RX_BUFFER_UNDERFLOW	(diagnostics[1]),
	.o_RX_BUFFER_OVERFLOW	(diagnostics[0]),
	
	//Optional Settings
	.i_TX_PREEMPHASIS		(SYNC_OUT[8:5]),
	.i_TX_POSTEMPHASIS		(SYNC_OUT[13:9]),
	.i_TX_DIFF_CTRL			(SYNC_OUT[17:14]),
	.i_RX_EQUALIZATION_MIX		(SYNC_OUT[20:18]),
	.i_TXINHIBIT			(SYNC_OUT[36]),
	.i_FRAMES2LOCK			(7'h3F),
	.i_FRAMES2UNLOCK		(7'h3F),
	.iv_MISMATCHES_2_UNLOCK		(7'h3F)
);

// Shorten raw control signals to one pulse on txusrclk2 domain
always @(posedge txusrclk2)
begin
	// Asynchronous entry point
	insert_frame_error_meta[0] <= SYNC_OUT[21];
	insert_bit_error_meta[0] <= SYNC_OUT[22];
	// Metastable flip-flops
	begin
	for(I = 0; I <= 3 - 1; I = I + 1)
		begin
		insert_frame_error_meta[I + 1] <= insert_frame_error_meta[I];
		insert_bit_error_meta[I + 1] <= insert_bit_error_meta[I];
		end
	end

// Produce one pulse only
insert_frame_error_pulse <= insert_frame_error_meta[2] & ~insert_frame_error_meta[3];
insert_bit_error_pulse <= insert_bit_error_meta[2] & ~insert_bit_error_meta[3];
end

// Shorten raw control signals to one pulse on rxusrclk2 domain
always @(posedge rxusrclk2)
begin
	// Asynchronous entry point
	capture_DSC_delay_meta[0]  <= SYNC_OUT[23];
	capture_data_delay_meta[0] <= SYNC_OUT[24];
	capture_data_mismatches_meta[0] <= SYNC_OUT[25];
	capture_frames_received_meta[0] <= SYNC_OUT[26];
	capture_frame_errors_meta[0] <= SYNC_OUT[27];
	// Metastable flip-flops
	begin
	for(I = 0; I <= 3 - 1; I = I + 1)
		begin
		capture_DSC_delay_meta[I + 1] <= capture_DSC_delay_meta[I];
		capture_data_delay_meta[I + 1] <= capture_data_delay_meta[I];
		capture_data_mismatches_meta[I + 1] <= capture_data_mismatches_meta[I];
		capture_frames_received_meta[I + 1] <= capture_frames_received_meta[I];
		capture_frame_errors_meta[I + 1] <= capture_frame_errors_meta[I];
		end
	end
// Produce one pulse only
capture_DSC_delay_pulse <= capture_DSC_delay_meta[2] & ~capture_DSC_delay_meta[3];
capture_data_delay_pulse <= capture_data_delay_meta[2] & ~capture_data_delay_meta[3];
capture_data_mismatches_pulse <= capture_data_mismatches_meta[2] & ~capture_data_mismatches_meta[3];
capture_frames_received_pulse <= capture_frames_received_meta[2] & ~capture_frames_received_meta[3];
capture_frame_errors_pulse <= capture_frame_errors_meta[2] & ~capture_frame_errors_meta[3];
end


 
assign DM_chan_sel         = SYNC_OUT[31:28];
assign data_delay_chan_sel = SYNC_OUT[35:32];

// Select data channel to read mismatches from
always @ (posedge rxusrclk2) begin
	case (DM_chan_sel)
	4'b0000: data_mismatches <= data_mismatches_ch00;
	4'b0001: data_mismatches <= data_mismatches_ch01;
	4'b0010: data_mismatches <= data_mismatches_ch02;
	4'b0011: data_mismatches <= data_mismatches_ch03;
	4'b0100: data_mismatches <= data_mismatches_ch04;
	4'b0101: data_mismatches <= data_mismatches_ch05;
	4'b0110: data_mismatches <= data_mismatches_ch06;
	4'b0111: data_mismatches <= data_mismatches_ch07;
	4'b1000: data_mismatches <= data_mismatches_ch08;
	4'b1001: data_mismatches <= data_mismatches_ch09;
	4'b1010: data_mismatches <= data_mismatches_ch10;
	4'b1011: data_mismatches <= data_mismatches_ch11;
	4'b1100: data_mismatches <= data_mismatches_ch12;
	4'b1101: data_mismatches <= data_mismatches_ch13;
	4'b1110: data_mismatches <= data_mismatches_ch14;
	4'b1111: data_mismatches <= data_mismatches_ch15;
	default: data_mismatches <= data_mismatches;
	endcase
end

// Capture data mismatches when strobe from controller is asserted 
always @(posedge rxusrclk2)
begin
	if (capture_data_mismatches_pulse)
		data_mismatches_capture <= data_mismatches;
	else
		data_mismatches_capture <= data_mismatches_capture;
end

// Capture DSC channel delay setting when strobe from controller is asserted 
always @(posedge rxusrclk2)
begin
	if (capture_DSC_delay_pulse)
		DSC_delay_setting_capture <= DSC_delay_setting;
	else
		DSC_delay_setting_capture <= DSC_delay_setting_capture;
end

// Select data channel to read delay setting from
always @ (posedge rxusrclk2) begin
	case (data_delay_chan_sel)
	4'b0000: delay_setting <= delay_setting_ch00;
	4'b0001: delay_setting <= delay_setting_ch01;
	4'b0010: delay_setting <= delay_setting_ch02;
	4'b0011: delay_setting <= delay_setting_ch03;
	4'b0100: delay_setting <= delay_setting_ch04;
	4'b0101: delay_setting <= delay_setting_ch05;
	4'b0110: delay_setting <= delay_setting_ch06;
	4'b0111: delay_setting <= delay_setting_ch07;
	4'b1000: delay_setting <= delay_setting_ch08;
	4'b1001: delay_setting <= delay_setting_ch09;
	4'b1010: delay_setting <= delay_setting_ch10;
	4'b1011: delay_setting <= delay_setting_ch11;
	4'b1100: delay_setting <= delay_setting_ch12;
	4'b1101: delay_setting <= delay_setting_ch13;
	4'b1110: delay_setting <= delay_setting_ch14;
	4'b1111: delay_setting <= delay_setting_ch15;
	default: delay_setting <= delay_setting;
	endcase
end

// Capture data delays when strobe from controller is asserted 
always @(posedge rxusrclk2)
begin
	if (capture_data_delay_pulse)
		delay_setting_capture <= delay_setting;
	else
		delay_setting_capture <= delay_setting_capture;
end

// Capture frame count received when strobe from controller is asserted 
always @(posedge rxusrclk2)
begin
	if (capture_frames_received_pulse)
		frames_received_capture <= frames_received;
	else
		frames_received_capture <= frames_received_capture;
end

// Capture frame errors received when strobe from controller is asserted 
always @(posedge rxusrclk2)
begin
	if (capture_frame_errors_pulse)
		frame_errors_capture <= frame_errors;
	else
		frame_errors_capture <= frame_errors_capture;
end

// PRBS PATTERN GENERATOR
//
PRBSGen31 PRBSGen31_0  
(
	.poly_in(31'h00000009), 
	.length_in(1'b0), 
	.data_out(data_pat), 
	.advance_in(1'b1), 
	.reset_in(global_reset2),
	.clock_in(txusrclk2)
);


assign SYNC_IN[31:0]	= data_mismatches_capture; 
assign SYNC_IN[37:32]	= delay_setting_capture;
assign SYNC_IN[43:38]	= DSC_delay_setting_capture;
assign SYNC_IN[75:44]	= frames_received_capture;
assign SYNC_IN[107:76]	= frame_errors_capture;

//******************************************************************************
// Chipscope modules

  wire [35:0] control0;
  wire [35:0] control1;
  wire [255:0] data_sampled;
  wire [7:0]  trigger;
  
assign trigger = {rxooa, rxlof, diagnostics[5:0]};

chipscope_vio i_vio
	(
	.CLK (rxusrclk2),
	.SYNC_IN(SYNC_IN),
	.CONTROL(control1),
	.ASYNC_OUT(ASYNC_OUT),
	.SYNC_OUT(SYNC_OUT)
);

chipscope_icon i_icon
 (
 .CONTROL0(control0),
 .CONTROL1(control1)
 );
  
chipscope_ila i_ila
    (
      .CONTROL(control0),
      .CLK    (rxusrclk2),
      .DATA   (data_sampled),
      .TRIG0  (trigger)
    );


assign data_sampled[15:0]  = RXDATA00;
assign data_sampled[31:16] = RXDATA01;
assign data_sampled[47:32] = RXDATA02; 
assign data_sampled[63:48] = RXDATA03; 
assign data_sampled[79:64] = RXDATA04;
assign data_sampled[95:80] = RXDATA05;
assign data_sampled[111:96] = RXDATA06;
assign data_sampled[127:112] = RXDATA07;
assign data_sampled[143:128] = RXDATA08;
assign data_sampled[159:144] = RXDATA09;
assign data_sampled[175:160] = RXDATA10;
assign data_sampled[191:176] = RXDATA11;
assign data_sampled[207:192] = RXDATA12;
assign data_sampled[223:208] = RXDATA13;
assign data_sampled[239:224] = RXDATA14;
assign data_sampled[255:240] = RXDATA15;

endmodule
  
