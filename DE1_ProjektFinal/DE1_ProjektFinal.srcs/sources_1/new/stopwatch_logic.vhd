library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch_logic is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        en_100hz   : in  std_logic;
        btn_start  : in  std_logic;
        btn_lap    : in  std_logic;
        btn_stop   : in  std_logic;
        btn_view   : in  std_logic;
        data_o     : out std_logic_vector(15 downto 0);
        lap_num_o  : out std_logic_vector(3 downto 0)
    );
end entity stopwatch_logic;

architecture behavioral of stopwatch_logic is
    type t_mem is array (0 to 7) of unsigned(15 downto 0);
    signal lap_mem : t_mem := (others => (others => '0'));
   
    signal s_cnt : unsigned(15 downto 0) := (others => '0');
    signal is_running : std_logic := '0';
    signal view_mode  : std_logic := '0';
   
    -- přesny počet uložených kol
    signal write_ptr : unsigned(2 downto 0) := "000";
    -- konkrentí ulož. číslo kola ktery je na displeji
    signal view_ptr  : unsigned(2 downto 0) := "000";
    -- smazana pameť , nebude tam ted zbytečna pameť prazdnych kol
    signal mem_empty : std_logic := '1';

    procedure p_bcd_inc(signal cnt : inout unsigned(15 downto 0)) is
    begin
        if cnt(3 downto 0) = 9 then
            cnt(3 downto 0) <= (others => '0');
            if cnt(7 downto 4) = 9 then
                cnt(7 downto 4) <= (others => '0');
                if cnt(11 downto 8) = 9 then
                    cnt(11 downto 8) <= (others => '0');
                    if cnt(15 downto 12) = 9 then
                        cnt(15 downto 12) <= (others => '0');
                    else cnt(15 downto 12) <= cnt(15 downto 12) + 1; end if;
                else cnt(11 downto 8) <= cnt(11 downto 8) + 1; end if;
            else cnt(7 downto 4) <= cnt(7 downto 4) + 1; end if;
        else cnt(3 downto 0) <= cnt(3 downto 0) + 1; end if;
    end procedure;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_cnt <= (others => '0');
                is_running <= '0';
                write_ptr <= "000";
                view_mode <= '0';
                mem_empty <= '1';
                lap_mem <= (others => (others => '0')); -- Vymazaní kompletní paměti 
            else
                -- START / STOP
                if btn_start = '1' then
                    is_running <= '1';
                    view_mode <= '0'; 
                end if;
               
                if btn_stop = '1' then
                    is_running <= '0';
                end if;
               
                -- průběh stopek 
                if is_running = '1' and en_100hz = '1' then
                    p_bcd_inc(s_cnt);
                end if;
               
                -- LAP (Uložení času) kola
                if btn_lap = '1' then
                    lap_mem(to_integer(write_ptr)) <= s_cnt;
                    s_cnt <= (others => '0');
                    mem_empty <= '0'; -- Už máme aspoň jedno kolo
                    write_ptr <= write_ptr + 1;
                end if;
               
                -- VIEW (zobrazení danych kol)
                if btn_view = '1' then
                    if mem_empty = '0' then -- Pouze historie akt.kol 
                        if view_mode = '0' then
                            view_mode <= '1';
                            view_ptr <= "000"; -- zpatky na začatek 
                        else
                            -- Cyklus paměti 
                            if (view_ptr + 1) = write_ptr then
                                view_ptr <= "000"; 
                            else
                                view_ptr <= view_ptr + 1;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Výstup: Buď čas nebo vybrané kolo z historie
    data_o <= std_logic_vector(s_cnt) when view_mode = '0' else
              std_logic_vector(lap_mem(to_integer(view_ptr)));
             
    -- Výstup čísla kola pro levou stranu displeje
    lap_num_o <= std_logic_vector(resize(write_ptr + 1, 4)) when view_mode = '0' else
                 std_logic_vector(resize(view_ptr + 1, 4));

end architecture behavioral;