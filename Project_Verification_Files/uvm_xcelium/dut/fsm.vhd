library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm is
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
          img_addr_o: out std_logic_vector(SIZE_WIDTH - 1 downto 0);
          x_o: out std_logic_vector(XY_WIDTH - 1 downto 0);
          y_o: out std_logic_vector(XY_WIDTH - 1 downto 0);
          theta_o: out std_logic_vector(THETA_WIDTH - 1 downto 0);
          rom_en_o: out std_logic;
          img_en_o: out std_logic;
          acc0_we_o: out std_logic_vector(3 downto 0);
          acc1_we_o: out std_logic_vector(3 downto 0);
          ready: out std_logic);
end fsm;

architecture Behavioral of fsm is
    component dsp_unit_1
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12);
        port (clk: in std_logic;
              rst: in std_logic;
              u1_i: in std_logic_vector (WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector (WIDTH2 - 1 downto 0);
              res_o: out std_logic_vector (WIDTH1 - 1 downto 0));
    end component;
    
    component dsp_unit_2
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12);
        port (clk: in std_logic;
              rst: in std_logic;
              u1_i: in std_logic_vector(WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector(WIDTH2 - 1 downto 0);
              res_o: out std_logic_vector(WIDTH1 + WIDTH2 - 1 downto 0));
    end component;
    
    component dsp_unit_3
        generic (WIDTH1: natural := 12;
                 WIDTH2: natural := 12;
                 PLUS_MINUS: string := "plus");
        port (u1_i: in std_logic_vector (WIDTH1 - 1 downto 0);
              u2_i: in std_logic_vector (WIDTH2 - 1 downto 0);
              res_o: out std_logic_vector (WIDTH1 - 1 downto 0));
    end component;
    
    
    --component dsp_unit_6 is
    --    generic (WIDTH1: natural := 12;
    --             WIDTH2: natural := 12;
    --             WIDTH3: natural := 12);
    --    port (clk: in std_logic;
    --          rst: in std_logic;
    --          u1_i: in std_logic_vector (WIDTH1 - 1 downto 0);
    --          u2_i: in std_logic_vector (WIDTH2 - 1 downto 0);
    --          u3_i: in std_logic_vector (WIDTH3 - 1 downto 0);
    --          res_o: out std_logic_vector (WIDTH1 + WIDTH2 - 1 downto 0));
    --end component;
    
    type state_type is (idle_state, x0_state, load_state, pixel_state, processing_state, x_exit_state, y_exit_state);
    signal state_reg, state_next: state_type;
    signal y_reg, y_next: std_logic_vector(XY_WIDTH - 1 downto 0);
    signal x_reg, x_next: std_logic_vector(XY_WIDTH - 1 downto 0);
    signal theta_reg, theta_next: std_logic_vector(THETA_WIDTH - 1 downto 0);
    signal pixel_reg, pixel_next: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal img_addr_reg, img_addr_next: std_logic_vector(SIZE_WIDTH - 1 downto 0);
    signal current_pixel_s: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal y_dsp_s, x_dsp_s: std_logic_vector(XY_WIDTH - 1 downto 0);
    signal theta_dsp_s: std_logic_vector(THETA_WIDTH - 1 downto 0);
    signal img_addr_dsp_s: std_logic_vector(SIZE_WIDTH - 1 downto 0);
    signal img_dsp_s: std_logic_vector(2*XY_WIDTH - 1 downto 0);
    signal x_one_s, y_one_s, theta_one_s: std_logic_vector(1 downto 0) := "01";
    signal img_one_s: std_logic_vector(3 downto 0) := "0001";
    signal nine_s: std_logic_vector(THETA_WIDTH - 1 downto 0) := std_logic_vector(to_unsigned(9, THETA_WIDTH));
    signal eighty_nine_s: std_logic_vector(THETA_WIDTH - 1 downto 0) := std_logic_vector(to_unsigned(89, THETA_WIDTH));
    signal ninety_s: std_logic_vector(THETA_WIDTH - 1 downto 0) := std_logic_vector(to_unsigned(90, THETA_WIDTH));
    signal hundred_s: std_logic_vector(THETA_WIDTH - 1 downto 0) := std_logic_vector(to_unsigned(100, THETA_WIDTH));
begin
    y_inc_dsp: dsp_unit_1
    generic map(WIDTH1 => XY_WIDTH,
                WIDTH2 => 2)
    port map(clk => clk,
             rst => rst,
             u1_i => y_reg,
             u2_i => y_one_s,
             res_o => y_dsp_s);
    
    x_inc_dsp: dsp_unit_1
    generic map(WIDTH1 => XY_WIDTH,
                WIDTH2 => 2)
    port map(clk => clk,
             rst => rst,
             u1_i => x_reg,
             u2_i => x_one_s,
             res_o => x_dsp_s);
    
    img_addr_inc_dsp: dsp_unit_1
    generic map(WIDTH1 => SIZE_WIDTH,
                WIDTH2 => 4)
    port map(clk => clk,
             rst => rst,
             u1_i => img_addr_reg,
             u2_i => img_one_s,
             res_o => img_addr_dsp_s);
    
    process(img_addr_reg)
    begin
        img_addr_o <= img_addr_reg;
    end process;
         
    theta_inc_dsp: dsp_unit_3
    generic map(WIDTH1 => THETA_WIDTH,
                WIDTH2 => 2,
                PLUS_MINUS => "plus")
    port map(u1_i => theta_reg,
             u2_i => theta_one_s,
             res_o => theta_dsp_s);
    
    --img_dsp: dsp_unit_6
    --generic map(WIDTH1 => XY_WIDTH,
    --            WIDTH2 => DIMENSIONS_WIDTH,
     --           WIDTH3 => XY_WIDTH)
   -- port map(clk => clk,
     --        rst => rst,
     --        u1_i => y_reg,
     --        u2_i => width_i,
     --        u3_i => x_reg,
     --        res_o => img_dsp_s);   
             
    --img_addr_o <= img_dsp_s(log2c(IMG_SIZE) - 1 downto 0);
             
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                state_reg <= idle_state;
                y_reg <= (others => '0');
                x_reg <= (others => '0');
                theta_reg <= (others => '0');
                pixel_reg <= (others => '0');
                img_addr_reg <= (others => '0');
            else
                state_reg <= state_next;
                y_reg <= y_next;
                x_reg <= x_next;
                theta_reg <= theta_next;
                pixel_reg <= pixel_next;
                img_addr_reg <= img_addr_next;
            end if;
        end if;
    end process;
    
    process(state_reg, start, pixel_reg, y_reg, theta_rom_i, x_reg, img_addr_reg, y_next, x_next, theta_reg, img_data_i, current_pixel_s, 
            y_dsp_s, x_dsp_s, img_addr_dsp_s, theta_dsp_s, width_i, height_i, treshold_i, theta_status_i,
            nine_s, eighty_nine_s, ninety_s, hundred_s)
    begin
        y_next <= y_reg;
        x_next <= x_reg;
        theta_next <= theta_reg;
        pixel_next <= pixel_reg;
        img_addr_next <= img_addr_reg;
        current_pixel_s <= (others => '0');
        img_en_o <= '0';
        rom_en_o <= '0';  
        acc0_we_o <= "0000";
        acc1_we_o <= "0000"; 
        ready <= '0';
        
        case state_reg is
            when idle_state => 
                ready <= '1';
                if (start = '1') then
                    y_next <= (others => '0');
                    img_addr_next <= (others => '0');
                    state_next <= x0_state;
                else
                    state_next <= idle_state;
                end if;
            when x0_state =>
                x_next <= (others => '0');
                img_en_o <= '1';
                --img_addr_o <= img_mult_dsp_s(log2c(IMG_SIZE) - 1 downto 0);
                state_next <= load_state;
            --when addr_state =>
            --    state_next <= load_state;
            when load_state => 
                img_addr_next <= img_addr_dsp_s;
                pixel_next <= img_data_i;
                state_next <= pixel_state;
            when pixel_state =>
                current_pixel_s <= pixel_reg;
                if (current_pixel_s > treshold_i) then
                    theta_next <= (others => '0');
                    state_next <= processing_state;
                else
                    state_next <= x_exit_state;
                end if;
            when processing_state =>
                theta_next <= theta_dsp_s;
                if (theta_rom_i < ninety_s) then
                    rom_en_o <= '1';
                end if;
                if (theta_reg > nine_s and theta_reg < hundred_s) then
                    acc0_we_o <= "0001";
                    acc1_we_o <= "0001";
                end if;
                if (theta_status_i = eighty_nine_s) then
                    state_next <= x_exit_state;
                else
                    state_next <= processing_state;
                end if;
            when x_exit_state =>
                x_next <= x_dsp_s;
                if(x_next = width_i) then
                    state_next <= y_exit_state;
                else
                    --img_addr_o <= img_dsp_s(log2c(IMG_SIZE) - 1 downto 0);
                    img_en_o <= '1';
                    state_next <= load_state;
                end if;
            when y_exit_state =>
                y_next <= y_dsp_s;
                if(y_next = height_i) then
                    state_next <= idle_state;
                else
                    state_next <= x0_state;
                end if;
        end case;
    end process;
    
    y_o <= y_reg;
    x_o <= x_reg;
    theta_o <= theta_reg;
end Behavioral;
