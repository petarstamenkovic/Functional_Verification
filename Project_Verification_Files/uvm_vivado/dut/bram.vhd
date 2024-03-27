library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bram is
    generic (WIDTH: positive := 8;
             SIZE: positive := 108000;
			 SIZE_WIDTH: positive := 17);
    port (clk_a : in std_logic;
          clk_b : in std_logic;
          en_a: in std_logic;
          en_b: in std_logic;
          we_a: in std_logic_vector(3 downto 0);
          we_b: in std_logic_vector(3 downto 0);
          addr_a: in std_logic_vector(SIZE_WIDTH-1 downto 0);
          addr_b: in std_logic_vector(SIZE_WIDTH-1 downto 0);
          data_a_i: in std_logic_vector(WIDTH-1 downto 0);
          data_b_i: in std_logic_vector(WIDTH-1 downto 0);
          data_a_o: out std_logic_vector(WIDTH-1 downto 0);
          data_b_o: out std_logic_vector(WIDTH-1 downto 0));
end bram;

architecture Behavioral of bram is
    type ram_type is array(SIZE-1 downto 0) of std_logic_vector(WIDTH-1 downto 0);
    signal RAM: ram_type;
    
    attribute ram_style: string;
    attribute ram_style of RAM: signal is "block";
begin
    process(clk_a, clk_b)
    begin
        if (rising_edge(clk_a)) then
            if (en_a = '1') then
                data_a_o <= RAM(to_integer(unsigned(addr_a)));
                if (we_a /= "0000") then
                    RAM(to_integer(unsigned(addr_a))) <= data_a_i;
                end if;
            end if;
        end if;
        
        if (rising_edge(clk_b)) then
            if (en_b = '1') then
                data_b_o <= RAM(to_integer(unsigned(addr_b)));
                if (we_b /= "0000") then
                    RAM(to_integer(unsigned(addr_b))) <= data_b_i;
                end if;
            end if;
        end if;
    end process;
end Behavioral;