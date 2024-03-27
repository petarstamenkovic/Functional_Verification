library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dsp_unit_5 is
    generic (WIDTH1: natural := 12;
             WIDTH2: natural := 12;
             WIDTH3: natural := 12;
             HOUGH_ADDR: string := "hough");
    port (clk: in std_logic;
          rst: in std_logic;
          u1_i: in std_logic_vector(WIDTH1 - 1 downto 0);
          u2_i: in std_logic_vector(WIDTH2 - 1 downto 0);
          u3_i: in std_logic_vector(WIDTH3 - 1 downto 0);
          res_o: out std_logic_vector(WIDTH1 + WIDTH2 - 1 downto 0));
end dsp_unit_5;

architecture Behavioral of dsp_unit_5 is
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";
    
    signal mult_reg, alu_reg: std_logic_vector(WIDTH1 + WIDTH2 - 1 downto 0);
    signal tmp_reg: std_logic_vector(WIDTH3 - 1 downto 0);
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                mult_reg <= (others => '0');
                tmp_reg <= (others => '0');
                alu_reg <= (others => '0');
            else
                if (HOUGH_ADDR = "hough") then
                    tmp_reg <= u3_i;
                    mult_reg <= std_logic_vector(signed(u1_i) * signed(u2_i));
                    alu_reg <= std_logic_vector(signed(mult_reg) - signed(tmp_reg));
                else
                    tmp_reg <= u3_i;
                    mult_reg <= std_logic_vector(unsigned(u1_i) * unsigned(u2_i));
                    alu_reg <= std_logic_vector(unsigned(mult_reg) + unsigned(tmp_reg));
                end if;
            end if;
        end if;
    end process;
    res_o <= alu_reg;
end Behavioral;
