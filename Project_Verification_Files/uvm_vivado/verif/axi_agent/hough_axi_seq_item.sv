`ifndef HOUGH_AXI_SEQ_ITEM_SV
    `define HOUGH_AXI_SEQ_ITEM_SV

    parameter AXI_BASE = 5'b0000;
    parameter START_REG_OFFSET = 0;
    parameter RESET_REG_OFFSET = 4;
    parameter WIDTH_REG_OFFSET = 8;
    parameter HEIGHT_REG_OFFSET = 12;
    parameter RHO_REG_OFFSET = 16;
    parameter TRESHOLD_REG_OFFSET = 20;
    parameter READY_REG_OFFSET = 24;

    parameter C_S00_AXI_ADDR_WIDTH = 5;
    parameter C_S00_AXI_DATA_WIDTH = 32;

class hough_axi_seq_item extends uvm_sequence_item; 

    // Control signal - 0 For Bram Input and 1 for AXI Lite registers
    rand logic           bram_axi;

    // Accumulator - Bram 
    rand logic [17:0]    acc0_addr_cont_i;
    rand logic [31:0]    acc0_data_cont_i;
    rand logic [3:0]     acc0_we_cont;
   
    rand logic [31:0]    acc0_data_cont_o;
   
    rand logic [17:0]    acc1_addr_cont_i;
    rand logic [31:0]    acc1_data_cont_i;
    rand logic [3:0]     acc1_we_cont;
    
    rand logic [31:0]    acc1_data_cont_o;

    // Image - Bram
    logic [18:0]    img_addr_cont_i;
    logic [31:0]    img_data_cont_i;
    logic [3:0]     img_we_cont;

    // AXI Lite - Here are the main register [width,height and others]
    rand logic [C_S00_AXI_ADDR_WIDTH -1:0] s00_axi_awaddr;
	rand logic [2:0] s00_axi_awprot;
	rand logic s00_axi_awvalid;
	rand logic s00_axi_awready;
	rand logic [C_S00_AXI_DATA_WIDTH -1:0] s00_axi_wdata;
	rand logic [(C_S00_AXI_DATA_WIDTH/8) -1:0] s00_axi_wstrb;
	rand logic s00_axi_wvalid;
	rand logic s00_axi_wready;
	rand logic [1:0] s00_axi_bresp;
	rand logic s00_axi_bvalid;
	rand logic s00_axi_bready;
	rand logic [C_S00_AXI_ADDR_WIDTH -1:0] s00_axi_araddr;
	rand logic [2:0] s00_axi_arprot;
	rand logic s00_axi_arvalid;
	rand logic s00_axi_arready;
	rand logic [C_S00_AXI_DATA_WIDTH - 1:0] s00_axi_rdata;
	rand logic [1:0] s00_axi_rresp;
	rand logic s00_axi_rvalid;
	rand logic s00_axi_rready;

    `uvm_object_utils_begin(hough_axi_seq_item)
        `uvm_field_int(acc0_addr_cont_i, UVM_DEFAULT );
        `uvm_field_int(acc0_data_cont_i, UVM_DEFAULT );
        `uvm_field_int(acc0_we_cont, UVM_DEFAULT );
        `uvm_field_int(acc1_addr_cont_i, UVM_DEFAULT );
        `uvm_field_int(acc1_data_cont_i, UVM_DEFAULT );
        `uvm_field_int(acc1_we_cont, UVM_DEFAULT );

        `uvm_field_int(img_addr_cont_i, UVM_DEFAULT );
        `uvm_field_int(img_data_cont_i, UVM_DEFAULT );
        `uvm_field_int(img_we_cont, UVM_DEFAULT );

        `uvm_field_int(s00_axi_awaddr, UVM_DEFAULT );
        `uvm_field_int(s00_axi_awprot, UVM_DEFAULT );
        `uvm_field_int(s00_axi_awvalid, UVM_DEFAULT );
        `uvm_field_int(s00_axi_awready, UVM_DEFAULT );
        `uvm_field_int(s00_axi_wdata, UVM_DEFAULT);
	    `uvm_field_int(s00_axi_wstrb, UVM_DEFAULT);
	    `uvm_field_int(s00_axi_wvalid, UVM_DEFAULT);
        `uvm_field_int(s00_axi_wready, UVM_DEFAULT);
        `uvm_field_int(s00_axi_bresp, UVM_DEFAULT);
        `uvm_field_int(s00_axi_bvalid, UVM_DEFAULT);
        `uvm_field_int(s00_axi_bready, UVM_DEFAULT);
        `uvm_field_int(s00_axi_araddr, UVM_DEFAULT);
        `uvm_field_int(s00_axi_arprot, UVM_DEFAULT);
        `uvm_field_int(s00_axi_arvalid, UVM_DEFAULT);
        `uvm_field_int(s00_axi_arready, UVM_DEFAULT);
        `uvm_field_int(s00_axi_rdata, UVM_DEFAULT);
        `uvm_field_int(s00_axi_rresp, UVM_DEFAULT);
        `uvm_field_int(s00_axi_rvalid, UVM_DEFAULT);
        `uvm_field_int(s00_axi_rready, UVM_DEFAULT);
    `uvm_object_utils_end
/*
    // Constraint for AXI Lite
    constraint axi_strobe   {s00_axi_wstrb inside{4'b1111, 4'b0000};};
    constraint axi_addreses {s00_axi_awaddr inside{AXI_BASE+START_REG_OFFSET, AXI_BASE+READY_REG_OFFSET, AXI_BASE+HEIGHT_REG_OFFSET, AXI_BASE+WIDTH_REG_OFFSET, AXI_BASE+TRESHOLD_REG_OFFSET, AXI_BASE+RHO_REG_OFFSET, AXI_BASE+RESET_REG_OFFSET};};
    constraint rho_size     {(s00_axi_awaddr == AXI_BASE+RHO_REG_OFFSET) -> (s00_axi_wdata < 474);};
    constraint thr_size     {(s00_axi_awaddr == AXI_BASE+TRESHOLD_REG_OFFSET) -> (s00_axi_wdata < 255);};
*/

    function new( string name = "hough_axi_seq_item");
        super.new(name);
    endfunction : new

endclass : hough_axi_seq_item

`endif