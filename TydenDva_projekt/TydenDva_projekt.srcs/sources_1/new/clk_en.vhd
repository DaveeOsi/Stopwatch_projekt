library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_en is
    generic (
        -- G_MAX určuje dělicí poměr.
        -- Pro 100 MHz hodiny a výstup 100 Hz (setiny) je G_MAX = 1 000 000.
        -- Pro 100 MHz hodiny a výstup 400 Hz (displej) je G_MAX = 250 000.
        G_MAX : integer := 1000000
    );
    port (
        clk : in  std_logic; -- Hlavní hodiny 100 MHz
        rst : in  std_logic; -- Synchronní reset
        ce  : out std_logic  -- Výstupní puls (Clock Enable)
    );
end entity clk_en;

architecture behavioral of clk_en is
    -- Vnitřní čítač (počet bitů musí stačit pro G_MAX)
    signal s_cnt : integer range 0 to G_MAX - 1 := 0;
begin

    p_clk_en : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_cnt <= 0;
                ce    <= '0';
            else
                if s_cnt >= G_MAX - 1 then
                    s_cnt <= 0;
                    ce    <= '1'; -- Generování pulsu na jeden takt hodin
                else
                    s_cnt <= s_cnt + 1;
                    ce    <= '0';
                end if;
            end if;
        end if;
    end process p_clk_en;

end architecture behavioral;