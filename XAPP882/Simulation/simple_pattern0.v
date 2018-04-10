`timescale 1ns / 1ps

module simple_pattern0
(
	i_CLK,
	i_RST,
	o_DATA
);

input		i_CLK;
input		i_RST;

output	[15:0]	o_DATA;

reg	[15:0]	o_DATA;
reg	[1:0]	CS, NS;

always @(posedge i_CLK) begin
	if (i_RST)
		CS <= 2'b00;
	else
		CS <= NS;
end

always @ (CS) begin
	case(CS)
		2'b00:	NS <= 2'b01;
		2'b01:	NS <= 2'b10;
		2'b10:	NS <= 2'b11;
		2'b11:	NS <= 2'b00;
	endcase
end

always @ (CS) begin
	case (CS)
		2'b00:	o_DATA <= 16'hA6E2;
		2'b01:	o_DATA <= 16'hF0A0;
		2'b10:	o_DATA <= 16'h5CDB;
		2'b11:	o_DATA <= 16'h475E;
	endcase
end

endmodule