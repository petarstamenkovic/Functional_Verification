`ifndef HOUGH_MONITOR_SV
    `define HOUGH_MONITOR_SV

class hough_monitor extends uvm_monitor;

    // Standard control fields
    bit checks_enable = 1;
    bit coverage_enable = 1;

    hough_config cfg;

    uvm_analysis_port #(hough_seq_item) item_collected_port;

    `uvm_component_utils_begin(hough_monitor)
        `uvm_field_int(checks_enable , UVM_DEFAULT)
        `uvm_field_int(coverage_enable,UVM_DEFAULT)
    `uvm_component_utils_end

    // Virtual interface 
    virtual interface hough_interface h_vif;

    // Current transacation
    hough_seq_item curr_it;


    // PLACE FOR COVERAGE /////

    covergroup acumulator_cover (int coverage_goal);
        option.per_instance = 1;
        option.goal = coverage_goal;
        acc0_address : coverpoint h_vif.acc0_addr_cont_i{
            bins b1 = {[0:6000]};
            bins b2 = {[6001:12000]};
            bins b3 = {[12001:18000]};
            bins b4 = {[18001:24000]};
            bins b5 = {[24001:30000]};
            bins b6 = {[30001:36000]};
            bins b7 = {[36001:42000]};
            bins b8 = {[42001:48000]};
            bins b9 = {[48001:52000]};
            bins b10 = {[52001:60000]};
        }
        acc1_address : coverpoint h_vif.acc1_addr_cont_i{
            bins b1 = {[0:6000]};
            bins b2 = {[6001:12000]};
            bins b3 = {[12001:18000]};
            bins b4 = {[18001:24000]};
            bins b5 = {[24001:30000]};
            bins b6 = {[30001:36000]};
            bins b7 = {[36001:42000]};
            bins b8 = {[42001:48000]};
            bins b9 = {[48001:52000]};
            bins b10 = {[52001:60000]};
        }
    endgroup

    function new(string name = "hough_monitor", uvm_component parent = null);
        super.new(name,parent);
        item_collected_port = new("item_collected_port",this); 

        //instancioniranje cover grupe
        
        
        if (!uvm_config_db#(virtual hough_interface)::get(this, "*", "hough_interface", h_vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".h_vif"})
        if(!uvm_config_db#(hough_config)::get(this, "", "hough_config", cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})

        acumulator_cover = new(cfg.coverage_goal_cfg);
   endfunction

   function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
   endfunction

   task main_phase(uvm_phase phase);
        @(posedge h_vif.clk)
        wait(h_vif.s00_axi_rdata == 0)
        wait(h_vif.s00_axi_rdata == 1)
        wait(h_vif.s00_axi_rdata == 0)
        wait(h_vif.s00_axi_rdata == 1)
        
        forever begin
        @(posedge h_vif.clk);
        if(h_vif.rst)
        begin
            curr_it = hough_seq_item::type_id::create("curr_it",this);
            if(h_vif.s00_axi_rdata == 1 && h_vif.s00_axi_araddr == 0)
            begin
                acumulator_cover.sample();
                `uvm_info(get_type_name(),$sformatf("[Monitor] Gathering information..."),UVM_MEDIUM);
                curr_it.acc0_addr_cont_i = h_vif.acc0_addr_cont_i-4;
                curr_it.acc0_data_cont_o = h_vif.acc0_data_cont_o;

                curr_it.acc1_addr_cont_i = h_vif.acc1_addr_cont_i-4;
                curr_it.acc1_data_cont_o = h_vif.acc1_data_cont_o;

                item_collected_port.write(curr_it);
            end 
        end 
        end   
   endtask          
endclass:hough_monitor    

`endif