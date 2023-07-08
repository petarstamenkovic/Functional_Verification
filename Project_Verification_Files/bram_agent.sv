`ifndef BRAM_AGENT_SV
    `define BRAM_AGENT_SV

class bram_agent extends uvm_agent;

    //components
    bram_driver drv;
    bram_sequencer seqr;
    bram_monitor mon;

    //config object
    hough_config cfg;       //da li ovde treba da stoji bram_config ili samo da promenimo naziv u config.sv ili pravimo bram_config fajl? 
                            //AKo ne samo izmeni u tekstu agenta da ti bude umesto bram_config bude hough_config

    //UVM factory registration
    `uvm_component_utils_begin(bram_agent)
        `uvm_field_object(cfg, UVM_DEFAULT);
    `uvm_component_utils_end

    //constructor
    function new( string name = "bram_agent", uvm_component = null);
        super.new(name,parent);
    endfunction : new

    //UVM Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //get configuration object from db
        if(!uvm_config_db#(bram_config)::get(this,"","bram_config",cfg))
        `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})

        mon = bram_monitor::type_id::create("mon",this);

        //creating driver and sequencer if agent is active
        if(!cfg.bram_cfg.is_active == UVM_ACTIVE) begin
            drv = bram_driver::type_id::create("drv",this);
            seqr = bram_sequencer::type_id::create("seqr", this);
        end
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(cfg.is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction : connect_phase

endclass : bram_agent 