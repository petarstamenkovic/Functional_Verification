----------------------------------------------------------------------------------
-- Company: Katedra za elektroniku, DEET, FTN, UNS
-- Engineer: Dejan Pejic
-- 
-- Create Date: 06/20/2023 04:11:20 PM
-- Design Name: Processing unit
-- Module Name: processing_unit - Behavioral
-- Project Name: hough_core
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

entity processing_unit is
    generic (THETA_WIDTH: natural := 8;
             XY_WIDTH: natural := 10;
             TRIG_WIDTH: natural := 10;
             RHO_WIDTH: natural := 12;
             ADDR_WIDTH: natural := 16;
             DATA_WIDTH: natural := 8;
             ACC_SIZE: natural := 65536;
			 SIZE_WIDTH: natural := 16);
    port (clk: in std_logic;
          rst: in std_logic;
          x_i: in std_logic_vector(XY_WIDTH - 1 downto 0);
          y_i: in std_logic_vector(XY_WIDTH - 1 downto 0);
          sin_i: in std_logic_vector(TRIG_WIDTH - 1 downto 0);
          cos_i: in std_logic_vector(TRIG_WIDTH - 1 downto 0);
          t3_i: in std_logic_vector(THETA_WIDTH - 1 downto 0);
          t4_i: in std_logic_vector(THETA_WIDTH - 1 downto 0);
          rho_i: in std_logic_vector(XY_WIDTH - 1 downto 0);
          acc_rdata_i: in std_logic_vector(DATA_WIDTH - 1 downto 0);
          acc_wdata_o: out std_logic_vector(DATA_WIDTH - 1 downto 0);
          acc_raddr_o: out std_logic_vector(SIZE_WIDTH - 1 downto 0);
          acc_waddr_o: out std_logic_vector(SIZE_WIDTH - 1 downto 0));
end processing_unit;

architecture Behavioral of processing_unit is
    component dsp_unit_1 is
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12);
        port (clk: in std_logic;
              rst: in std_logic;
              u1_i: in std_logic_vector (WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector (WIDTH2 - 1 downto 0);
              res_o: out std_logic_vector (WIDTH1 - 1 downto 0));
    end component;
        
    component dsp_unit_3 is
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12;
                 PLUS_MINUS: string := "plus");
        port (u1_i: in std_logic_vector (WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector (WIDTH2 - 1 downto 0);
              res_o: out std_logic_vector (WIDTH1 - 1 downto 0));
    end component;
    
    component dsp_unit_5 is
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12;
                 WIDTH3: natural := 12;
                 HOUGH_ADDR: string := "hough");
        port (clk: in std_logic;
              rst: in std_logic;
              u1_i: in std_logic_vector (WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector (WIDTH2 - 1 downto 0);
              u3_i: in std_logic_vector (WIDTH3 - 1 downto 0);
              res_o: out std_logic_vector (WIDTH1 + WIDTH2 - 1 downto 0));
    end component;
    
    component dsp_unit_7 is
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12;
                 WIDTH3: natural := 12;
                 HOUGH_ADDR: string := "hough");
        port (clk: in std_logic;
              rst: in std_logic;
              u1_i: in std_logic_vector (WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector (WIDTH2 - 1 downto 0);
              u3_i: in std_logic_vector (WIDTH3 - 1 downto 0);
              res_o: out std_logic_vector (WIDTH1 + WIDTH2 - 1 downto 0));
    end component;
    
    component dsp_unit_8 is
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12);
        port (clk: in std_logic;
              rst: in std_logic;
              u1_i: in std_logic_vector (WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector (WIDTH2 - 1 downto 0);
              res_o: out std_logic_vector (WIDTH1 + WIDTH2 - 1 downto 0));
    end component;
    
    signal acc_addr0_reg, acc_addr0_next: std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal acc_addr1_reg, acc_addr1_next: std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal acc_addr2_reg, acc_addr2_next: std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal acc_data0_reg, acc_data0_next: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal acc_data1_reg, acc_data1_next: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal theta_offset_s: std_logic_vector(THETA_WIDTH - 1 downto 0) := std_logic_vector(to_unsigned(90, THETA_WIDTH));
    signal data_max: std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '1');
    signal one_s: std_logic_vector(1 downto 0) := "01";
    signal zero_s: std_logic_vector(RHO_WIDTH - 1 downto 0) := (others => '0');
    signal mux_sel_s: std_logic;
    signal theta_mux_out_s: std_logic_vector(THETA_WIDTH - 1 downto 0);
    signal rho_mux_out_s: std_logic_vector(RHO_WIDTH - 1 downto 0);
    signal rho_s: std_logic_vector(RHO_WIDTH - 1 downto 0);
    signal rho_red_s: std_logic_vector(RHO_WIDTH - 1 downto 0);
    signal dsp_theta_s: std_logic_vector(THETA_WIDTH - 1 downto 0);
    signal dsp_inc_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal dsp_mult_s: std_logic_vector(XY_WIDTH + TRIG_WIDTH - 1 downto 0);
    signal dsp_hough_s: std_logic_vector(XY_WIDTH + TRIG_WIDTH - 1 downto 0);
    signal dsp_addr_s: std_logic_vector(THETA_WIDTH + XY_WIDTH - 1 downto 0);
    signal acc_addr_s: std_logic_vector(ADDR_WIDTH - 1 downto 0);
