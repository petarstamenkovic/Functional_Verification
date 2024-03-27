`ifndef HOUGH_DRIVER_SV
    `define HOUGH_DRIVER_SV

class hough_driver extends uvm_driver#(hough_seq_item);
    
    `uvm_component_utils(hough_driver)

    virtual interface hough_interface h_vif;
    hough_seq_item seq_item;    

    function new(string name = "hough_driver",uvm_component parent = null);
        super.new(name,parent);
         if (!uvm_config_db#(virtual hough_interface)::get(this, "", "hough_interface", h_vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".h_vif"})    
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    task main_phase(uvm_phase phase);
        forever begin       
            @(posedge h_vif.clk);
            if(h_vif.rst)  
            begin
                seq_item_port.get_next_item(req);
                `uvm_info(get_type_name(), $sformatf("Driver sending...\n%s", req.sprint()), UVM_HIGH);
                
                if(req.bram_axi == 0)
                begin
                    // Fill the bram
                    h_vif.acc0_addr_cont_i = req.acc0_addr_cont_i;
                    h_vif.acc0_data_cont_i = req.acc0_data_cont_i;
                    h_vif.acc0_we_cont = req.acc0_we_cont;
                    h_vif.acc1_addr_cont_i = req.acc1_addr_cont_i;
                    h_vif.acc1_data_cont_i = req.acc1_data_cont_i;
                    h_vif.acc1_we_cont = req.acc1_we_cont;
                    h_vif.img_addr_cont_i = req.img_addr_cont_i;
                    h_vif.img_data_cont_i = req.img_data_cont_i;
                    h_vif.img_we_cont = req.img_we_cont;

                end

                else                
                begin
                    // Axi write transaction
                    $display("\nStarting AXI Transaction...\n");
                    h_vif.s00_axi_awaddr = req.s00_axi_awaddr;
                    h_vif.s00_axi_wdata = req.s00_axi_wdata;
                    h_vif.s00_axi_wstrb = 4'b1111;
                    h_vif.s00_axi_awvalid = 1'b1;
                    h_vif.s00_axi_wvalid = 1'b1;
                    h_vif.s00_axi_bready = 1'b1;
                    
                    @(posedge h_vif.clk iff h_vif.s00_axi_awready);
                    @(posedge h_vif.clk iff !h_vif.s00_axi_awready);
                    #20
                    
                    h_vif.s00_axi_awvalid = 1'b0;
                    h_vif.s00_axi_awaddr = 1'b0;
                    h_vif.s00_axi_wdata = 1'b0;
                    h_vif.s00_axi_wvalid = 1'b0;
                    h_vif.s00_axi_wstrb = 4'b0000;
            
                    @(posedge h_vif.clk iff !h_vif.s00_axi_bvalid); 
                    #20
                    h_vif.s00_axi_bready = 1'b0;


                    // Reading logic

                    if(req.s00_axi_awaddr == AXI_BASE + START_REG_OFFSET && req.s00_axi_wdata == 1)
                    begin
                        $display("\n Entering final detection...\n");
                        h_vif.s00_axi_arprot = 3'b000;
                        h_vif.s00_axi_araddr = AXI_BASE + READY_REG_OFFSET;
                        h_vif.s00_axi_arvalid = 1'b1;
                        //h_vif.s00_axi_arready = 1'b1;
                        h_vif.s00_axi_rready  = 1'b1; 

                        @(posedge h_vif.clk iff h_vif.s00_axi_arready == 0);
                        @(posedge h_vif.clk iff h_vif.s00_axi_arready == 1);
            

                        h_vif.s00_axi_araddr = 5'd0;
                        h_vif.s00_axi_arvalid = 1'b0;
                        //h_vif.s00_axi_rready = 1'b0;

                        wait(h_vif.s00_axi_rdata == 0)

                            $display("\nSystem on the go!\n");
                            h_vif.s00_axi_awaddr = AXI_BASE + START_REG_OFFSET;
                            h_vif.s00_axi_wdata = 32'd0;
                            h_vif.s00_axi_wstrb = 4'b1111;
                            h_vif.s00_axi_awvalid = 1'b1;
                            h_vif.s00_axi_wvalid = 1'b1;
                            h_vif.s00_axi_bready = 1'b1;
                    
                            @(posedge h_vif.clk iff h_vif.s00_axi_awready);
                            @(posedge h_vif.clk iff !h_vif.s00_axi_awready);
                            #20
                            
                            h_vif.s00_axi_awvalid = 1'b0;
                            h_vif.s00_axi_awaddr = 1'b0;
                            h_vif.s00_axi_wdata = 1'b0;
                            h_vif.s00_axi_wvalid = 1'b0;
                            h_vif.s00_axi_wstrb = 4'b0000;
                    
                            @(posedge h_vif.clk iff !h_vif.s00_axi_bvalid); 
                            #20
                            h_vif.s00_axi_bready = 1'b0;
                            $display("\nStart signal taken down! \n");
                            //////////////////////////////////////////////////////
                            $display("\nWaiting for a finishing ready...\n");
                            #20
                            h_vif.s00_axi_arprot = 3'b000;
                            h_vif.s00_axi_araddr = AXI_BASE + READY_REG_OFFSET;
                            h_vif.s00_axi_arvalid = 1'b1;
                            //h_vif.s00_axi_arready = 1'b1;
                            h_vif.s00_axi_rready  = 1'b1;  

                            @(posedge h_vif.clk iff h_vif.s00_axi_arready == 0);
                            @(posedge h_vif.clk iff h_vif.s00_axi_arready == 1);
            
                            wait(h_vif.s00_axi_rdata == 1)
                            h_vif.s00_axi_araddr = 5'd0;
                            h_vif.s00_axi_arvalid = 1'b0;

                            

                            $display("\nDUT finished! \n");

                    end   


                    if(req.s00_axi_awaddr == AXI_BASE + RESET_REG_OFFSET && req.s00_axi_wdata == 1)
                    begin

                        $display("\n Waiting for a ready on the initialization... \n");
                        h_vif.s00_axi_arprot = 3'b000;
                        h_vif.s00_axi_araddr = AXI_BASE + READY_REG_OFFSET;
                        h_vif.s00_axi_arvalid = 1'b1;
                        //h_vif.s00_axi_arready = 1'b1;
                        h_vif.s00_axi_rready  = 1'b1; 

                        @(posedge h_vif.clk iff h_vif.s00_axi_arready == 0);
                        @(posedge h_vif.clk iff h_vif.s00_axi_arready == 1);
            

                        h_vif.s00_axi_araddr = 5'd0;
                        h_vif.s00_axi_arvalid = 1'b0;
                        //h_vif.s00_axi_rready = 1'b0;

                        wait(h_vif.s00_axi_rdata == 1)
                            $display("\nReady detected!\n");
                            h_vif.s00_axi_awaddr = AXI_BASE + RESET_REG_OFFSET;
                            h_vif.s00_axi_wdata = 32'd0;
                            h_vif.s00_axi_wstrb = 4'b1111;
                            h_vif.s00_axi_awvalid = 1'b1;
                            h_vif.s00_axi_wvalid = 1'b1;
                            h_vif.s00_axi_bready = 1'b1;
                    
                            @(posedge h_vif.clk iff h_vif.s00_axi_awready);
                            @(posedge h_vif.clk iff !h_vif.s00_axi_awready);
                            #20
                            
                            h_vif.s00_axi_awvalid = 1'b0;
                            h_vif.s00_axi_awaddr = 1'b0;
                            h_vif.s00_axi_wdata = 1'b0;
                            h_vif.s00_axi_wvalid = 1'b0;
                            h_vif.s00_axi_wstrb = 4'b0000;
                    
                            @(posedge h_vif.clk iff !h_vif.s00_axi_bvalid); 
                            #20
                            h_vif.s00_axi_bready = 1'b0;
                            $display("\nReset signal taken down! \n");



                        //@(posedge h_vif.clk iff h_vif.s00_axi_rvalid == 0);
                        //@(posedge h_vif.clk iff h_vif.s00_axi_rvalid == 1);

                        h_vif.s00_axi_rready = 1'b0;

                    end
                    $display("\nAxi Lite transaction completed! \n");
                end    
            seq_item_port.item_done();      
            end          
        end
    endtask : main_phase  

endclass : hough_driver

`endif 