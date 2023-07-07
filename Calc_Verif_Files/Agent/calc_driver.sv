`ifndef CALC_DRIVER_SV
`define CALC_DRIVER_SV
class calc_driver extends uvm_driver#(calc_seq_item);

   `uvm_component_utils(calc_driver)
   virtual interface calc_if vif;
   function new(string name = "calc_driver", uvm_component parent = null);
      super.new(name,parent);
   endfunction // new
   
   function void build_phase(uvm_phase phase);
      if (!uvm_config_db#(virtual calc_if)::get(null, "*", "calc_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
      
   endfunction // build_phase
   
   task main_phase(uvm_phase phase);
      forever begin
	 @(posedge vif.clk);	 
	 if (!vif.rst)
	   begin
              seq_item_port.get_next_item(req);
	      
              `uvm_info(get_type_name(),
			$sformatf("Driver sending...\n%s", req.sprint()),
			UVM_HIGH)
			
		  case(req.port)
		  	2'b00:  begin
		  	        vif.req1_data_in = req.operand1;
                    vif.req1_cmd_in = req.cmd;	      
                    @(posedge vif.clk);
                    vif.req1_data_in = req.operand2;
                    vif.req1_cmd_in = 0;	      
                    for(int i =0 ; i<=5 ; i++)
                    begin	      
                        @(posedge vif.clk);
                        if(vif.out_resp1)
                        begin
                            seq_item_port.item_done();
                            break;
                        end
                    end    
	               end
	               
	       2'b01:   begin 
	                vif.req2_data_in = req.operand1;
                    vif.req2_cmd_in = req.cmd;	      
                    @(posedge vif.clk);
                    vif.req2_data_in = req.operand2;
                    vif.req2_cmd_in = 0;	      
                    for(int i =0 ; i<=5 ; i++)
                    begin	      
                        @(posedge vif.clk);
                        if(vif.out_resp2)
                        begin
                            seq_item_port.item_done();
                            break;
                        end
                    end    
	                end 
	                
	       2'b10:  begin 
	               vif.req3_data_in = req.operand1;
                    vif.req3_cmd_in = req.cmd;	      
                    @(posedge vif.clk);
                    vif.req3_data_in = req.operand2;
                    vif.req3_cmd_in = 0;	      
                    for(int i =0 ; i<=5 ; i++)
                    begin	      
                        @(posedge vif.clk);
                        if(vif.out_resp3)
                        begin
                            seq_item_port.item_done();
                            break;
                        end
                    end    
	               end 
	               
	       default: begin
	                vif.req4_data_in = req.operand1;
                    vif.req4_cmd_in = req.cmd;	      
                    @(posedge vif.clk);
                    vif.req4_data_in = req.operand2;
                    vif.req4_cmd_in = 0;
                    for(int i =0 ; i<=5 ; i++)
                    begin	      
                        @(posedge vif.clk);
                        if(vif.out_resp4)
                        begin
                            seq_item_port.item_done();
                            break;
                        end
                        if(i == 5) begin
                            seq_item_port.item_done();
                            end
                    end
                    
	                end
	       endcase   
      end
      end
   endtask : main_phase

endclass : calc_driver

`endif