begin
    mult_dsp: dsp_unit_8
    generic map(WIDTH1 => XY_WIDTH,
                WIDTH2 => TRIG_WIDTH)
    port map(clk => clk, 
             rst => rst, 
             u1_i => y_i,
             u2_i => cos_i,
             res_o => dsp_mult_s);

    hough_dsp: dsp_unit_7
    generic map(WIDTH1 => XY_WIDTH,
                WIDTH2 => TRIG_WIDTH,
                WIDTH3 => XY_WIDTH + TRIG_WIDTH,
                HOUGH_ADDR => "hough")
    port map(clk => clk,
             rst => rst,
             u1_i => x_i,
             u2_i => sin_i,
             u3_i => dsp_mult_s,
             res_o => dsp_hough_s);
    
    process(dsp_hough_s) is
    begin
        rho_s <= dsp_hough_s(XY_WIDTH + TRIG_WIDTH - 1 downto XY_WIDTH + TRIG_WIDTH - RHO_WIDTH);
    end process;
    
    red_dsp: dsp_unit_3
    generic map(WIDTH1 => RHO_WIDTH,
                WIDTH2 => RHO_WIDTH,
                PLUS_MINUS => "minus")
    port map(u1_i => zero_s,
             u2_i => rho_s,
             res_o => rho_red_s);
    
    process(rho_s) is
    begin
        mux_sel_s <= rho_s(RHO_WIDTH - 1);
    end process;
    
    theta_shift_dsp: dsp_unit_1
    generic map(WIDTH1 => THETA_WIDTH,
                WIDTH2 => THETA_WIDTH)
    port map(clk => clk,
             rst => rst,
             u1_i => t3_i,
             u2_i => theta_offset_s,
             res_o => dsp_theta_s);
    
    process(mux_sel_s, t4_i, dsp_theta_s) is
    begin
        if (mux_sel_s = '0') then
            theta_mux_out_s <= t4_i;
        else
            theta_mux_out_s <= dsp_theta_s;
        end if;
    end process;
    
    process(mux_sel_s, rho_s, rho_red_s) is
    begin
        if (mux_sel_s = '0') then
            rho_mux_out_s <= rho_s;
        else
            rho_mux_out_s <= rho_red_s;
        end if;
    end process;
    
    addr_dsp: dsp_unit_5
    generic map(WIDTH1 => THETA_WIDTH,
                WIDTH2 => XY_WIDTH,
                WIDTH3 => RHO_WIDTH,
                HOUGH_ADDR => "addr")
    port map(clk => clk,
             rst => rst,
             u1_i => theta_mux_out_s,
             u2_i => rho_i,
             u3_i => rho_mux_out_s,
             res_o => dsp_addr_s);
    
    process(dsp_addr_s) is
    begin
        acc_addr_s <= dsp_addr_s(ADDR_WIDTH - 1 downto 0);
    end process;
    
    process(acc_addr_s) is
    begin
        acc_addr0_next <= acc_addr_s;
        acc_raddr_o <= acc_addr_s;
    end process;
    
    process(acc_addr0_reg) is
    begin
        acc_addr1_next <= acc_addr0_reg;
    end process;
    
    process(acc_addr1_reg) is
    begin
        acc_addr2_next <= acc_addr1_reg;
    end process;
    
    process(clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                acc_addr0_reg <= (others => '0');
                acc_addr1_reg <= (others => '0');
                acc_addr2_reg <= (others => '0');
                acc_data0_reg <= (others => '0');
                acc_data1_reg <= (others => '0');
            else
                acc_addr0_reg <= acc_addr0_next;
                acc_addr1_reg <= acc_addr1_next;
                acc_addr2_reg <= acc_addr2_next;
                acc_data0_reg <= acc_data0_next;
                acc_data1_reg <= acc_data1_next;
            end if;
        end if;
    end process;
    
    process(acc_addr2_reg) is
    begin
        acc_waddr_o <= acc_addr2_reg;
    end process;
    
    process(acc_rdata_i) is
    begin
        acc_data0_next <= acc_rdata_i;
    end process;
    
    value_inc_dsp: dsp_unit_3
    generic map(WIDTH1 => DATA_WIDTH,
                WIDTH2 => 2,
                PLUS_MINUS => "plus")
    port map(u1_i => acc_data0_reg,
             u2_i => one_s,
             res_o => dsp_inc_s);
    
    process(acc_data0_reg, data_max, dsp_inc_s) is
    begin
        if (acc_data0_reg = data_max) then
            acc_data1_next <= acc_data0_reg;
        else
            acc_data1_next  <= dsp_inc_s;
        end if;
    end process;
    
    process(acc_data1_reg) is
    begin
        acc_wdata_o <= acc_data1_reg;
    end process;
end Behavioral;