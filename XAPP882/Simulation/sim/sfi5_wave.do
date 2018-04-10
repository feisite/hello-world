onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {SFI-5 Transmit Signals}
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/TXDATA_P
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/TXDATA_N
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/TXDSC_P
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/TXDSC_N
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/TXREFCK
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/TXDCK
add wave -noupdate -divider {SFI-5 Receive Signals}
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/RXDATA_P
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/RXDATA_N
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/RXDSC_P
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/RXDSC_N
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/RXS
add wave -noupdate -divider {Global Signals}
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/i_RST
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_RESETDONE
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_GTXPLL_LOCK
add wave -noupdate -divider {System-side Transmit Data/Clock Signals}
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA00_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA01_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA02_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA03_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA04_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA05_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA06_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA07_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA08_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA09_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA10_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA11_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA12_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA13_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA14_IN
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_TXDATA15_IN
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_TXUSRCLK2
add wave -noupdate -divider {System-side Receive Data/Clock Signals}
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA00_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA01_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA02_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA03_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA04_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA05_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA06_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA07_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA08_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA09_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA10_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA11_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA12_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA13_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA14_OUT
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA15_OUT
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_RXRECCLK
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_RXUSRCLK2
add wave -noupdate -divider {System-side Transmit Diagnostics}
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_TX_INIT_DONE
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/i_INSERT_FRAME_ERROR
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/i_INSERT_DATA_ERROR
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/i_LOOPBACK
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/i_TXINHIBIT
add wave -noupdate -divider {System-side Receive Diagnostics}
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_RXOOA
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_RXLOF
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_RXLOF_HISTORY
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/i_CLEAR_FRAME_ERRORS
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/i_CLEAR_MISMATCHES
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_FRAME_ERRORS
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_FRAMES_RECEIVED
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH00
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH01
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH02
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH03
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH04
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH05
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH06
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH07
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH08
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH09
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH10
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH11
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH12
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH13
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH14
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_DATA_MISMATCHES_CH15
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXFRAME_SHIFT
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH00
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH01
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH02
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH03
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH04
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH05
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH06
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH07
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH08
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH09
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH10
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH11
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH12
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH13
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH14
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/ov_RXDATA_SHIFT_CH15
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_RX_INIT_DONE
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_RX_BUFFER_UNDERFLOW
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/o_RX_BUFFER_OVERFLOW
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/i_FRAMES2LOCK
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/i_FRAMES2UNLOCK
add wave -noupdate -format Literal -radix unsigned /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/iv_MISMATCHES_2_UNLOCK
add wave -noupdate -divider {TX RESET SIGNALS}
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/i_CLK
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/i_RST
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/i_GTXS_READY
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/o_TXENPHASEALIGN
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/o_TXPMASETPHASE
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/o_TXDLYALIGNDISABLE
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/o_TXDLYALIGNRESET
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/o_TX_LOGIC_RST
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/o_GTXS_RST
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/CURRENT_STATE
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/NEXT_STATE
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/tx_sync_ready
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/timeout_counter
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/count
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_tx_0/tx_set_phase_done
add wave -noupdate -divider {RX RESET SIGNALS}
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/i_CLK
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/i_RST
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/i_GTXS_READY
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/o_RX_LOGIC_RST
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/i_RXLOF
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/i_RXOOA
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/o_RESET_GTXS
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/CURRENT_STATE_RX
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/NEXT_STATE_RX
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/timeout_counter
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_reset_rx_0/count
add wave -noupdate -divider {Framer signals}
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/i_CLK
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/i_RST
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/i_FRAMES2LOCK
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/i_FRAMES2UNLOCK
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/i_CLEAR_FRAME_ERRORS
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/iv_DESKEW_CHANNEL
add wave -noupdate -format Literal -radix hexadecimal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/ov_DESKEW_CHANNEL
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/o_RXLOF
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/o_RXLOF_HISTORY
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/ov_FRAME_ERRORS
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/ov_FRAMES_RECEIVED
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/o_FRAME_START
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/ov_RXFRAME_SHIFT
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/CURRENT_STATE
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/NEXT_STATE
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/count_bitslip
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/ud_bitslip
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/count_timer
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/count_frames2lock
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/ud_frames2lock
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/count_frames2unlock
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/ud_frames2unlock
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/count_frames_received
add wave -noupdate -format Logic /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/ud_frames_received
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/shift_value
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/count_value
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/frames2lock
add wave -noupdate -format Literal /SFI5_V6_16BIT_TB/sfi5_if_v6_16bit_0/sfi5_rx_if_v6_16bit_0/sfi5_rx_frame_sync_0/frames2unlock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {157407606 ps} 0}
configure wave -namecolwidth 259
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {224656482 ps}
