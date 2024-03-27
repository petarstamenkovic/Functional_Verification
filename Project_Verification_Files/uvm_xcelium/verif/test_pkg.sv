`ifndef TEST_PKG_SV
    `define TEST_PKG_SV

package test_pkg; 
    
        import uvm_pkg::*;
        `include "uvm_macros.svh"

        import hough_agent_pkg::*;
        import hough_axi_agent_pkg::*;
        import hough_sequence_pkg::*;
        import configuration_pkg::*;

        `include "hough_scoreboard.sv"
        `include "hough_environment.sv"
        `include "test_hough_base.sv"
        `include "test_hough_simple.sv"

endpackage : test_pkg

    `include "hough_interface.sv"

`endif
