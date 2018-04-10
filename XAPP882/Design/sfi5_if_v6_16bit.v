// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: sfi5_if_v6_16bit.v
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

SFI-5 interface top module, containing the SFI-5 transmitter and receiver.
--------------------------------------------------------------------------------
*/
`timescale  1 ns / 10 ps

module sfi5_if_v6_16bit(
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
	RXS,
	
	//Global Signals
	i_RST,
	o_RESETDONE,
	o_GTXPLL_LOCK,
	
	//System-side Transmit Data/Clock Signals
	iv_TXDATA00_IN,
	iv_TXDATA01_IN,
	iv_TXDATA02_IN,
	iv_TXDATA03_IN,
	iv_TXDATA04_IN,
	iv_TXDATA05_IN,
	iv_TXDATA06_IN,
	iv_TXDATA07_IN,
	iv_TXDATA08_IN,
	iv_TXDATA09_IN,
	iv_TXDATA10_IN,
	iv_TXDATA11_IN,
	iv_TXDATA12_IN,
	iv_TXDATA13_IN,
	iv_TXDATA14_IN,
	iv_TXDATA15_IN,
	o_TXUSRCLK2,
	
	//System-side Receive Data/Clock Signals
	ov_RXDATA00_OUT,
	ov_RXDATA01_OUT,
	ov_RXDATA02_OUT,
	ov_RXDATA03_OUT,
	ov_RXDATA04_OUT,
	ov_RXDATA05_OUT,
	ov_RXDATA06_OUT,
	ov_RXDATA07_OUT,
	ov_RXDATA08_OUT,
	ov_RXDATA09_OUT,
	ov_RXDATA10_OUT,
	ov_RXDATA11_OUT,
	ov_RXDATA12_OUT,
	ov_RXDATA13_OUT,
	ov_RXDATA14_OUT,
	ov_RXDATA15_OUT,
	o_RXRECCLK,
	o_RXUSRCLK2,
	
	//System-side Transmit Diagnostics
	o_TX_INIT_DONE,
	i_INSERT_FRAME_ERROR,
	i_INSERT_DATA_ERROR,
	i_LOOPBACK,
	
	//System-side Receive Diagnostics
	o_RXOOA,
	o_RXOOA_HISTORY,
	o_RXLOF,
	o_RXLOF_HISTORY,
	i_CLEAR_FRAME_ERRORS,
	i_CLEAR_MISMATCHES,
	ov_FRAME_ERRORS,
	ov_FRAMES_RECEIVED,
	ov_DATA_MISMATCHES_CH00,
	ov_DATA_MISMATCHES_CH01,
	ov_DATA_MISMATCHES_CH02,
	ov_DATA_MISMATCHES_CH03,
	ov_DATA_MISMATCHES_CH04,
	ov_DATA_MISMATCHES_CH05,
	ov_DATA_MISMATCHES_CH06,
	ov_DATA_MISMATCHES_CH07,
	ov_DATA_MISMATCHES_CH08,
	ov_DATA_MISMATCHES_CH09,
	ov_DATA_MISMATCHES_CH10,
	ov_DATA_MISMATCHES_CH11,
	ov_DATA_MISMATCHES_CH12,
	ov_DATA_MISMATCHES_CH13,
	ov_DATA_MISMATCHES_CH14,
	ov_DATA_MISMATCHES_CH15,
	ov_RXFRAME_SHIFT,
	ov_RXDATA_SHIFT_CH00,
	ov_RXDATA_SHIFT_CH01,
	ov_RXDATA_SHIFT_CH02,
	ov_RXDATA_SHIFT_CH03,
	ov_RXDATA_SHIFT_CH04,
	ov_RXDATA_SHIFT_CH05,
	ov_RXDATA_SHIFT_CH06,
	ov_RXDATA_SHIFT_CH07,
	ov_RXDATA_SHIFT_CH08,
	ov_RXDATA_SHIFT_CH09,
	ov_RXDATA_SHIFT_CH10,
	ov_RXDATA_SHIFT_CH11,
	ov_RXDATA_SHIFT_CH12,
	ov_RXDATA_SHIFT_CH13,
	ov_RXDATA_SHIFT_CH14,
	ov_RXDATA_SHIFT_CH15,
	o_RX_INIT_DONE,
	o_RX_BUFFER_UNDERFLOW,
	o_RX_BUFFER_OVERFLOW,
		
	//Optional Settings
	i_TX_PREEMPHASIS,
        i_TX_POSTEMPHASIS,
	i_TXINHIBIT,
	i_TX_DIFF_CTRL,
	i_RX_EQUALIZATION_MIX,
	i_FRAMES2LOCK,
	i_FRAMES2UNLOCK,
	iv_MISMATCHES_2_UNLOCK
);

input	[15:0]	RXDATA_P;		// 16 SFI-5 RX data channels (P-side)
input	[15:0]	RXDATA_N;		// 16 SFI-5 RX data channels (N-side)
input		RXDSC_P;		// SFI-5 RX deskew channel (P-side)
input		RXDSC_N;		// SFI-5 RX deskew channel (N-side)
input	[1:0]	TXREFCK;		// Reference clock input to TX/RX from oscillator
input	[1:0]	TXREFCK_2;		// 2nd reference clock input to TX/RX from oscillator
input		i_RST;			// Global reset pin to initiate reset cycle of TX/RX. 
input	[15:0]	iv_TXDATA00_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA01_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA02_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA03_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA04_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA05_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA06_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA07_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA08_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA09_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA10_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA11_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA12_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA13_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA14_IN;		// System side data input to SFI-5 interface (256 bits total)
input	[15:0]	iv_TXDATA15_IN;		// System side data input to SFI-5 interface (256 bits total)
input		i_INSERT_FRAME_ERROR;	// Manual error insertion in the framing bits of DSC channel
input		i_INSERT_DATA_ERROR;	// Manual error insertion on data channel 15
input	[2:0]	i_LOOPBACK;		// GTX loopback settings for link troubleshooting
input	[3:0]	i_TX_PREEMPHASIS;	// GTX driver preemphasis setting
input	[3:0]	i_TX_DIFF_CTRL;		// GTX driver output swing
input	[4:0]	i_TX_POSTEMPHASIS;	// GTX driver postemphasis setting
input		i_TXINHIBIT;		// When asserted, GTX TX drivers are disabled
input	[2:0]	i_RX_EQUALIZATION_MIX;	// Mixing of high and low frequency signal components
input		i_CLEAR_FRAME_ERRORS;	// Clears frame error count and RXLOF_HISTORY
input		i_CLEAR_MISMATCHES;	// Clears mismatch counts and all diagnostic sticky bits
input	[6:0]	i_FRAMES2LOCK;		// User-defined threshold for framer lock
input	[6:0]	i_FRAMES2UNLOCK;	// User-defined threshold for framer unlock
input	[6:0]	iv_MISMATCHES_2_UNLOCK;	// User-defined threshold for data sync loss

output	[15:0]	TXDATA_P;		// 16 SFI-5 TX data channels (P-side)
output	[15:0]	TXDATA_N;		// 16 SFI-5 TX data channels (N-side)
output		TXDSC_P;		// SFI-5 TX deskew channel (P-side)
output		TXDSC_N;		// SFI-5 TX deskew channel (N-side)
output	[1:0]	TXDCK;			// Clock reference forwarded to RX (optional to use in RX)
output		RXS;			// Receive status (tied to no alarm by this implementation)
output		o_RESETDONE;		// Sticky bit indicating that all GTX's have completed their resets
output		o_GTXPLL_LOCK;		// Sticky bit indicating that all GTX's PLL's have locked
output		o_TXUSRCLK2;		// The txusrclk2 is made available to the user for system use
output	[15:0]	ov_RXDATA00_OUT;	// System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA01_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA02_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA03_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA04_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA05_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA06_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA07_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA08_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA09_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA10_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA11_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA12_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA13_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA14_OUT;        // System side data output from SFI-5 interface (256 bits total)
output	[15:0]	ov_RXDATA15_OUT;        // System side data output from SFI-5 interface (256 bits total)
output		o_RXRECCLK;		// The rxrecclk is made available to the user for system use
output		o_RXUSRCLK2;		// The rxusrclk2 is made available to the user for system use
output		o_RXOOA;		// RX out of alignment (one or more data channels is misaligned)
output		o_RXOOA_HISTORY;	// RX out of alignment history (sticky bit)
output		o_RXLOF;		// RX loss of frame (framer has not locked to deskew channel frame)
output		o_RXLOF_HISTORY;	// RX loss of frame history (sticky bit)
output	[31:0]	ov_FRAME_ERRORS;	// Running count of frame errors
output	[31:0]	ov_FRAMES_RECEIVED;	// Running count of frames received
output	[31:0]	ov_DATA_MISMATCHES_CH00;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH01;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH02;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH03;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH04;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH05;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH06;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH07;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH08;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH09;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH10;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH11;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH12;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH13;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH14;// Running count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH15;// Running count of data mismatches when compared to deskew channel
output	[5:0]	ov_RXFRAME_SHIFT;	// Barrel shifter setting of deskew channel
output	[5:0]	ov_RXDATA_SHIFT_CH00;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH01;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH02;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH03;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH04;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH05;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH06;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH07;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH08;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH09;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH10;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH11;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH12;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH13;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH14;	// Barrel shifter setting of data channel
output	[5:0]	ov_RXDATA_SHIFT_CH15;	// Barrel shifter setting of data channel
output		o_RX_INIT_DONE;		// RX reset sequence is complete (sticky bit)
output		o_RX_BUFFER_UNDERFLOW;	// GTX RX elastic buffer underflow (sticky bit)
output		o_RX_BUFFER_OVERFLOW;	// GTX RX elastic buffer overflow (sticky bit)
output		o_TX_INIT_DONE;		// TX reset sequence is complete (sticky bit)

wire		rxrecclk;
(*KEEP = "TRUE"*)
wire		rxusrclk2;
wire		txusrclk;
(*KEEP = "TRUE"*)
wire		txusrclk2;
wire		txusrclk_oddr;
wire		txrefclk_2_gtx;
wire		txrefclk_2_gtx_2;
wire		refclkout;
wire	[15:0]	rxdata00_out;
wire	[15:0]	rxdata01_out;
wire	[15:0]	rxdata02_out;
wire	[15:0]	rxdata03_out;
wire	[15:0]	rxdata04_out;
wire	[15:0]	rxdata05_out;
wire	[15:0]	rxdata06_out;
wire	[15:0]	rxdata07_out;
wire	[15:0]	rxdata08_out;
wire	[15:0]	rxdata09_out;
wire	[15:0]	rxdata10_out;
wire	[15:0]	rxdata11_out;
wire	[15:0]	rxdata12_out;
wire	[15:0]	rxdata13_out;
wire	[15:0]	rxdata14_out;
wire	[15:0]	rxdata15_out;
wire	[15:0]	rxdata00_aligned;
wire	[15:0]	rxdata01_aligned;
wire	[15:0]	rxdata02_aligned;
wire	[15:0]	rxdata03_aligned;
wire	[15:0]	rxdata04_aligned;
wire	[15:0]	rxdata05_aligned;
wire	[15:0]	rxdata06_aligned;
wire	[15:0]	rxdata07_aligned;
wire	[15:0]	rxdata08_aligned;
wire	[15:0]	rxdata09_aligned;
wire	[15:0]	rxdata10_aligned;
wire	[15:0]	rxdata11_aligned;
wire	[15:0]	rxdata12_aligned;
wire	[15:0]	rxdata13_aligned;
wire	[15:0]	rxdata14_aligned;
wire	[15:0]	rxdata15_aligned;
wire	[15:0]	deskew_out;
wire	[15:0]	deskew_in;
wire	[16:0]	gtx_pll_locked;
wire		gtx_pll_locked_all;
wire	[16:0]	gtx_reset_done;
wire		gtx_reset_done_all;
wire		gtx_txpmaphasealign;
wire		gtx_txpmasetphase;
wire		tx_logic_reset;
wire		rx_logic_reset;
reg	[15:0]	txdata00_in;
reg	[15:0]	txdata01_in;
reg	[15:0]	txdata02_in;
reg	[15:0]	txdata03_in;
reg	[15:0]	txdata04_in;
reg	[15:0]	txdata05_in;
reg	[15:0]	txdata06_in;
reg	[15:0]	txdata07_in;
reg	[15:0]	txdata08_in;
reg	[15:0]	txdata09_in;
reg	[15:0]	txdata10_in;
reg	[15:0]	txdata11_in;
reg	[15:0]	txdata12_in;
reg	[15:0]	txdata13_in;
reg	[15:0]	txdata14_in;
reg	[15:0]	txdata15_in;
wire	[15:0]	txdata00_tmp;
wire	[15:0]	txdata01_tmp;
wire	[15:0]	txdata02_tmp;
wire	[15:0]	txdata03_tmp;
wire	[15:0]	txdata04_tmp;
wire	[15:0]	txdata05_tmp;
wire	[15:0]	txdata06_tmp;
wire	[15:0]	txdata07_tmp;
wire	[15:0]	txdata08_tmp;
wire	[15:0]	txdata09_tmp;
wire	[15:0]	txdata10_tmp;
wire	[15:0]	txdata11_tmp;
wire	[15:0]	txdata12_tmp;
wire	[15:0]	txdata13_tmp;
wire	[15:0]	txdata14_tmp;
wire	[15:0]	txdata15_tmp;
wire	[15:0]	rxooa_all_channels;
wire	[16:0]	rx_buffer_underflow;
wire	[16:0]	rx_buffer_overflow;

wire    [2:0]   gtx0_rxbufstatus_i;
wire    [2:0]   gtx1_rxbufstatus_i;
wire    [2:0]   gtx2_rxbufstatus_i;
wire    [2:0]   gtx3_rxbufstatus_i;
wire    [2:0]   gtx4_rxbufstatus_i;
wire    [2:0]   gtx5_rxbufstatus_i;
wire    [2:0]   gtx6_rxbufstatus_i;
wire    [2:0]   gtx7_rxbufstatus_i;
wire    [2:0]   gtx8_rxbufstatus_i;
wire    [2:0]   gtx9_rxbufstatus_i;
wire    [2:0]   gtx10_rxbufstatus_i;
wire    [2:0]   gtx11_rxbufstatus_i;
wire    [2:0]   gtx12_rxbufstatus_i;
wire    [2:0]   gtx13_rxbufstatus_i;
wire    [2:0]   gtx14_rxbufstatus_i;
wire    [2:0]   gtx15_rxbufstatus_i;
wire    [2:0]   gtx16_rxbufstatus_i;

reg 	[16:0]	gtx_reset_done_r;
(*KEEP = "TRUE"*)
reg             resetdone_tmp = 0;
reg		resetdone = 0;
reg		gtxpll_lock = 0;
reg		gtxs_ready_meta = 0;
reg		gtxs_ready = 0;
reg		tx_logic_reset_txusrclk2 = 0;
reg		rx_logic_reset_rxusrclk2 = 0;
reg		o_RXOOA_HISTORY = 0;
reg		o_RESETDONE = 0;
reg		o_GTXPLL_LOCK = 0;
reg		o_RX_INIT_DONE = 0;
reg		o_RX_BUFFER_UNDERFLOW = 0;
reg		o_RX_BUFFER_OVERFLOW = 0;
reg		o_TX_INIT_DONE = 0;

assign	txdata00_tmp		=	{iv_TXDATA15_IN[00],iv_TXDATA14_IN[00],iv_TXDATA13_IN[00],iv_TXDATA12_IN[00],iv_TXDATA11_IN[00],iv_TXDATA10_IN[00],iv_TXDATA09_IN[00],iv_TXDATA08_IN[00],iv_TXDATA07_IN[00],iv_TXDATA06_IN[00],iv_TXDATA05_IN[00],iv_TXDATA04_IN[00],iv_TXDATA03_IN[00],iv_TXDATA02_IN[00],iv_TXDATA01_IN[00],iv_TXDATA00_IN[00]};
assign	txdata01_tmp		=	{iv_TXDATA15_IN[01],iv_TXDATA14_IN[01],iv_TXDATA13_IN[01],iv_TXDATA12_IN[01],iv_TXDATA11_IN[01],iv_TXDATA10_IN[01],iv_TXDATA09_IN[01],iv_TXDATA08_IN[01],iv_TXDATA07_IN[01],iv_TXDATA06_IN[01],iv_TXDATA05_IN[01],iv_TXDATA04_IN[01],iv_TXDATA03_IN[01],iv_TXDATA02_IN[01],iv_TXDATA01_IN[01],iv_TXDATA00_IN[01]};
assign	txdata02_tmp		=	{iv_TXDATA15_IN[02],iv_TXDATA14_IN[02],iv_TXDATA13_IN[02],iv_TXDATA12_IN[02],iv_TXDATA11_IN[02],iv_TXDATA10_IN[02],iv_TXDATA09_IN[02],iv_TXDATA08_IN[02],iv_TXDATA07_IN[02],iv_TXDATA06_IN[02],iv_TXDATA05_IN[02],iv_TXDATA04_IN[02],iv_TXDATA03_IN[02],iv_TXDATA02_IN[02],iv_TXDATA01_IN[02],iv_TXDATA00_IN[02]};
assign	txdata03_tmp		=	{iv_TXDATA15_IN[03],iv_TXDATA14_IN[03],iv_TXDATA13_IN[03],iv_TXDATA12_IN[03],iv_TXDATA11_IN[03],iv_TXDATA10_IN[03],iv_TXDATA09_IN[03],iv_TXDATA08_IN[03],iv_TXDATA07_IN[03],iv_TXDATA06_IN[03],iv_TXDATA05_IN[03],iv_TXDATA04_IN[03],iv_TXDATA03_IN[03],iv_TXDATA02_IN[03],iv_TXDATA01_IN[03],iv_TXDATA00_IN[03]};
assign	txdata04_tmp		=	{iv_TXDATA15_IN[04],iv_TXDATA14_IN[04],iv_TXDATA13_IN[04],iv_TXDATA12_IN[04],iv_TXDATA11_IN[04],iv_TXDATA10_IN[04],iv_TXDATA09_IN[04],iv_TXDATA08_IN[04],iv_TXDATA07_IN[04],iv_TXDATA06_IN[04],iv_TXDATA05_IN[04],iv_TXDATA04_IN[04],iv_TXDATA03_IN[04],iv_TXDATA02_IN[04],iv_TXDATA01_IN[04],iv_TXDATA00_IN[04]};
assign	txdata05_tmp		=	{iv_TXDATA15_IN[05],iv_TXDATA14_IN[05],iv_TXDATA13_IN[05],iv_TXDATA12_IN[05],iv_TXDATA11_IN[05],iv_TXDATA10_IN[05],iv_TXDATA09_IN[05],iv_TXDATA08_IN[05],iv_TXDATA07_IN[05],iv_TXDATA06_IN[05],iv_TXDATA05_IN[05],iv_TXDATA04_IN[05],iv_TXDATA03_IN[05],iv_TXDATA02_IN[05],iv_TXDATA01_IN[05],iv_TXDATA00_IN[05]};
assign	txdata06_tmp		=	{iv_TXDATA15_IN[06],iv_TXDATA14_IN[06],iv_TXDATA13_IN[06],iv_TXDATA12_IN[06],iv_TXDATA11_IN[06],iv_TXDATA10_IN[06],iv_TXDATA09_IN[06],iv_TXDATA08_IN[06],iv_TXDATA07_IN[06],iv_TXDATA06_IN[06],iv_TXDATA05_IN[06],iv_TXDATA04_IN[06],iv_TXDATA03_IN[06],iv_TXDATA02_IN[06],iv_TXDATA01_IN[06],iv_TXDATA00_IN[06]};
assign	txdata07_tmp		=	{iv_TXDATA15_IN[07],iv_TXDATA14_IN[07],iv_TXDATA13_IN[07],iv_TXDATA12_IN[07],iv_TXDATA11_IN[07],iv_TXDATA10_IN[07],iv_TXDATA09_IN[07],iv_TXDATA08_IN[07],iv_TXDATA07_IN[07],iv_TXDATA06_IN[07],iv_TXDATA05_IN[07],iv_TXDATA04_IN[07],iv_TXDATA03_IN[07],iv_TXDATA02_IN[07],iv_TXDATA01_IN[07],iv_TXDATA00_IN[07]};
assign	txdata08_tmp		=	{iv_TXDATA15_IN[08],iv_TXDATA14_IN[08],iv_TXDATA13_IN[08],iv_TXDATA12_IN[08],iv_TXDATA11_IN[08],iv_TXDATA10_IN[08],iv_TXDATA09_IN[08],iv_TXDATA08_IN[08],iv_TXDATA07_IN[08],iv_TXDATA06_IN[08],iv_TXDATA05_IN[08],iv_TXDATA04_IN[08],iv_TXDATA03_IN[08],iv_TXDATA02_IN[08],iv_TXDATA01_IN[08],iv_TXDATA00_IN[08]};
assign	txdata09_tmp		=	{iv_TXDATA15_IN[09],iv_TXDATA14_IN[09],iv_TXDATA13_IN[09],iv_TXDATA12_IN[09],iv_TXDATA11_IN[09],iv_TXDATA10_IN[09],iv_TXDATA09_IN[09],iv_TXDATA08_IN[09],iv_TXDATA07_IN[09],iv_TXDATA06_IN[09],iv_TXDATA05_IN[09],iv_TXDATA04_IN[09],iv_TXDATA03_IN[09],iv_TXDATA02_IN[09],iv_TXDATA01_IN[09],iv_TXDATA00_IN[09]};
assign	txdata10_tmp		=	{iv_TXDATA15_IN[10],iv_TXDATA14_IN[10],iv_TXDATA13_IN[10],iv_TXDATA12_IN[10],iv_TXDATA11_IN[10],iv_TXDATA10_IN[10],iv_TXDATA09_IN[10],iv_TXDATA08_IN[10],iv_TXDATA07_IN[10],iv_TXDATA06_IN[10],iv_TXDATA05_IN[10],iv_TXDATA04_IN[10],iv_TXDATA03_IN[10],iv_TXDATA02_IN[10],iv_TXDATA01_IN[10],iv_TXDATA00_IN[10]};
assign	txdata11_tmp		=	{iv_TXDATA15_IN[11],iv_TXDATA14_IN[11],iv_TXDATA13_IN[11],iv_TXDATA12_IN[11],iv_TXDATA11_IN[11],iv_TXDATA10_IN[11],iv_TXDATA09_IN[11],iv_TXDATA08_IN[11],iv_TXDATA07_IN[11],iv_TXDATA06_IN[11],iv_TXDATA05_IN[11],iv_TXDATA04_IN[11],iv_TXDATA03_IN[11],iv_TXDATA02_IN[11],iv_TXDATA01_IN[11],iv_TXDATA00_IN[11]};
assign	txdata12_tmp		=	{iv_TXDATA15_IN[12],iv_TXDATA14_IN[12],iv_TXDATA13_IN[12],iv_TXDATA12_IN[12],iv_TXDATA11_IN[12],iv_TXDATA10_IN[12],iv_TXDATA09_IN[12],iv_TXDATA08_IN[12],iv_TXDATA07_IN[12],iv_TXDATA06_IN[12],iv_TXDATA05_IN[12],iv_TXDATA04_IN[12],iv_TXDATA03_IN[12],iv_TXDATA02_IN[12],iv_TXDATA01_IN[12],iv_TXDATA00_IN[12]};
assign	txdata13_tmp		=	{iv_TXDATA15_IN[13],iv_TXDATA14_IN[13],iv_TXDATA13_IN[13],iv_TXDATA12_IN[13],iv_TXDATA11_IN[13],iv_TXDATA10_IN[13],iv_TXDATA09_IN[13],iv_TXDATA08_IN[13],iv_TXDATA07_IN[13],iv_TXDATA06_IN[13],iv_TXDATA05_IN[13],iv_TXDATA04_IN[13],iv_TXDATA03_IN[13],iv_TXDATA02_IN[13],iv_TXDATA01_IN[13],iv_TXDATA00_IN[13]};
assign	txdata14_tmp		=	{iv_TXDATA15_IN[14],iv_TXDATA14_IN[14],iv_TXDATA13_IN[14],iv_TXDATA12_IN[14],iv_TXDATA11_IN[14],iv_TXDATA10_IN[14],iv_TXDATA09_IN[14],iv_TXDATA08_IN[14],iv_TXDATA07_IN[14],iv_TXDATA06_IN[14],iv_TXDATA05_IN[14],iv_TXDATA04_IN[14],iv_TXDATA03_IN[14],iv_TXDATA02_IN[14],iv_TXDATA01_IN[14],iv_TXDATA00_IN[14]};
assign	txdata15_tmp		=	{iv_TXDATA15_IN[15],iv_TXDATA14_IN[15],iv_TXDATA13_IN[15],iv_TXDATA12_IN[15],iv_TXDATA11_IN[15],iv_TXDATA10_IN[15],iv_TXDATA09_IN[15],iv_TXDATA08_IN[15],iv_TXDATA07_IN[15],iv_TXDATA06_IN[15],iv_TXDATA05_IN[15],iv_TXDATA04_IN[15],iv_TXDATA03_IN[15],iv_TXDATA02_IN[15],iv_TXDATA01_IN[15],iv_TXDATA00_IN[15]};

assign	ov_RXDATA00_OUT		=	{rxdata15_aligned[00],rxdata14_aligned[00],rxdata13_aligned[00],rxdata12_aligned[00],rxdata11_aligned[00],rxdata10_aligned[00],rxdata09_aligned[00],rxdata08_aligned[00],rxdata07_aligned[00],rxdata06_aligned[00],rxdata05_aligned[00],rxdata04_aligned[00],rxdata03_aligned[00],rxdata02_aligned[00],rxdata01_aligned[00],rxdata00_aligned[00]};
assign	ov_RXDATA01_OUT		=	{rxdata15_aligned[01],rxdata14_aligned[01],rxdata13_aligned[01],rxdata12_aligned[01],rxdata11_aligned[01],rxdata10_aligned[01],rxdata09_aligned[01],rxdata08_aligned[01],rxdata07_aligned[01],rxdata06_aligned[01],rxdata05_aligned[01],rxdata04_aligned[01],rxdata03_aligned[01],rxdata02_aligned[01],rxdata01_aligned[01],rxdata00_aligned[01]};
assign	ov_RXDATA02_OUT		=	{rxdata15_aligned[02],rxdata14_aligned[02],rxdata13_aligned[02],rxdata12_aligned[02],rxdata11_aligned[02],rxdata10_aligned[02],rxdata09_aligned[02],rxdata08_aligned[02],rxdata07_aligned[02],rxdata06_aligned[02],rxdata05_aligned[02],rxdata04_aligned[02],rxdata03_aligned[02],rxdata02_aligned[02],rxdata01_aligned[02],rxdata00_aligned[02]};
assign	ov_RXDATA03_OUT		=	{rxdata15_aligned[03],rxdata14_aligned[03],rxdata13_aligned[03],rxdata12_aligned[03],rxdata11_aligned[03],rxdata10_aligned[03],rxdata09_aligned[03],rxdata08_aligned[03],rxdata07_aligned[03],rxdata06_aligned[03],rxdata05_aligned[03],rxdata04_aligned[03],rxdata03_aligned[03],rxdata02_aligned[03],rxdata01_aligned[03],rxdata00_aligned[03]};
assign	ov_RXDATA04_OUT		=	{rxdata15_aligned[04],rxdata14_aligned[04],rxdata13_aligned[04],rxdata12_aligned[04],rxdata11_aligned[04],rxdata10_aligned[04],rxdata09_aligned[04],rxdata08_aligned[04],rxdata07_aligned[04],rxdata06_aligned[04],rxdata05_aligned[04],rxdata04_aligned[04],rxdata03_aligned[04],rxdata02_aligned[04],rxdata01_aligned[04],rxdata00_aligned[04]};
assign	ov_RXDATA05_OUT		=	{rxdata15_aligned[05],rxdata14_aligned[05],rxdata13_aligned[05],rxdata12_aligned[05],rxdata11_aligned[05],rxdata10_aligned[05],rxdata09_aligned[05],rxdata08_aligned[05],rxdata07_aligned[05],rxdata06_aligned[05],rxdata05_aligned[05],rxdata04_aligned[05],rxdata03_aligned[05],rxdata02_aligned[05],rxdata01_aligned[05],rxdata00_aligned[05]};
assign	ov_RXDATA06_OUT		=	{rxdata15_aligned[06],rxdata14_aligned[06],rxdata13_aligned[06],rxdata12_aligned[06],rxdata11_aligned[06],rxdata10_aligned[06],rxdata09_aligned[06],rxdata08_aligned[06],rxdata07_aligned[06],rxdata06_aligned[06],rxdata05_aligned[06],rxdata04_aligned[06],rxdata03_aligned[06],rxdata02_aligned[06],rxdata01_aligned[06],rxdata00_aligned[06]};
assign	ov_RXDATA07_OUT		=	{rxdata15_aligned[07],rxdata14_aligned[07],rxdata13_aligned[07],rxdata12_aligned[07],rxdata11_aligned[07],rxdata10_aligned[07],rxdata09_aligned[07],rxdata08_aligned[07],rxdata07_aligned[07],rxdata06_aligned[07],rxdata05_aligned[07],rxdata04_aligned[07],rxdata03_aligned[07],rxdata02_aligned[07],rxdata01_aligned[07],rxdata00_aligned[07]};
assign	ov_RXDATA08_OUT		=	{rxdata15_aligned[08],rxdata14_aligned[08],rxdata13_aligned[08],rxdata12_aligned[08],rxdata11_aligned[08],rxdata10_aligned[08],rxdata09_aligned[08],rxdata08_aligned[08],rxdata07_aligned[08],rxdata06_aligned[08],rxdata05_aligned[08],rxdata04_aligned[08],rxdata03_aligned[08],rxdata02_aligned[08],rxdata01_aligned[08],rxdata00_aligned[08]};
assign	ov_RXDATA09_OUT		=	{rxdata15_aligned[09],rxdata14_aligned[09],rxdata13_aligned[09],rxdata12_aligned[09],rxdata11_aligned[09],rxdata10_aligned[09],rxdata09_aligned[09],rxdata08_aligned[09],rxdata07_aligned[09],rxdata06_aligned[09],rxdata05_aligned[09],rxdata04_aligned[09],rxdata03_aligned[09],rxdata02_aligned[09],rxdata01_aligned[09],rxdata00_aligned[09]};
assign	ov_RXDATA10_OUT		=	{rxdata15_aligned[10],rxdata14_aligned[10],rxdata13_aligned[10],rxdata12_aligned[10],rxdata11_aligned[10],rxdata10_aligned[10],rxdata09_aligned[10],rxdata08_aligned[10],rxdata07_aligned[10],rxdata06_aligned[10],rxdata05_aligned[10],rxdata04_aligned[10],rxdata03_aligned[10],rxdata02_aligned[10],rxdata01_aligned[10],rxdata00_aligned[10]};
assign	ov_RXDATA11_OUT		=	{rxdata15_aligned[11],rxdata14_aligned[11],rxdata13_aligned[11],rxdata12_aligned[11],rxdata11_aligned[11],rxdata10_aligned[11],rxdata09_aligned[11],rxdata08_aligned[11],rxdata07_aligned[11],rxdata06_aligned[11],rxdata05_aligned[11],rxdata04_aligned[11],rxdata03_aligned[11],rxdata02_aligned[11],rxdata01_aligned[11],rxdata00_aligned[11]};
assign	ov_RXDATA12_OUT		=	{rxdata15_aligned[12],rxdata14_aligned[12],rxdata13_aligned[12],rxdata12_aligned[12],rxdata11_aligned[12],rxdata10_aligned[12],rxdata09_aligned[12],rxdata08_aligned[12],rxdata07_aligned[12],rxdata06_aligned[12],rxdata05_aligned[12],rxdata04_aligned[12],rxdata03_aligned[12],rxdata02_aligned[12],rxdata01_aligned[12],rxdata00_aligned[12]};
assign	ov_RXDATA13_OUT		=	{rxdata15_aligned[13],rxdata14_aligned[13],rxdata13_aligned[13],rxdata12_aligned[13],rxdata11_aligned[13],rxdata10_aligned[13],rxdata09_aligned[13],rxdata08_aligned[13],rxdata07_aligned[13],rxdata06_aligned[13],rxdata05_aligned[13],rxdata04_aligned[13],rxdata03_aligned[13],rxdata02_aligned[13],rxdata01_aligned[13],rxdata00_aligned[13]};
assign	ov_RXDATA14_OUT		=	{rxdata15_aligned[14],rxdata14_aligned[14],rxdata13_aligned[14],rxdata12_aligned[14],rxdata11_aligned[14],rxdata10_aligned[14],rxdata09_aligned[14],rxdata08_aligned[14],rxdata07_aligned[14],rxdata06_aligned[14],rxdata05_aligned[14],rxdata04_aligned[14],rxdata03_aligned[14],rxdata02_aligned[14],rxdata01_aligned[14],rxdata00_aligned[14]};
assign	ov_RXDATA15_OUT		=	{rxdata15_aligned[15],rxdata14_aligned[15],rxdata13_aligned[15],rxdata12_aligned[15],rxdata11_aligned[15],rxdata10_aligned[15],rxdata09_aligned[15],rxdata08_aligned[15],rxdata07_aligned[15],rxdata06_aligned[15],rxdata05_aligned[15],rxdata04_aligned[15],rxdata03_aligned[15],rxdata02_aligned[15],rxdata01_aligned[15],rxdata00_aligned[15]};

assign	gtx_pll_locked_all	=	&gtx_pll_locked;
assign	gtx_reset_done_all	=	&gtx_reset_done_r;
assign	RXS			=	1'b0;
assign	o_TXUSRCLK2		=	txusrclk2;
assign	o_RXRECCLK		=	rxrecclk;
assign	o_RXUSRCLK2		=	rxusrclk2;
assign	o_RXOOA			=	|rxooa_all_channels;

//===============================================================================
// Clock inputs/outputs
//===============================================================================

IBUFDS_GTXE1 IBUFDS_inst (
        .O                              (txrefclk_2_gtx),
        .ODIV2                          (),
        .CEB                            (1'b0),
        .I                              (TXREFCK[0]),
        .IB                             (TXREFCK[1])
    );
    
IBUFDS_GTXE1 IBUFDS_inst_2 (
        .O                              (txrefclk_2_gtx_2),
        .ODIV2                          (),
        .CEB                            (1'b0),
        .I                              (TXREFCK_2[0]),
        .IB                             (TXREFCK_2[1])
    );




OBUFDS #(
	.IOSTANDARD("LVDS_25")
) OBUFDS_inst (
	.O(TXDCK[0]),
	.OB(TXDCK[1]),
	.I(txusrclk_oddr)
);

ODDR #(
	.DDR_CLK_EDGE("OPPOSITE_EDGE"),
	.INIT(1'b0),
	.SRTYPE("SYNC")
) ODDR_inst (
	.Q(txusrclk_oddr),
	.C(txusrclk2),
	.CE(1'b1),
	.D1(1'b1),
	.D2(1'b0),
	.R(1'b0),
	.S(1'b0)
);

//===============================================================================
// Clock generation and reset logic for RX and TX interfaces 
//===============================================================================

BUFG TXUSRCLK_BUFG(.O(txusrclk2), .I(refclkout));
BUFG RXUSRCLK_BUFG(.O(rxusrclk2), .I(rxrecclk));

// register to avoid timing violations
always @ (posedge txusrclk2) begin
	txdata00_in <= txdata00_tmp;
	txdata01_in <= txdata01_tmp;
	txdata02_in <= txdata02_tmp;
	txdata03_in <= txdata03_tmp;
	txdata04_in <= txdata04_tmp;
	txdata05_in <= txdata05_tmp;
	txdata06_in <= txdata06_tmp;
	txdata07_in <= txdata07_tmp;
	txdata08_in <= txdata08_tmp;
	txdata09_in <= txdata09_tmp;
	txdata10_in <= txdata10_tmp;
	txdata11_in <= txdata11_tmp;
	txdata12_in <= txdata12_tmp;
	txdata13_in <= txdata13_tmp;
	txdata14_in <= txdata14_tmp;
	txdata15_in <= txdata15_tmp;
end

always @ (posedge txusrclk2)
	gtx_reset_done_r = gtx_reset_done;
 
always @ (posedge txusrclk2) begin
	resetdone_tmp	<= gtx_reset_done_all;
	resetdone       <= resetdone_tmp;
	gtxpll_lock	<= gtx_pll_locked_all;
	gtxs_ready_meta	<= ((gtxpll_lock==1'b1) && (resetdone == 1'b1)); 
	gtxs_ready	<= gtxs_ready_meta;
end

sfi5_reset_tx sfi5_reset_tx_0(
	.i_CLK               (txusrclk2),
	.i_RST               (i_RST),
	.i_GTXS_READY        (gtxs_ready),
	.o_TXENPHASEALIGN    (gtx_txpmaphasealign),
	.o_TXPMASETPHASE     (gtx_txpmasetphase),
	.o_TXDLYALIGNDISABLE (gtx_txdlyaligndisable),
	.o_TXDLYALIGNRESET   (gtx_txdlyalignreset),
	.o_TX_LOGIC_RST      (tx_logic_reset),
	.o_GTXS_RST          (gtxs_rst)
    );
    
sfi5_reset_rx sfi5_reset_rx_0(
	.i_CLK          (txusrclk2),
	.i_RST          (i_RST),
	.i_GTXS_READY   (gtxs_ready),
	.o_RX_LOGIC_RST (rx_logic_reset),
	.i_RXLOF        (o_RXLOF),
	.i_RXOOA        (o_RXOOA),
	.o_RESET_GTXS   (gtxs_rst_from_rx)
    );

//===============================================================================
// Transmitter logic (deskew channel generation)
//===============================================================================

always @(posedge txusrclk2)
begin
	tx_logic_reset_txusrclk2	<= tx_logic_reset;
end

sfi5_tx_deskew_channel sfi5_tx_deskew_channel_0
(
	.i_CLK(txusrclk2),
	.i_RST(tx_logic_reset_txusrclk2),
	.iv_TXDATA00(txdata00_in),
	.iv_TXDATA01(txdata01_in),
	.iv_TXDATA02(txdata02_in),
	.iv_TXDATA03(txdata03_in),
	.iv_TXDATA04(txdata04_in),
	.iv_TXDATA05(txdata05_in),
	.iv_TXDATA06(txdata06_in),
	.iv_TXDATA07(txdata07_in),
	.iv_TXDATA08(txdata08_in),
	.iv_TXDATA09(txdata09_in),
	.iv_TXDATA10(txdata10_in),
	.iv_TXDATA11(txdata11_in),
	.iv_TXDATA12(txdata12_in),
	.iv_TXDATA13(txdata13_in),
	.iv_TXDATA14(txdata14_in),
	.iv_TXDATA15(txdata15_in),
	.ov_DESKEW_CHANNEL(deskew_in),
	.i_INSERT_FRAME_ERROR(i_INSERT_FRAME_ERROR),
	.i_INSERT_DATA_ERROR(i_INSERT_DATA_ERROR)
);

//===============================================================================
// Receiver logic (deskew channel framing, data deskew)
//===============================================================================

always @(posedge rxusrclk2) begin
	if (i_CLEAR_MISMATCHES)
		o_RXOOA_HISTORY <= 1'b0;
	else if (o_RXOOA)
		o_RXOOA_HISTORY <= 1'b1;
	else
		o_RXOOA_HISTORY <= o_RXOOA_HISTORY;
end

always @(posedge rxusrclk2)
begin
	rx_logic_reset_rxusrclk2	<= rx_logic_reset;
end

sfi5_rx_if_v6_16bit sfi5_rx_if_v6_16bit_0
(
	.i_CLK(rxusrclk2),
	.i_RST(rx_logic_reset_rxusrclk2),
	.iv_RXDATA00(rxdata00_out),
	.iv_RXDATA01(rxdata01_out),
	.iv_RXDATA02(rxdata02_out),
	.iv_RXDATA03(rxdata03_out),
	.iv_RXDATA04(rxdata04_out),
	.iv_RXDATA05(rxdata05_out),
	.iv_RXDATA06(rxdata06_out),
	.iv_RXDATA07(rxdata07_out),
	.iv_RXDATA08(rxdata08_out),
	.iv_RXDATA09(rxdata09_out),
	.iv_RXDATA10(rxdata10_out),
	.iv_RXDATA11(rxdata11_out),
	.iv_RXDATA12(rxdata12_out),
	.iv_RXDATA13(rxdata13_out),
	.iv_RXDATA14(rxdata14_out),
	.iv_RXDATA15(rxdata15_out),
	.iv_DESKEW_CHANNEL(deskew_out),
	.i_FRAMES2LOCK(i_FRAMES2LOCK),
	.i_FRAMES2UNLOCK(i_FRAMES2UNLOCK),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_FRAME_ERRORS(i_CLEAR_FRAME_ERRORS),
	.ov_RXDATA00(rxdata00_aligned),
	.ov_RXDATA01(rxdata01_aligned),
	.ov_RXDATA02(rxdata02_aligned),
	.ov_RXDATA03(rxdata03_aligned),
	.ov_RXDATA04(rxdata04_aligned),
	.ov_RXDATA05(rxdata05_aligned),
	.ov_RXDATA06(rxdata06_aligned),
	.ov_RXDATA07(rxdata07_aligned),
	.ov_RXDATA08(rxdata08_aligned),
	.ov_RXDATA09(rxdata09_aligned),
	.ov_RXDATA10(rxdata10_aligned),
	.ov_RXDATA11(rxdata11_aligned),
	.ov_RXDATA12(rxdata12_aligned),
	.ov_RXDATA13(rxdata13_aligned),
	.ov_RXDATA14(rxdata14_aligned),
	.ov_RXDATA15(rxdata15_aligned),
	.o_RXLOF(o_RXLOF),
	.o_RXLOF_HISTORY(o_RXLOF_HISTORY),
	.ov_FRAME_ERRORS(ov_FRAME_ERRORS),
	.ov_FRAMES_RECEIVED(ov_FRAMES_RECEIVED),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA_MISMATCHES_CH00(ov_DATA_MISMATCHES_CH00),
	.ov_DATA_MISMATCHES_CH01(ov_DATA_MISMATCHES_CH01),
	.ov_DATA_MISMATCHES_CH02(ov_DATA_MISMATCHES_CH02),
	.ov_DATA_MISMATCHES_CH03(ov_DATA_MISMATCHES_CH03),
	.ov_DATA_MISMATCHES_CH04(ov_DATA_MISMATCHES_CH04),
	.ov_DATA_MISMATCHES_CH05(ov_DATA_MISMATCHES_CH05),
	.ov_DATA_MISMATCHES_CH06(ov_DATA_MISMATCHES_CH06),
	.ov_DATA_MISMATCHES_CH07(ov_DATA_MISMATCHES_CH07),
	.ov_DATA_MISMATCHES_CH08(ov_DATA_MISMATCHES_CH08),
	.ov_DATA_MISMATCHES_CH09(ov_DATA_MISMATCHES_CH09),
	.ov_DATA_MISMATCHES_CH10(ov_DATA_MISMATCHES_CH10),
	.ov_DATA_MISMATCHES_CH11(ov_DATA_MISMATCHES_CH11),
	.ov_DATA_MISMATCHES_CH12(ov_DATA_MISMATCHES_CH12),
	.ov_DATA_MISMATCHES_CH13(ov_DATA_MISMATCHES_CH13),
	.ov_DATA_MISMATCHES_CH14(ov_DATA_MISMATCHES_CH14),
	.ov_DATA_MISMATCHES_CH15(ov_DATA_MISMATCHES_CH15),
	.ov_RXFRAME_SHIFT(ov_RXFRAME_SHIFT),
	.ov_RXDATA_SHIFT_CH00(ov_RXDATA_SHIFT_CH00),
	.ov_RXDATA_SHIFT_CH01(ov_RXDATA_SHIFT_CH01),
	.ov_RXDATA_SHIFT_CH02(ov_RXDATA_SHIFT_CH02),
	.ov_RXDATA_SHIFT_CH03(ov_RXDATA_SHIFT_CH03),
	.ov_RXDATA_SHIFT_CH04(ov_RXDATA_SHIFT_CH04),
	.ov_RXDATA_SHIFT_CH05(ov_RXDATA_SHIFT_CH05),
	.ov_RXDATA_SHIFT_CH06(ov_RXDATA_SHIFT_CH06),
	.ov_RXDATA_SHIFT_CH07(ov_RXDATA_SHIFT_CH07),
	.ov_RXDATA_SHIFT_CH08(ov_RXDATA_SHIFT_CH08),
	.ov_RXDATA_SHIFT_CH09(ov_RXDATA_SHIFT_CH09),
	.ov_RXDATA_SHIFT_CH10(ov_RXDATA_SHIFT_CH10),
	.ov_RXDATA_SHIFT_CH11(ov_RXDATA_SHIFT_CH11),
	.ov_RXDATA_SHIFT_CH12(ov_RXDATA_SHIFT_CH12),
	.ov_RXDATA_SHIFT_CH13(ov_RXDATA_SHIFT_CH13),
	.ov_RXDATA_SHIFT_CH14(ov_RXDATA_SHIFT_CH14),
	.ov_RXDATA_SHIFT_CH15(ov_RXDATA_SHIFT_CH15),
	.o_RXOOA(rxooa_all_channels)
);


//===============================================================================
// Sticky bits for diagnostics 
//===============================================================================

always @(posedge txusrclk2) begin
	if (i_CLEAR_MISMATCHES)
		o_RESETDONE <= 1'b1;
	else if (~resetdone)
		o_RESETDONE <= 1'b0;
	else
		o_RESETDONE <= o_RESETDONE;
end

always @(posedge txusrclk2) begin
	if (i_CLEAR_MISMATCHES)
		o_GTXPLL_LOCK <= 1'b1;
	else if (~gtxpll_lock)
		o_GTXPLL_LOCK <= 1'b0;
	else
		o_GTXPLL_LOCK <= o_GTXPLL_LOCK;
end

always @(posedge txusrclk2) begin
	if (i_CLEAR_MISMATCHES)
		o_TX_INIT_DONE <= 1'b1;
	else if (tx_logic_reset)
		o_TX_INIT_DONE <= 1'b0;
	else
		o_TX_INIT_DONE <= o_TX_INIT_DONE;
end

always @(posedge txusrclk2) begin
	if (i_CLEAR_MISMATCHES)
		o_RX_INIT_DONE <= 1'b1;
	else if (rx_logic_reset)
		o_RX_INIT_DONE <= 1'b0;
	else
		o_RX_INIT_DONE <= o_RX_INIT_DONE;
end

always @(posedge txusrclk2) begin
	if (i_CLEAR_MISMATCHES)
		o_RX_BUFFER_UNDERFLOW <= 1'b0;
	else if (|rx_buffer_underflow)
		o_RX_BUFFER_UNDERFLOW <= 1'b1;
	else
		o_RX_BUFFER_UNDERFLOW <= o_RX_BUFFER_UNDERFLOW;
end

always @(posedge txusrclk2) begin
	if (i_CLEAR_MISMATCHES)
		o_RX_BUFFER_OVERFLOW <= 1'b0;
	else if (|rx_buffer_overflow)
		o_RX_BUFFER_OVERFLOW <= 1'b1;
	else
		o_RX_BUFFER_OVERFLOW <= o_RX_BUFFER_OVERFLOW;
end

    //--------------------------- The GTX Wrapper -----------------------------
    
    // Use the instantiation template in the example directory to add the GTX wrapper to your design.
    // In this example, the wrapper is wired up for basic operation with a frame generator and frame 
    // checker. The GTXs will reset, then attempt to align and transmit data. If channel bonding is 
    // enabled, bonding should occur after alignment.
    
    GTX_WRAPPER #
    (
        .WRAPPER_SIM_GTXRESET_SPEEDUP   (1'b1)
    )
    gtx_wrapper_i
    (
 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX0  (X0Y0)


	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX0_LOOPBACK_IN               (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX0_RXDATA_OUT                (rxdata00_out),
        .GTX0_RXRECCLK_OUT              (),
        .GTX0_RXRESET_IN                (1'b0),
        .GTX0_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX0_RXCDRRESET_IN             (1'b0),
        .GTX0_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX0_RXN_IN                    (RXDATA_N[0]),
        .GTX0_RXP_IN                    (RXDATA_P[0]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX0_RXBUFRESET_IN             (1'b0),
        .GTX0_RXBUFSTATUS_OUT           (gtx0_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX0_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX0_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX0_PLLRXRESET_IN             (1'b0),
        .GTX0_RXPLLLKDET_OUT            (gtx_pll_locked[0]),
        .GTX0_RXRESETDONE_OUT           (gtx0_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX0_TXDATA_IN                 (txdata00_in),
	.GTX0_TXOUTCLK_OUT              (),
        .GTX0_TXRESET_IN                (1'b0),
        .GTX0_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX0_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX0_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX0_TXN_OUT                   (TXDATA_N[0]),
        .GTX0_TXP_OUT                   (TXDATA_P[0]),
        .GTX0_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX0_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS),
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX0_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX0_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX0_TXDLYALIGNMONITOR_OUT     (),
        .GTX0_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX0_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX0_TXPMASETPHASE_IN          (gtx_txpmasetphase),

         
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX0_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX0_TXRESETDONE_OUT           (gtx0_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX1  (X0Y1)
	
	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX1_LOOPBACK_IN               (i_LOOPBACK),

        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX1_RXDATA_OUT                (rxdata01_out),
        .GTX1_RXRECCLK_OUT              (),
        .GTX1_RXRESET_IN                (1'b0),
        .GTX1_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX1_RXCDRRESET_IN             (1'b0),
        .GTX1_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX1_RXN_IN                    (RXDATA_N[1]),
        .GTX1_RXP_IN                    (RXDATA_P[1]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX1_RXBUFRESET_IN             (1'b0),
        .GTX1_RXBUFSTATUS_OUT           (gtx1_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX1_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX1_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX1_PLLRXRESET_IN             (1'b0),
        .GTX1_RXPLLLKDET_OUT            (gtx_pll_locked[1]),
        .GTX1_RXRESETDONE_OUT           (gtx1_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX1_TXDATA_IN                 (txdata01_in),
        .GTX1_TXOUTCLK_OUT              (),
        .GTX1_TXRESET_IN                (1'b0),
        .GTX1_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX1_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX1_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX1_TXN_OUT                   (TXDATA_N[1]),
        .GTX1_TXP_OUT                   (TXDATA_P[1]),
        .GTX1_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX1_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS),
         //------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX1_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX1_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX1_TXDLYALIGNMONITOR_OUT     (),
        .GTX1_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX1_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX1_TXPMASETPHASE_IN          (gtx_txpmasetphase),

         
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX1_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX1_TXRESETDONE_OUT           (gtx1_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX2  (X0Y2)
	
	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX2_LOOPBACK_IN               (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX2_RXDATA_OUT                (rxdata02_out),
        .GTX2_RXRECCLK_OUT              (),
        .GTX2_RXRESET_IN                (1'b0),
        .GTX2_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX2_RXCDRRESET_IN             (1'b0),
        .GTX2_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX2_RXN_IN                    (RXDATA_N[2]),
        .GTX2_RXP_IN                    (RXDATA_P[2]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX2_RXBUFRESET_IN             (1'b0),
        .GTX2_RXBUFSTATUS_OUT           (gtx2_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX2_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX2_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX2_PLLRXRESET_IN             (1'b0),
        .GTX2_RXPLLLKDET_OUT            (gtx_pll_locked[2]),
        .GTX2_RXRESETDONE_OUT           (gtx2_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX2_TXDATA_IN                 (txdata02_in),
        .GTX2_TXOUTCLK_OUT              (),
        .GTX2_TXRESET_IN                (1'b0),
        .GTX2_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX2_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX2_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX2_TXN_OUT                   (TXDATA_N[2]),
        .GTX2_TXP_OUT                   (TXDATA_P[2]),
        .GTX2_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX2_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX2_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX2_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX2_TXDLYALIGNMONITOR_OUT     (),
        .GTX2_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX2_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX2_TXPMASETPHASE_IN          (gtx_txpmasetphase),
	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX2_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX2_TXRESETDONE_OUT           (gtx2_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX3  (X0Y3)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX3_LOOPBACK_IN               (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX3_RXDATA_OUT                (rxdata03_out),
        .GTX3_RXRECCLK_OUT              (),
        .GTX3_RXRESET_IN                (1'b0),
        .GTX3_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX3_RXCDRRESET_IN             (1'b0),
        .GTX3_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX3_RXN_IN                    (RXDATA_N[3]),
        .GTX3_RXP_IN                    (RXDATA_P[3]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX3_RXBUFRESET_IN             (1'b0),
        .GTX3_RXBUFSTATUS_OUT           (gtx3_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX3_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX3_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX3_PLLRXRESET_IN             (1'b0),
        .GTX3_RXPLLLKDET_OUT            (gtx_pll_locked[3]),
        .GTX3_RXRESETDONE_OUT           (gtx3_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX3_TXDATA_IN                 (txdata03_in),
        .GTX3_TXOUTCLK_OUT              (),
        .GTX3_TXRESET_IN                (1'b0),
        .GTX3_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX3_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX3_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX3_TXN_OUT                   (TXDATA_N[3]),
        .GTX3_TXP_OUT                   (TXDATA_P[3]),
        .GTX3_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX3_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX3_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX3_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX3_TXDLYALIGNMONITOR_OUT     (),
        .GTX3_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX3_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX3_TXPMASETPHASE_IN          (gtx_txpmasetphase),

       
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX3_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX3_TXRESETDONE_OUT           (gtx3_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX4  (X0Y4)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX4_LOOPBACK_IN               (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX4_RXDATA_OUT                (rxdata04_out),
        .GTX4_RXRECCLK_OUT              (),
        .GTX4_RXRESET_IN                (1'b0),
        .GTX4_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX4_RXCDRRESET_IN             (1'b0),
        .GTX4_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX4_RXN_IN                    (RXDATA_N[4]),
        .GTX4_RXP_IN                    (RXDATA_P[4]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX4_RXBUFRESET_IN             (1'b0),
        .GTX4_RXBUFSTATUS_OUT           (gtx4_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX4_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX4_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX4_PLLRXRESET_IN             (1'b0),
        .GTX4_RXPLLLKDET_OUT            (gtx_pll_locked[4]),
        .GTX4_RXRESETDONE_OUT           (gtx4_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX4_TXDATA_IN                 (txdata04_in),
        .GTX4_TXOUTCLK_OUT              (),
        .GTX4_TXRESET_IN                (1'b0),
        .GTX4_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX4_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX4_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX4_TXN_OUT                   (TXDATA_N[4]),
        .GTX4_TXP_OUT                   (TXDATA_P[4]),
        .GTX4_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX4_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS),
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX4_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX4_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX4_TXDLYALIGNMONITOR_OUT     (),
        .GTX4_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX4_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX4_TXPMASETPHASE_IN          (gtx_txpmasetphase),
 
	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX4_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX4_TXRESETDONE_OUT           (gtx4_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX5  (X0Y5)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX5_LOOPBACK_IN               (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX5_RXDATA_OUT                (rxdata05_out),
        .GTX5_RXRECCLK_OUT              (),
        .GTX5_RXRESET_IN                (1'b0),
        .GTX5_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX5_RXCDRRESET_IN             (1'b0),
        .GTX5_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX5_RXN_IN                    (RXDATA_N[5]),
        .GTX5_RXP_IN                    (RXDATA_P[5]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX5_RXBUFRESET_IN             (1'b0),
        .GTX5_RXBUFSTATUS_OUT           (gtx5_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX5_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX5_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX5_PLLRXRESET_IN             (1'b0),
        .GTX5_RXPLLLKDET_OUT            (gtx_pll_locked[5]),
        .GTX5_RXRESETDONE_OUT           (gtx5_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX5_TXDATA_IN                 (txdata05_in),
        .GTX5_TXOUTCLK_OUT              (),
        .GTX5_TXRESET_IN                (1'b0),
        .GTX5_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX5_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX5_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX5_TXN_OUT                   (TXDATA_N[5]),
        .GTX5_TXP_OUT                   (TXDATA_P[5]),
        .GTX5_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX5_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS),
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX5_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX5_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX5_TXDLYALIGNMONITOR_OUT     (),
        .GTX5_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX5_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX5_TXPMASETPHASE_IN          (gtx_txpmasetphase),
 

        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX5_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX5_TXRESETDONE_OUT           (gtx5_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX6  (X0Y6)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX6_LOOPBACK_IN               (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX6_RXDATA_OUT                (rxdata06_out),
        .GTX6_RXRECCLK_OUT              (),
        .GTX6_RXRESET_IN                (1'b0),
        .GTX6_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX6_RXCDRRESET_IN             (1'b0),
        .GTX6_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX6_RXN_IN                    (RXDATA_N[6]),
        .GTX6_RXP_IN                    (RXDATA_P[6]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX6_RXBUFRESET_IN             (1'b0),
        .GTX6_RXBUFSTATUS_OUT           (gtx6_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX6_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX6_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX6_PLLRXRESET_IN             (1'b0),
        .GTX6_RXPLLLKDET_OUT            (gtx_pll_locked[6]),
        .GTX6_RXRESETDONE_OUT           (gtx6_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX6_TXDATA_IN                 (txdata06_in),
        .GTX6_TXOUTCLK_OUT              (),
        .GTX6_TXRESET_IN                (1'b0),
        .GTX6_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX6_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX6_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX6_TXN_OUT                   (TXDATA_N[6]),
        .GTX6_TXP_OUT                   (TXDATA_P[6]),
        .GTX6_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX6_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX6_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX6_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX6_TXDLYALIGNMONITOR_OUT     (),
        .GTX6_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX6_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX6_TXPMASETPHASE_IN          (gtx_txpmasetphase),

	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX6_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX6_TXRESETDONE_OUT           (gtx6_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX7  (X0Y7)
 
	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX7_LOOPBACK_IN               (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX7_RXDATA_OUT                (rxdata07_out),
        .GTX7_RXRECCLK_OUT              (),
        .GTX7_RXRESET_IN                (1'b0),
        .GTX7_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX7_RXCDRRESET_IN             (1'b0),
        .GTX7_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX7_RXN_IN                    (RXDATA_N[7]),
        .GTX7_RXP_IN                    (RXDATA_P[7]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX7_RXBUFRESET_IN             (1'b0),
        .GTX7_RXBUFSTATUS_OUT           (gtx7_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX7_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX7_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX7_PLLRXRESET_IN             (1'b0),
        .GTX7_RXPLLLKDET_OUT            (gtx_pll_locked[7]),
        .GTX7_RXRESETDONE_OUT           (gtx7_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX7_TXDATA_IN                 (txdata07_in),
        .GTX7_TXOUTCLK_OUT              (),
        .GTX7_TXRESET_IN                (1'b0),
        .GTX7_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX7_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX7_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX7_TXN_OUT                   (TXDATA_N[7]),
        .GTX7_TXP_OUT                   (TXDATA_P[7]),
        .GTX7_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX7_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX7_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX7_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX7_TXDLYALIGNMONITOR_OUT     (),
        .GTX7_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX7_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX7_TXPMASETPHASE_IN          (gtx_txpmasetphase),
	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX7_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX7_TXRESETDONE_OUT           (gtx7_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX8  (X0Y8)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX8_LOOPBACK_IN               (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX8_RXDATA_OUT                (rxdata08_out),
        .GTX8_RXRECCLK_OUT              (),
        .GTX8_RXRESET_IN                (1'b0),
        .GTX8_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX8_RXCDRRESET_IN             (1'b0),
        .GTX8_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX8_RXN_IN                    (RXDATA_N[8]),
        .GTX8_RXP_IN                    (RXDATA_P[8]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX8_RXBUFRESET_IN             (1'b0),
        .GTX8_RXBUFSTATUS_OUT           (gtx8_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX8_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX8_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX8_PLLRXRESET_IN             (1'b0),
        .GTX8_RXPLLLKDET_OUT            (gtx_pll_locked[8]),
        .GTX8_RXRESETDONE_OUT           (gtx8_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX8_TXDATA_IN                 (txdata08_in),
        .GTX8_TXOUTCLK_OUT              (),
        .GTX8_TXRESET_IN                (1'b0),
        .GTX8_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX8_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX8_TXINHIBIT_IN		(i_TXINHIBIT),
       	.GTX8_TXN_OUT                   (TXDATA_N[8]),
        .GTX8_TXP_OUT                   (TXDATA_P[8]),
        .GTX8_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX8_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX8_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX8_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX8_TXDLYALIGNMONITOR_OUT     (),
        .GTX8_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX8_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX8_TXPMASETPHASE_IN          (gtx_txpmasetphase),
	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX8_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX8_TXRESETDONE_OUT           (gtx8_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX9  (X0Y9)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX9_LOOPBACK_IN               (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX9_RXDATA_OUT                (rxdata09_out),
        .GTX9_RXRECCLK_OUT              (),
        .GTX9_RXRESET_IN                (1'b0),
        .GTX9_RXUSRCLK2_IN              (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX9_RXCDRRESET_IN             (1'b0),
        .GTX9_RXEQMIX_IN                (i_RX_EQUALIZATION_MIX),
        .GTX9_RXN_IN                    (RXDATA_N[9]),
        .GTX9_RXP_IN                    (RXDATA_P[9]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX9_RXBUFRESET_IN             (1'b0),
        .GTX9_RXBUFSTATUS_OUT           (gtx9_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX9_GTXRXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX9_MGTREFCLKRX_IN            (txrefclk_2_gtx),
        .GTX9_PLLRXRESET_IN             (1'b0),
        .GTX9_RXPLLLKDET_OUT            (gtx_pll_locked[9]),
        .GTX9_RXRESETDONE_OUT           (gtx9_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX9_TXDATA_IN                 (txdata09_in),
        .GTX9_TXOUTCLK_OUT              (),
        .GTX9_TXRESET_IN                (1'b0),
        .GTX9_TXUSRCLK2_IN              (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX9_TXDIFFCTRL_IN             (i_TX_DIFF_CTRL),
	.GTX9_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX9_TXN_OUT                   (TXDATA_N[9]),
        .GTX9_TXP_OUT                   (TXDATA_P[9]),
        .GTX9_TXPOSTEMPHASIS_IN         (i_TX_POSTEMPHASIS),
        .GTX9_TXPREEMPHASIS_IN          (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX9_TXDLYALIGNDISABLE_IN      (gtx_txdlyaligndisable),
	.GTX9_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX9_TXDLYALIGNMONITOR_OUT     (),
        .GTX9_TXDLYALIGNRESET_IN        (gtx_txdlyalignreset),
        .GTX9_TXENPMAPHASEALIGN_IN      (gtx_txpmaphasealign),
        .GTX9_TXPMASETPHASE_IN          (gtx_txpmasetphase),
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX9_GTXTXRESET_IN             (gtxs_rst || gtxs_rst_from_rx),
        .GTX9_TXRESETDONE_OUT           (gtx9_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX10  (X0Y10)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX10_LOOPBACK_IN              (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX10_RXDATA_OUT               (rxdata10_out),
        .GTX10_RXRECCLK_OUT             (),
        .GTX10_RXRESET_IN               (1'b0),
        .GTX10_RXUSRCLK2_IN             (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX10_RXCDRRESET_IN            (1'b0),
        .GTX10_RXEQMIX_IN               (i_RX_EQUALIZATION_MIX),
        .GTX10_RXN_IN                   (RXDATA_N[10]),
        .GTX10_RXP_IN                   (RXDATA_P[10]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX10_RXBUFRESET_IN            (1'b0),
        .GTX10_RXBUFSTATUS_OUT          (gtx10_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX10_GTXRXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX10_MGTREFCLKRX_IN           (txrefclk_2_gtx),
        .GTX10_PLLRXRESET_IN            (1'b0),
        .GTX10_RXPLLLKDET_OUT           (gtx_pll_locked[10]),
        .GTX10_RXRESETDONE_OUT          (gtx10_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX10_TXDATA_IN                (txdata10_in),
        .GTX10_TXOUTCLK_OUT             (),
        .GTX10_TXRESET_IN               (1'b0),
        .GTX10_TXUSRCLK2_IN             (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX10_TXDIFFCTRL_IN            (i_TX_DIFF_CTRL),
	.GTX10_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX10_TXN_OUT                  (TXDATA_N[10]),
        .GTX10_TXP_OUT                  (TXDATA_P[10]),
        .GTX10_TXPOSTEMPHASIS_IN        (i_TX_POSTEMPHASIS),
        .GTX10_TXPREEMPHASIS_IN         (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX10_TXDLYALIGNDISABLE_IN     (gtx_txdlyaligndisable),
	.GTX10_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX10_TXDLYALIGNMONITOR_OUT    (),
        .GTX10_TXDLYALIGNRESET_IN       (gtx_txdlyalignreset),
        .GTX10_TXENPMAPHASEALIGN_IN     (gtx_txpmaphasealign),
        .GTX10_TXPMASETPHASE_IN         (gtx_txpmasetphase),
	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX10_GTXTXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX10_TXRESETDONE_OUT          (gtx10_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX11  (X0Y11)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX11_LOOPBACK_IN              (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX11_RXDATA_OUT               (rxdata11_out),
        .GTX11_RXRECCLK_OUT             (),
        .GTX11_RXRESET_IN               (1'b0),
        .GTX11_RXUSRCLK2_IN             (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX11_RXCDRRESET_IN            (1'b0),
        .GTX11_RXEQMIX_IN               (i_RX_EQUALIZATION_MIX),
        .GTX11_RXN_IN                   (RXDATA_N[11]),
        .GTX11_RXP_IN                   (RXDATA_P[11]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX11_RXBUFRESET_IN            (1'b0),
        .GTX11_RXBUFSTATUS_OUT          (gtx11_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX11_GTXRXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX11_MGTREFCLKRX_IN           (txrefclk_2_gtx),
        .GTX11_PLLRXRESET_IN            (1'b0),
        .GTX11_RXPLLLKDET_OUT           (gtx_pll_locked[11]),
        .GTX11_RXRESETDONE_OUT          (gtx11_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX11_TXDATA_IN                (txdata11_in),
        .GTX11_TXOUTCLK_OUT             (),
        .GTX11_TXRESET_IN               (1'b0),
        .GTX11_TXUSRCLK2_IN             (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX11_TXDIFFCTRL_IN            (i_TX_DIFF_CTRL),
	.GTX11_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX11_TXN_OUT                  (TXDATA_N[11]),
        .GTX11_TXP_OUT                  (TXDATA_P[11]),
        .GTX11_TXPOSTEMPHASIS_IN        (i_TX_POSTEMPHASIS),
        .GTX11_TXPREEMPHASIS_IN         (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX11_TXDLYALIGNDISABLE_IN     (gtx_txdlyaligndisable),
	.GTX11_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX11_TXDLYALIGNMONITOR_OUT    (),
        .GTX11_TXDLYALIGNRESET_IN       (gtx_txdlyalignreset),
        .GTX11_TXENPMAPHASEALIGN_IN     (gtx_txpmaphasealign),
        .GTX11_TXPMASETPHASE_IN         (gtx_txpmasetphase),
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX11_GTXTXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX11_TXRESETDONE_OUT          (gtx11_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX12  (X0Y12)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX12_LOOPBACK_IN              (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX12_RXDATA_OUT               (rxdata12_out),
        .GTX12_RXRECCLK_OUT             (),
        .GTX12_RXRESET_IN               (1'b0),
        .GTX12_RXUSRCLK2_IN             (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX12_RXCDRRESET_IN            (1'b0),
        .GTX12_RXEQMIX_IN               (i_RX_EQUALIZATION_MIX),
        .GTX12_RXN_IN                   (RXDATA_N[12]),
        .GTX12_RXP_IN                   (RXDATA_P[12]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX12_RXBUFRESET_IN            (1'b0),
        .GTX12_RXBUFSTATUS_OUT          (gtx12_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX12_GTXRXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX12_MGTREFCLKRX_IN           (txrefclk_2_gtx_2),
        .GTX12_PLLRXRESET_IN            (1'b0),
        .GTX12_RXPLLLKDET_OUT           (gtx_pll_locked[12]),
        .GTX12_RXRESETDONE_OUT          (gtx12_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX12_TXDATA_IN                (txdata12_in),
        .GTX12_TXOUTCLK_OUT             (),
        .GTX12_TXRESET_IN               (1'b0),
        .GTX12_TXUSRCLK2_IN             (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX12_TXDIFFCTRL_IN            (i_TX_DIFF_CTRL),
	.GTX12_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX12_TXN_OUT                  (TXDATA_N[12]),
        .GTX12_TXP_OUT                  (TXDATA_P[12]),
        .GTX12_TXPOSTEMPHASIS_IN        (i_TX_POSTEMPHASIS),
        .GTX12_TXPREEMPHASIS_IN         (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX12_TXDLYALIGNDISABLE_IN     (gtx_txdlyaligndisable),
	.GTX12_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX12_TXDLYALIGNMONITOR_OUT    (),
        .GTX12_TXDLYALIGNRESET_IN       (gtx_txdlyalignreset),
        .GTX12_TXENPMAPHASEALIGN_IN     (gtx_txpmaphasealign),
        .GTX12_TXPMASETPHASE_IN         (gtx_txpmasetphase),
	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX12_GTXTXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX12_TXRESETDONE_OUT          (gtx12_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX13  (X0Y13)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX13_LOOPBACK_IN              (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX13_RXDATA_OUT               (rxdata13_out),
        .GTX13_RXRECCLK_OUT             (),
        .GTX13_RXRESET_IN               (1'b0),
        .GTX13_RXUSRCLK2_IN             (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX13_RXCDRRESET_IN            (1'b0),
        .GTX13_RXEQMIX_IN               (i_RX_EQUALIZATION_MIX),
        .GTX13_RXN_IN                   (RXDATA_N[13]),
        .GTX13_RXP_IN                   (RXDATA_P[13]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX13_RXBUFRESET_IN            (1'b0),
        .GTX13_RXBUFSTATUS_OUT          (gtx13_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX13_GTXRXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX13_MGTREFCLKRX_IN           (txrefclk_2_gtx_2),
        .GTX13_PLLRXRESET_IN            (1'b0),
        .GTX13_RXPLLLKDET_OUT           (gtx_pll_locked[13]),
        .GTX13_RXRESETDONE_OUT          (gtx13_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX13_TXDATA_IN                (txdata13_in),
        .GTX13_TXOUTCLK_OUT             (),
        .GTX13_TXRESET_IN               (1'b0),
        .GTX13_TXUSRCLK2_IN             (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX13_TXDIFFCTRL_IN            (i_TX_DIFF_CTRL),
	.GTX13_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX13_TXN_OUT                  (TXDATA_N[13]),
        .GTX13_TXP_OUT                  (TXDATA_P[13]),
        .GTX13_TXPOSTEMPHASIS_IN        (i_TX_POSTEMPHASIS),
        .GTX13_TXPREEMPHASIS_IN         (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX13_TXDLYALIGNDISABLE_IN     (gtx_txdlyaligndisable),
	.GTX13_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX13_TXDLYALIGNMONITOR_OUT    (),
        .GTX13_TXDLYALIGNRESET_IN       (gtx_txdlyalignreset),
        .GTX13_TXENPMAPHASEALIGN_IN     (gtx_txpmaphasealign),
        .GTX13_TXPMASETPHASE_IN         (gtx_txpmasetphase),	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX13_GTXTXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX13_TXRESETDONE_OUT          (gtx13_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX14  (X0Y14)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX14_LOOPBACK_IN              (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX14_RXDATA_OUT               (rxdata14_out),
        .GTX14_RXRECCLK_OUT             (),
        .GTX14_RXRESET_IN               (1'b0),
        .GTX14_RXUSRCLK2_IN             (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX14_RXCDRRESET_IN            (1'b0),
        .GTX14_RXEQMIX_IN               (i_RX_EQUALIZATION_MIX),
        .GTX14_RXN_IN                   (RXDATA_N[14]),
        .GTX14_RXP_IN                   (RXDATA_P[14]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX14_RXBUFRESET_IN            (1'b0),
        .GTX14_RXBUFSTATUS_OUT          (gtx14_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX14_GTXRXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX14_MGTREFCLKRX_IN           (txrefclk_2_gtx_2),
        .GTX14_PLLRXRESET_IN            (1'b0),
        .GTX14_RXPLLLKDET_OUT           (gtx_pll_locked[14]),
        .GTX14_RXRESETDONE_OUT          (gtx14_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX14_TXDATA_IN                (txdata14_in),
        .GTX14_TXOUTCLK_OUT             (),
        .GTX14_TXRESET_IN               (1'b0),
        .GTX14_TXUSRCLK2_IN             (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX14_TXDIFFCTRL_IN            (i_TX_DIFF_CTRL),
	.GTX14_TXINHIBIT_IN		(i_TXINHIBIT),
	.GTX14_TXN_OUT                  (TXDATA_N[14]),
        .GTX14_TXP_OUT                  (TXDATA_P[14]),
        .GTX14_TXPOSTEMPHASIS_IN        (i_TX_POSTEMPHASIS),
        .GTX14_TXPREEMPHASIS_IN         (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX14_TXDLYALIGNDISABLE_IN     (gtx_txdlyaligndisable),
	.GTX14_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX14_TXDLYALIGNMONITOR_OUT    (),
        .GTX14_TXDLYALIGNRESET_IN       (gtx_txdlyalignreset),
        .GTX14_TXENPMAPHASEALIGN_IN     (gtx_txpmaphasealign),
        .GTX14_TXPMASETPHASE_IN         (gtx_txpmasetphase),	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX14_GTXTXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX14_TXRESETDONE_OUT          (gtx14_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX15  (X0Y15)
	
	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX15_LOOPBACK_IN              (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX15_RXDATA_OUT               (rxdata15_out),
        .GTX15_RXRECCLK_OUT             (),
        .GTX15_RXRESET_IN               (1'b0),
        .GTX15_RXUSRCLK2_IN             (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX15_RXCDRRESET_IN            (1'b0),
        .GTX15_RXEQMIX_IN               (i_RX_EQUALIZATION_MIX),
        .GTX15_RXN_IN                   (RXDATA_N[15]),
        .GTX15_RXP_IN                   (RXDATA_P[15]),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX15_RXBUFRESET_IN            (1'b0),
        .GTX15_RXBUFSTATUS_OUT          (gtx15_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX15_GTXRXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX15_MGTREFCLKRX_IN           (txrefclk_2_gtx_2),
        .GTX15_PLLRXRESET_IN            (1'b0),
        .GTX15_RXPLLLKDET_OUT           (gtx_pll_locked[15]),
        .GTX15_RXRESETDONE_OUT          (gtx15_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX15_TXDATA_IN                (txdata15_in),
        .GTX15_TXOUTCLK_OUT             (),
        .GTX15_TXRESET_IN               (1'b0),
        .GTX15_TXUSRCLK2_IN             (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTX15_TXDIFFCTRL_IN            (i_TX_DIFF_CTRL),
	.GTX15_TXINHIBIT_IN		(i_TXINHIBIT),
        .GTX15_TXN_OUT                  (TXDATA_N[15]),
        .GTX15_TXP_OUT                  (TXDATA_P[15]),
        .GTX15_TXPOSTEMPHASIS_IN        (i_TX_POSTEMPHASIS),
        .GTX15_TXPREEMPHASIS_IN         (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX15_TXDLYALIGNDISABLE_IN     (gtx_txdlyaligndisable),
	.GTX15_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX15_TXDLYALIGNMONITOR_OUT    (),
        .GTX15_TXDLYALIGNRESET_IN       (gtx_txdlyalignreset),
        .GTX15_TXENPMAPHASEALIGN_IN     (gtx_txpmaphasealign),
        .GTX15_TXPMASETPHASE_IN         (gtx_txpmasetphase),	
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX15_GTXTXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX15_TXRESETDONE_OUT          (gtx15_txresetdone_i),


 
 
        //_____________________________________________________________________
        //_____________________________________________________________________
        //GTX16  (X0Y16)

	//---------------------- Loopback and Powerdown Ports ----------------------
        .GTX16_LOOPBACK_IN              (i_LOOPBACK),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GTX16_RXDATA_OUT               (deskew_out),
        .GTX16_RXRECCLK_OUT             (rxrecclk),
        .GTX16_RXRESET_IN               (1'b0),
        .GTX16_RXUSRCLK2_IN             (rxusrclk2),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GTX16_RXCDRRESET_IN            (1'b0),
        .GTX16_RXEQMIX_IN               (i_RX_EQUALIZATION_MIX),
        .GTX16_RXN_IN                   (RXDSC_N),
        .GTX16_RXP_IN                   (RXDSC_P),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .GTX16_RXBUFRESET_IN            (1'b0),
        .GTX16_RXBUFSTATUS_OUT          (gtx16_rxbufstatus_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GTX16_GTXRXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX16_MGTREFCLKRX_IN           (txrefclk_2_gtx_2),
        .GTX16_PLLRXRESET_IN            (1'b0),
        .GTX16_RXPLLLKDET_OUT           (gtx_pll_locked[16]),
        .GTX16_RXRESETDONE_OUT          (gtx16_rxresetdone_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GTX16_TXDATA_IN                (deskew_in),
        .GTX16_TXOUTCLK_OUT             (refclkout),
        .GTX16_TXRESET_IN               (1'b0),
        .GTX16_TXUSRCLK2_IN             (txusrclk2),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
	.GTX16_TXDIFFCTRL_IN            (i_TX_DIFF_CTRL),
	.GTX16_TXINHIBIT_IN		(i_TXINHIBIT),
        .GTX16_TXN_OUT                  (TXDSC_N),
        .GTX16_TXP_OUT                  (TXDSC_P),
        .GTX16_TXPOSTEMPHASIS_IN        (i_TX_POSTEMPHASIS),
        .GTX16_TXPREEMPHASIS_IN         (i_TX_PREEMPHASIS), 
	//------ Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
        .GTX16_TXDLYALIGNDISABLE_IN     (gtx_txdlyaligndisable),
	.GTX16_TXDLYALIGNMONENB_IN	(1'b0),
        .GTX16_TXDLYALIGNMONITOR_OUT    (),
        .GTX16_TXDLYALIGNRESET_IN       (gtx_txdlyalignreset),
        .GTX16_TXENPMAPHASEALIGN_IN     (gtx_txpmaphasealign),
        .GTX16_TXPMASETPHASE_IN         (gtx_txpmasetphase),
        //--------------------- Transmit Ports - TX PLL Ports ----------------------
        .GTX16_GTXTXRESET_IN            (gtxs_rst || gtxs_rst_from_rx),
        .GTX16_TXRESETDONE_OUT          (gtx16_txresetdone_i)
    );


assign gtx_reset_done[00] = gtx0_rxresetdone_i & gtx0_txresetdone_i;
assign gtx_reset_done[01] = gtx1_rxresetdone_i & gtx1_txresetdone_i;
assign gtx_reset_done[02] = gtx2_rxresetdone_i & gtx2_txresetdone_i;
assign gtx_reset_done[03] = gtx3_rxresetdone_i & gtx3_txresetdone_i;
assign gtx_reset_done[04] = gtx4_rxresetdone_i & gtx4_txresetdone_i;
assign gtx_reset_done[05] = gtx5_rxresetdone_i & gtx5_txresetdone_i;
assign gtx_reset_done[06] = gtx6_rxresetdone_i & gtx6_txresetdone_i;
assign gtx_reset_done[07] = gtx7_rxresetdone_i & gtx7_txresetdone_i;
assign gtx_reset_done[08] = gtx8_rxresetdone_i & gtx8_txresetdone_i;
assign gtx_reset_done[09] = gtx9_rxresetdone_i & gtx9_txresetdone_i;
assign gtx_reset_done[10] = gtx10_rxresetdone_i & gtx10_txresetdone_i;
assign gtx_reset_done[11] = gtx11_rxresetdone_i & gtx11_txresetdone_i;
assign gtx_reset_done[12] = gtx12_rxresetdone_i & gtx12_txresetdone_i;
assign gtx_reset_done[13] = gtx13_rxresetdone_i & gtx13_txresetdone_i;
assign gtx_reset_done[14] = gtx14_rxresetdone_i & gtx14_txresetdone_i;
assign gtx_reset_done[15] = gtx15_rxresetdone_i & gtx15_txresetdone_i;
assign gtx_reset_done[16] = gtx16_rxresetdone_i & gtx16_txresetdone_i;

assign rx_buffer_underflow[00] = gtx0_rxbufstatus_i[2] && !gtx0_rxbufstatus_i[1] && gtx0_rxbufstatus_i[0];
assign rx_buffer_underflow[01] = gtx2_rxbufstatus_i[2] && !gtx1_rxbufstatus_i[1] && gtx1_rxbufstatus_i[0];
assign rx_buffer_underflow[02] = gtx2_rxbufstatus_i[2] && !gtx2_rxbufstatus_i[1] && gtx2_rxbufstatus_i[0];
assign rx_buffer_underflow[03] = gtx3_rxbufstatus_i[2] && !gtx3_rxbufstatus_i[1] && gtx3_rxbufstatus_i[0];
assign rx_buffer_underflow[04] = gtx4_rxbufstatus_i[2] && !gtx4_rxbufstatus_i[1] && gtx4_rxbufstatus_i[0];
assign rx_buffer_underflow[05] = gtx5_rxbufstatus_i[2] && !gtx5_rxbufstatus_i[1] && gtx5_rxbufstatus_i[0];
assign rx_buffer_underflow[06] = gtx6_rxbufstatus_i[2] && !gtx6_rxbufstatus_i[1] && gtx6_rxbufstatus_i[0];
assign rx_buffer_underflow[07] = gtx7_rxbufstatus_i[2] && !gtx7_rxbufstatus_i[1] && gtx7_rxbufstatus_i[0];
assign rx_buffer_underflow[08] = gtx8_rxbufstatus_i[2] && !gtx8_rxbufstatus_i[1] && gtx8_rxbufstatus_i[0];
assign rx_buffer_underflow[09] = gtx9_rxbufstatus_i[2] && !gtx9_rxbufstatus_i[1] && gtx9_rxbufstatus_i[0];
assign rx_buffer_underflow[10] = gtx10_rxbufstatus_i[2] && !gtx10_rxbufstatus_i[1] && gtx10_rxbufstatus_i[0];
assign rx_buffer_underflow[11] = gtx11_rxbufstatus_i[2] && !gtx11_rxbufstatus_i[1] && gtx11_rxbufstatus_i[0];
assign rx_buffer_underflow[12] = gtx12_rxbufstatus_i[2] && !gtx12_rxbufstatus_i[1] && gtx12_rxbufstatus_i[0];
assign rx_buffer_underflow[13] = gtx13_rxbufstatus_i[2] && !gtx13_rxbufstatus_i[1] && gtx13_rxbufstatus_i[0];
assign rx_buffer_underflow[14] = gtx14_rxbufstatus_i[2] && !gtx14_rxbufstatus_i[1] && gtx14_rxbufstatus_i[0];
assign rx_buffer_underflow[15] = gtx15_rxbufstatus_i[2] && !gtx15_rxbufstatus_i[1] && gtx15_rxbufstatus_i[0];
assign rx_buffer_underflow[16] = gtx16_rxbufstatus_i[2] && !gtx16_rxbufstatus_i[1] && gtx16_rxbufstatus_i[0];

assign rx_buffer_overflow[00] = gtx0_rxbufstatus_i[2] && gtx0_rxbufstatus_i[1] && !gtx0_rxbufstatus_i[0];
assign rx_buffer_overflow[01] = gtx2_rxbufstatus_i[2] && gtx1_rxbufstatus_i[1] && !gtx1_rxbufstatus_i[0];
assign rx_buffer_overflow[02] = gtx2_rxbufstatus_i[2] && gtx2_rxbufstatus_i[1] && !gtx2_rxbufstatus_i[0];
assign rx_buffer_overflow[03] = gtx3_rxbufstatus_i[2] && gtx3_rxbufstatus_i[1] && !gtx3_rxbufstatus_i[0];
assign rx_buffer_overflow[04] = gtx4_rxbufstatus_i[2] && gtx4_rxbufstatus_i[1] && !gtx4_rxbufstatus_i[0];
assign rx_buffer_overflow[05] = gtx5_rxbufstatus_i[2] && gtx5_rxbufstatus_i[1] && !gtx5_rxbufstatus_i[0];
assign rx_buffer_overflow[06] = gtx6_rxbufstatus_i[2] && gtx6_rxbufstatus_i[1] && !gtx6_rxbufstatus_i[0];
assign rx_buffer_overflow[07] = gtx7_rxbufstatus_i[2] && gtx7_rxbufstatus_i[1] && !gtx7_rxbufstatus_i[0];
assign rx_buffer_overflow[08] = gtx8_rxbufstatus_i[2] && gtx8_rxbufstatus_i[1] && !gtx8_rxbufstatus_i[0];
assign rx_buffer_overflow[09] = gtx9_rxbufstatus_i[2] && gtx9_rxbufstatus_i[1] && !gtx9_rxbufstatus_i[0];
assign rx_buffer_overflow[10] = gtx10_rxbufstatus_i[2] && gtx10_rxbufstatus_i[1] && !gtx10_rxbufstatus_i[0];
assign rx_buffer_overflow[11] = gtx11_rxbufstatus_i[2] && gtx11_rxbufstatus_i[1] && !gtx11_rxbufstatus_i[0];
assign rx_buffer_overflow[12] = gtx12_rxbufstatus_i[2] && gtx12_rxbufstatus_i[1] && !gtx12_rxbufstatus_i[0];
assign rx_buffer_overflow[13] = gtx13_rxbufstatus_i[2] && gtx13_rxbufstatus_i[1] && !gtx13_rxbufstatus_i[0];
assign rx_buffer_overflow[14] = gtx14_rxbufstatus_i[2] && gtx14_rxbufstatus_i[1] && !gtx14_rxbufstatus_i[0];
assign rx_buffer_overflow[15] = gtx15_rxbufstatus_i[2] && gtx15_rxbufstatus_i[1] && !gtx15_rxbufstatus_i[0];
assign rx_buffer_overflow[16] = gtx16_rxbufstatus_i[2] && gtx16_rxbufstatus_i[1] && !gtx16_rxbufstatus_i[0];
endmodule


