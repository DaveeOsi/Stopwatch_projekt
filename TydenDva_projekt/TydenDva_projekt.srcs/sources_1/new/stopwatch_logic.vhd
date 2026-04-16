library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch_logic is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic; -- Hlavní reset 
        en_100hz   : in  std_logic; 
        btn_start  : in  std_logic;
        btn_lap    : in  std_logic; -- Změření kola + reset čítače
        btn_stop   : in  std_logic;
        btn_view   : in  std_logic; -- Procházení paměti
        -- Výstupy a měření do (99:99)
        data_o     : out std_logic_vector(15 downto 0)
    );
end entity stopwatch_logic;

architecture behavioral of stopwatch_logic is
    type t_mem is array (0 to 7) of std_logic_vector(15 downto 0);
    signal lap_mem   : t_mem := (others => (others => '0'));
    signal lap_count : unsigned(2 downto 0) := "000"; -- lapování 
    signal view_idx  : unsigned(2 downto 0) := "000"; -- konkrétní kolo
    
    signal running   : std_logic := '0';
    signal mode_view : std_logic := '0'; 
    
    
    signal c0, c1, c2, c3 : unsigned(3 downto 0) := "0000";
begin
    p_stopwatch : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                running <= '0'; mode_view <= '0';
                lap_count <= "000"; view_idx <= "000";
                c0 <= "0000"; c1 <= "0000"; c2 <= "0000"; c3 <= "0000";
                lap_mem <= (others => (others => '0'));
            else
                -- START
                if btn_start = '1' then running <= '1'; mode_view <= '0'; end if;
                -- STOP
                if btn_stop = '1' then running <= '0'; end if;
                -- VIEW (Procházení historie)
                if btn_view = '1' then
                    running <= '0';
                    mode_view <= '1';
                    if lap_count > 0 then
                        if view_idx >= lap_count - 1 then view_idx <= "000";
                        else view_idx <= view_idx + 1; end if;
                    end if;
                end if;

                -- ČÍTÁNÍ ČASU 
                if running = '1' and en_100hz = '1' then
                    if c0 = 9 then
                        c0 <= "0000";
                        if c1 = 9 then
                            c1 <= "0000";
                            if c2 = 9 then
                                c2 <= "0000";
                                if c3 = 9 then c3 <= "0000"; -- do 99.99
                                else c3 <= c3 + 1; end if;
                            else c2 <= c2 + 1; end if;
                        else c1 <= c1 + 1; end if;
                    else c0 <= c0 + 1; end if;
                end if;

                -- LAP (Změření času)
                if btn_lap = '1' and running = '1' then
                    lap_mem(to_integer(lap_count)) <= 
                        std_logic_vector(c3) & std_logic_vector(c2) & 
                        std_logic_vector(c1) & std_logic_vector(c0);
                    lap_count <= lap_count + 1;
                    -- Reset času pro nové kolo 
                    c0 <= "0000"; c1 <= "0000"; c2 <= "0000"; c3 <= "0000";
                end if;
            end if;
        end if;
    end process;

    data_o <= lap_mem(to_integer(view_idx)) when mode_view = '1' else
              std_logic_vector(c3) & std_logic_vector(c2) & 
              std_logic_vector(c1) & std_logic_vector(c0);
end architecture behavioral;