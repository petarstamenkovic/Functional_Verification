`ifndef HOUGH_AXI_MONITOR_SV
    `define HOUGH_AXI_MONITOR_SV

class hough_axi_monitor extends uvm_monitor;

    // Standard control fields
    bit checks_enable = 1;
    bit coverage_enable = 1;  

    uvm_analysis_port #(hough_axi_seq_item) axi_item_collected_port;

    `uvm_component_utils_begin(hough_axi_monitor)
        `uvm_field_int(checks_enable ,UVM_DEFAULT)
        `uvm_field_int(coverage_enable,UVM_DEFAULT)
    `uvm_component_utils_end

    // Virtual interface 
    virtual interface hough_interface h_vif;

    // Current transacation
    hough_axi_seq_item curr_it;

    //komanda za coverage: exec xcrg -report_format html -dir xcrg -report_format html -dir C:/Users/Momir/Desktop/Verifikacija/UVM_verification/uvm_test/uvm_project/hough_verif.sim/sim_1/behav/xsim -report_dir C:/Users/Momir/Desktop/Verifikacija
    //potrebno je promeniti putanje koje odgovaraju vama!!!
    //komanda Petar : exec xcrg -report_format html -dir xcrg -report_format html -dir C:/Users/Pera/Desktop/CurrentHough/uvm_test/uvm_project/hough_verif.sim/sim_1/behav/xsim -report_dir C:/Users/Pera/Desktop/Coverage

    // PLACE FOR COVERAGE /////
    covergroup axi_write_transactions;
        option.per_instance = 1;
        option.goal = 9;
        write_address : coverpoint h_vif.s00_axi_awaddr{
            bins BASE_ADDRESS = {AXI_BASE};
            bins START_REG_INPUT = {AXI_BASE+START_REG_OFFSET};
            bins RESET_REG_INPUT = {AXI_BASE+RESET_REG_OFFSET};
            bins WIDTH_REG_INPUT = {AXI_BASE+WIDTH_REG_OFFSET};
            bins HEIGHT_REG_INPUT = {AXI_BASE+HEIGHT_REG_OFFSET};
            bins RHO_REG_INPUT = {AXI_BASE+RHO_REG_OFFSET};
            bins TRESHOLD_REG_INPUT = {AXI_BASE+TRESHOLD_REG_OFFSET};
        }
        write_data : coverpoint h_vif.s00_axi_wdata{
            bins AXI_WDATA_LOW = {0};
            bins AXI_WDATA_HIGH = {1};
            bins AXI_WDATA_PARAMETERS = {[2:424]};
        }    
    endgroup   

    covergroup axi_read_transactions;
        option.per_instance = 1;
        option.goal = 3;
        read_address : coverpoint h_vif.s00_axi_araddr{
            bins READY_ADDRESS = {AXI_BASE+READY_REG_OFFSET};
        }
        read_data : coverpoint h_vif.s00_axi_rdata{
            bins READY_RDATA_LOW = {0};
            bins READY_RDATA_HIGH = {1};
        }   
    endgroup   

    function new(string name = "hough_axi_monitor", uvm_component parent = null);
        super.new(name,parent);
        axi_item_collected_port = new("axi_item_collected_port",this); 

        //instancioniranje cover grupe
        axi_write_transactions = new();
        axi_read_transactions = new();
        
   endfunction

   function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (!uvm_config_db#(virtual hough_interface)::get(this, "*", "hough_interface", h_vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".h_vif"})     

   endfunction

   task main_phase(uvm_phase phase);
        $display("\nin UVM AXI_AGENT_MONITOR\n");
        forever begin
            @(posedge h_vif.clk)
            if(h_vif.rst)
            begin
                curr_it = hough_axi_seq_item::type_id::create("curr_it",this);
                // Monitor an Axi writing transaction
                if(h_vif.s00_axi_awvalid == 1 && h_vif.s00_axi_awready == 1) 
                begin
                    if(h_vif.s00_axi_wstrb == 15)
                    begin
                        axi_write_transactions.sample();
                        `uvm_info(get_type_name(),$sformatf("[AXI_Monitor] Gathering information..."),UVM_MEDIUM);
                        curr_it.s00_axi_awaddr = h_vif.s00_axi_awaddr;
                        curr_it.s00_axi_wdata = h_vif.s00_axi_wdata;
                    end
                end

                // Monitor an Axi reading transaction
                if(h_vif.s00_axi_arvalid == 1 && h_vif.s00_axi_arready == 1)
                begin
                    axi_read_transactions.sample();
                    curr_it.s00_axi_rdata = h_vif.s00_axi_rdata;
                    curr_it.s00_axi_araddr = h_vif.s00_axi_araddr;
                end

                axi_item_collected_port.write(curr_it);
            end

        end   
   endtask          


endclass:hough_axi_monitor    

`endif