`ifndef HOUGH_MONITOR_SV
    `define HOUGH_MONITOR_SV

class hough_monitor extends uvm_monitor;
    
    //virtualni interfejs za HDL Signale
    virtual interface hough_if vif;

    bit checks_enable = 1;

    uvm_analysis_port#(hough_seq_item) item_collected_port;

    `uvm_component_utils_begin(hough_monitor)
        `uvm_field_int(checks_enable,UVM_DEFAULT)
    `uvm_component_utils_end
    
    hough_seq_item curr_it;

    function new(string = "hough_monitor", uvm_component parent = null);
        super.new(name,parent);
        item_collected_port = new("item_collected_port", this);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(hough_config)::get(this,"","hough_config",cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for:",get_full_name(),".cfg"})
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(!uvm_config_db#(virtual hough_interface)::get(this,"*","hough_interface",hough_interface))
            `uvm_fatal("NOVIF",{"Virtual interface must be set: ",get_full_name(),".vif"})
    endfunction : connect_phase

    function main_phase(uvm_phase phase);
        forever begin
            curr_it = hough_seq_item::type_id::create("curr_it",this);
            @(posedge vif.clk);
            if ( vif.start == 1 && ) 
                curr_it.width_i = vif.width_i;
                curr_it.height_i = vif.height_i;
                curr_it.threshold = vif.threshold;

                item_collected_port.write(curr_it);     //slanje informacije ka scoreboard-u
        end
    endfunction : main_phase
endclass : hough_monitor


/*

informacija za Petra: uvm_analysis_port je port koji se
nalazi izmedju monitora i scoreboard-a

*/
