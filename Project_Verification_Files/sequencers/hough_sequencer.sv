`ifndef HOUGH_SEQUENCER_SV
    `define HOUGH_SEQUENCER_SV

class hough_sequencer extends uvm_sequencer#(hough_seq_item);

    `uvm_component_utils(hough_sequencer)

    function new(string name = "sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction : hough_sequencer

endclass : hough_sequencer 

`endif 