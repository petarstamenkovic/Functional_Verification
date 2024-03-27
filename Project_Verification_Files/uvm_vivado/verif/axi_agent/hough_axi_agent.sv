`ifndef HOUGH_AXI_AGENT_SV
    `define HOUGH_AXI_AGENT_SV

class hough_axi_agent extends uvm_agent;
    
    //komponente

    hough_axi_monitor axi_mon;

    virtual interface hough_interface h_vif;
    
    `uvm_component_utils_begin(hough_axi_agent)
        `uvm_field_object(axi_mon,UVM_DEFAULT);
    `uvm_component_utils_end

    function new(string name = "hough_axi_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //checking if the interface is set for this component
        if(!uvm_config_db#(virtual hough_interface)::get(this,"","hough_interface",h_vif))
            `uvm_fatal("NOVIF", {"Virtual interface must be set:",get_full_name(),".h_vif"})

        //setting virtual interface h_vif
        uvm_config_db#(virtual hough_interface)::set(this,"*","hough_interface",h_vif);

        axi_mon = hough_axi_monitor::type_id::create("axi_mon",this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

endclass : hough_axi_agent 

`endif