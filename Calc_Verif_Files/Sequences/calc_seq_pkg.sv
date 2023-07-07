`ifndef CALC_SEQ_PKG_SV
 `define CALC_SEQ_PKG_SV
package calc_seq_pkg;
   import uvm_pkg::*;      // import the UVM library
 `include "uvm_macros.svh" // Include the UVM macros
  import calc_agent_pkg::calc_seq_item;
   import calc_agent_pkg::calc_sequencer;
 `include "calc_base_seq.sv"
 `include "calc_simple_seq.sv"
     endpackage 
`endif
