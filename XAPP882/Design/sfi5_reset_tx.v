// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: sfi5_reset_tx.v
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

This module generates reset signals for the SFI-5 TX interface.
--------------------------------------------------------------------------------
*/
`timescale  1 ns / 10 ps

module sfi5_reset_tx(
	i_CLK,
	i_RST,
	i_GTXS_READY,
	o_TXENPHASEALIGN,
	o_TXPMASETPHASE,
	o_TXDLYALIGNDISABLE,
        o_TXDLYALIGNRESET,
	o_TX_LOGIC_RST,
	o_GTXS_RST
    );

//===============================================================================
// Parameter declaration
//===============================================================================



//TX RESET FSM
localparam TX_RESET_SEQUENCE_INIT	= 7'b000_0001;
localparam RESET_GTXS			= 7'b000_0010;
localparam TX_WAIT_RESET_DEASSERT	= 7'b000_0100;
localparam TX_WAIT_RESET_DONE		= 7'b000_1000;
localparam TX_SET_PHASE			= 7'b001_0000;
localparam WAIT_TX_SET_PHASE_DONE	= 7'b010_0000;
localparam TX_RESET_DONE		= 7'b100_0000;


//===============================================================================
// I/O declaration
//===============================================================================

input		i_CLK;			// Free-running clock 
input		i_RST;			// Active high async reset
input		i_GTXS_READY;		// Reset done and GTX PLL locked for all GTX's
output		o_TXENPHASEALIGN;	// TX phase alignment signal
output		o_TXPMASETPHASE;	// TX phase alignment signal
output          o_TXDLYALIGNDISABLE;    // TX phase alignment signal
output          o_TXDLYALIGNRESET;      // TX phase alignment signal
output		o_TX_LOGIC_RST;		// Hold TX logic in reset
output		o_GTXS_RST;		// Reset GTX's

//===============================================================================
// Declaration of wires/regs
//===============================================================================

reg	[6:0]	CURRENT_STATE;	
reg	[6:0]	NEXT_STATE;
reg		tx_sync_ready;
reg	[19:0]	timeout_counter;
reg		count;

wire		tx_set_phase_done;

assign o_GTXS_RST	= (CURRENT_STATE == RESET_GTXS);


//===============================================================================
// TX Reset FSM to cycle through all stages of startup. 
//===============================================================================

//CURRENT STATE LOGIC
always @ (posedge i_CLK or posedge i_RST) begin
	if (i_RST)
		CURRENT_STATE <= TX_RESET_SEQUENCE_INIT;
	else
		CURRENT_STATE <= NEXT_STATE;
end

//NEXT STATE LOGIC
always @ (CURRENT_STATE or i_GTXS_READY or tx_set_phase_done or timeout_counter) begin
	case(CURRENT_STATE)
	TX_RESET_SEQUENCE_INIT: NEXT_STATE <= RESET_GTXS;

	RESET_GTXS:		NEXT_STATE <= TX_WAIT_RESET_DEASSERT;
	TX_WAIT_RESET_DEASSERT:	begin
				if (~i_GTXS_READY)
					NEXT_STATE <= TX_WAIT_RESET_DONE;
				else
					NEXT_STATE <= TX_WAIT_RESET_DEASSERT;
				end					
	TX_WAIT_RESET_DONE:	begin
				if (i_GTXS_READY)
					NEXT_STATE <= TX_SET_PHASE;
				else if (timeout_counter == 20'hFFFFE)
					NEXT_STATE <= TX_RESET_SEQUENCE_INIT;
				else
					NEXT_STATE <= TX_WAIT_RESET_DONE;
				end
	TX_SET_PHASE:		NEXT_STATE <= WAIT_TX_SET_PHASE_DONE;
	WAIT_TX_SET_PHASE_DONE: begin
				if (!i_GTXS_READY)
					NEXT_STATE <= TX_RESET_SEQUENCE_INIT;
				else if (tx_set_phase_done)
					NEXT_STATE <= TX_RESET_DONE;
				else
					NEXT_STATE <= WAIT_TX_SET_PHASE_DONE;
				end
	TX_RESET_DONE:		begin
				if (!i_GTXS_READY)
					NEXT_STATE <= TX_RESET_SEQUENCE_INIT;
				else
					NEXT_STATE <= TX_RESET_DONE;
				end
	default:		NEXT_STATE <= TX_RESET_SEQUENCE_INIT;
	endcase
end

//OUTPUT LOGIC
always @ (CURRENT_STATE) begin
	case(CURRENT_STATE)
	TX_RESET_SEQUENCE_INIT:	begin
				tx_sync_ready		<= 1'b0;
				count			<= 1'b0;
				end
	RESET_GTXS:		begin
				tx_sync_ready		<= 1'b0;
				count			<= 1'b0;
				end
	TX_WAIT_RESET_DEASSERT:	begin
				tx_sync_ready		<= 1'b0;
				count			<= 1'b0;
				end
	TX_WAIT_RESET_DONE:	begin
				tx_sync_ready		<= 1'b0;
				count			<= 1'b1;
				end                           
	TX_SET_PHASE:		begin                         
	                        tx_sync_ready		<= 1'b1;	//start TX phase align        
	                        count			<= 1'b0;
			        end                           
	WAIT_TX_SET_PHASE_DONE:	begin                         
	                        tx_sync_ready		<= 1'b1;       
	                        count			<= 1'b0; 
		                end                           
	TX_RESET_DONE:		begin                         
	                        tx_sync_ready		<= 1'b1;        
	                        count			<= 1'b0;
	                        end                           
	default:		begin                         
	                        tx_sync_ready		<= 1'b0;        
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


//===============================================================================
// TX Sync Sequence
//===============================================================================

TX_SYNC txsync_0 (
        .TXENPMAPHASEALIGN(o_TXENPHASEALIGN),
        .TXPMASETPHASE(o_TXPMASETPHASE),
        .TXDLYALIGNDISABLE(o_TXDLYALIGNDISABLE),
        .TXDLYALIGNRESET(o_TXDLYALIGNRESET),
        .SYNC_DONE(tx_set_phase_done),
        .USER_CLK(i_CLK),
        .RESET(!tx_sync_ready)
);


assign o_TX_LOGIC_RST = !tx_set_phase_done;

endmodule
