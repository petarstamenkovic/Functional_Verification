----------------------------------------------------------------------------------
-- Company: Katedra za elektroniku, DEET, FTN, UNS
-- Engineer: Dejan Pejic
-- 
-- Create Date: 06/21/2023 02:45:55 PM
-- Design Name: 
-- Module Name: hough_structure - Behavioral
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

entity hough_structure is
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
          trig1_addr_o: out std_logic_vector(ROM_SIZE_WIDTH- 1 downto 0);
          trig0_data_i: in std_logic_vector(ROM_DATA_WIDTH - 1 downto 0);
          trig1_data_i: in std_logic_vector(ROM_DATA_WIDTH - 1 downto 0);
          rom_en_o: out std_logic;
          img_en_o: out std_logic;
          acc0_we_o: out std_logic_vector(3 downto 0);
          acc1_we_o: out std_logic_vector(3 downto 0);
          ready: out std_logic);
end hough_structure;

architecture Behavioral of hough_structure is
    component processing_unit
        generic (THETA_WIDTH: natural := 8;
                 XY_WIDTH: natural := 10;
                 TRIG_WIDTH: natural := 16;
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
              acc_raddr_o: out std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0);
              acc_waddr_o: out std_logic_vector(ACC_SIZE_WIDTH - 1 downto 0));
    end component;
    
    component loop_pipeline_if
        generic (THETA_WIDTH: natural := 8;
                 ROM_SIZE: natural := 180;
				 SIZE_WIDTH: natural := 8);
        port (clk: in std_logic;
              rst: in std_logic;
              theta_i: in std_logic_vector(THETA_WIDTH - 1 downto 0 );
              trig0_addr_o: out std_logic_vector(ROM_SIZE_WIDTH - 1 downto 0);
              trig1_addr_o: out std_logic_vector(ROM_SIZE_WIDTH - 1 downto 0);
              t0_o: out std_logic_vector(THETA_WIDTH - 1 downto 0);
              t3_o: out std_logic_vector(THETA_WIDTH - 1 downto 0);
              t4_o: out std_logic_vector(THETA_WIDTH - 1 downto 0);
              t9_o: out std_logic_vector(THETA_WIDTH - 1 downto 0));
    end component;
    
    component fsm
        generic (XY_WIDTH: natural := 10;
                 DIMENSIONS_WIDTH: natural := 10;
                 TRESHOLD_WIDTH: natural := 8;
                 THETA_WIDTH: natural := 8;
                 DATA_WIDTH: natural := 8;
                 IMG_SIZE: natural := 108000;
				 SIZE_WIDTH: natural := 17);
        port (clk: in std_logic;
              rst: in std_logic;
              start: in std_logic;
              theta_status_i: in std_logic_vector(THETA_WIDTH - 1 downto 0);
              theta_rom_i: in std_logic_vector(THETA_WIDTH - 1 downto 0);
              width_i: in std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
              height_i: in std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
              treshold_i: in std_logic_vector(TRESHOLD_WIDTH - 1 downto 0);
              img_data_i: in std_logic_vector(DATA_WIDTH - 1 downto 0);
              img_addr_o: out std_logic_vector(IMG_SIZE_WIDTH - 1 downto 0);
              x_o: out std_logic_vector(XY_WIDTH - 1 downto 0);
              y_o: out std_logic_vector(XY_WIDTH - 1 downto 0);
              theta_o: out std_logic_vector(THETA_WIDTH - 1 downto 0);
              rom_en_o: out std_logic;
              img_en_o: out std_logic;
              acc0_we_o: out std_logic_vector(3 downto 0);
              acc1_we_o: out std_logic_vector(3 downto 0);
              ready: out std_logic);
    end component;

    signal x_s, y_s: std_logic_vector(XY_WIDTH - 1 downto 0);
    signal t3_s, t4_s: std_logic_vector(THETA_WIDTH - 1 downto 0);
    signal theta_s, theta_status_s, theta_rom_s: std_logic_vector(THETA_WIDTH - 1 downto 0);
    signal sin0_s, cos0_s: std_logic_vector(TRIG_WIDTH - 1 downto 0);
    signal sin1_s, cos1_s: std_logic_vector(TRIG_WIDTH - 1 downto 0);
