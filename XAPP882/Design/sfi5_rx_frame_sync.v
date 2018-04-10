// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: sfi5_rx_frame_sync.v
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

This module synchronizes to the incoming deskew channel frame.
--------------------------------------------------------------------------------
*/
`timescale 1ns / 1ps

module sfi5_rx_frame_sync
(
	i_CLK,
	i_RST,
	i_FRAMES2LOCK,
	i_FRAMES2UNLOCK,
	i_CLEAR_FRAME_ERRORS,
	iv_DESKEW_CHANNEL,
	ov_DESKEW_CHANNEL,
	o_RXLOF,
	o_RXLOF_HISTORY,
	ov_FRAME_ERRORS,
	ov_FRAMES_RECEIVED,
	o_FRAME_START,
	ov_RXFRAME_SHIFT
);

input		i_CLK;			// Clock for all frame sync logic
input		i_RST;			// Reset for all frame sync logic
input	[6:0]	i_FRAMES2LOCK;		// User threshold: consecutive frame matches before !RXLOF
input	[6:0]	i_FRAMES2UNLOCK;	// User threshold: total frame errors before RXLOF
input		i_CLEAR_FRAME_ERRORS;	// Clears error counter and RXLOF history
input	[15:0]	iv_DESKEW_CHANNEL;	// Raw deskew channel data (unframed)

output	[15:0]	ov_DESKEW_CHANNEL;	// Correctly framed deskew channel data
output		o_RXLOF;		// RX Loss of Frame signal
output		o_RXLOF_HISTORY;	// Sticky bit to capture and hold any RXLOF event 
output	[31:0]	ov_FRAME_ERRORS;	// Running count of errors in frame header
output	[31:0]	ov_FRAMES_RECEIVED;	// Running count of frames received by RX
output		o_FRAME_START;		// Pulse indicating the start of a frame
output	[5:0]	ov_RXFRAME_SHIFT;	// Barrel shifter setting for aligned DSC channel

//`define		CHIPSCOPE_MODE		//Comment out when simulating

reg		o_RXLOF_HISTORY;
reg	[3:0]	CURRENT_STATE;
reg	[3:0]	NEXT_STATE;
reg		count_bitslip;
reg		ud_bitslip;
reg		count_timer;
reg		count_frames2lock;
reg		ud_frames2lock;
reg		count_frames2unlock;
reg		ud_frames2unlock;
reg		count_frames_received;
reg		ud_frames_received;

wire	[5:0]	shift_value;
wire	[6:0]	count_value;
wire	[6:0]	frames2lock;
wire	[31:0]	frames2unlock;

parameter	RESET		= 4'h0;
parameter	FRAME_FIND1	= 4'h1;
parameter	FRAME_FIND2	= 4'h2;
parameter	BITSLIP		= 4'h3;
parameter	WAIT_FRAME_LOCK1= 4'h4;
parameter	WAIT_FRAME_LOCK2= 4'h5;
parameter	FRAME_LOCK1	= 4'h6;
parameter	FRAME_LOCK2	= 4'h7;
parameter	FRAME1_MISMATCH	= 4'h8;
parameter	FRAME2_MISMATCH	= 4'h9;

assign		o_RXLOF		= ~(CURRENT_STATE == 4'h6 || CURRENT_STATE == 4'h7 || CURRENT_STATE == 4'h8 || CURRENT_STATE == 4'h9);
assign		ov_FRAME_ERRORS	= frames2unlock;
assign		o_FRAME_START	= (CURRENT_STATE == FRAME_LOCK2);
assign		ov_RXFRAME_SHIFT = shift_value;

always @(posedge i_CLK) begin
	if (i_CLEAR_FRAME_ERRORS)
		o_RXLOF_HISTORY <= 1'b0;
	else if (o_RXLOF)
		o_RXLOF_HISTORY <= 1'b1;
	else
		o_RXLOF_HISTORY <= o_RXLOF_HISTORY;
end

