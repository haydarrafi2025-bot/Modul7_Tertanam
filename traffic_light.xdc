## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]
    set_property IOSTANDARD LVCMOS33 [get_ports clk]
    create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Switches (sw[3:0] untuk mengatur durasi hijau 5-20 detik)
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]

## Reset Button (Center Button)
set_property PACKAGE_PIN U18 [get_ports btnC]
    set_property IOSTANDARD LVCMOS33 [get_ports btnC]

## LED Jalur A [Merah, Kuning, Hijau] -> LED0 hingga LED2
set_property PACKAGE_PIN U16 [get_ports {led_A[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {led_A[0]}]
set_property PACKAGE_PIN E19 [get_ports {led_A[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {led_A[1]}]
set_property PACKAGE_PIN U19 [get_ports {led_A[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {led_A[2]}]

## LED Jalur B [Merah, Kuning, Hijau] -> LED3 hingga LED5
set_property PACKAGE_PIN V19 [get_ports {led_B[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {led_B[0]}]
set_property PACKAGE_PIN W18 [get_ports {led_B[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {led_B[1]}]
set_property PACKAGE_PIN U15 [get_ports {led_B[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {led_B[2]}]