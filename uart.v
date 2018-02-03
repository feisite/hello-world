`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/02/01 21:31:03
// Design Name: 
// Module Name: uart
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


module uart #(
    parameter               BD_RATE = 9600,                 //BD RATE
    parameter               RX_CLK  = 50_000_000            //50MHz
)
(
//--------------------------------rst clk ---------------------------------------
    input   wire            rst,
    input   wire            clk,
//--------------------------------in port ---------------------------------------
    input   wire            uart_rx,
//--------------------------------out port --------------------------------------
    output  reg     [7:0]   uart_rxdata
    );

//---------------------------------define ----------------------------------------
localparam      sampling_cnt = RX_CLK / BD_RATE,
                sampling_num = sampling_cnt / 2;

reg             uart_rx_1d,uart_rx_2d,uart_rx_3d;
wire            uart_rx_falling;
reg             rx_en;
reg     [15:0]  rx_1cycle_cnt;
reg     [3:0]   rx_11_cycle;

//---------------------------------process ---------------------------------------
//rx low start
always @(posedge clk)
    if(rst) begin
        uart_rx_1d <= 1'b0;
        uart_rx_2d <= 1'b0;
        uart_rx_3d <= 1'b0;
    end
    else begin
        uart_rx_1d <= uart_rx;
        uart_rx_2d <= uart_rx_1d;
        uart_rx_3d <= uart_rx_2d;
    end

assign uart_rx_falling = uart_rx_3d & uart_rx_2d & ~uart_rx_1d & ~uart_rx;

//
always @(posedge clk)
    if(rst)
        rx_en <= 1'b0;
    else if(rx_11_cycle == 4'd10)
        rx_en <= 1'b0;
    else if(uart_rx_falling)
        rx_en <= 1'b1;
    else
        rx_en <= rx_en;

//
always @(posedge clk)
    if(rst | ~rx_en) begin
        rx_1cycle_cnt <= 16'd0;
        rx_11_cycle   <= 4'd0;
    end
    else if(rx_1cycle_cnt == sampling_cnt - 1) begin
        rx_1cycle_cnt <= 16'd0;
        rx_11_cycle   <= rx_11_cycle + 1;
    end
    else if(rx_en) begin
        rx_1cycle_cnt <= rx_1cycle_cnt + 1;
        rx_11_cycle   <= rx_11_cycle;
    end
    else begin
        rx_1cycle_cnt <= rx_1cycle_cnt;
        rx_11_cycle   <= rx_11_cycle;
    end

//rx_data
always @(posedge clk)
    if(rst)
        uart_rxdata <= 8'b0;
    else if(rx_1cycle_cnt == sampling_num)
        case(rx_11_cycle)
            4'd1:
                uart_rxdata[0] <= uart_rx;
            4'd2:
                uart_rxdata[1] <= uart_rx;
            4'd3:
                uart_rxdata[2] <= uart_rx;
            4'd4:
                uart_rxdata[3] <= uart_rx;
            4'd5:
                uart_rxdata[4] <= uart_rx;
            4'd6:
                uart_rxdata[5] <= uart_rx;
            4'd7:
                uart_rxdata[6] <= uart_rx;
            4'd8:
                uart_rxdata[7] <= uart_rx;
            4'd9:
                uart_rxdata <= uart_rxdata;
            4'd10:
                uart_rxdata <= uart_rxdata;
            default:
                uart_rxdata <= uart_rxdata;
        endcase

endmodule
