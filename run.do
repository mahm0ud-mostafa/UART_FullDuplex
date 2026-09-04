transcript on

if {![file exists work]} {
    vlib work
}

file mkdir sim/waves

vlog -sv serializer.sv parity_calc.sv mux.sv main_controller.sv uart_tx.sv
vlog -sv rx_edge_detector.sv rx_deserializer.sv rx_main_controller.sv uart_rx.sv
vlog -sv uart_loopback_tb.sv

vsim -voptargs=+acc -onfinish stop work.uart_grading_tb
add wave -r sim:/uart_grading_tb/*
run -all
wave zoom full
