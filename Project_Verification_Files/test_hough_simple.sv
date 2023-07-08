`ifndef TEST_HOUGH_SIMPLE_SV
    `define TEST_HOUGH_SIMPLE_SV

class test_hoguh_simple extends test_hough_base;

    `uvm_component_utils(test_hoguh_simple)
    
    function new(string name = "test_hough_simple",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

    endtask : run_phase

endclass : test_hoguh_simple

`endif    