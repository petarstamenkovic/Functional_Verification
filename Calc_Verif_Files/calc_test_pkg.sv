`ifndef CALC_TEST_PKG_SV
 `define CALC_TEST_PKG_SV

package calc_test_pkg;

   import uvm_pkg::*;      // import the UVM library   
 `include "uvm_macros.svh" // Include the UVM macros

   import calc_agent_pkg::*;
   import calc_seq_pkg::*;

 
 `include "test_base.sv"
 `include "test_simple.sv"
 `include "test_simple_2.sv"
 

endpackage : calc_test_pkg
`include "calc_if.sv"  


`endif

