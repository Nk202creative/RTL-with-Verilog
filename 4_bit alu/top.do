# automate the modelsim for this file 
# cleane the old library 
#vdel -all

#create new work library
vlib work
vmap work work

# compile the HDl file and test bench 
vlog -sv alu.sv
# compile test bench 
vlog -sv alu_tb.sv

# load the test bench 
vsim -voptargs=+acc work.tb

# set behavior simulation finishes

onfinish stop

#add signla to waveform windows
add wave -radix binary sim:/tb/*
#add wave -radix binary sim:/tb/dut/*

# waveformating 
TreeUpdate [SetDefaultTree]
WaveRestoreZoom {0 ps} {75 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -timelineunits ns

#wave zoom
wave zoom full

# run all the signal 
run -all
