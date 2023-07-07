`ifndef CALC_SEQUENCER_SV
 `define CALC_SEQUENCER_SV

class calc_sequencer extends uvm_sequencer#(calc_seq_item);

   `uvm_component_utils(calc_sequencer)

   function new(string name = "calc_sequencer", uvm_component parent = null);
      super.new(name,parent);
   endfunction

endclass : calc_sequencer

`endif

