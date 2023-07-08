`ifndef HOUGH_SEQ_ITEM
    `define HOUGH_SEQ_ITEM

class hough_seq_item extends uvm_sequence_item;

    logic [ 9 : 0 ] width_i;
    logic [ 9 : 0 ] height_i;
    logic [ 7 : 0 ] threshold;

    rand logic start;

    `uvm_object_utils_begin(hough_seq_item)
        `uvm_field_int(width_i, UVM_DEFAULT );
        `uvm_field_int(height_i, UVM_DEFAULT );
        `uvm_field_int(threshold, UVM_DEFAULT );
    `uvm_object_utils_end

    function new( string name = "hough_seq_item");
        super.new(name);
    endfunction : hough_seq_item
endclass : hough_seq_item