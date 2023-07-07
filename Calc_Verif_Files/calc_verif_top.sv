module calc_verif_top;

   import uvm_pkg::*;     // import the UVM library
`include "uvm_macros.svh" // Include the UVM macros

   import calc_test_pkg::*;

   logic clk;
   logic [6 : 0] rst;

   // interface
   calc_if calc_vif1(clk, rst);
   calc_if calc_vif2(clk, rst);
   calc_if calc_vif3(clk, rst);
   calc_if calc_vif4(clk, rst);
   // DUT
   calc_top DUT(
                .c_clk        ( clk ),
                .reset        ( rst ),
                .out_data1    ( calc_vif1.out_data ),
                .out_data2    ( calc_vif2.out_data ),
                .out_data3    ( calc_vif3.out_data ),
                .out_data4    ( calc_vif4.out_data ),
                .out_resp1    ( calc_vif1.out_resp ),
                .out_resp2    ( calc_vif2.out_resp ),
                .out_resp3    ( calc_vif3.out_resp ),
                .out_resp4    ( calc_vif4.out_resp ),
                .req1_cmd_in  ( calc_vif1.req_cmd_in ),
                .req1_data_in ( calc_vif1.req_data_in ),
                .req2_cmd_in  ( calc_vif2.req_cmd_in ),
                .req2_data_in ( calc_vif2.req_data_in ),
                .req3_cmd_in  ( calc_vif3.req_cmd_in ),
                .req3_data_in ( calc_vif3.req_data_in ),
                .req4_cmd_in  ( calc_vif4.req_cmd_in ),
                .req4_data_in ( calc_vif4.req_data_in )
                );

   // run test
   initial begin
      uvm_config_db#(virtual calc_if)::set(null, "uvm_test_top.mon1", "calc_if", calc_vif1);
      uvm_config_db#(virtual calc_if)::set(null, "uvm_test_top.mon2", "calc_if", calc_vif2);
      uvm_config_db#(virtual calc_if)::set(null, "uvm_test_top.mon3", "calc_if", calc_vif3);
      uvm_config_db#(virtual calc_if)::set(null, "uvm_test_top.mon4", "calc_if", calc_vif4);
      run_test();
   end

   // clock and reset init.
   initial begin
      clk <= 0;
      rst <= 1;
      #50 rst <= 0;
   end

   // clock generation
   always #50 clk = ~clk;

endmodule : calc_verif_top
