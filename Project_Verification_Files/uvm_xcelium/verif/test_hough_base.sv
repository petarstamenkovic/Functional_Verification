`ifndef TEST_HOUGH_BASE_SV
    `define TEST_HOUGH_BASE_SV

class test_hough_base extends uvm_test;

    `uvm_component_utils(test_hough_base)

    hough_environment env;
    hough_config cfg;

    function new(string name = "test_hough_base", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"Starting build phase...", UVM_LOW);
        cfg = hough_config::type_id::create("cfg");
        cfg.randomize();
        cfg.extracting_data();
        uvm_config_db#(hough_config)::set(this,"*","hough_config",cfg);
        env = hough_environment::type_id::create("env",this); 
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

endclass : test_hough_base

`endif    