library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light_tb is
end traffic_light_tb;

architecture Behavioral of traffic_light_tb is

    -- Sinyal Penghubung ke Unit Utama (UUT)
    signal clk      : STD_LOGIC := '0';
    signal btnC     : STD_LOGIC := '0';
    signal sw       : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal led_A    : STD_LOGIC_VECTOR(2 downto 0);
    signal led_B    : STD_LOGIC_VECTOR(2 downto 0);

    -- Periode Clock untuk Simulasi (misal dipercepat)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instansiasi Unit Under Test (UUT)
    -- Catatan: Untuk simulasi, pastikan konstanta CLK_FREQ di file utama diubah sementara menjadi kecil (misal: 10 atau 100)
    uut: entity work.traffic_light_top
        Port map (
            clk   => clk,
            btnC  => btnC,
            sw    => sw,
            led_A => led_A,
            led_B => led_B
        );

    -- Generator Clock 100 MHz
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus Proses Pengujian
    stim_proc: process
    begin
        -- 1. Inisialisasi & Reset awal
        btnC <= '1';
        sw   <= "0000"; -- Durasi hijau minimum (5 detik)
        wait for 50 ns;
        btnC <= '0';
        
        -- 2. Amati Jalur A Hijau -> Kuning -> All-Red 1 -> Jalur B Hijau
        wait for 15 us; 

        -- 3. Ubah Switch saat berjalan untuk menguji durasi hijau dinamis (misal: sw = "1010" / 10 + 5 = 15 detik)
        sw <= "1010"; 
        wait for 30 us;

        -- 4. Uji Reset kembali
        btnC <= '1';
        wait for 40 ns;
        btnC <= '0';
        
        wait;
    end process;

end Behavioral;