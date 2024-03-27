`ifndef HOUGH_AXI_AGENT_PKG
    `define HOUGH_AXI_AGENT_PKG

    package hough_axi_agent_pkg;

        import uvm_pkg::*;
        `include "uvm_macros.svh"

        //import configuration_pkg::*;

        `include "hough_axi_seq_item.sv"
        `include "hough_axi_monitor.sv"
        `include "hough_axi_agent.sv"

    endpackage : hough_axi_agent_pkg

`endif 