sfi5_rx_barrel_shifter_16bit sfi5_rx_barrel_shifter_16bit_dsc
(
	.i_CLK(i_CLK),
	.i_SYNC_RST(i_RST),
	.iv_SHIFT_VALUE(shift_value),
	.iv_DATA(iv_DESKEW_CHANNEL),
	.ov_DATA(ov_DESKEW_CHANNEL)
);

//===============================================================================
// Counter_64_0 is used to track the current shift setting of the barrel shifter.
// The counter is initialized to a shift value of 24 in the 63-bit shifter. The
// purpose of this initialization is to situate the deskew channel as close to 31
// as possible so that the data deskew capability is symmetric (ideally +/- 31). 
// It begins at 24 and shifts up until it finds a frame match (search field will 
// not be greater than 16). Worst cases: 24 and 39, yielding a worst-case deskew
// compensation of +/- 24.
//===============================================================================

counter_64 counter_64_0
(
	.clk(i_CLK), 
	.rst(i_RST),
	.init_value(6'd24),
	.ceiling_value(6'd39), 
	.count(count_bitslip), 
	.ud(ud_bitslip), 
	.counter_value(shift_value)
);

counter_128 counter_128_0
(
	.clk(i_CLK), 
	.rst(i_RST), 
	.count(count_timer), 
	.ud(1'b1), 
	.counter_value(count_value)
);

counter_128 counter_128_1
(
	.clk(i_CLK), 
	.rst(i_RST), 
	.count(count_frames2lock), 
	.ud(ud_frames2lock), 
	.counter_value(frames2lock)
);

counter_32bit counter_32bit_0
(
	.clk(i_CLK), 
	.rst(i_RST || i_CLEAR_FRAME_ERRORS), 
	.count(count_frames2unlock), 
	.ud(ud_frames2unlock), 
	.counter_value(frames2unlock)
);

counter_32bit counter_32bit_1
(
	.clk(i_CLK), 
	.rst(i_RST), 
	.count(count_frames_received), 
	.ud(ud_frames_received), 
	.counter_value(ov_FRAMES_RECEIVED)
);

//CURRENT STATE LOGIC
always @ (posedge i_CLK)
begin
	if (i_RST)
		CURRENT_STATE <= RESET;
	else
		CURRENT_STATE <= NEXT_STATE;
end

//NEXT STATE LOGIC
always @ (CURRENT_STATE or count_value or ov_DESKEW_CHANNEL or frames2lock or frames2unlock or i_FRAMES2LOCK or i_FRAMES2UNLOCK)
begin
	case (CURRENT_STATE)
		RESET:			NEXT_STATE <= FRAME_FIND1;
		FRAME_FIND1:		begin
					if (ov_DESKEW_CHANNEL == 16'hF6F6)
						NEXT_STATE <= FRAME_FIND2;
					else if (count_value < 7'd127)
						NEXT_STATE <= FRAME_FIND1;
					else
						NEXT_STATE <= BITSLIP;
					end
		FRAME_FIND2:		begin
					if (ov_DESKEW_CHANNEL == 16'h2828)
						NEXT_STATE <= WAIT_FRAME_LOCK1;
					else
						NEXT_STATE <= FRAME_FIND1;
					end
		BITSLIP:		NEXT_STATE <= FRAME_FIND1;
		WAIT_FRAME_LOCK1:	begin					
					if (count_value == 7'd66)
						begin
						if (ov_DESKEW_CHANNEL == 16'hF6F6)
							NEXT_STATE <= WAIT_FRAME_LOCK2;
						else
							NEXT_STATE <= FRAME_FIND1;
						end
					else
						NEXT_STATE <= WAIT_FRAME_LOCK1;
					end	
		WAIT_FRAME_LOCK2:	begin
					if (ov_DESKEW_CHANNEL == 16'h2828) 
						begin
						if (frames2lock == i_FRAMES2LOCK)
							NEXT_STATE <= FRAME_LOCK1;
						else
							NEXT_STATE <= WAIT_FRAME_LOCK1;
						end
					else	
						NEXT_STATE <= FRAME_FIND1;		
					end
		FRAME_LOCK1:		begin					
					if (count_value == 7'd66)
						begin
						if (ov_DESKEW_CHANNEL == 16'hF6F6)
							NEXT_STATE <= FRAME_LOCK2;
						else
							NEXT_STATE <= FRAME1_MISMATCH;
						end
					else
						NEXT_STATE <= FRAME_LOCK1;
					end
		FRAME_LOCK2:		begin
					if (ov_DESKEW_CHANNEL == 16'h2828) 
						NEXT_STATE <= FRAME_LOCK1;
					else	
						NEXT_STATE <= FRAME2_MISMATCH;		
					end
		FRAME1_MISMATCH:	begin
					if (frames2unlock == i_FRAMES2UNLOCK)
						NEXT_STATE <= FRAME_FIND1;
					else
						NEXT_STATE <= FRAME_LOCK1;
					end
		FRAME2_MISMATCH:	begin
					if (frames2unlock == i_FRAMES2UNLOCK)
						NEXT_STATE <= FRAME_FIND1;
					else
						NEXT_STATE <= FRAME_LOCK1;
					end
		default:		NEXT_STATE <= FRAME_FIND1;
	endcase
end

//OUTPUT LOGIC
always @ (CURRENT_STATE)
begin
	case (CURRENT_STATE)
		RESET:			begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b1;
					count_timer		<= 1'b0;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b1;
					count_frames2unlock	<= 1'b0;
					ud_frames2unlock	<= 1'b1;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b1;
					end		
		FRAME_FIND1:		begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b0;
					count_timer		<= 1'b1;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b1;
					count_frames2unlock	<= 1'b0;
					ud_frames2unlock	<= 1'b1;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b1;
					end		
		FRAME_FIND2:		begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b0;
					count_timer		<= 1'b0;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b1;
					count_frames2unlock	<= 1'b0;
					ud_frames2unlock	<= 1'b1;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b1;
					end		
		BITSLIP:		begin
					count_bitslip		<= 1'b1;
					ud_bitslip		<= 1'b1;
					count_timer		<= 1'b0;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b1;
					count_frames2unlock	<= 1'b0;
					ud_frames2unlock	<= 1'b1;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b1;
					end		
		WAIT_FRAME_LOCK1:	begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b0;
					count_timer		<= 1'b1;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b0;
					count_frames2unlock	<= 1'b0;
					ud_frames2unlock	<= 1'b1;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b1;
					end
		WAIT_FRAME_LOCK2:	begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b0;
					count_timer		<= 1'b0;
					count_frames2lock	<= 1'b1;
					ud_frames2lock		<= 1'b1;
					count_frames2unlock	<= 1'b0;
					ud_frames2unlock	<= 1'b1;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b1;
					end
		FRAME_LOCK1:		begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b0;
					count_timer		<= 1'b1;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b0;
					count_frames2unlock	<= 1'b0;
					ud_frames2unlock	<= 1'b0;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b0;
					end
		FRAME_LOCK2:		begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b0;
					count_timer		<= 1'b0;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b0;
					count_frames2unlock	<= 1'b0;
					ud_frames2unlock	<= 1'b0;
					count_frames_received	<= 1'b1;
					ud_frames_received	<= 1'b1;
					end				
		FRAME1_MISMATCH:	begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b0;
					count_timer		<= 1'b0;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b0;
					count_frames2unlock	<= 1'b1;
					ud_frames2unlock	<= 1'b1;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b0;
					end
		FRAME2_MISMATCH:	begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b0;
					count_timer		<= 1'b1;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b0;
					count_frames2unlock	<= 1'b1;
					ud_frames2unlock	<= 1'b1;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b0;
					end
		default:		begin
					count_bitslip		<= 1'b0;
					ud_bitslip		<= 1'b1;
					count_timer		<= 1'b0;
					count_frames2lock	<= 1'b0;
					ud_frames2lock		<= 1'b1;
					count_frames2unlock	<= 1'b0;
					ud_frames2unlock	<= 1'b1;
					count_frames_received	<= 1'b0;
					ud_frames_received	<= 1'b1;
					end		
	endcase
end

endmodule


