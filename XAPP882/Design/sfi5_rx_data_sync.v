// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: sfi5_rx_data_sync.v
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

This module deskews a data channel to match the deskew channel.
--------------------------------------------------------------------------------
*/
`timescale 1ns / 1ps

module sfi5_rx_data_sync
(
	i_CLK,
	i_RST,
	iv_DATA,
	iv_DSC,
	i_RXLOF,
	i_FRAME_START,
	iv_CHANNEL_OFFSET,
	iv_MISMATCHES_2_UNLOCK,
	i_CLEAR_MISMATCHES,
	ov_DATA,
	o_RXOOA,
	ov_RXDATA_SHIFT,
	ov_DATA_MISMATCHES
);

input		i_CLK;			// Clocks all data sync logic
input		i_RST;			// Resets all data sync logic
input	[15:0]	iv_DATA;		// Deserialized data from one GTP		
input	[15:0]	iv_DSC;			// Incoming deskew channel
input		i_RXLOF;		// Indicates deskew channel is not yet synced
input		i_FRAME_START;		// Flag from framer indicating start of a frame
input	[4:0]	iv_CHANNEL_OFFSET;	// Each data channel compares to different part of frame
input	[6:0]	iv_MISMATCHES_2_UNLOCK;	// User-defined threshold for data sync loss
input		i_CLEAR_MISMATCHES;	// Clears mismatch count

output	[15:0]	ov_DATA;		// Deskewed version of iv_DATA
output		o_RXOOA;		// Indicates data is out of alignment
output	[5:0]	ov_RXDATA_SHIFT;	// Barrel shifter setting for ov_DATA  
output	[31:0]	ov_DATA_MISMATCHES;	// Count of data mismatches when compared to deskew channel

reg		rxooa;
reg		rxooa_enable;
reg	[3:0]	CURRENT_STATE;
reg	[3:0]	NEXT_STATE;
reg		count_data_position;
reg		count_consec_mismatch;
reg		ud_consec_mismatch;
reg		count_mismatch;
reg		ud_mismatch;
reg		count_shift_data;
reg		ud_shift_data;

wire	[6:0]	consecutive_mismatches;
wire	[6:0]	data_position;
wire	[5:0]	shift_data;
wire	[6:0]	channel_offset;

parameter	WAIT_FRAME_SYNC		= 4'h0;
parameter	WAIT_FRAME_START	= 4'h1;
parameter	WAIT_DATA_POSITION	= 4'h2;
parameter	DATA_MATCH_0		= 4'h3;
parameter	DATA_MATCH_1		= 4'h4;
parameter	DATA_MATCH_2		= 4'h5;
parameter	DATA_MATCH_3		= 4'h6;
parameter	COMPARE_ERROR		= 4'h7;
parameter	DATA_SHIFT		= 4'h8;

assign		channel_offset		= iv_CHANNEL_OFFSET*4 + 2;
assign		ov_RXDATA_SHIFT		= shift_data;

sfi5_rx_barrel_shifter_16bit sfi5_rx_barrel_shifter_16bit_0
(
	.i_CLK(i_CLK),
	.i_SYNC_RST(i_RST),
	.iv_SHIFT_VALUE(shift_data),
	.iv_DATA(iv_DATA),
	.ov_DATA(ov_DATA)
);

//Barrel shifter position
counter_64 counter_64_0
(
	.clk(i_CLK), 
	.rst(i_RST),
	.init_value(6'd0),
	.ceiling_value(6'd63), 
	.count(count_shift_data), 
	.ud(ud_shift_data), 
	.counter_value(shift_data)
);

//Keep track of current position in frame
counter_128 counter_128_0
(
	.clk(i_CLK), 
	.rst(i_RST), 
	.count(count_data_position), 
	.ud(1'b1), 
	.counter_value(data_position)
);

//Count consecutive mismatches
counter_128 counter_128_1
(
	.clk(i_CLK), 
	.rst(i_RST), 
	.count(count_consec_mismatch), 
	.ud(ud_consec_mismatch), 
	.counter_value(consecutive_mismatches)
);

//Count all mismatches
counter_32bit counter_32bit_0
(
	.clk(i_CLK), 
	.rst(i_RST || i_CLEAR_MISMATCHES), 
	.count(count_mismatch), 
	.ud(ud_mismatch), 
	.counter_value(ov_DATA_MISMATCHES)
);

FDRSE #(
	.INIT(1'b1)
) FDRSE_inst (
	.Q(o_RXOOA),
	.C(i_CLK),
	.CE(rxooa_enable),
	.D(rxooa),
	.R(1'b0),
	.S(1'b0)
);

//CURRENT STATE LOGIC
always @ (posedge i_CLK)
begin
	if (i_RST || i_RXLOF)
		CURRENT_STATE <= WAIT_FRAME_SYNC;
	else
		CURRENT_STATE <= NEXT_STATE;
end

//NEXT STATE LOGIC
always @ (CURRENT_STATE or i_FRAME_START or channel_offset or data_position or iv_DSC or ov_DATA or consecutive_mismatches or iv_MISMATCHES_2_UNLOCK)
begin
	case (CURRENT_STATE)
		WAIT_FRAME_SYNC:	NEXT_STATE <= WAIT_FRAME_START;
		WAIT_FRAME_START:	begin
					if (i_FRAME_START)
						NEXT_STATE <= WAIT_DATA_POSITION;
					else
						NEXT_STATE <= WAIT_FRAME_START;
					end
		WAIT_DATA_POSITION:	begin
					if (data_position == channel_offset)
						begin
						if (ov_DATA == iv_DSC)
							NEXT_STATE <= DATA_MATCH_0;
						else
							NEXT_STATE <= COMPARE_ERROR;
						end
					else
						NEXT_STATE <= WAIT_DATA_POSITION;
					end
		DATA_MATCH_0:		begin
					if (ov_DATA == iv_DSC)
						NEXT_STATE <= DATA_MATCH_1;
					else
						NEXT_STATE <= COMPARE_ERROR;
					end
		DATA_MATCH_1:		begin
					if (ov_DATA == iv_DSC)
						NEXT_STATE <= DATA_MATCH_2;
					else
						NEXT_STATE <= COMPARE_ERROR;
					end
		DATA_MATCH_2:		begin
					if (ov_DATA == iv_DSC)
						NEXT_STATE <= DATA_MATCH_3;
					else
						NEXT_STATE <= COMPARE_ERROR;
					end
		DATA_MATCH_3:		NEXT_STATE <= WAIT_FRAME_START;
		COMPARE_ERROR:		begin
					if (consecutive_mismatches >= iv_MISMATCHES_2_UNLOCK)
						NEXT_STATE <= DATA_SHIFT;
					else
						NEXT_STATE <= WAIT_FRAME_START;
					end
		DATA_SHIFT:		NEXT_STATE <= WAIT_FRAME_SYNC;
		default:		NEXT_STATE <= WAIT_FRAME_SYNC;
	endcase
end

//OUTPUT LOGIC
always @ (CURRENT_STATE)
begin
	case (CURRENT_STATE)
		WAIT_FRAME_SYNC:	begin
					count_data_position	<= 1'b0;
					count_shift_data	<= 1'b0;
					ud_shift_data		<= 1'b0;
					count_consec_mismatch	<= 1'b0;
					ud_consec_mismatch	<= 1'b1;
					count_mismatch		<= 1'b0;
					ud_mismatch		<= 1'b1;
					rxooa			<= 1'b1;
					rxooa_enable		<= 1'b1;
					end
		WAIT_FRAME_START:	begin
					count_data_position	<= 1'b0;
					count_shift_data	<= 1'b0;
					ud_shift_data		<= 1'b0;
					count_consec_mismatch	<= 1'b0;
					ud_consec_mismatch	<= 1'b0;
					count_mismatch		<= 1'b0;
					ud_mismatch		<= 1'b0;
					rxooa			<= 1'b0;
					rxooa_enable		<= 1'b0;
					end
		WAIT_DATA_POSITION:	begin
					count_data_position	<= 1'b1;
					count_shift_data	<= 1'b0;
					ud_shift_data		<= 1'b0;
					count_consec_mismatch	<= 1'b0;
					ud_consec_mismatch	<= 1'b0;
					count_mismatch		<= 1'b0;
					ud_mismatch		<= 1'b0;
					rxooa			<= 1'b0;
					rxooa_enable		<= 1'b0;
					end
		DATA_MATCH_0:		begin
					count_data_position	<= 1'b0;
					count_shift_data	<= 1'b0;
					ud_shift_data		<= 1'b0;
					count_consec_mismatch	<= 1'b0;
					ud_consec_mismatch	<= 1'b0;
					count_mismatch		<= 1'b0;
					ud_mismatch		<= 1'b0;
					rxooa			<= 1'b0;
					rxooa_enable		<= 1'b0;
					end
		DATA_MATCH_1:		begin
					count_data_position	<= 1'b0;
					count_shift_data	<= 1'b0;
					ud_shift_data		<= 1'b0;
					count_consec_mismatch	<= 1'b0;
					ud_consec_mismatch	<= 1'b0;
					count_mismatch		<= 1'b0;
					ud_mismatch		<= 1'b0;
					rxooa			<= 1'b0;
					rxooa_enable		<= 1'b0;
					end
		DATA_MATCH_2:		begin
					count_data_position	<= 1'b0;
					count_shift_data	<= 1'b0;
					ud_shift_data		<= 1'b0;
					count_consec_mismatch	<= 1'b0;
					ud_consec_mismatch	<= 1'b0;
					count_mismatch		<= 1'b0;
					ud_mismatch		<= 1'b0;
					rxooa			<= 1'b0;
					rxooa_enable		<= 1'b0;
					end
		DATA_MATCH_3:		begin
					count_data_position	<= 1'b0;
					count_shift_data	<= 1'b0;
					ud_shift_data		<= 1'b0;
					count_consec_mismatch	<= 1'b0;
					ud_consec_mismatch	<= 1'b1;
					count_mismatch		<= 1'b0;
					ud_mismatch		<= 1'b0;
					rxooa			<= 1'b0;
					rxooa_enable		<= 1'b1;
					end
		COMPARE_ERROR:		begin
					count_data_position	<= 1'b0;
					count_shift_data	<= 1'b0;
					ud_shift_data		<= 1'b0;
					count_consec_mismatch	<= 1'b1;
					ud_consec_mismatch	<= 1'b1;
					count_mismatch		<= 1'b1;
					ud_mismatch		<= 1'b1;
					rxooa			<= 1'b0;
					rxooa_enable		<= 1'b0;
					end
		DATA_SHIFT:		begin
					count_data_position	<= 1'b0;
					count_shift_data	<= 1'b1;
					ud_shift_data		<= 1'b1;
					count_consec_mismatch	<= 1'b0;
					ud_consec_mismatch	<= 1'b1;
					count_mismatch		<= 1'b0;
					ud_mismatch		<= 1'b0;
					rxooa			<= 1'b1;
					rxooa_enable		<= 1'b1;
					end
		default:		begin
					count_data_position	<= 1'b0;
					count_shift_data	<= 1'b0;
					ud_shift_data		<= 1'b0;
					count_consec_mismatch	<= 1'b0;
					ud_consec_mismatch	<= 1'b1;
					count_mismatch		<= 1'b0;
					ud_mismatch		<= 1'b1;
					rxooa			<= 1'b1;
					rxooa_enable		<= 1'b1;
					end
	endcase
end    

endmodule
