----------------------------------------------------------------------------------
-- Company: Katedra za elektroniku, DEET, FTN, UNS
-- Engineer: Dejan Pejic
-- 
-- Create Date: 06/23/2023 01:37:55 AM
-- Design Name: 
-- Module Name: hough_core - Behavioral
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

entity hough_core is
    generic (THETA_WIDTH: natural := 8;
             XY_WIDTH: natural := 10;
             TRIG_WIDTH: natural := 16;
             RHO_WIDTH: natural := 12;
             DIMENSIONS_WIDTH: natural := 10;
             TRESHOLD_WIDTH: natural := 8;
             ADDR_WIDTH: natural := 16;
             DATA_WIDTH: natural := 8;
             BUS_DATA_WIDTH: natural := 32;
             ROM_DATA_WIDTH: natural := 32;
             IMG_SIZE: natural := 98304;
             ACC_SIZE: natural := 60000;
             ROM_SIZE: natural := 180;
             ADDR_OFFSET: natural := 2;
			 IMG_SIZE_WIDTH: natural := 17;
			 ACC_SIZE_WIDTH: natural := 16;
			 ROM_SIZE_WIDTH: natural := 8);
    port (clk: in std_logic;
          reset: in std_logic;
          axi_reset: in std_logic;
          start: in std_logic;
          width_i: in std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
          height_i: in std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
          treshold_i: in std_logic_vector(TRESHOLD_WIDTH - 1 downto 0);
          rho_i: in std_logic_vector(XY_WIDTH - 1 downto 0);
          acc0_addr_cont_i: in std_logic_vector(ACC_SIZE_WIDTH + ADDR_OFFSET - 1 downto 0);
          acc0_data_cont_o: out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
          acc0_data_cont_i: in std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
          acc0_we_cont: in std_logic_vector(3 downto 0);
          acc1_addr_cont_i: in std_logic_vector(ACC_SIZE_WIDTH + ADDR_OFFSET - 1 downto 0);
          acc1_data_cont_o: out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
          acc1_data_cont_i: in std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
          acc1_we_cont: in std_logic_vector(3 downto 0);
          img_addr_cont_i: in std_logic_vector(IMG_SIZE_WIDTH + ADDR_OFFSET - 1 downto 0);
          img_data_cont_o: out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
          img_data_cont_i: in std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
          img_we_cont: in std_logic_vector(3 downto 0);
          ready: out std_logic);
end hough_core;

