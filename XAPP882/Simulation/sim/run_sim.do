vlib work
vmap work work

vlog +acc -work work ../../Design/tx_sync.v;
vlog +acc -work work ../../Design/sfi5_rx_barrel_shifter_16bit.v;
vlog +acc -work work ../../Design/sfi5_rx_frame_sync.v;
vlog +acc -work work ../../Design/sfi5_rx_data_sync.v;
vlog +acc -work work ../../Design/gtx_wrapper_gtx.v;
vlog +acc -work work ../../Design/gtx_wrapper.v;
vlog +acc -work work ../../Design/sfi5_if_v6_16bit.v;
vlog +acc -work work ../../Design/sfi5_reset_tx.v;
vlog +acc -work work ../../Design/sfi5_reset_rx.v;
vlog +acc -work work ../../Design/counter_64.v;
vlog +acc -work work ../../Design/counter_128.v;
vlog +acc -work work ../../Design/counter_32bit.v;
vlog +acc -work work ../../Design/sfi5_rx_if_v6_16bit.v;
vlog +acc -work work ../../Design/sfi5_tx_deskew_channel.v;
vlog +acc -work work ../SFI5_V6_16BIT_TB.v;
vlog +acc -work work ../simple_pattern0.v;
vlog +acc -work work ../simple_pattern1.v;

vlog +acc -work work glbl.v;

##Load Design
vsim -voptargs="+acc" -t 1ps -L unisims_ver -L secureip -L xilinxcorelib_ver work.SFI5_V6_16BIT_TB glbl

##Load signals in wave window
view wave
do sfi5_wave.do

##Run simulation
#restart
#run 15 us

