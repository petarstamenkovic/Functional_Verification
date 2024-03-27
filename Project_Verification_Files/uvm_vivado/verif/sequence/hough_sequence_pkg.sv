`ifndef HOUGH_SEQUENCE_PKG_SV
    `define HOUGH_SEQUENCE_PKG_SV

    package hough_sequence_pkg;

        import uvm_pkg::*;            
        `include "uvm_macros.svh"           

        import hough_agent_pkg::hough_seq_item;
        import hough_agent_pkg::hough_sequencer;

        `include "hough_base_sequence.sv"
        `include "hough_simple_sequence.sv"
    endpackage
`endif 