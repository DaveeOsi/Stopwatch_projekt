library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port (
        clk      : in  std_logic;
        btnc     : in  std_logic;
        btnl     : in  std_logic;
        btnr     : in  std_logic;
        btnd     : in  std_logic;
        btnu     : in  std_logic;
        seg      : out std_logic_vector(6 downto 0);
        an       : out std_logic_vector(7 downto 0);
        dp       : out std_logic
    );
end entity top_level;

architecture structural of top_level is
    signal sig_rst, sig_ce_100 : std_logic;
    signal s_start, s_lap, s_stop, s_view : std_logic;
    signal sig_data    : std_logic_vector(15 downto 0);
    signal sig_lap_num : std_logic_vector(3 downto 0); -- Lap číslo 
begin
    sig_rst <= btnu;

    deb_start : entity work.debounce port map (clk=>clk, rst=>sig_rst, btn_in=>btnc, btn_press=>s_start);
    deb_lap   : entity work.debounce port map (clk=>clk, rst=>sig_rst, btn_in=>btnl, btn_press=>s_lap);
    deb_stop  : entity work.debounce port map (clk=>clk, rst=>sig_rst, btn_in=>btnr, btn_press=>s_stop);
    deb_view  : entity work.debounce port map (clk=>clk, rst=>sig_rst, btn_in=>btnd, btn_press=>s_view);

    clk_gen : entity work.clk_en generic map (G_MAX => 1000000)
        port map (clk => clk, rst => sig_rst, ce => sig_ce_100);

    logic_inst : entity work.stopwatch_logic
        port map (
            clk => clk, rst => sig_rst, en_100hz => sig_ce_100,
            btn_start => s_start, btn_lap => s_lap, 
            btn_stop => s_stop, btn_view => s_view,
            data_o => sig_data,
            lap_num_o => sig_lap_num 
        );

    disp_inst : entity work.driver_7seg_8dig
        port map (
            clk => clk, rst => sig_rst,
            data0_i => sig_data(3 downto 0),   data1_i => sig_data(7 downto 4),
            data2_i => sig_data(11 downto 8),  data3_i => sig_data(15 downto 12),
            lap_num_i => sig_lap_num, 
            seg_o => seg, dig_o => an,
            dp_o  => dp
        );

end architecture structural;