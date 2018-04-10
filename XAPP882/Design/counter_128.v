// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: counter_128.v
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

This module counts up/down between 0 to 128
--------------------------------------------------------------------------------
*/
`timescale  1 ns / 10 ps

module counter_128
(
	clk, 
	rst, 
	count, 
	ud, 
	counter_value
);

input		clk, rst, count, ud;
output	[6:0]	counter_value;

wire	[6:0]	counter_value_preserver;
reg	[6:0]	counter_value;

always@(posedge clk)
begin
	if(rst == 1'b1)
		counter_value = 7'h00;
	else begin
	case({count,ud})
		2'b00: counter_value = counter_value_preserver;
		2'b01: counter_value = 7'h00;
		2'b10: counter_value = counter_value_preserver - 1;
		2'b11: counter_value = counter_value_preserver + 1;
		default: counter_value = 7'h00;
	endcase
	end
end

assign counter_value_preserver = counter_value;

endmodule
