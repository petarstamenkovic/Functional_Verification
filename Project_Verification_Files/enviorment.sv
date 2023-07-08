`ifndef ENVIORMENT_SV
    `define ENVIORMENT_SV
    
    class hough_env extends uvm_env;
    
    hough_agent h_agent;    // Where "hough and bram" agents are names of classes to be created
    bram_agent  b_agent;
    hough_config cfg;
    virtual interface hough_if h_vif;
    virtual interface bram_if  b_vif;
    
    `uvm_component_utils (hough_env)

    
    function new(string name = "hough_env" , uvm_component parent = null);  
       super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Getting interfaces from configuration base //
        if (!uvm_config_db#(virtual hough_if)::get(this, "", "hough_if", h_vif))
         `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".h_vif"})
        if (!uvm_config_db#(virtual bram_if)::get(this, "", "bram_if", b_vif))
         `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".b_vif"})

        if (!uvm_config_db#(virtual hough_if)::get(this, "", "hough_if", cfg))
         `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".cfg"})

         // Setting to configurartion base //
        uvm_config_db#(hough_config)::set(this, "*agent", "hough_config", cfg);
        uvm_config_db#(virtual hough_if)::set(this, "h_agent", "hough_if", h_vif);
        uvm_config_db#(virtual calc_if)::set(this, "b_agent", "bram_if", b_vif);

        h_agent = hough_agent::type_id::create("h_agent",this);
        b_agent = bram_agent::type_id::create("b_agent",this);
        cfg = hough_config::type_id::create("cfg",this);
        
    endfunction : build_phase    
    
    
    endclass : hough_env

`endif    