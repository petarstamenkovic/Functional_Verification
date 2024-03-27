`ifndef TEST_HOUGH_SIMPLE_SV
    `define TEST_HOUGH_SIMPLE_SV

class test_hough_simple extends test_hough_base; 

    `uvm_component_utils(test_hough_simple)

    hough_simple_sequence simple_sequence;
    
    function new(string name = "test_hough_simple",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
            `uvm_info(get_type_name(),"Starting build phase...",UVM_LOW)

        simple_sequence = hough_simple_sequence::type_id::create("simple_sequence");    
    endfunction : build_phase


    task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        simple_sequence.start(env.agent.seqr);
        phase.drop_objection(this);
        
    endtask



endclass : test_hough_simple

`endif    