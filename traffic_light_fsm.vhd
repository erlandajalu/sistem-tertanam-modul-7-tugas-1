library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light_fsm is
    Port (
        clk  : in  STD_LOGIC;
        rst  : in  STD_LOGIC;
        tick : in  STD_LOGIC;
        sw   : in  STD_LOGIC_VECTOR(3 downto 0);  -- Switch SW3..SW0 (0..15 -> 5..20s)
        led  : out STD_LOGIC_VECTOR(5 downto 0)   -- led(2..0): NS, led(5..3): EW
    );
end traffic_light_fsm;

architecture Behavioral of traffic_light_fsm is

    -- Definisi 6 State (Termasuk 2 Fase All-Red Jeda Keselamatan)
    type state_type is (NS_HIJAU, NS_KUNING, ALL_RED_1, EW_HIJAU, EW_KUNING, ALL_RED_2);
    signal current_state, next_state : state_type := NS_HIJAU;

    -- Signal Timer (Maksimal 20 detik)
    signal timer : integer range 0 to 20 := 5;
    
    -- Sinyal durasi hijau dinamis (5 + nilai integer SW)
    signal green_duration : integer range 5 to 20 := 5;

begin

    -- Hitung durasi hijau berbasis switch (5 + SW)
    green_duration <= 5 + to_integer(unsigned(sw));

    ------------------------------------------------------------------
    -- PROCESS 1 (SINKRON / SEQUENTIAL)
    -- Memperbarui state dan menurunkan timer setiap tick='1'
    ------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_state <= NS_HIJAU;
                timer         <= green_duration;
            else
                -- Deteksi Transisi State
                if current_state /= next_state then
                    current_state <= next_state;
                    
                    -- Load timer sesuai state baru
                    case next_state is
                        when NS_HIJAU   => timer <= green_duration; -- 5 - 20 detik
                        when NS_KUNING  => timer <= 3;               -- 3 detik
                        when ALL_RED_1  => timer <= 1;               -- 1 detik (All-Red 1)
                        when EW_HIJAU   => timer <= green_duration; -- 5 - 20 detik
                        when EW_KUNING  => timer <= 3;               -- 3 detik
                        when ALL_RED_2  => timer <= 1;               -- 1 detik (All-Red 2)
                    end case;
                    
                -- Kurangi timer saat pulsa tick='1'
                elsif tick = '1' then
                    if timer > 0 then
                        timer <= timer - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- PROCESS 2 (KOMBINASIONAL)
    -- Menentukan transisi next_state saat timer = 0
    ------------------------------------------------------------------
    process(current_state, timer)
    begin
        next_state <= current_state;

        case current_state is
            when NS_HIJAU =>
                if timer = 0 then
                    next_state <= NS_KUNING;
                end if;

            when NS_KUNING =>
                if timer = 0 then
                    next_state <= ALL_RED_1;
                end if;

            when ALL_RED_1 =>
                if timer = 0 then
                    next_state <= EW_HIJAU;
                end if;

            when EW_HIJAU =>
                if timer = 0 then
                    next_state <= EW_KUNING;
                end if;

            when EW_KUNING =>
                if timer = 0 then
                    next_state <= ALL_RED_2;
                end if;

            when ALL_RED_2 =>
                if timer = 0 then
                    next_state <= NS_HIJAU;
                end if;
        end case;
    end process;

    ------------------------------------------------------------------
    -- LOGIKA DEKODE OUTPUT LED
    ------------------------------------------------------------------
    process(current_state)
    begin
        case current_state is
            when NS_HIJAU =>
                led <= "100001"; -- EW: Merah ("100"), NS: Hijau ("001")
            when NS_KUNING =>
                led <= "100010"; -- EW: Merah ("100"), NS: Kuning ("010")
            when ALL_RED_1 =>
                led <= "100100"; -- Kedua arah MERAH ("100100")
            when EW_HIJAU =>
                led <= "001100"; -- EW: Hijau ("001"), NS: Merah ("100")
            when EW_KUNING =>
                led <= "010100"; -- EW: Kuning ("010"), NS: Merah ("100")
            when ALL_RED_2 =>
                led <= "100100"; -- Kedua arah MERAH ("100100")
        end case;
    end process;

end Behavioral;