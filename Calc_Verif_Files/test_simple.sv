`ifndef TEST_SIMPLE_SV
 `define TEST_SIMPLE_SV

class test_simple extends test_base;

   `uvm_component_utils(test_simple)

   calc_simple_seq simple_seq;

   function new(string name = "test_simple", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      simple_seq = calc_simple_seq::type_id::create("simple_seq");
   endfunction : build_phase

   task main_phase(uvm_phase phase);
      phase.raise_objection(this);
      simple_seq.start(seqr);
      #100us;      
      phase.drop_objection(this);
   endtask : main_phase

endclass

`endif
