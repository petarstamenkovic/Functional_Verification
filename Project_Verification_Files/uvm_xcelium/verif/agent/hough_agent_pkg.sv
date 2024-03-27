`ifndef HOUGH_AGENT_PKG
    `define HOUGH_AGENT_PKG

    package hough_agent_pkg;

        import uvm_pkg::*;
        `include "uvm_macros.svh"

        import configuration_pkg::*;

        `include "hough_seq_item.sv"
        `include "hough_sequencer.sv"
        `include "hough_driver.sv"
        `include "hough_monitor.sv"
        `include "hough_agent.sv"
        

    endpackage : hough_agent_pkg

`endif 