// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: sfi5_rx_if_v6_16bit.v
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

SFI-5 RX interface, containing all framing and data deskew logic.
--------------------------------------------------------------------------------
*/
`timescale 1ns / 1ps

module sfi5_rx_if_v6_16bit
(
	i_CLK,
	i_RST,
	iv_RXDATA00,
	iv_RXDATA01,
	iv_RXDATA02,
	iv_RXDATA03,
	iv_RXDATA04,
	iv_RXDATA05,
	iv_RXDATA06,
	iv_RXDATA07,
	iv_RXDATA08,
	iv_RXDATA09,
	iv_RXDATA10,
	iv_RXDATA11,
	iv_RXDATA12,
	iv_RXDATA13,
	iv_RXDATA14,
	iv_RXDATA15,
	iv_DESKEW_CHANNEL,
	i_FRAMES2LOCK,
	i_FRAMES2UNLOCK,
	iv_MISMATCHES_2_UNLOCK,
	i_CLEAR_FRAME_ERRORS,
	i_CLEAR_MISMATCHES,
	ov_RXDATA00,
	ov_RXDATA01,
	ov_RXDATA02,
	ov_RXDATA03,
	ov_RXDATA04,
	ov_RXDATA05,
	ov_RXDATA06,
	ov_RXDATA07,
	ov_RXDATA08,
	ov_RXDATA09,
	ov_RXDATA10,
	ov_RXDATA11,
	ov_RXDATA12,
	ov_RXDATA13,
	ov_RXDATA14,
	ov_RXDATA15,
	o_RXLOF,
	o_RXLOF_HISTORY,
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
	o_RXOOA
);

//===============================================================================
// I/O declaration                                                               
//===============================================================================

input		i_CLK;			// Clocks all receiver logic
input		i_RST;			// Resets all receiver logic
input	[15:0]	iv_RXDATA00;		// Raw deserialized data from GTP 00 (not deskewed)
input	[15:0]	iv_RXDATA01;		// Raw deserialized data from GTP 01 (not deskewed)
input	[15:0]	iv_RXDATA02;		// Raw deserialized data from GTP 02 (not deskewed)
input	[15:0]	iv_RXDATA03;		// Raw deserialized data from GTP 03 (not deskewed)
input	[15:0]	iv_RXDATA04;		// Raw deserialized data from GTP 04 (not deskewed)
input	[15:0]	iv_RXDATA05;		// Raw deserialized data from GTP 05 (not deskewed)
input	[15:0]	iv_RXDATA06;		// Raw deserialized data from GTP 06 (not deskewed)
input	[15:0]	iv_RXDATA07;		// Raw deserialized data from GTP 07 (not deskewed)
input	[15:0]	iv_RXDATA08;		// Raw deserialized data from GTP 08 (not deskewed)
input	[15:0]	iv_RXDATA09;		// Raw deserialized data from GTP 09 (not deskewed)
input	[15:0]	iv_RXDATA10;		// Raw deserialized data from GTP 10 (not deskewed)
input	[15:0]	iv_RXDATA11;		// Raw deserialized data from GTP 11 (not deskewed)
input	[15:0]	iv_RXDATA12;		// Raw deserialized data from GTP 12 (not deskewed)
input	[15:0]	iv_RXDATA13;		// Raw deserialized data from GTP 13 (not deskewed)
input	[15:0]	iv_RXDATA14;		// Raw deserialized data from GTP 14 (not deskewed)
input	[15:0]	iv_RXDATA15;		// Raw deserialized data from GTP 15 (not deskewed)
input	[15:0]	iv_DESKEW_CHANNEL;	// Raw deserialized data from deskew channel (not framed)
input	[6:0]	i_FRAMES2LOCK;		// User-defined threshold for framer lock
input	[6:0]	i_FRAMES2UNLOCK;	// User-defined threshold for framer unlock
input	[6:0]	iv_MISMATCHES_2_UNLOCK;	// User-defined threshold for data sync loss
input		i_CLEAR_FRAME_ERRORS;	// Clears frame error count and RXLOF_HISTORY
input		i_CLEAR_MISMATCHES;	// Clears mismatch counts

output	[15:0]	ov_RXDATA00;		// Deskewed data from GTP 00 
output	[15:0]	ov_RXDATA01;		// Deskewed data from GTP 01
output	[15:0]	ov_RXDATA02;		// Deskewed data from GTP 02
output	[15:0]	ov_RXDATA03;		// Deskewed data from GTP 03
output	[15:0]	ov_RXDATA04;		// Deskewed data from GTP 04
output	[15:0]	ov_RXDATA05;		// Deskewed data from GTP 05
output	[15:0]	ov_RXDATA06;		// Deskewed data from GTP 06
output	[15:0]	ov_RXDATA07;		// Deskewed data from GTP 07
output	[15:0]	ov_RXDATA08;		// Deskewed data from GTP 08
output	[15:0]	ov_RXDATA09;		// Deskewed data from GTP 09
output	[15:0]	ov_RXDATA10;		// Deskewed data from GTP 10
output	[15:0]	ov_RXDATA11;		// Deskewed data from GTP 11
output	[15:0]	ov_RXDATA12;		// Deskewed data from GTP 12
output	[15:0]	ov_RXDATA13;		// Deskewed data from GTP 13
output	[15:0]	ov_RXDATA14;		// Deskewed data from GTP 14
output	[15:0]	ov_RXDATA15;		// Deskewed data from GTP 15
output		o_RXLOF;		// RX loss of frame (framer has not locked to deskew channel frame)
output		o_RXLOF_HISTORY;	// RX loss of frame history (sticky bit)
output	[31:0]	ov_FRAME_ERRORS;	// Count of frame errors
output	[31:0]	ov_FRAMES_RECEIVED;	// Count of frames received
output	[31:0]	ov_DATA_MISMATCHES_CH00;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH01;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH02;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH03;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH04;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH05;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH06;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH07;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH08;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH09;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH10;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH11;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH12;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH13;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH14;// Count of data mismatches when compared to deskew channel
output	[31:0]	ov_DATA_MISMATCHES_CH15;// Count of data mismatches when compared to deskew channel
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
output	[15:0]	o_RXOOA;		// RX out of alignment (one or more data channels is misaligned)

//`define		CHIPSCOPE_MODE		//Comment out when simulating

