library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dsp_unit_3 is
    generic (WIDTH1: natural := 12;
             WIDTH2: natural := 12;
             PLUS_MINUS: string := "plus");
    port (u1_i: in std_logic_vector(WIDTH1 - 1 downto 0);
          u2_i: in std_logic_vector(WIDTH2 - 1 downto 0);
          res_o: out std_logic_vector(WIDTH1 - 1 downto 0));
end dsp_unit_3;

architecture Behavioral of dsp_unit_3 is
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";
begin
    process(u1_i, u2_i)
    begin
        if (PLUS_MINUS = "plus") then
            res_o <= std_logic_vector(unsigned(u1_i) + unsigned(u2_i));
        else
            res_o <= std_logic_vector(signed(u1_i) - signed(u2_i));
        end if;
    end process;
end Behavioral;
