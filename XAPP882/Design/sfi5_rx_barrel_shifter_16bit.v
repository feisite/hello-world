// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: sfi5_rx_barrel_shifter_16bit.v
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

This module is a 63-bit barrel shifter. The data input is 16 bits, and the 
data output is the data input shifted to any of the 63 shift selections
--------------------------------------------------------------------------------
*/
`timescale  1 ns / 10 ps

module sfi5_rx_barrel_shifter_16bit
(
	i_CLK,
	i_SYNC_RST,
	iv_SHIFT_VALUE,
	iv_DATA,
	ov_DATA
);

//===============================================================================
// I/O declaration
//===============================================================================

input			i_CLK;		// Clock
input			i_SYNC_RST;	// Active high synchronous reset.
input	[5:0]		iv_SHIFT_VALUE;	// Shift value from 0 to 63
input	[15:0]		iv_DATA;	// Input data
output	[15:0]		ov_DATA;	// Output data from barrel shift
reg	[15:0]		ov_DATA;

//===============================================================================
// Declaration of wires/regs
//===============================================================================
		         
reg	[78:0]		latched_data;	// First level of registers (79 = 63(max shift)+ 16 (data width)) 
wire	[46:0]		data_mux_1;          
wire	[30:0]		data_mux_2;          
reg	[22:0]		data_mux_3;           
wire	[18:0]		data_mux_4;          
wire	[16:0]		data_mux_5;          
reg	[5:0]		shift_value_rt1;

//===============================================================================
// Each cycle, the 16-bit input data is added to the 79-bit sliding window of data,  
// causing the 16 oldest bits in the window to be displaced. A 79 bit window allows
// barrel shifts between 0 and 63 bits. The 6-level barrel shifter is pipelined at 
// level 3 and level 6 to ease timing closure. The SHIFT_VALUE vector is treated as
// active low in the logic below so that a value of 000000 corresponds to a shift
// of zero, 000001 to a shift of 1, etc.  
//===============================================================================

always @ (posedge i_CLK) begin
	if (i_SYNC_RST) begin
		latched_data    <= 79'd0;
		ov_DATA         <= 16'd0;
	end
	else begin
		shift_value_rt1 <= iv_SHIFT_VALUE;					// Retime the shift value for each stage of pipelining
		latched_data <= {iv_DATA,latched_data[78:16]};				// Shift in 16 bits of new data every clock cycle
		data_mux_3 <= (~iv_SHIFT_VALUE[3]) ? data_mux_2[30:8] : data_mux_2[22:0];// Add pipelining stage in the middle of the mux
		ov_DATA <= (~shift_value_rt1[0]) ? data_mux_5[16:1] : data_mux_5[15:0];	// Sixth mux stage
   	end
end

//===============================================================================
// To shift data by up to 63 bits we need 6 levels of 2 to 1 muxes (2 ^ 6 = 63)
//===============================================================================

assign data_mux_1 = (~iv_SHIFT_VALUE[5]) ? latched_data[78:32] : latched_data[46:0];	// Select 79 bits
assign data_mux_2 = (~iv_SHIFT_VALUE[4]) ? data_mux_1[46:16] : data_mux_1[30:0];	// Select 47 bits
//assign data_mux_3 = (~iv_SHIFT_VALUE[3]) ? data_mux_2[30:8] : data_mux_2[22:0];	// Select 31 bits
assign data_mux_4 = (~shift_value_rt1[2]) ? data_mux_3[22:4] : data_mux_3[18:0];	// Select 23 bits
assign data_mux_5 = (~shift_value_rt1[1]) ? data_mux_4[18:2] : data_mux_4[16:0];	// Select 19 bits

endmodule