//===============================================================================
// Declaration of wires/regs
//===============================================================================

wire	[15:0]	aligned_deskew_channel;
wire		rxlof;
wire		frame_start;
wire	[3:0]	CURRENT_STATE_OUTPUT;

assign		o_RXLOF		= rxlof;

//===============================================================================
// Frame Synchronizer: Finds and locks to framing information embedded in incoming data
//===============================================================================

sfi5_rx_frame_sync sfi5_rx_frame_sync_0
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.i_FRAMES2LOCK(i_FRAMES2LOCK),
	.i_FRAMES2UNLOCK(i_FRAMES2UNLOCK),
	.i_CLEAR_FRAME_ERRORS(i_CLEAR_FRAME_ERRORS),
	.iv_DESKEW_CHANNEL(iv_DESKEW_CHANNEL),
	.ov_DESKEW_CHANNEL(aligned_deskew_channel),
	.o_RXLOF(rxlof),
	.o_RXLOF_HISTORY(o_RXLOF_HISTORY),
	.ov_FRAME_ERRORS(ov_FRAME_ERRORS),
	.ov_FRAMES_RECEIVED(ov_FRAMES_RECEIVED),
	.o_FRAME_START(frame_start),
	.ov_RXFRAME_SHIFT(ov_RXFRAME_SHIFT)
);

//===============================================================================
// Deskew block for each data channel
//===============================================================================

sfi5_rx_data_sync sfi5_rx_data_sync_CH00
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA00),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd15),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA00),
	.o_RXOOA(o_RXOOA[0]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH00),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH00)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH01
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA01),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd14),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA01),
	.o_RXOOA(o_RXOOA[1]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH01),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH01)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH02
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA02),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd13),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA02),
	.o_RXOOA(o_RXOOA[2]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH02),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH02)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH03
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA03),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd12),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA03),
	.o_RXOOA(o_RXOOA[3]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH03),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH03)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH04
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA04),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd11),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA04),
	.o_RXOOA(o_RXOOA[4]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH04),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH04)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH05
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA05),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd10),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA05),
	.o_RXOOA(o_RXOOA[5]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH05),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH05)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH06
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA06),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd9),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA06),
	.o_RXOOA(o_RXOOA[6]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH06),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH06)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH07
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA07),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd8),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA07),
	.o_RXOOA(o_RXOOA[7]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH07),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH07)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH08
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA08),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd7),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA08),
	.o_RXOOA(o_RXOOA[8]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH08),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH08)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH09
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA09),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd6),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA09),
	.o_RXOOA(o_RXOOA[9]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH09),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH09)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH10
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA10),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd5),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA10),
	.o_RXOOA(o_RXOOA[10]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH10),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH10)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH11
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA11),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd4),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA11),
	.o_RXOOA(o_RXOOA[11]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH11),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH11)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH12
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA12),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd3),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA12),
	.o_RXOOA(o_RXOOA[12]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH12),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH12)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH13
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA13),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd2),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA13),
	.o_RXOOA(o_RXOOA[13]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH13),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH13)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH14
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA14),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd1),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA14),
	.o_RXOOA(o_RXOOA[14]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH14),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH14)
);

sfi5_rx_data_sync sfi5_rx_data_sync_CH15
(
	.i_CLK(i_CLK),
	.i_RST(i_RST),
	.iv_DATA(iv_RXDATA15),
	.iv_DSC(aligned_deskew_channel),
	.i_RXLOF(rxlof),
	.i_FRAME_START(frame_start),
	.iv_CHANNEL_OFFSET(5'd0),
	.iv_MISMATCHES_2_UNLOCK(iv_MISMATCHES_2_UNLOCK),
	.i_CLEAR_MISMATCHES(i_CLEAR_MISMATCHES),
	.ov_DATA(ov_RXDATA15),
	.o_RXOOA(o_RXOOA[15]),
	.ov_RXDATA_SHIFT(ov_RXDATA_SHIFT_CH15),
	.ov_DATA_MISMATCHES(ov_DATA_MISMATCHES_CH15)
);
/*
//******************************************************************************
// Chipscope modules

  wire [35:0] control;
  wire [95:0] data_sampled;
  wire [0:0]  trigger;
  
assign trigger = frame_start;

chipscope_icon i_icon
 (
 .control0(control)
 );

  
chipscope_ila i_ila
    (
      .control(control),
      .clk    (i_CLK),
      .data   (data_sampled),
      .trig0  (trigger)
    );


assign data_sampled[15:0]  = iv_RXDATA00;
assign data_sampled[31:16] = ov_RXDATA00;
assign data_sampled[47:32] = iv_RXDATA15; 
assign data_sampled[63:48] = ov_RXDATA15; 
assign data_sampled[79:64] = iv_DESKEW_CHANNEL;
assign data_sampled[95:80] = aligned_deskew_channel;
*/
endmodule
/*
module chipscope_icon
	(
	control0
);
inout [35:0] control0;
endmodule

module chipscope_ila
  (
    control,
    clk,
    data,
    trig0
  );
  inout [35:0] control;
  input clk;
  input [95:0]data;
  input [0:0]trig0;

endmodule
*/
