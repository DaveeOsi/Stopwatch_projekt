library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity driver_7seg_8dig is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        data0_i  : in  std_logic_vector(3 downto 0);
        data1_i  : in  std_logic_vector(3 downto 0);
        data2_i  : in  std_logic_vector(3 downto 0);
        data3_i  : in  std_logic_vector(3 downto 0);
        lap_num_i: in  std_logic_vector(3 downto 0); -- číslo kola
        seg_o    : out std_logic_vector(6 downto 0);
        dig_o    : out std_logic_vector(7 downto 0);
        dp_o     : out std_logic
    );
end entity driver_7seg_8dig;

architecture behavioral of driver_7seg_8dig is
    signal s_cnt : unsigned(2 downto 0) := "000";
    signal s_hex : std_logic_vector(3 downto 0);
    signal s_ce  : std_logic;
begin

    hex2seg : entity work.hex_7seg
        port map (
            hex_i => s_hex,
            seg_o => seg_o
        );

    -- Clock enable pro multiplexing
    process(clk)
        variable v_cnt : integer := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then v_cnt := 0; s_ce <= '0';
            elsif v_cnt >= 250000 then v_cnt := 0; s_ce <= '1';
            else v_cnt := v_cnt + 1; s_ce <= '0';
            end if;
        end if;
    end process;

    -- Čítač 
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then s_cnt <= "000";
            elsif s_ce = '1' then s_cnt <= s_cnt + 1;
            end if;
        end if;
    end process;

    -- číslice
    process(s_cnt, data0_i, data1_i, data2_i, data3_i, lap_num_i)
    begin
        dp_o <= '1'; -- Tečka VYP/ZAP
        case s_cnt is
            -- Pravá strana: ČAS
            when "000" => dig_o <= "11111110"; s_hex <= data0_i;
            when "001" => dig_o <= "11111101"; s_hex <= data1_i;
            when "010" => dig_o <= "11111011"; s_hex <= data2_i; dp_o <= '0'; -- Tečka svítí
            when "011" => dig_o <= "11110111"; s_hex <= data3_i;
            
            -- Levá strana: kola
            when "100" => dig_o <= "11101111"; s_hex <= lap_num_i;
            
            --zhastnute pozice ost. anod
            when others => dig_o <= "11111111"; s_hex <= "0000";
        end case;
    end process;

end architecture behavioral;