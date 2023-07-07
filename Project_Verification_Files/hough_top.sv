module hough_top

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import hough_test_pkg::*;  // "Hough test pkg to be created by Momir"

    logic clk;
    logic rst = 0;

    // Interfaces
    hough_if h_vif(clk,rst);
    bram_if  b_vif(clk);

    // DUT - Verify with designer for adequate names from DUT(left side here)
    hough_top DUT(
                   .clk             (clk),
                   .rst             (rst),
                   .width_i         (h_vif.width_i),
                   .height_i        (h_vif.height_i),
                   .threshold       (h_vif.threshold),
                   .rho_i           (h_vif.rho_i),
                   .start           (h_vif.start),
                   .ready           (h_vif.ready),
                   .img_addr_cont_i (b_vif.addr_i),
                   .img_data_cont_i (b_vif.data_i),
                   .we_b            (b_vif.we_b)
                );

    // Run tests and set interfaces
    inital begin
       uvm_config_db#(virtual hough_if)::set(null, "uvm_test_top.env", "hough_if", h_vif);  // What does uvm_test_top.env stand for?
       uvm_config_db#(virtual bram_if)::set(null, "uvm_test_top.env", "bram_if", b_vif);
       run_test();      // To be created by Momir
    end 

    // Clock and reset init
    inital begin
        clk <= 1
        rst <= 1;
        for(int i = 0 ; i < 4 ; i++) begin  //wait for 5 cycles 
            @(posedge clk);
        end
        rst <= 0;
    end

    // Clock generation
    always #50 clk = ~clk;

endmodule : hough_top    
