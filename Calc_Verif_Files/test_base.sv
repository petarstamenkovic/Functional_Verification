`ifndef TEST_BASE_SV
 `define TEST_BASE_SV

 class test_base extends uvm_test;

   `uvm_component_utils(test_base)

   calc_driver drv;
   calc_sequencer seqr;
   calc_seq_item seq_item1;
   calc_monitor mon1;
   calc_monitor mon2;
   calc_monitor mon3;
   calc_monitor mon4;
   function new(string name = "test_base", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      drv = calc_driver::type_id::create("drv", this);      
      seqr = calc_sequencer::type_id::create("seqr", this);      
      mon1 = calc_monitor::type_id::create("mon1", this);  
      mon2 = calc_monitor::type_id::create("mon2", this);   
      mon3 = calc_monitor::type_id::create("mon3", this);   
      mon4 = calc_monitor::type_id::create("mon4", this);   
 
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
   endfunction : connect_phase

endclass : test_base

`endif
