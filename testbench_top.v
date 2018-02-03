`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/02/01 21:31:03
// Design Name: 
// Module Name: testbench_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_top #(
    parameter       BD_RATE = 9600,
    parameter       RX_CLK  = 50_000_000
)
(

    );

//---------------------------------define ----------------------------------------
reg             rst;
reg             clk;

//---------------------------------process ---------------------------------------

initial begin
    rst = 1'b1;
    #100;
    rst = 1'b0;
end

always begin
    clk = 1'b0;
    #0.5;
    clk = ~clk;
    #0.5;
end

//--------------------------------define ------------------------------------------
reg             uart_rx;
wire    [7:0]   uart_rxdata;
//--------------------------------source module -----------------------------------
initial begin
    uart_rx = 1'b1;
    #20000;
    uart_rx = 1'b0;     //begin
    #5208;
    uart_rx = 1'b0;
    #5208;
    uart_rx = 1'b1;
    #5208;
    uart_rx = 1'b0;
    #5208;
    uart_rx = 1'b1;
    #5208;
    uart_rx = 1'b0;
    #5208;
    uart_rx = 1'b1;
    #5208;
    uart_rx = 1'b0;
    #5208;
    uart_rx = 1'b0;
    #5208;
    uart_rx = 1'b1;
end

//--------------------------------objective module --------------------------------
uart #(
    BD_RATE,
    RX_CLK
)
uart_inst(
//--------------------------------rst clk ---------------------------------------
    .rst                (rst),
    .clk                (clk),
//--------------------------------in port ---------------------------------------
    .uart_rx            (uart_rx),
//--------------------------------out port --------------------------------------
    .uart_rxdata        (uart_rxdata)
    );




endmodule
