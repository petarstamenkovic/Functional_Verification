`ifndef HOUGH_ENVIRONMENT_SV
    `define HOUGH_ENVIRONMENT_SV
    
    class hough_environment extends uvm_env;
    
    hough_agent agent; 
    hough_axi_agent axi_agent;
    
    hough_config cfg;
    hough_scoreboard h_scbd;

    virtual interface hough_interface h_vif;
    `uvm_component_utils (hough_environment)

    function new(string name = "hough_environment" , uvm_component parent = null);  
       super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Getting interfaces from configuration base //
        if (!uvm_config_db#(virtual hough_interface)::get(this, "", "hough_interface", h_vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".h_vif"})

        if (!uvm_config_db#(hough_config)::get(this, "", "hough_config", cfg))
            `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".cfg"})

         // Setting to configurartion base //
        uvm_config_db#(hough_config)::set(this, "agent", "hough_config", cfg);
        uvm_config_db#(hough_config)::set(this, "h_scbd","hough_config", cfg);
        uvm_config_db#(virtual hough_interface)::set(this, "agent", "hough_interface", h_vif);
        uvm_config_db#(virtual hough_interface)::set(this, "axi_agent", "hough_interface", h_vif);

        agent = hough_agent::type_id::create("agent",this);
        axi_agent = hough_axi_agent::type_id::create("axi_agent",this);
        //Dodavanje scoreboard-a
        h_scbd = hough_scoreboard::type_id::create("h_scbd",this);
    endfunction : build_phase   
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.mon.item_collected_port.connect(h_scbd.item_collected_import);
    endfunction
    
    
    endclass : hough_environment

`endif    