architecture Behavioral of hough_core is
    component hough_structure 
        generic (THETA_WIDTH: natural := 8;
                 XY_WIDTH: natural := 10;
                 TRIG_WIDTH: natural := 16;
                 RHO_WIDTH: natural := 12;
                 DIMENSIONS_WIDTH: natural := 10;
                 TRESHOLD_WIDTH: natural := 8;
                 ADDR_WIDTH: natural := 16;
                 DATA_WIDTH: natural := 8;
                 ROM_DATA_WIDTH: natural := 32;
                 IMG_SIZE: natural := 108000;
                 ACC_SIZE: natural := 65536;
                 ROM_SIZE: natural := 180;
				 IMG_SIZE_WIDTH: natural := 17;
			     ACC_SIZE_WIDTH: natural := 16;
			     ROM_SIZE_WIDTH: natural := 8);
        port (clk: in std_logic;
              rst: in std_logic;
              start: in std_logic;
              width_i: in std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
              height_i: in std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
              treshold_i: in std_logic_vector(TRESHOLD_WIDTH - 1 downto 0);
              rho_i: in std_logic_vector(XY_WIDTH - 1 downto 0);
              img_data_i: in std_logic_vector(DATA_WIDTH - 1 downto 0);
              img_addr_o: out std_logic_vector(IMG_SIZE_WIDTH - 1 downto 0);
              acc0_rdata_i: in std_logic_vector(DATA_WIDTH - 1 downto 0);
              acc0_wdata_o: out std_logic_vector(DATA_WIDTH - 1 downto 0);
              acc0_raddr_o: out std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
              acc0_waddr_o: out std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
              acc1_rdata_i: in std_logic_vector(DATA_WIDTH - 1 downto 0);
              acc1_wdata_o: out std_logic_vector(DATA_WIDTH - 1 downto 0);
              acc1_raddr_o: out std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
              acc1_waddr_o: out std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
              trig0_addr_o: out std_logic_vector(ROM_SIZE_WIDTH - 1 downto 0);
              trig1_addr_o: out std_logic_vector(ROM_SIZE_WIDTH - 1 downto 0);
              trig0_data_i: in std_logic_vector(ROM_DATA_WIDTH - 1 downto 0);
              trig1_data_i: in std_logic_vector(ROM_DATA_WIDTH - 1 downto 0);
              rom_en_o: out std_logic;
              img_en_o: out std_logic;
              acc0_we_o: out std_logic_vector(3 downto 0);
              acc1_we_o: out std_logic_vector(3 downto 0);
              ready: out std_logic);
    end component;
    
    component rom 
        generic (WIDTH: positive := 32;
                 SIZE: positive := 180;
				 SIZE_WIDTH: positive := 8);
        port (clk_a : in std_logic;
              clk_b : in std_logic;
              en_a: in std_logic;
              en_b: in std_logic;
              addr_a : in std_logic_vector(SIZE_WIDTH - 1 downto 0);
              addr_b : in std_logic_vector(SIZE_WIDTH - 1 downto 0);
              data_a_o: out std_logic_vector(WIDTH - 1 downto 0);
              data_b_o: out std_logic_vector(WIDTH - 1 downto 0));
    end component;
    
    component bram 
        generic (WIDTH: positive := 8;
                 SIZE: positive := 108000;
				 SIZE_WIDTH: positive := 17);
        port (clk_a : in std_logic;
              clk_b : in std_logic;
              en_a: in std_logic;
              en_b: in std_logic;
              we_a: in std_logic_vector(3 downto 0);
              we_b: in std_logic_vector(3 downto 0);
              addr_a : in std_logic_vector(SIZE_WIDTH-1 downto 0);
              addr_b : in std_logic_vector(SIZE_WIDTH-1 downto 0);
              data_a_i: in std_logic_vector(WIDTH-1 downto 0);
              data_b_i: in std_logic_vector(WIDTH-1 downto 0);
              data_a_o: out std_logic_vector(WIDTH-1 downto 0);
              data_b_o: out std_logic_vector(WIDTH-1 downto 0));
    end component;
    
    signal acc0_data_cont_i_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal acc0_data_cont_o_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal acc1_data_cont_i_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal acc1_data_cont_o_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal img_data_cont_i_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal img_data_cont_o_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    
    signal acc0_addr_cont_i_s: std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
    signal acc1_addr_cont_i_s: std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
    signal img_addr_cont_i_s: std_logic_vector(IMG_SIZE_WIDTH - 1 downto 0);
    
    signal cont_sel_reg, cont_sel_next: std_logic;
    signal acc0_raddr_s, acc1_raddr_s: std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
    signal acc0_rdata_s, acc1_rdata_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal acc0_waddr_s, acc1_waddr_s: std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
    signal acc0_wdata_s, acc1_wdata_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal acc0_we_s, acc1_we_s: std_logic_vector(3 downto 0);
    signal acc0_addr_mux_s, acc1_addr_mux_s: std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
    signal acc0_data_mux_s, acc1_data_mux_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal acc0_we_mux_s, acc1_we_mux_s: std_logic_vector(3 downto 0);
    signal img_addr_s: std_logic_vector(IMG_SIZE_WIDTH - 1 downto 0);
    signal img_data_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal img_en_s: std_logic;
    signal trig0_addr_s, trig1_addr_s: std_logic_vector(ROM_SIZE_WIDTH - 1 downto 0);
    signal trig0_data_s, trig1_data_s: std_logic_vector(ROM_DATA_WIDTH - 1 downto 0);
    signal rom_en_s: std_logic;
    signal ready_s: std_logic;
    signal one_s: std_logic := '1';
    signal we_zero_s: std_logic_vector(3 downto 0) := "0000";
    signal data_zero_s: std_logic_vector(DATA_WIDTH - 1 downto 0) := "00000000";
    signal zero24_s: std_logic_vector(BUS_DATA_WIDTH - DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal rst: std_logic;
begin
    process(ready_s)
    begin
        ready <= ready_s;
    end process;
        
    process(clk) 
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                cont_sel_reg <= '0';
            else
                cont_sel_reg <= cont_sel_next;
            end if;
        end if;
    end process;
    
    process(start, ready_s, cont_sel_reg)
    begin
        if (start = '1') then
            cont_sel_next <= '1';
        elsif (ready_s = '1') then
            cont_sel_next <= '0';
        else
            cont_sel_next <= cont_sel_reg;
        end if;
    end process;
    
    process(acc0_addr_cont_i)
    begin
        acc0_addr_cont_i_s <= acc0_addr_cont_i(ACC_SIZE_WIDTH + ADDR_OFFSET - 1 downto ADDR_OFFSET);
    end process;
    
    process(acc1_addr_cont_i)
    begin
        acc1_addr_cont_i_s <= acc1_addr_cont_i(ACC_SIZE_WIDTH + ADDR_OFFSET - 1 downto ADDR_OFFSET);
    end process;
    
    process(img_addr_cont_i)
    begin
        img_addr_cont_i_s <= img_addr_cont_i(IMG_SIZE_WIDTH + ADDR_OFFSET - 1 downto ADDR_OFFSET);
    end process;
    
    process(acc0_data_cont_i)
    begin
        acc0_data_cont_i_s <= acc0_data_cont_i(DATA_WIDTH - 1 downto 0);
    end process;
    
    process(acc0_data_cont_o_s)
    begin
        acc0_data_cont_o <= zero24_s & acc0_data_cont_o_s;
    end process;
    
    process(acc1_data_cont_i)
    begin
        acc1_data_cont_i_s <= acc1_data_cont_i(DATA_WIDTH - 1 downto 0);
    end process;
    
    process(acc1_data_cont_o_s)
    begin
        acc1_data_cont_o <= zero24_s & acc1_data_cont_o_s;
    end process;
    
    process(img_data_cont_i)
    begin
        img_data_cont_i_s <= img_data_cont_i(DATA_WIDTH - 1 downto 0);
    end process;
    
    process(img_data_cont_o_s)
    begin
        img_data_cont_o <= zero24_s & img_data_cont_o_s;
    end process;
    
    process(cont_sel_reg, acc0_waddr_s, acc0_wdata_s, acc0_we_s, acc1_waddr_s, acc1_wdata_s, acc1_we_s,
            acc0_addr_cont_i_s, acc0_data_cont_i_s, acc0_we_cont, acc1_addr_cont_i_s, acc1_data_cont_i_s, acc1_we_cont)
    begin
        if (cont_sel_reg = '0') then
            acc0_addr_mux_s <= acc0_addr_cont_i_s;
            acc0_data_mux_s <= acc0_data_cont_i_s;
            acc0_we_mux_s <= acc0_we_cont;
            acc1_addr_mux_s <= acc1_addr_cont_i_s;
            acc1_data_mux_s <= acc1_data_cont_i_s;
            acc1_we_mux_s <= acc1_we_cont;
        else
            acc0_addr_mux_s <= acc0_waddr_s;
            acc0_data_mux_s <= acc0_wdata_s;
            acc0_we_mux_s <= acc0_we_s;
            acc1_addr_mux_s <= acc1_waddr_s;
            acc1_data_mux_s <= acc1_wdata_s;
            acc1_we_mux_s <= acc1_we_s;
        end if;
    end process;
    
    hough_unit: hough_structure
        generic map (THETA_WIDTH => THETA_WIDTH,
                     XY_WIDTH => XY_WIDTH,
                     TRIG_WIDTH => TRIG_WIDTH,
                     RHO_WIDTH => RHO_WIDTH,
                     DIMENSIONS_WIDTH => DIMENSIONS_WIDTH,
                     TRESHOLD_WIDTH => TRESHOLD_WIDTH,
                     ADDR_WIDTH => ADDR_WIDTH,
                     DATA_WIDTH => DATA_WIDTH,
                     ROM_DATA_WIDTH => ROM_DATA_WIDTH,
                     IMG_SIZE => IMG_SIZE,
                     ACC_SIZE => ACC_SIZE,
                     ROM_SIZE => ROM_SIZE,
					 IMG_SIZE_WIDTH => IMG_SIZE_WIDTH,
					 ACC_SIZE_WIDTH => ACC_SIZE_WIDTH,
					 ROM_SIZE_WIDTH => ROM_SIZE_WIDTH)
        port map (clk => clk,
                  rst => rst,
                  start => start,
                  width_i => width_i,
                  height_i => height_i,
                  treshold_i => treshold_i,
                  rho_i => rho_i,
                  img_data_i => img_data_s,
                  img_addr_o => img_addr_s,
                  acc0_rdata_i => acc0_rdata_s,
                  acc0_wdata_o => acc0_wdata_s,
                  acc0_raddr_o => acc0_raddr_s,
                  acc0_waddr_o => acc0_waddr_s,
                  acc1_rdata_i => acc1_rdata_s,
                  acc1_wdata_o => acc1_wdata_s,
                  acc1_raddr_o => acc1_raddr_s,
                  acc1_waddr_o => acc1_waddr_s,
                  trig0_addr_o => trig0_addr_s,
                  trig1_addr_o => trig1_addr_s,
                  trig0_data_i => trig0_data_s,
                  trig1_data_i => trig1_data_s,
                  rom_en_o => rom_en_s,
                  img_en_o => img_en_s,
                  acc0_we_o => acc0_we_s,
                  acc1_we_o => acc1_we_s,
                  ready => ready_s);
    
    trig_rom: rom
        generic map (WIDTH => ROM_DATA_WIDTH,
                     SIZE => ROM_SIZE,
					 SIZE_WIDTH => ROM_SIZE_WIDTH)
        port map (clk_a => clk,
                  clk_b => clk,
                  en_a => rom_en_s,
                  en_b => rom_en_s,
                  addr_a => trig0_addr_s, 
                  addr_b => trig1_addr_s,
                  data_a_o => trig0_data_s,
                  data_b_o => trig1_data_s);
    
    acc0_ram: bram
        generic map (WIDTH => DATA_WIDTH,
                     SIZE => ACC_SIZE,
					 SIZE_WIDTH => ACC_SIZE_WIDTH)
        port map (clk_a => clk,
                  clk_b => clk,
                  en_a => one_s,
                  en_b => one_s,
                  we_a => we_zero_s,
                  we_b => acc0_we_mux_s,
                  addr_a => acc0_raddr_s,
                  addr_b => acc0_addr_mux_s,
                  data_a_i => data_zero_s,
                  data_b_i => acc0_data_mux_s,
                  data_a_o => acc0_rdata_s,
                  data_b_o => acc0_data_cont_o_s);
    
    acc1_ram: bram
        generic map (WIDTH => DATA_WIDTH,
                     SIZE => ACC_SIZE,
					 SIZE_WIDTH => ACC_SIZE_WIDTH)
        port map (clk_a => clk,
                  clk_b => clk,
                  en_a => one_s,
                  en_b => one_s,
                  we_a => we_zero_s,
                  we_b => acc1_we_mux_s,
                  addr_a => acc1_raddr_s,
                  addr_b => acc1_addr_mux_s,
                  data_a_i => data_zero_s,
                  data_b_i => acc1_data_mux_s,
                  data_a_o => acc1_rdata_s,
                  data_b_o => acc1_data_cont_o_s);
    
    img_ram: bram
        generic map (WIDTH => DATA_WIDTH,
                     SIZE => IMG_SIZE,
					 SIZE_WIDTH => IMG_SIZE_WIDTH)
        port map (clk_a => clk,
                  clk_b => clk,
                  en_a => img_en_s,
                  en_b => one_s,
                  we_a => we_zero_s,
                  we_b => img_we_cont,
                  addr_a => img_addr_s,
                  addr_b => img_addr_cont_i_s,
                  data_a_i => data_zero_s,
                  data_b_i => img_data_cont_i_s,
                  data_a_o => img_data_s,
                  data_b_o => img_data_cont_o_s);
    
    process(reset, axi_reset) 
    begin
        rst <= reset or (not axi_reset);
    end process;
end Behavioral;
