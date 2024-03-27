library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dsp_unit_8 is
    generic (WIDTH1: natural := 12;
             WIDTH2: natural := 12);
    port (clk: in std_logic;
          rst: in std_logic;
          u1_i: in std_logic_vector(WIDTH1 - 1 downto 0);
          u2_i: in std_logic_vector(WIDTH2 - 1 downto 0);
          res_o: out std_logic_vector(WIDTH1 + WIDTH2 - 1 downto 0));
end dsp_unit_8;

architecture Behavioral of dsp_unit_8 is
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";
    
    signal u1_reg: std_logic_vector(WIDTH1 - 1 downto 0);
    signal u2_reg: std_logic_vector(WIDTH2 - 1 downto 0);
begin
    process(clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                u1_reg <= (others => '0');
                u2_reg <= (others => '0');
            else
                u1_reg <= u1_i;
                u2_reg <= u2_i;
            end if;
        end if;
    end process;
    
    res_o <= std_logic_vector(signed(u1_reg) * signed(u2_reg));
end Behavioral;
