`ifndef HOUGH_INTERFACE_SV
    `define HOUGH_INTERFACE_SV

interface hough_interface(input clk,logic rst); 
    
    parameter C_S00_AXI_DATA_WIDTH = 32;
    parameter C_S00_AXI_ADDR_WIDTH = 5;

    // Accumulators
    logic [17:0]    acc0_addr_cont_i;
    logic [31:0]    acc0_data_cont_i;
    logic [3:0]     acc0_we_cont;
    logic [31:0]    acc0_data_cont_o;
    logic [17:0]    acc1_addr_cont_i;
    logic [31:0]    acc1_data_cont_i;
    logic [3:0]     acc1_we_cont;
    logic [31:0]    acc1_data_cont_o;

    // Image 
    logic [18:0]    img_addr_cont_i;
    logic [31:0]    img_data_cont_i;
    logic [31:0]    img_data_cont_o;
    logic [3:0]     img_we_cont;


    // AXI4 Lite interface
    logic [C_S00_AXI_ADDR_WIDTH -1:0] s00_axi_awaddr;
    logic [2:0] s00_axi_awprot;
    logic s00_axi_awvalid;
    logic s00_axi_awready;
    logic [C_S00_AXI_DATA_WIDTH -1:0] s00_axi_wdata;
    logic [(C_S00_AXI_DATA_WIDTH/8) -1:0] s00_axi_wstrb;
    logic s00_axi_wvalid;
    logic s00_axi_wready;
    logic [1:0] s00_axi_bresp;
    logic s00_axi_bvalid;
    logic s00_axi_bready;
    logic [C_S00_AXI_ADDR_WIDTH -1:0] s00_axi_araddr;
    logic [2:0] s00_axi_arprot;
    logic s00_axi_arvalid;
    logic s00_axi_arready;
    logic [C_S00_AXI_DATA_WIDTH - 1:0] s00_axi_rdata;
    logic [1:0] s00_axi_rresp;
    logic s00_axi_rvalid;
    logic s00_axi_rready;

endinterface : hough_interface


`endif

