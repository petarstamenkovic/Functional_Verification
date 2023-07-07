`ifndef CALC_SEQ_ITEM_SV
 `define CALC_SEQ_ITEM_SV

class calc_seq_item extends uvm_sequence_item;

   rand logic [31:0] operand1;
   rand logic [31:0] operand2;
   rand logic [3:0]  cmd;
   rand logic [3:0]  port;
 
   
   `uvm_object_utils_begin(calc_seq_item)
   `uvm_object_utils_end

   function new (string name = "calc_seq_item");
      super.new(name);
   endfunction // new

endclass : calc_seq_item

`endif
