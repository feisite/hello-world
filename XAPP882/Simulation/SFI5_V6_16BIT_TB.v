`timescale 1ns / 1ps

module SFI5_V6_16BIT_TB;

//*************************Parameter Declarations******************************

	parameter	REFCLK_PERIOD		= 6.4;	//156.25 MHz
	
//************************** Register Declarations ****************************        

	reg		refclk_n_r;
	reg		usrclk2;
	reg		gsr_r;
	reg		gts_r;
	reg		reset_i;
	reg		txenpmaphasealign_in;
	reg		txpmasetphase_in;
	reg		rxpmasetphase0_in;
	reg		rxpmasetphase1_in;
	reg 		reset_00;
	reg		reset_01;
	reg		reset_02;
	reg		insert_frame_error;
	reg		clear_frame_errors;
	reg		insert_data_error;
	reg		clear_mismatches;
	reg	[2:0]	loopback;
//********************************Wire Declarations**********************************

	wire		refclk_p_r;
	wire		resetdone0_out;
	wire		resetdone1_out;
	wire	[15:0]	data_pat0;
	wire	[15:0]	data_pat0_d1;
	wire	[15:0]	data_pat0_d2;
	wire	[15:0]	data_pat0_d3;
	wire	[15:0]	data_pat1;
	wire	[15:0]	LOOPBACK_P;
	wire	[15:0]	LOOPBACK_N;
	wire		DSCLOOPBACK_P;
	wire		DSCLOOPBACK_N;
	
// ------------------------- MGT Serial Connections ------------------------

	
//---------- Generate Reference Clock input to GTX  ----------------
    
    initial begin
        refclk_n_r = 1'b1;
    end

    always  
        #(REFCLK_PERIOD/2) refclk_n_r = !refclk_n_r;

    assign refclk_p_r = !refclk_n_r;


//--------------------------------- Resets ---------------------------------
    
    initial
    begin
        reset_i = 1'b1;
        reset_00 = 1'b1; 
        reset_01 = 1'b1;
        reset_02 = 1'b1;
        insert_frame_error = 1'b0;
        clear_frame_errors = 1'b0;
        insert_data_error = 1'b0;
        clear_mismatches = 1'b0;
        loopback = 3'b000;
        #100 reset_i = 1'b0;
        #7 reset_00 = 1'b0;
        #7 reset_01 = 1'b0;
        #7 reset_02 = 1'b0;
//        #55000 loopback = 3'b001;
//        #70000 clear_frame_errors = 1'b1;
//        #7 clear_frame_errors = 1'b0; 
//        #7 insert_frame_error = 1'b1;
//        #7 insert_frame_error = 1'b0;
//        #435 insert_frame_error = 1'b1;
//        #20 insert_frame_error = 1'b0;
//        #435 insert_frame_error = 1'b1;
//        #20 insert_frame_error = 1'b0;
//        #3000 clear_frame_errors = 1'b1;
//        #7 clear_frame_errors = 1'b0;
//        #1000 insert_data_error = 1'b1; 
//        #7 insert_data_error = 1'b0;
//        #435 clear_mismatches = 1'b1;
//        #7 clear_mismatches = 1'b0;
    end

sfi5_if_v6_16bit sfi5_if_v6_16bit_0(
	//SFI-5 Transmit Signals
	.TXDATA_P(LOOPBACK_P),
	.TXDATA_N(LOOPBACK_N),
	.TXDSC_P(DSCLOOPBACK_P),
	.TXDSC_N(DSCLOOPBACK_N),
	.TXREFCK({refclk_n_r,refclk_p_r}),
	.TXREFCK_2({refclk_n_r,refclk_p_r}),
	.TXDCK(),
	
	//SFI-5 Receive Signals
	.RXDATA_P(LOOPBACK_P),
	.RXDATA_N(LOOPBACK_N),
	.RXDSC_P(DSCLOOPBACK_P),
	.RXDSC_N(DSCLOOPBACK_N),
	.RXS(),
	
	//Global Signals
	.i_RST(reset_i),
	.o_RESETDONE(),
	.o_GTXPLL_LOCK(),
	
	//System-side Transmit Data/Clock Signals
	.iv_TXDATA00_IN(data_pat1),
	.iv_TXDATA01_IN(data_pat0_d1),
	.iv_TXDATA02_IN(data_pat0),
	.iv_TXDATA03_IN(data_pat1),
	.iv_TXDATA04_IN(data_pat0),
	.iv_TXDATA05_IN(data_pat1),
	.iv_TXDATA06_IN(data_pat0_d3),
	.iv_TXDATA07_IN(data_pat0),
	.iv_TXDATA08_IN(data_pat0),
	.iv_TXDATA09_IN(data_pat1),
	.iv_TXDATA10_IN(data_pat0_d1),
	.iv_TXDATA11_IN(data_pat0_d2),
	.iv_TXDATA12_IN(data_pat0),
	.iv_TXDATA13_IN(data_pat1),
	.iv_TXDATA14_IN(data_pat0),
	.iv_TXDATA15_IN(data_pat0_d3),
	.o_TXUSRCLK2(),
	
	//System-side Receive Data/Clock Signals
	.ov_RXDATA00_OUT(),
	.ov_RXDATA01_OUT(),
	.ov_RXDATA02_OUT(),
	.ov_RXDATA03_OUT(),
	.ov_RXDATA04_OUT(),
	.ov_RXDATA05_OUT(),
	.ov_RXDATA06_OUT(),
	.ov_RXDATA07_OUT(),
	.ov_RXDATA08_OUT(),
	.ov_RXDATA09_OUT(),
	.ov_RXDATA10_OUT(),
	.ov_RXDATA11_OUT(),
	.ov_RXDATA12_OUT(),
	.ov_RXDATA13_OUT(),
	.ov_RXDATA14_OUT(),
	.ov_RXDATA15_OUT(),
	.o_RXRECCLK(),
	.o_RXUSRCLK2(),
	
	//System-side Transmit Diagnostics
	.o_TX_INIT_DONE(),
	.i_INSERT_FRAME_ERROR(insert_frame_error),
	.i_INSERT_DATA_ERROR(insert_data_error),
	.i_LOOPBACK(loopback),
	
	//System-side Receive Diagnostics
	.o_RXOOA(),
	.o_RXOOA_HISTORY(),
	.o_RXLOF(),
	.o_RXLOF_HISTORY(),
	.i_CLEAR_FRAME_ERRORS(clear_frame_errors),
	.i_CLEAR_MISMATCHES(clear_mismatches),
	.ov_FRAME_ERRORS(),
	.ov_FRAMES_RECEIVED(),
	.ov_DATA_MISMATCHES_CH00(),
	.ov_DATA_MISMATCHES_CH01(),
	.ov_DATA_MISMATCHES_CH02(),
	.ov_DATA_MISMATCHES_CH03(),
	.ov_DATA_MISMATCHES_CH04(),
	.ov_DATA_MISMATCHES_CH05(),
	.ov_DATA_MISMATCHES_CH06(),
	.ov_DATA_MISMATCHES_CH07(),
	.ov_DATA_MISMATCHES_CH08(),
	.ov_DATA_MISMATCHES_CH09(),
	.ov_DATA_MISMATCHES_CH10(),
	.ov_DATA_MISMATCHES_CH11(),
	.ov_DATA_MISMATCHES_CH12(),
	.ov_DATA_MISMATCHES_CH13(),
	.ov_DATA_MISMATCHES_CH14(),
	.ov_DATA_MISMATCHES_CH15(),
	.ov_RXFRAME_SHIFT(),
	.ov_RXDATA_SHIFT_CH00(),
	.ov_RXDATA_SHIFT_CH01(),
	.ov_RXDATA_SHIFT_CH02(),
	.ov_RXDATA_SHIFT_CH03(),
	.ov_RXDATA_SHIFT_CH04(),
	.ov_RXDATA_SHIFT_CH05(),
	.ov_RXDATA_SHIFT_CH06(),
	.ov_RXDATA_SHIFT_CH07(),
	.ov_RXDATA_SHIFT_CH08(),
	.ov_RXDATA_SHIFT_CH09(),
	.ov_RXDATA_SHIFT_CH10(),
	.ov_RXDATA_SHIFT_CH11(),
	.ov_RXDATA_SHIFT_CH12(),
	.ov_RXDATA_SHIFT_CH13(),
	.ov_RXDATA_SHIFT_CH14(),
	.ov_RXDATA_SHIFT_CH15(),
	.o_RX_INIT_DONE(),
	.o_RX_BUFFER_UNDERFLOW(),
	.o_RX_BUFFER_OVERFLOW(),
	
	//Optional Settings
	.i_TXINHIBIT(1'b0),
	.i_TX_PREEMPHASIS(4'b0000),
	.i_TX_POSTEMPHASIS(5'b00000),
	.i_TX_DIFF_CTRL(4'b0000),
	.i_RX_EQUALIZATION_MIX(3'b000),
	.i_FRAMES2LOCK(7'd2),
	.i_FRAMES2UNLOCK(7'd2),
	.iv_MISMATCHES_2_UNLOCK(7'd0)
);

simple_pattern0 simple_pattern0_0
(
	.i_CLK(refclk_p_r),
	.i_RST(reset_i),
	.o_DATA(data_pat0)
);

simple_pattern0 simple_pattern0_1
(
	.i_CLK(refclk_p_r),
	.i_RST(reset_00),
	.o_DATA(data_pat0_d1)
);

simple_pattern0 simple_pattern0_2
(
	.i_CLK(refclk_p_r),
	.i_RST(reset_01),
	.o_DATA(data_pat0_d2)
);

simple_pattern0 simple_pattern0_3
(
	.i_CLK(refclk_p_r),
	.i_RST(reset_02),
	.o_DATA(data_pat0_d3)
);

simple_pattern1 simple_pattern1_0
(
	.i_CLK(refclk_p_r),
	.i_RST(reset_i),
	.o_DATA(data_pat1)
);

endmodule





