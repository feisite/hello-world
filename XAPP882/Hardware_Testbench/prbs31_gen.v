// -----------------------------------------------------------------------------
// -- Copyright (c) 2010 Xilinx, Inc.
// -- This design is confidential and proprietary of Xilinx, All Rights
// Reserved.
// -----------------------------------------------------------------------------
// -   ____  ____
// -  /   /\/   /
// - /___/  \  /   Vendor: Xilinx
// - \   \   \/    Version: 1.0
// -  \   \        Filename: PRBSGen31.v
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

This module generates PRBS31 type pattern. 
--------------------------------------------------------------------------------
*/

module PRBSGen31(data_out, advance_in, reset_in, poly_in, length_in, clock_in);

output	[15:00]	data_out;
input	[30:00]	poly_in;
input		length_in, advance_in, reset_in, clock_in;

reg 	[30:00]	PRBS;
reg 	[15:00]	data_out;

wire	[30:00]	ix00, ix01, ix02, ix03, ix04, ix05, ix06, ix07, ix08, ix09, ix10, ix11, ix12, ix13, ix14, ix15;

IX31 intermediate_expression00(ix00, PRBS, poly_in, length_in);
IX31 intermediate_expression01(ix01, ix00, poly_in, length_in);
IX31 intermediate_expression02(ix02, ix01, poly_in, length_in);
IX31 intermediate_expression03(ix03, ix02, poly_in, length_in);
IX31 intermediate_expression04(ix04, ix03, poly_in, length_in);
IX31 intermediate_expression05(ix05, ix04, poly_in, length_in);
IX31 intermediate_expression06(ix06, ix05, poly_in, length_in);
IX31 intermediate_expression07(ix07, ix06, poly_in, length_in);
IX31 intermediate_expression08(ix08, ix07, poly_in, length_in);
IX31 intermediate_expression09(ix09, ix08, poly_in, length_in);
IX31 intermediate_expression10(ix10, ix09, poly_in, length_in);
IX31 intermediate_expression11(ix11, ix10, poly_in, length_in);
IX31 intermediate_expression12(ix12, ix11, poly_in, length_in);
IX31 intermediate_expression13(ix13, ix12, poly_in, length_in);
IX31 intermediate_expression14(ix14, ix13, poly_in, length_in);
IX31 intermediate_expression15(ix15, ix14, poly_in, length_in);

always @ (posedge clock_in) begin
	if (reset_in) begin 
		PRBS <= 31'b1111111111111111111111111111111;
		data_out <= 1;
	end else if (advance_in) begin
		PRBS <= ix15;
		data_out <= {ix00[30], ix01[30], ix02[30], ix03[30], ix04[30], ix05[30], ix06[30], ix07[30], ix08[30], ix09[30], ix10[30], ix11[30], ix12[30], ix13[30], ix14[30], ix15[30]};
	end
end

endmodule


module IX31 (exp_out, exp_in, poly_in, length_in);

output	[30:00]	exp_out;
input	[30:00]	exp_in, poly_in;
input		length_in;

assign exp_out[00] = (exp_in[00] & poly_in[30]) ^
                     (exp_in[01] & poly_in[29]) ^
                     (exp_in[02] & poly_in[28]) ^
                     (exp_in[03] & poly_in[27]) ^
                     (exp_in[04] & poly_in[26]) ^
                     (exp_in[05] & poly_in[25]) ^
                     (exp_in[06] & poly_in[24]) ^
                     (exp_in[07] & poly_in[23]) ^
                     (exp_in[08] & poly_in[22]) ^
                     (exp_in[09] & poly_in[21]) ^
                     (exp_in[10] & poly_in[20]) ^
                     (exp_in[11] & poly_in[19]) ^
                     (exp_in[12] & poly_in[18]) ^
                     (exp_in[13] & poly_in[17]) ^
                     (exp_in[14] & poly_in[16]) ^
                     (exp_in[15] & poly_in[15]) ^
                     (exp_in[16] & poly_in[14]) ^
                     (exp_in[17] & poly_in[13]) ^
                     (exp_in[18] & poly_in[12]) ^
                     (exp_in[19] & poly_in[11]) ^
                     (exp_in[20] & poly_in[10]) ^
                     (exp_in[21] & poly_in[09]) ^
                     (exp_in[22] & poly_in[08]) ^
                     (exp_in[23] & poly_in[07]) ^
                     (exp_in[24] & poly_in[06]) ^
                     (exp_in[25] & poly_in[05]) ^
                     (exp_in[26] & poly_in[04]) ^
                     (exp_in[27] & poly_in[03]) ^
                     (exp_in[28] & poly_in[02]) ^
                     (exp_in[29] & poly_in[01]) ^
                     (exp_in[30] & poly_in[00]) ^ length_in;

assign exp_out[30:01] = exp_in[29:00];

endmodule
