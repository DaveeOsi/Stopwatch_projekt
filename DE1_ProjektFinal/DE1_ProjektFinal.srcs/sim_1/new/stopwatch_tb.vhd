library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch_tb is
-- Testbench nemá žádné porty
end entity stopwatch_tb;

architecture test of stopwatch_tb is
    -- Signály pro propojení s testovaným modulem
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal en_100hz   : std_logic := '0';
    signal btn_start  : std_logic := '0';
    signal btn_lap    : std_logic := '0';
    signal btn_stop   : std_logic := '0';
    signal btn_view   : std_logic := '0';
    signal data_o     : std_logic_vector(15 downto 0);

    -- Definice periody hodin 
    constant clk_period : time := 10 ns;

begin
    -- Instance tvé logiky stopek 
    uut: entity work.stopwatch_logic
        port map (
            clk        => clk,
            rst        => rst,
            en_100hz   => en_100hz,
            btn_start  => btn_start,
            btn_lap    => btn_lap,
            btn_stop   => btn_stop,
            btn_view   => btn_view,
            data_o     => data_o
        );

    -- Generátor hodin
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Hlavní testovací scénář
    stim_proc: process
    begin
        -- 1. Reset systému
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;

        -- 2. START stopek
        btn_start <= '1';
        wait for clk_period;
        btn_start <= '0';
        wait for 100 ns;

        -- 3. Simulace několika tiků (setiny sekundy)
        for i in 1 to 20 loop
            en_100hz <= '1';
            wait for clk_period;
            en_100hz <= '0';
            wait for clk_period * 10;
        end loop;

        -- 4. ZMĚŘENÍ KOLA (LAP) - uloží čas a vynuluje čítač
        btn_lap <= '1';
        wait for clk_period;
        btn_lap <= '0';
        wait for 200 ns;

        -- 5. ZASTAVENÍ (STOP)
        btn_stop <= '1';
        wait for clk_period;
        btn_stop <= '0';
        wait for 200 ns;

        -- 6. KONTROLA HISTORIE (VIEW) - zobrazení uloženého kola
        btn_view <= '1';
        wait for clk_period;
        btn_view <= '0';

        wait for 1 us;
       
        report "Simulace stopwatch_tb uspesne dokoncena";
        wait;
    end process;

end architecture test;