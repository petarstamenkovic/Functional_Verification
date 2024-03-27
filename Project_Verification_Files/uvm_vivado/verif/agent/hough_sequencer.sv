`ifndef HOUGH_SEQUENCER_SV
    `define HOUGH_SEQUENCER_SV

class hough_sequencer extends uvm_sequencer#(hough_seq_item);

    `uvm_component_utils(hough_sequencer)

    hough_config cfg;

    function new(string name = "sequencer", uvm_component parent = null);
        super.new(name,parent);

        if(!uvm_config_db#(hough_config)::get(this, "", "hough_config", cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
        
    endfunction : new

endclass : hough_sequencer 

`endif 