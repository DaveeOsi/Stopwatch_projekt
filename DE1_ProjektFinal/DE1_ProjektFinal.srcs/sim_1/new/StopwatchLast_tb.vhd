library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_stopwatch_logic is
end entity tb_stopwatch_logic;

architecture test of tb_stopwatch_logic is
    
    signal s_clk      : std_logic := '0';
    signal s_rst      : std_logic := '0';
    signal s_en_100hz : std_logic := '0';
    signal s_btn_start: std_logic := '0';
    signal s_btn_lap  : std_logic := '0';
    signal s_btn_stop : std_logic := '0';
    signal s_btn_view : std_logic := '0';
    signal s_data     : std_logic_vector(15 downto 0);
    signal s_lap_num  : std_logic_vector(3 downto 0);

    
    constant C_CLK_PERIOD : time := 10 ns;

begin

    
    uut: entity work.stopwatch_logic
        port map (
            clk        => s_clk,
            rst        => s_rst,
            en_100hz   => s_en_100hz,
            btn_start  => s_btn_start,
            btn_lap    => s_btn_lap,
            btn_stop   => s_btn_stop,
            btn_view   => s_btn_view,
            data_o     => s_data,
            lap_num_o  => s_lap_num
        );

    
    p_clk_gen : process
    begin
        while now < 2 ms loop 
            s_clk <= '0'; wait for C_CLK_PERIOD / 2;
            s_clk <= '1'; wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

   
    p_en_gen : process
    begin
        while now < 2 ms loop
            s_en_100hz <= '1'; wait for C_CLK_PERIOD;
            s_en_100hz <= '0'; wait for C_CLK_PERIOD * 5; 
        end loop;
        wait;
    end process;

  
    p_stimulus : process
    begin
        -- 1. Reset systému
        s_rst <= '1';
        wait for 50 ns;
        s_rst <= '0';
        wait for 50 ns;

        -- 2. START stopek
        s_btn_start <= '1'; wait for 20 ns; s_btn_start <= '0';
        wait for 500 ns; 

        -- 3. Uložení 1. KOLA (LAP)
        s_btn_lap <= '1'; wait for 10 ns; s_btn_lap <= '0';
        wait for 400 ns;

        -- 4. Uložení 2. KOLA
        s_btn_lap <= '1'; wait for 10 ns; s_btn_lap <= '0';
        wait for 300 ns;

        -- 5. Uložení 3. KOLA
        s_btn_lap <= '1'; wait for 10 ns; s_btn_lap <= '0';
        wait for 200 ns;

        -- 6. STOP
        s_btn_stop <= '1'; wait for 10 ns; s_btn_stop <= '0';
        wait for 100 ns;

        -- 7. PROHLÍŽENÍ HISTORIE (VIEW) 
        s_btn_view <= '1'; wait for 10 ns; s_btn_view <= '0'; 
        wait for 100 ns;
        s_btn_view <= '1'; wait for 10 ns; s_btn_view <= '0'; 
        wait for 100 ns;
        s_btn_view <= '1'; wait for 10 ns; s_btn_view <= '0'; 
        wait for 100 ns;
        s_btn_view <= '1'; wait for 10 ns; s_btn_view <= '0'; 
        wait for 100 ns;

        -- 8. RESET 
        s_rst <= '1'; wait for 50 ns; s_rst <= '0';
        wait for 100 ns;

        -- 9. Zkusíme znovu VIEW 
        s_btn_view <= '1'; wait for 20 ns; s_btn_view <= '0';
        wait for 100 ns;

        report "Simulace uspesne ukoncena!";
        wait;
    end process;

end architecture test;