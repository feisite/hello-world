// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: sfi5_tx_deskew_channel.v
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

This module generates the deskew channel frame.
--------------------------------------------------------------------------------
*/
`timescale 1ns / 1ps

module sfi5_tx_deskew_channel
(
	i_CLK,
	i_RST,
	iv_TXDATA00,
	iv_TXDATA01,
	iv_TXDATA02,
	iv_TXDATA03,
	iv_TXDATA04,
	iv_TXDATA05,
	iv_TXDATA06,
	iv_TXDATA07,
	iv_TXDATA08,
	iv_TXDATA09,
	iv_TXDATA10,
	iv_TXDATA11,
	iv_TXDATA12,
	iv_TXDATA13,
	iv_TXDATA14,
	iv_TXDATA15,
	ov_DESKEW_CHANNEL,
	i_INSERT_FRAME_ERROR,
	i_INSERT_DATA_ERROR
);

input		i_CLK;			// drives all deskew channel logic
input		i_RST;			// resets all deskew channel logic
input	[15:0]	iv_TXDATA00;		// data to be transmitted by GTP 00
input	[15:0]	iv_TXDATA01;		// data to be transmitted by GTP 01
input	[15:0]	iv_TXDATA02;		// data to be transmitted by GTP 02
input	[15:0]	iv_TXDATA03;		// data to be transmitted by GTP 03
input	[15:0]	iv_TXDATA04;		// data to be transmitted by GTP 04
input	[15:0]	iv_TXDATA05;		// data to be transmitted by GTP 05
input	[15:0]	iv_TXDATA06;		// data to be transmitted by GTP 06
input	[15:0]	iv_TXDATA07;		// data to be transmitted by GTP 07
input	[15:0]	iv_TXDATA08;		// data to be transmitted by GTP 08
input	[15:0]	iv_TXDATA09;		// data to be transmitted by GTP 09
input	[15:0]	iv_TXDATA10;		// data to be transmitted by GTP 10
input	[15:0]	iv_TXDATA11;		// data to be transmitted by GTP 11
input	[15:0]	iv_TXDATA12;		// data to be transmitted by GTP 12
input	[15:0]	iv_TXDATA13;		// data to be transmitted by GTP 13
input	[15:0]	iv_TXDATA14;		// data to be transmitted by GTP 14
input	[15:0]	iv_TXDATA15;		// data to be transmitted by GTP 15
input		i_INSERT_FRAME_ERROR;	// insert error in frame header
input		i_INSERT_DATA_ERROR;	// insert error in frame body (CH 15)

output	[15:0]	ov_DESKEW_CHANNEL;	// frame transmitted by deskew channel	
	
reg	[4:0]	CURRENT_STATE;
reg	[4:0]	NEXT_STATE;
reg	[15:0]	deskew_channel_prelim;
reg		count;
reg		insert_frame_error;
reg		insert_frame_error_sticky;
reg		insert_data_error;
reg		insert_data_error_sticky;

wire	[5:0]	count_value;

parameter	RESET		= 5'b00000;
parameter	FRAME1		= 5'b00001;
parameter	FRAME2		= 5'b00010;
parameter	EXTENSION1	= 5'b00011;
parameter	EXTENSION2	= 5'b00100;
parameter	DATA00		= 5'b00101;
parameter	DATA01		= 5'b00110;
parameter	DATA02		= 5'b00111;
parameter	DATA03		= 5'b01000;
parameter	DATA04		= 5'b01001;
parameter	DATA05		= 5'b01010;
parameter	DATA06		= 5'b01011;
parameter	DATA07		= 5'b01100;
parameter	DATA08		= 5'b01101;
parameter	DATA09		= 5'b01110;
parameter	DATA10		= 5'b01111;
parameter	DATA11		= 5'b10000;
parameter	DATA12		= 5'b10001;
parameter	DATA13		= 5'b10010;
parameter	DATA14		= 5'b10011;
parameter	DATA15		= 5'b10100;
parameter	FRAME2_W_ERROR	= 5'b10101;
parameter	DATA00_W_ERROR	= 5'b10110;

assign	ov_DESKEW_CHANNEL = deskew_channel_prelim;

//Retime i_INSERT_FRAME_ERROR to i_CLK domain
always @ (posedge i_CLK) begin
	 insert_frame_error <= i_INSERT_FRAME_ERROR;
end

//Frame error insertion logic
always @ (posedge i_CLK)
begin
	if (CURRENT_STATE == EXTENSION1)
		insert_frame_error_sticky <= 1'b0;
	else if (insert_frame_error)
		insert_frame_error_sticky <= 1'b1;
	else
		insert_frame_error_sticky <= insert_frame_error_sticky;
end	  

//Retime i_INSERT_DATA_ERROR to i_CLK domain
always @ (posedge i_CLK) begin
	 insert_data_error <= i_INSERT_DATA_ERROR;
end

//Data error insertion logic
always @ (posedge i_CLK)
begin
	if (CURRENT_STATE == DATA02)
		insert_data_error_sticky <= 1'b0;
	else if (insert_data_error)
		insert_data_error_sticky <= 1'b1;
	else
		insert_data_error_sticky <= insert_data_error_sticky;
end
	 
counter_64 counter_64_0
(
	.clk(i_CLK), 
	.rst(i_RST),
	.init_value(6'd00),
	.ceiling_value(6'd63), 
	.count(count), 
	.ud(1'b1), 
	.counter_value(count_value)
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
always @ (CURRENT_STATE or count_value or insert_frame_error_sticky or insert_data_error_sticky)
begin
	case (CURRENT_STATE)
		RESET:		NEXT_STATE <= FRAME1;
		FRAME1:		begin
				if (insert_frame_error_sticky)
					NEXT_STATE <= FRAME2_W_ERROR;
				else
					NEXT_STATE <= FRAME2;
				end
		FRAME2:		NEXT_STATE <= EXTENSION1;
		FRAME2_W_ERROR:	NEXT_STATE <= EXTENSION1;
		EXTENSION1:	NEXT_STATE <= EXTENSION2;
		EXTENSION2:	begin
				if (insert_data_error_sticky)
					NEXT_STATE <= DATA00_W_ERROR;
				else
					NEXT_STATE <= DATA00;
				end
		DATA00:		begin
				if (count_value == 6'd3)
					NEXT_STATE <= DATA01;
				else
					NEXT_STATE <= DATA00;
				end
		DATA00_W_ERROR:	begin
				if (count_value == 6'd3)
					NEXT_STATE <= DATA01;
				else
					NEXT_STATE <= DATA00;
				end
		DATA01:		begin
				if (count_value == 6'd7)
					NEXT_STATE <= DATA02;
				else
					NEXT_STATE <= DATA01;
				end
		DATA02:		begin
				if (count_value == 6'd11)
					NEXT_STATE <= DATA03;
				else
					NEXT_STATE <= DATA02;
				end
		DATA03:		begin
				if (count_value == 6'd15)
					NEXT_STATE <= DATA04;
				else
					NEXT_STATE <= DATA03;
				end
		DATA04:		begin
				if (count_value == 6'd19)
					NEXT_STATE <= DATA05;
				else
					NEXT_STATE <= DATA04;
				end		
		DATA05:		begin
				if (count_value == 6'd23)
					NEXT_STATE <= DATA06;
				else
					NEXT_STATE <= DATA05;
				end		
		DATA06:		begin
				if (count_value == 6'd27)
					NEXT_STATE <= DATA07;
				else
					NEXT_STATE <= DATA06;
				end		
		DATA07:		begin
				if (count_value == 6'd31)
					NEXT_STATE <= DATA08;
				else
					NEXT_STATE <= DATA07;
				end
		DATA08:		begin
				if (count_value == 6'd35)
					NEXT_STATE <= DATA09;
				else
					NEXT_STATE <= DATA08;
				end				
		DATA09:		begin
				if (count_value == 6'd39)
					NEXT_STATE <= DATA10;
				else
					NEXT_STATE <= DATA09;
				end		
		DATA10:		begin
				if (count_value == 6'd43)
					NEXT_STATE <= DATA11;
				else
					NEXT_STATE <= DATA10;
				end		
		DATA11:		begin
				if (count_value == 6'd47)
					NEXT_STATE <= DATA12;
				else
					NEXT_STATE <= DATA11;
				end		
		DATA12:		begin
				if (count_value == 6'd51)
					NEXT_STATE <= DATA13;
				else
					NEXT_STATE <= DATA12;
				end				
		DATA13:		begin
				if (count_value == 6'd55)
					NEXT_STATE <= DATA14;
				else
					NEXT_STATE <= DATA13;
				end				
		DATA14:		begin
				if (count_value == 6'd59)
					NEXT_STATE <= DATA15;
				else
					NEXT_STATE <= DATA14;
				end				
		DATA15:		begin
				if (count_value == 6'd63)
					NEXT_STATE <= FRAME1;
				else
					NEXT_STATE <= DATA15;
				end
                default:        NEXT_STATE <= RESET;
	endcase
end

//OUTPUT LOGIC
always @ (CURRENT_STATE or iv_TXDATA00 or iv_TXDATA01 or iv_TXDATA02 or iv_TXDATA03 or iv_TXDATA04 or iv_TXDATA05 or iv_TXDATA06 or iv_TXDATA07 or iv_TXDATA08 or iv_TXDATA09 or iv_TXDATA10 or iv_TXDATA11 or iv_TXDATA12 or iv_TXDATA13 or iv_TXDATA14 or iv_TXDATA15)
begin
	count <= 1'b0;
	deskew_channel_prelim <= 16'h0000;
	case (CURRENT_STATE)
		RESET:		begin		
					count <= 1'b0;
					deskew_channel_prelim <= 16'h0000;
				end
		FRAME1:		begin		
					count <= 1'b0;
					deskew_channel_prelim <= 16'hF6F6;
				end
		FRAME2:		begin		
					count <= 1'b0;
					deskew_channel_prelim <= 16'h2828;
				end
		FRAME2_W_ERROR:	begin		
					count <= 1'b0;
					deskew_channel_prelim <= 16'h2928;
				end
		EXTENSION1:	begin		
					count <= 1'b0;
					deskew_channel_prelim <= 16'hAAAA;
				end
		EXTENSION2:	begin		
					count <= 1'b0;
					deskew_channel_prelim <= 16'hAAAA;
				end
		DATA00:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA15;
				end
		DATA00_W_ERROR:	begin		
					count <= 1'b1;
					deskew_channel_prelim <= ~iv_TXDATA15;
				end
		DATA01:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA14;
				end
		DATA02:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA13;
				end
		DATA03:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA12;
				end
		DATA04:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA11;
				end
		DATA05:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA10;
				end
		DATA06:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA09;
				end
		DATA07:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA08;
				end
		DATA08:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA07;
				end
		DATA09:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA06;
				end
		DATA10:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA05;
				end
		DATA11:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA04;
				end
		DATA12:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA03;
				end
		DATA13:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA02;
				end
		DATA14:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA01;
				end
		DATA15:		begin		
					count <= 1'b1;
					deskew_channel_prelim <= iv_TXDATA00;
				end
	endcase
end

endmodule
