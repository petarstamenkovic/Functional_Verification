`ifndef HOUGH_SIMPLE_SEQUENCE_SV
    `define HOUGH_SIMPLE_SEQUENCE_SV

class hough_base_sequence extends hough_simple_sequence;

    `uvm_object_utils(hough_simple_sequence)
    


    function new(string name = "hough_simple_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        
    endtask : body

endclass : hough_simple_sequence
`endif 