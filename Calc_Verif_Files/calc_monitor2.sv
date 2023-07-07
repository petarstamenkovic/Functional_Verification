class calc_monitor2 extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;
   
   //definition of a port
   uvm_analysis_port #(calc_seq_item) item_collected_port;

   `uvm_component_utils_begin(calc_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   // The virtual interface used to drive and view HDL signals.
   virtual interface calc_if vif;

   // current transaction
   calc_seq_item curr_it;

   // coverage can go here
   // ...

   function new(string name = "calc_monitor", uvm_component parent = null);
      super.new(name,parent);
      if (!uvm_config_db#(virtual calc_if)::get(null, "*", "calc_if2", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
   endfunction : connect_phase

   task main_phase(uvm_phase phase);
       forever begin
        @(posedge vif.clk);
        curr_it = calc_seq_item::type_id::create("curr_it", this);
        if(vif.req_cmd_in == 4'b0010 || vif.req_cmd_in == 4'b0001 || vif.req_cmd_in == 4'b0101 || vif.req_cmd_in == 4'b0110)
        begin
            curr_it.cmd = vif.req_cmd_in;
            curr_it.operand1 = vif.req_data_in;
            @(posedge vif.clk);
            curr_it.operand2 = vif.req_data_in;
            @(posedge vif.clk iff vif.out_resp);
            item_collected_port.write(curr_it);   //sending it through a port
        end
       end
   endtask : main_phase

endclass : calc_monitor2