begin
    central_unit: fsm
    generic map(XY_WIDTH => XY_WIDTH,
                DIMENSIONS_WIDTH => DIMENSIONS_WIDTH,
                TRESHOLD_WIDTH => TRESHOLD_WIDTH,
                THETA_WIDTH => THETA_WIDTH,
                DATA_WIDTH => DATA_WIDTH,
                IMG_SIZE => IMG_SIZE,
				SIZE_WIDTH => IMG_SIZE_WIDTH)
    port map(clk => clk,
             rst => rst,
             start => start,
             theta_status_i => theta_status_s,
             theta_rom_i => theta_rom_s,
             width_i => width_i,
             height_i => height_i,
             treshold_i => treshold_i,
             img_data_i => img_data_i,
             img_addr_o => img_addr_o,
             x_o => x_s,
             y_o => y_s,
             theta_o => theta_s,
             rom_en_o => rom_en_o,
             img_en_o => img_en_o,
             acc0_we_o => acc0_we_o,
             acc1_we_o => acc1_we_o,
             ready => ready);
             
    theta_if: loop_pipeline_if
    generic map(THETA_WIDTH => THETA_WIDTH,
                ROM_SIZE => ROM_SIZE,
				SIZE_WIDTH => ROM_SIZE_WIDTH)
    port map(clk => clk,
             rst => rst,
             theta_i => theta_s,
             trig0_addr_o => trig0_addr_o,
             trig1_addr_o => trig1_addr_o,
             t0_o => theta_rom_s,
             t3_o => t3_s,
             t4_o => t4_s,
             t9_o => theta_status_s);
    
    pu_0: processing_unit
    generic map(THETA_WIDTH => THETA_WIDTH,
                XY_WIDTH => XY_WIDTH,
                TRIG_WIDTH => TRIG_WIDTH,
                RHO_WIDTH => RHO_WIDTH,
                ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => DATA_WIDTH,
                ACC_SIZE => ACC_SIZE,
				SIZE_WIDTH => ACC_SIZE_WIDTH)
    port map(clk => clk,
             rst => rst,
             x_i => x_s,
             y_i => y_s,
             sin_i => sin0_s,
             cos_i => cos0_s,
             t3_i => t3_s,
             t4_i => t4_s,
             rho_i => rho_i,
             acc_rdata_i => acc0_rdata_i,
             acc_wdata_o => acc0_wdata_o,
             acc_raddr_o => acc0_raddr_o,
             acc_waddr_o => acc0_waddr_o);
    
    pu_1: processing_unit
    generic map(THETA_WIDTH => THETA_WIDTH,
                XY_WIDTH => XY_WIDTH,
                TRIG_WIDTH => TRIG_WIDTH,
                RHO_WIDTH => RHO_WIDTH,
                ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => DATA_WIDTH,
                ACC_SIZE => ACC_SIZE,
				SIZE_WIDTH => ACC_SIZE_WIDTH)
    port map(clk => clk,
             rst => rst,
             x_i => x_s,
             y_i => y_s,
             sin_i => sin1_s,
             cos_i => cos1_s,
             t3_i => t3_s,
             t4_i => t4_s,
             rho_i => rho_i,
             acc_rdata_i => acc1_rdata_i,
             acc_wdata_o => acc1_wdata_o,
             acc_raddr_o => acc1_raddr_o,
             acc_waddr_o => acc1_waddr_o);    
             
    process(trig0_data_i) 
    begin
        sin0_s <= trig0_data_i(ROM_DATA_WIDTH - 1 downto ROM_DATA_WIDTH - TRIG_WIDTH);
        cos0_s <= trig0_data_i(TRIG_WIDTH - 1 downto 0);
    end process;
    
    process(trig1_data_i) 
    begin
        sin1_s <= trig1_data_i(ROM_DATA_WIDTH - 1 downto ROM_DATA_WIDTH - TRIG_WIDTH);
        cos1_s <= trig1_data_i(TRIG_WIDTH - 1 downto 0);
    end process;
end Behavioral;
