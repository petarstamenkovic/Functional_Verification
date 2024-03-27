class hough_scoreboard extends uvm_scoreboard;
    
    bit checks_enable = 1;
    bit coverage_enable = 1;

    hough_config cfg;

    uvm_analysis_imp#(hough_seq_item, hough_scoreboard) item_collected_import;

    int num_of_tr;

    `uvm_component_utils_begin(hough_scoreboard)
        `uvm_field_int(checks_enable, UVM_DEFAULT)
        `uvm_field_int(coverage_enable, UVM_DEFAULT)
    `uvm_component_utils_end

    function new(string name = "hough_scoreboard", uvm_component parent = null);
        super.new(name,parent);
        item_collected_import = new("item_collected_import", this);

        if(!uvm_config_db#(hough_config)::get(this, "", "hough_config", cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    function void write(hough_seq_item curr_it);
        if(checks_enable)
        begin
            `uvm_info(get_type_name(),$sformatf("\n[Scoreboard] Scoreboard function write called..."),UVM_MEDIUM);
            asrt_acc0  :  assert(curr_it.acc0_data_cont_o == cfg.acc0_gv_arr[curr_it.acc0_addr_cont_i/4])
                `uvm_info(get_type_name(),$sformatf("\nACC0 match succesfull\nObserved value is %d, expected is %d.\n",
                                                    curr_it.acc0_data_cont_o, 
                                                    cfg.acc0_gv_arr[curr_it.acc0_addr_cont_i/4]),UVM_MEDIUM)
            else
            `uvm_error(get_type_name(),$sformatf("\nObserved mismatch for acc0[%d]\n Observed value is %d, expected is %d.\n",
                                                    curr_it.acc0_addr_cont_i/4, 
                                                    curr_it.acc0_data_cont_o, 
                                                    cfg.acc0_gv_arr[curr_it.acc0_addr_cont_i/4]))


            asrt_acc1  :  assert(curr_it.acc1_data_cont_o == cfg.acc1_gv_arr[curr_it.acc1_addr_cont_i/4])                                        
                `uvm_info(get_type_name(),$sformatf("\nACC1 match succesfull\nObserved value is %d, expected is %d.\n",
                                                    curr_it.acc1_data_cont_o, 
                                                    cfg.acc1_gv_arr[curr_it.acc1_addr_cont_i/4]),UVM_MEDIUM)
            else
                `uvm_error(get_type_name(),$sformatf("\nObserved mismatch for acc1[%d]\n Observed value is %d, expected is %d.\n",
                                                    curr_it.acc1_addr_cont_i/4, 
                                                    curr_it.acc1_data_cont_o, 
                                                    cfg.acc1_gv_arr[curr_it.acc1_addr_cont_i/4]))                                        
            
            ++num_of_tr;
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Hough scoreboard examined: %0d transactions", num_of_tr), UVM_LOW);
    endfunction : report_phase

endclass