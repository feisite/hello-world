// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: sfi5_reset_rx.v
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

This module generates reset signals for the SFI-5 RX interface.
--------------------------------------------------------------------------------
*/
`timescale  1 ns / 10 ps

module sfi5_reset_rx(
	i_CLK,
	i_RST,
	i_GTXS_READY,
	o_RX_LOGIC_RST,
	i_RXLOF,
	i_RXOOA,
	o_RESET_GTXS
    );

//===============================================================================
// Parameter declaration
//===============================================================================


parameter MAX_COUNT_RX			= 10'd469;	// ~3 us for CDR reset       

//RX RESET FSM
localparam RESET_RX_GTX			= 5'b0_0001;
localparam RX_WAIT_RESET_DONE		= 5'b0_0010;
localparam IDLE				= 5'b0_0100;
localparam RX_RESET_DONE		= 5'b0_1000;
localparam RESET_GTXS			= 5'b1_0000;


//===============================================================================
// I/O declaration
//===============================================================================

input		i_CLK;			// Free-running clock 
input		i_RST;			// Active high async reset
input		i_GTXS_READY;		// Reset done and GTX PLL locked for all GTX's
output		o_RX_LOGIC_RST;		// Hold RX logic in reset
input		i_RXLOF;		// Indicates frame sync is lost
input		i_RXOOA;		// Indicates all data channels are out of alignment
output		o_RESET_GTXS;		// Reset GTX's if frame lock is lost indefinitely

//===============================================================================
// Declaration of wires/regs
//===============================================================================

reg	[4:0]	CURRENT_STATE_RX;	
reg	[4:0]	NEXT_STATE_RX;

reg	[19:0]	timeout_counter;
reg		count;

assign		o_RX_LOGIC_RST		= (CURRENT_STATE_RX != RX_RESET_DONE);
assign		o_RESET_GTXS		= (CURRENT_STATE_RX == RESET_GTXS);

//===============================================================================
// RX Reset FSM to cycle through all stages of startup. 
//===============================================================================

//CURRENT STATE LOGIC
always @ (posedge i_CLK or posedge i_RST) begin
	if (i_RST)
		CURRENT_STATE_RX <= RESET_RX_GTX;
	else
		CURRENT_STATE_RX <= NEXT_STATE_RX;
end

//NEXT STATE LOGIC
always @ (CURRENT_STATE_RX or i_GTXS_READY or timeout_counter or i_RXLOF or i_RXOOA) begin
	case(CURRENT_STATE_RX)
	RESET_RX_GTX:		NEXT_STATE_RX <= IDLE;
	
	IDLE:			NEXT_STATE_RX <= RX_WAIT_RESET_DONE;
	RX_WAIT_RESET_DONE:	begin
				if (i_GTXS_READY)
					NEXT_STATE_RX <= RX_RESET_DONE;
				else if (timeout_counter == 20'hFFFFE)
					NEXT_STATE_RX <= RESET_RX_GTX;
				else
					NEXT_STATE_RX <= RX_WAIT_RESET_DONE;
				end

	RX_RESET_DONE:		begin
				if (!i_GTXS_READY || (timeout_counter == 20'hFFFFE && (i_RXLOF || i_RXOOA)))
					NEXT_STATE_RX <= RESET_GTXS;
				else
					NEXT_STATE_RX <= RX_RESET_DONE;
				end
	RESET_GTXS:		NEXT_STATE_RX <= RESET_RX_GTX;
	default:		NEXT_STATE_RX <= RESET_RX_GTX;
	endcase
end

//OUTPUT LOGIC
always @ (CURRENT_STATE_RX) begin
	case(CURRENT_STATE_RX)
	RESET_RX_GTX:		begin                         
	                        count			<= 1'b0;
			        end                           
	IDLE:			begin                         
	                        count			<= 1'b0;	// reset timeout counter
		                end                           
	RX_WAIT_RESET_DONE:	begin
				count			<= 1'b1;	//start timeout counter
				end
	RX_RESET_DONE:		begin                         
	                        count			<= 1'b1;
	                        end                           
	RESET_GTXS:		begin                         
	                        count			<= 1'b0;
	                        end                           
	default:		begin                         
	                        count			<= 1'b0;
			        end                           
	endcase
end					

//===============================================================================
// Timeout counter when waiting for resetdone and gtpplllock
//===============================================================================

always@(posedge i_CLK)
begin
	if(i_RST == 1'b1)
		timeout_counter = 20'h00000;
	else if (count)
		timeout_counter = timeout_counter + 1;
	else
		timeout_counter = 20'h00000;
end

endmodule
