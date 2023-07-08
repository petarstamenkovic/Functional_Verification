`ifndef BRAM_SEQ_ITEM
    `define BRAM_SEQ_ITEM

class bram_seq_item extends uvm_sequence_item;

    logic [16 : 0] addr_i;
    logic [7 : 0] data_i;

    `uvm_object_utils_begin(bram_seq_item)
        `uvm_field_int(addr_i, UVM_DEFAULT );
        `uvm_field_int(data_i, UVM_DEFAULT );
    `uvm_object_utils_end

    function new( string name = "hough_seq_item");
        super.new(name);
    endfunction : bram_seq_item
endclass : bram_seq_item