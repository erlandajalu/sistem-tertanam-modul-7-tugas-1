## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset (Tombol Tengah / BTNC)
set_property PACKAGE_PIN U18 [get_ports rst]						
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Switches sw(3 downto 0) untuk Pengaturan Durasi Hijau (5..20 detik)
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]

## LED Utara-Selatan (NS) -> led(2 downto 0)
# NS Hijau
set_property PACKAGE_PIN U16 [get_ports {led[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}] 
# NS Kuning
set_property PACKAGE_PIN E19 [get_ports {led[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}] 
# NS Merah
set_property PACKAGE_PIN U19 [get_ports {led[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}] 

## LED Timur-Barat (EW) -> led(5 downto 3)
# EW Hijau
set_property PACKAGE_PIN V19 [get_ports {led[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}] 
# EW Kuning
set_property PACKAGE_PIN W18 [get_ports {led[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}] 
# EW Merah
set_property PACKAGE_PIN U15 [get_ports {led[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]