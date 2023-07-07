`ifndef CALC_SIMPLE_SEQ_SV
 `define CALC_SIMPLE_SEQ_SV

class calc_simple_seq extends calc_base_seq;

   `uvm_object_utils (calc_simple_seq)

   function new(string name = "calc_simple_seq");
      super.new(name);
   endfunction

   virtual task body();
      calc_seq_item calc_it;
      for(int i = 0 ; i <= 4 ; i++) begin 
        `uvm_info(get_type_name(),"Starting for loop...",UVM_LOW);      
        calc_it = calc_seq_item::type_id::create("calc_it");
        start_item(calc_it);
        `uvm_info(get_type_name(),"Started sending...",UVM_LOW);
        assert (calc_it.randomize() with {calc_it.cmd inside {[4'b0000:4'b0010],4'b0101,4'b0110}; calc_it.operand1<10; calc_it.operand2<10; calc_it.port<4;});
        finish_item(calc_it);
        `uvm_info(get_type_name(),"Finished sending...",UVM_LOW);
      end
      
   endtask : body

endclass : calc_simple_seq

`endif
