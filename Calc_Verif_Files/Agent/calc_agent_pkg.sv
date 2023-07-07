`ifndef CALC_AGENT_PKG
`define CALC_AGENT_PKG

package calc_agent_pkg;
 
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // include Agent components : driver,monitor,sequencer
   /////////////////////////////////////////////////////////
   `include "calc_seq_item.sv"
   `include "calc_sequencer.sv"
   `include "calc_driver.sv"
   `include "calc_monitor.sv"
   `include "calc_monitor2.sv"
   `include "calc_monitor3.sv"
   `include "calc_monitor4.sv"
endpackage

`endif



