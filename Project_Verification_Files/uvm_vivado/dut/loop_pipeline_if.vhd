----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2023 01:10:04 PM
-- Design Name: 
-- Module Name: loop_pipeline_if - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity loop_pipeline_if is
    generic (THETA_WIDTH: natural := 8;
             ROM_SIZE: natural := 180;
			 SIZE_WIDTH : natural := 8);
    port (clk: in std_logic;
          rst: in std_logic;
          theta_i: in std_logic_vector(THETA_WIDTH - 1 downto 0);
          trig0_addr_o: out std_logic_vector(SIZE_WIDTH - 1 downto 0);
          trig1_addr_o: out std_logic_vector(SIZE_WIDTH - 1 downto 0);
          t0_o: out std_logic_vector(THETA_WIDTH - 1 downto 0);
          t3_o: out std_logic_vector(THETA_WIDTH - 1 downto 0);
          t4_o: out std_logic_vector(THETA_WIDTH - 1 downto 0);
          t9_o: out std_logic_vector(THETA_WIDTH - 1 downto 0));
end loop_pipeline_if;

architecture Behavioral of loop_pipeline_if is
    component dsp_unit_2 is
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12);
        port (clk: in std_logic;
              rst: in std_logic;
              u1_i: in std_logic_vector(WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector(WIDTH2 - 1 downto 0);
              res_o: out std_logic_vector(WIDTH1 + WIDTH2 - 1 downto 0));
    end component;
    
    component dsp_unit_3 is
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12;
                 PLUS_MINUS: string := "plus");
        port (u1_i: in std_logic_vector (WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector (WIDTH2 - 1 downto 0);
              res_o: out std_logic_vector (WIDTH1 - 1 downto 0));
    end component;
    
    signal t0_reg, t1_reg, t2_reg, t3_reg, t4_reg, t5_reg, t6_reg, t7_reg, t8_reg, t9_reg: std_logic_vector(THETA_WIDTH - 1 downto 0);
    signal t0_next, t1_next, t2_next, t3_next, t4_next, t5_next, t6_next, t7_next, t8_next, t9_next: std_logic_vector(THETA_WIDTH - 1 downto 0);
    signal dsp_mult_s: std_logic_vector(THETA_WIDTH + 2 - 1 downto 0);
    signal trig0_addr_s: std_logic_vector(SIZE_WIDTH - 1 downto 0);
    signal dsp_inc_s: std_logic_vector(SIZE_WIDTH - 1 downto 0);
    signal one_s: std_logic_vector(1 downto 0) := "01";
    signal two_s: std_logic_vector(1 downto 0) := "10";
begin
    rom_addr_dsp: dsp_unit_2
    generic map(WIDTH1 => THETA_WIDTH,
                WIDTH2 => 2)
    port map(clk => clk,
             rst => rst,
             u1_i => theta_i,
             u2_i => two_s,
             res_o => dsp_mult_s);
    
    process(dsp_mult_s) is
    begin
        trig0_addr_s <= dsp_mult_s(SIZE_WIDTH - 1 downto 0);
    end process;
    
    addres_inc_dsp: dsp_unit_3
    generic map(WIDTH1 => SIZE_WIDTH,
                WIDTH2 => 2,
                PLUS_MINUS => "plus")
    port map(u1_i => trig0_addr_s,
             u2_i => one_s,
             res_o => dsp_inc_s);
    
    trig0_addr_o <= trig0_addr_s;
    trig1_addr_o <= dsp_inc_s;
    
    process(theta_i, t0_reg, t1_reg, t2_reg, t3_reg, t4_reg, t5_reg, t6_reg, t7_reg, t8_reg) is
    begin
        t0_next <= theta_i;
        t1_next <= t0_reg;
        t2_next <= t1_reg;
        t3_next <= t2_reg;
        t4_next <= t3_reg;
        t5_next <= t4_reg;
        t6_next <= t5_reg;
        t7_next <= t6_reg;
        t8_next <= t7_reg;
        t9_next <= t8_reg;
    end process;
    
    process(clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                t0_reg <= (others => '0');
                t1_reg <= (others => '0');
                t2_reg <= (others => '0');
                t3_reg <= (others => '0');
                t4_reg <= (others => '0');
                t5_reg <= (others => '0');
                t6_reg <= (others => '0');
                t7_reg <= (others => '0');
                t8_reg <= (others => '0');
                t9_reg <= (others => '0');
            else
                t0_reg <= t0_next;
                t1_reg <= t1_next;
                t2_reg <= t2_next;
                t3_reg <= t3_next;
                t4_reg <= t4_next;
                t5_reg <= t5_next;
                t6_reg <= t6_next;
                t7_reg <= t7_next;
                t8_reg <= t8_next;
                t9_reg <= t9_next;
            end if;
        end if;
    end process;
    
    t0_o <= t0_reg;
    t3_o <= t3_reg;
    t4_o <= t4_reg;
    t9_o <= t9_reg;
end Behavioral;
