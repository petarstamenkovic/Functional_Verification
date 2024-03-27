library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Hough_IP_v1_0 is
	generic (
		-- Users to add parameters here
        THETA_WIDTH: natural := 8;
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
        ACC_SIZE: natural := 64000;
        ROM_SIZE: natural := 180;
        ADDR_OFFSET: natural := 2;
        ADDR_FACTOR: natural := 4;
        ACC_ADDR_WIDTH: natural := 18;
        IMG_ADDR_WIDTH: natural := 19;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 5
	);
	port (
		-- Users to add ports here
        acc0_addr_cont_i: in std_logic_vector(ACC_ADDR_WIDTH - 1 downto 0);
        acc0_data_cont_o: out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
        acc0_data_cont_i: in std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
        acc0_we_cont: in std_logic_vector(3 downto 0);
        acc1_addr_cont_i: in std_logic_vector(ACC_ADDR_WIDTH - 1 downto 0);
        acc1_data_cont_o: out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
        acc1_data_cont_i: in std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
        acc1_we_cont: in std_logic_vector(3 downto 0);
        img_addr_cont_i: in std_logic_vector(IMG_ADDR_WIDTH - 1 downto 0);
        img_data_cont_o: out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
        img_data_cont_i: in std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
        img_we_cont: in std_logic_vector(3 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end Hough_IP_v1_0;

architecture arch_imp of Hough_IP_v1_0 is

	-- component declaration
	component Hough_IP_v1_0_S00_AXI is
		generic (
		DIMENSIONS_WIDTH: natural := 10;
        TRESHOLD_WIDTH: natural := 8;
        XY_WIDTH: natural := 10;
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5
		);
		port (
		start_o: out std_logic;
        reset_o: out std_logic;
        width_o: out std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
        height_o: out std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
        rho_o: out std_logic_vector(XY_WIDTH - 1 downto 0);
        treshold_o: out std_logic_vector(TRESHOLD_WIDTH - 1 downto 0);
        ready_i: in std_logic;
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component Hough_IP_v1_0_S00_AXI;

    component hough_core is
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
                 ACC_SIZE: natural := 64000;
                 ROM_SIZE: natural := 180;
                 ADDR_OFFSET: natural := 2);
        port (clk: in std_logic;
              reset: in std_logic;
              axi_reset: in std_logic;
              start: in std_logic;
              width_i: in std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
              height_i: in std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
              treshold_i: in std_logic_vector(TRESHOLD_WIDTH - 1 downto 0);
              rho_i: in std_logic_vector(XY_WIDTH - 1 downto 0);
              acc0_addr_cont_i: in std_logic_vector(ACC_ADDR_WIDTH - 1 downto 0);
              acc0_data_cont_o: out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
              acc0_data_cont_i: in std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
              acc0_we_cont: in std_logic_vector(3 downto 0);
              acc1_addr_cont_i: in std_logic_vector(ACC_ADDR_WIDTH - 1 downto 0);
              acc1_data_cont_o: out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
              acc1_data_cont_i: in std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
              acc1_we_cont: in std_logic_vector(3 downto 0);
              img_addr_cont_i: in std_logic_vector(IMG_ADDR_WIDTH - 1 downto 0);
              img_data_cont_o: out std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
              img_data_cont_i: in std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
              img_we_cont: in std_logic_vector(3 downto 0);
              ready: out std_logic);
    end component;
    
    signal reset_s: std_logic;
    signal axi_reset_s: std_logic;
    signal start_s: std_logic;
    signal width_s: std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
    signal height_s: std_logic_vector(DIMENSIONS_WIDTH - 1 downto 0);
    signal treshold_s: std_logic_vector(TRESHOLD_WIDTH - 1 downto 0);
    signal rho_s: std_logic_vector(XY_WIDTH - 1 downto 0);
    signal acc0_addr_cont_s: std_logic_vector(ACC_ADDR_WIDTH - 1 downto 0);
    signal acc0_data_cont_o_s: std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
    signal acc0_data_cont_i_s: std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
    signal acc0_we_cont_s: std_logic_vector(3 downto 0);
    signal acc1_addr_cont_s: std_logic_vector(ACC_ADDR_WIDTH - 1 downto 0);
    signal acc1_data_cont_o_s: std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
    signal acc1_data_cont_i_s: std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
    signal acc1_we_cont_s: std_logic_vector(3 downto 0);
    signal img_addr_cont_s: std_logic_vector(IMG_ADDR_WIDTH - 1 downto 0);
    signal img_data_cont_o_s: std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
    signal img_data_cont_i_s: std_logic_vector(BUS_DATA_WIDTH - 1 downto 0);
    signal img_we_cont_s: std_logic_vector(3 downto 0);
    signal ready_s: std_logic;
begin

-- Instantiation of Axi Bus Interface S00_AXI
Hough_IP_v1_0_S00_AXI_inst : Hough_IP_v1_0_S00_AXI
	generic map (
	    DIMENSIONS_WIDTH => DIMENSIONS_WIDTH,
        TRESHOLD_WIDTH => TRESHOLD_WIDTH,
        XY_WIDTH => XY_WIDTH,
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	    start_o => start_s,
        reset_o => reset_s,
        width_o => width_s,
        height_o => height_s,
        rho_o => rho_s,
        treshold_o => treshold_s,
        ready_i => ready_s,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
    my_core: hough_core 
    generic map (THETA_WIDTH => THETA_WIDTH,
                 XY_WIDTH => XY_WIDTH,
                 TRIG_WIDTH => TRIG_WIDTH,
                 RHO_WIDTH => RHO_WIDTH,
                 DIMENSIONS_WIDTH => DIMENSIONS_WIDTH,
                 TRESHOLD_WIDTH => TRESHOLD_WIDTH,
                 ADDR_WIDTH => ADDR_WIDTH,
                 DATA_WIDTH => DATA_WIDTH,
                 BUS_DATA_WIDTH => BUS_DATA_WIDTH,
                 ROM_DATA_WIDTH => ROM_DATA_WIDTH,
                 IMG_SIZE => IMG_SIZE,
                 ACC_SIZE => ACC_SIZE,
                 ROM_SIZE => ROM_SIZE,
                 ADDR_OFFSET => ADDR_OFFSET)
    port map (clk => s00_axi_aclk,
              reset => reset_s,
              axi_reset => s00_axi_aresetn,
              start => start_s,
              width_i => width_s,
              height_i => height_s,
              treshold_i => treshold_s,
              rho_i => rho_s,
              acc0_addr_cont_i => acc0_addr_cont_s,
              acc0_data_cont_o => acc0_data_cont_o_s,
              acc0_data_cont_i => acc0_data_cont_i_s,
              acc0_we_cont => acc0_we_cont_s,
              acc1_addr_cont_i => acc1_addr_cont_s,
              acc1_data_cont_o => acc1_data_cont_o_s,
              acc1_data_cont_i => acc1_data_cont_i_s,
              acc1_we_cont => acc1_we_cont_s,
              img_addr_cont_i => img_addr_cont_s,
              img_data_cont_o => img_data_cont_o_s,
              img_data_cont_i => img_data_cont_i_s,
              img_we_cont => img_we_cont_s,
              ready => ready_s);
              
    acc0_addr_cont_s <= acc0_addr_cont_i;
    acc0_data_cont_o <= acc0_data_cont_o_s;
    acc0_data_cont_i_s <= acc0_data_cont_i;
    acc0_we_cont_s <= acc0_we_cont;
    acc1_addr_cont_s <= acc1_addr_cont_i;
    acc1_data_cont_o <= acc1_data_cont_o_s;
    acc1_data_cont_i_s <= acc1_data_cont_i;
    acc1_we_cont_s <= acc1_we_cont;
    img_addr_cont_s <= img_addr_cont_i;
    img_data_cont_o <= img_data_cont_o_s;
    img_data_cont_i_s <= img_data_cont_i;
    img_we_cont_s <=img_we_cont;
	-- User logic ends

end arch_imp;
