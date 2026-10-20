----------------------------------------------------------------------------------
-- Controller Lampu Lalu Lintas dengan Fase All-Red & Durasi Hijau Dinamis (Switch)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light_top is
    Port ( 
        clk      : in  STD_LOGIC;                      -- Clock utama 100 MHz
        btnC     : in  STD_LOGIC;                      -- Tombol Reset (Center Button)
        sw       : in  STD_LOGIC_VECTOR(3 downto 0);   -- Switch input untuk durasi hijau (sw3 downto sw0)
        
        -- Output Lampu format: [Hijau, Kuning, Merah] -> Bit 2: Merah, Bit 1: Kuning, Bit 0: Hijau
        led_A    : out STD_LOGIC_VECTOR(2 downto 0);   -- Indikator Jalur A (LED2, LED1, LED0)
        led_B    : out STD_LOGIC_VECTOR(2 downto 0)    -- Indikator Jalur B (LED5, LED4, LED3)
    );
end traffic_light_top;

architecture Behavioral of traffic_light_top is

    -- Definisi State FSM termasuk All-Red 1 dan All-Red 2 sebagai jeda keselamatan
    type state_type is (A_GREEN, A_YELLOW, ALL_RED_1, B_GREEN, B_YELLOW, ALL_RED_2);
    signal current_state, next_state : state_type;

    -- Pembagi frekuensi dari 100 MHz menjadi 1 Hz (1 detik)
    -- Catatan: Jika ingin simulasi cepat di testbench, ubah CLK_FREQ jadi angka kecil (misal 10)
    constant CLK_FREQ : integer := 100_000_000; 
    signal clk_counter : integer range 0 to CLK_FREQ := 0;
    signal tick_1s     : STD_LOGIC := '0';

    -- Counter detik per state
    signal sec_counter : integer range 0 to 30 := 0;
    
    -- Durasi hijau dinamis: 5 detik + nilai integer dari switch (0 s.d 15) = rentang 5 s.d 20 detik
    signal dynamic_green_time : integer range 5 to 20 := 5;

begin

    -- 1. Pemetaan Switch (sw 3 downto 0) menjadi rentang waktu 5 hingga 20 detik
    dynamic_green_time <= 5 + to_integer(unsigned(sw));

    -- 2. Pembangkit Detik (Clock Divider 1 Hz)
    process(clk, btnC)
    begin
        if btnC = '1' then
            clk_counter <= 0;
            tick_1s <= '0';
        elsif rising_edge(clk) then
            if clk_counter = CLK_FREQ - 1 then
                clk_counter <= 0;
                tick_1s <= '1';
            else
                clk_counter <= clk_counter + 1;
                tick_1s <= '0';
            end if;
        end if;
    end process;

    -- 3. Register State FSM (Sequential)
    process(clk, btnC)
    begin
        if btnC = '1' then
            current_state <= A_GREEN;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- 4. Logika Transisi State & Durasi Waktu
    process(current_state, tick_1s, sec_counter, dynamic_green_time)
    begin
        next_state <= current_state;
        
        case current_state is
            -- Jalur A Hijau (durasi fleksibel sesuai switch: 5 - 20 detik)
            when A_GREEN =>
                if tick_1s = '1' then
                    if sec_counter >= dynamic_green_time - 1 then
                        next_state <= A_YELLOW;
                    end if;
                end if;

            -- Jalur A Kuning (tetap 3 detik: hitungan 0, 1, 2)
            when A_YELLOW =>
                if tick_1s = '1' then
                    if sec_counter >= 2 then
                        next_state <= ALL_RED_1;
                    end if;
                end if;

            -- Fase All-Red 1: Jeda keselamatan 1 detik (kedua arah merah)
            when ALL_RED_1 =>
                if tick_1s = '1' then
                    if sec_counter >= 0 then
                        next_state <= B_GREEN;
                    end if;
                end if;

            -- Jalur B Hijau (durasi fleksibel sesuai switch: 5 - 20 detik)
            when B_GREEN =>
                if tick_1s = '1' then
                    if sec_counter >= dynamic_green_time - 1 then
                        next_state <= B_YELLOW;
                    end if;
                end if;

            -- Jalur B Kuning (tetap 3 detik: hitungan 0, 1, 2)
            when B_YELLOW =>
                if tick_1s = '1' then
                    if sec_counter >= 2 then
                        next_state <= ALL_RED_2;
                    end if;
                end if;

            -- Fase All-Red 2: Jeda keselamatan 1 detik (kedua arah merah)
            when ALL_RED_2 =>
                if tick_1s = '1' then
                    if sec_counter >= 0 then
                        next_state <= A_GREEN;
                    end if;
                end if;
        end case;
    end process;

    -- 5. Counter Detik untuk Penghitung Durasi State
    process(clk, btnC)
    begin
        if btnC = '1' then
            sec_counter <= 0;
        elsif rising_edge(clk) then
            if tick_1s = '1' then
                if current_state /= next_state then
                    sec_counter <= 0;
                else
                    sec_counter <= sec_counter + 1;
                end if;
            end if;
        end if;
    end process;

    -- 6. Logika Kombinasional Output Lampu [Merah, Kuning, Hijau]
    -- Bit 2 = Merah, Bit 1 = Kuning, Bit 0 = Hijau
    process(current_state)
    begin
        case current_state is
            when A_GREEN =>
                led_A <= "001"; -- Jalur A Hijon, Jalur B Merah ("100")
                led_B <= "100";
            when A_YELLOW =>
                led_A <= "010"; -- Jalur A Kuning, Jalur B Merah ("100")
                led_B <= "100";
            when ALL_RED_1 =>
                led_A <= "100"; -- KEDUA ARAH MERAH (All-Red / Jeda Keselamatan)
                led_B <= "100";
            when B_GREEN =>
                led_A <= "100"; -- Jalur A Merah, Jalur B Hijau ("001")
                led_B <= "001";
            when B_YELLOW =>
                led_A <= "100"; -- Jalur A Merah, Jalur B Kuning ("010")
                led_B <= "010";
            when ALL_RED_2 =>
                led_A <= "100"; -- KEDUA ARAH MERAH (All-Red / Jeda Keselamatan)
                led_B <= "100";
        end case;
    end process;

end Behavioral;