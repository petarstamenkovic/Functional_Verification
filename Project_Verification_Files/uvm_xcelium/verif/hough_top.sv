module hough_top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
        
    import test_pkg::*;

    logic clk;
    logic rst;

    // Interface
    hough_interface h_vif(clk,rst);

    // DUT
    hough_IP_v1_0 DUT(
                   .s00_axi_aclk                  (clk),
                   .s00_axi_aresetn               (rst),

                   .acc0_addr_cont_i              (h_vif.acc0_addr_cont_i),
                   .acc0_data_cont_i              (h_vif.acc0_data_cont_i),
                   .acc0_data_cont_o              (h_vif.acc0_data_cont_o),
                   .acc0_we_cont                  (h_vif.acc0_we_cont),
                   .acc1_addr_cont_i              (h_vif.acc1_addr_cont_i),
                   .acc1_data_cont_i              (h_vif.acc1_data_cont_i),
                   .acc1_data_cont_o              (h_vif.acc1_data_cont_o),
                   .acc1_we_cont                  (h_vif.acc1_we_cont),
                   .img_addr_cont_i               (h_vif.img_addr_cont_i),
                   .img_data_cont_i               (h_vif.img_data_cont_i),
                   .img_data_cont_o               (h_vif.img_data_cont_o),
                   .img_we_cont                   (h_vif.img_we_cont),

                   .s00_axi_awaddr                (h_vif.s00_axi_awaddr),
                   .s00_axi_awprot                (h_vif.s00_axi_awprot),
                   .s00_axi_awvalid               (h_vif.s00_axi_awvalid),
                   .s00_axi_awready               (h_vif.s00_axi_awready),
                   .s00_axi_wdata                 (h_vif.s00_axi_wdata),
                   .s00_axi_wstrb                 (h_vif.s00_axi_wstrb),
                   .s00_axi_wvalid                (h_vif.s00_axi_wvalid),
                   .s00_axi_wready                (h_vif.s00_axi_wready),
                   .s00_axi_bresp                 (h_vif.s00_axi_bresp),
                   .s00_axi_bvalid                (h_vif.s00_axi_bvalid),
                   .s00_axi_bready                (h_vif.s00_axi_bready),
                   .s00_axi_araddr                (h_vif.s00_axi_araddr),
                   .s00_axi_arprot                (h_vif.s00_axi_arprot),
                   .s00_axi_arvalid               (h_vif.s00_axi_arvalid),
                   .s00_axi_arready               (h_vif.s00_axi_arready),
                   .s00_axi_rdata                 (h_vif.s00_axi_rdata),
                   .s00_axi_rresp                 (h_vif.s00_axi_rresp),
                   .s00_axi_rvalid                (h_vif.s00_axi_rvalid),
                   .s00_axi_rready                (h_vif.s00_axi_rready)
                );

    // Run tests and set interfaces
    initial begin
       uvm_config_db#(virtual hough_interface)::set(null, "uvm_test_top.env", "hough_interface", h_vif);
       run_test("test_hough_simple");
    end 

    // Clock and reset init - Reset is active on 0
    initial begin
        clk <= 0;
        rst <= 0;
        #50 rst <= 1;
    end

    // Clock generation
    always #50 clk = ~clk;

endmodule : hough_top    
