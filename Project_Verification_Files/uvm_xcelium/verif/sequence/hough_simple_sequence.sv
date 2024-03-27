`ifndef HOUGH_SIMPLE_SEQUENCE_SV
    `define HOUGH_SIMPLE_SEQUENCE_SV

    parameter AXI_BASE = 5'b00000;
    parameter START_REG_OFFSET = 0;
    parameter RESET_REG_OFFSET = 4;
    parameter WIDTH_REG_OFFSET = 8;
    parameter HEIGHT_REG_OFFSET = 12;
    parameter RHO_REG_OFFSET = 16;
    parameter TRESHOLD_REG_OFFSET = 20;
    parameter READY_REG_OFFSET = 24;

    parameter TRESHOLD = 149;

    int width,height;
    int rho;

class hough_simple_sequence extends hough_base_sequence;

    int i = 0;
    int j = 0;
    

    covergroup img_data_cover();
        option.per_instance = 1;
        img_pix_value : coverpoint hough_item.img_data_cont_i{
            bins low_value = {[0:85]};
            bins medium_value = {[86:170]};
            bins high_value = {[171:255]};
        }
    endgroup

    `uvm_object_utils(hough_simple_sequence)
    hough_seq_item hough_item;


    function new(string name = "hough_simple_sequence");
        super.new(name);

        img_data_cover = new();
    endfunction : new

    virtual task body();

        //Loading throug configuration files
        width = p_sequencer.cfg.width;
        height = p_sequencer.cfg.height;
        rho = p_sequencer.cfg.rho;

        
        
        hough_item = hough_seq_item::type_id::create("hough_item");

        // //  ***********************   INITALIZATION OF THE SYSTEM    ***********************//
        
        $display("AXI initialization starts...\n");
        `uvm_do_with(hough_item,{   hough_item.bram_axi == 1;   hough_item.s00_axi_awaddr == AXI_BASE+START_REG_OFFSET;     hough_item.s00_axi_wdata == 32'd0;});                       
        `uvm_do_with(hough_item,{   hough_item.bram_axi == 1;   hough_item.s00_axi_awaddr == AXI_BASE+RESET_REG_OFFSET;     hough_item.s00_axi_wdata == 32'd1;});


        // //  ***********************   SETTING IMAGE PARAMETERS    ***********************//
        $display("\nSetting image parameters...\n\n");
        `uvm_do_with(hough_item,{   hough_item.bram_axi == 1;   hough_item.s00_axi_awaddr == AXI_BASE+WIDTH_REG_OFFSET;     hough_item.s00_axi_wdata == width;});                            
        `uvm_do_with(hough_item,{   hough_item.bram_axi == 1;   hough_item.s00_axi_awaddr == AXI_BASE+HEIGHT_REG_OFFSET;    hough_item.s00_axi_wdata == height;});
        `uvm_do_with(hough_item,{   hough_item.bram_axi == 1;   hough_item.s00_axi_awaddr == AXI_BASE+RHO_REG_OFFSET;       hough_item.s00_axi_wdata == rho;}); 
        `uvm_do_with(hough_item,{   hough_item.bram_axi == 1;   hough_item.s00_axi_awaddr == AXI_BASE+TRESHOLD_REG_OFFSET;  hough_item.s00_axi_wdata == TRESHOLD;});                             
        
        
        //  ***********************     PRELOADING ZEROS IN ACC0 AND ACC1   ***********************//
        `uvm_info(get_name(), $sformatf("UBACIVANJE NULA U AKUMULATOR ACC0 I ACC1"),   UVM_HIGH)
        $display("\nAccumulators loading begins...\n");

        for ( i = 0 ; i < p_sequencer.cfg.rho*135 ; i ++)
        begin
            start_item(hough_item);
                hough_item.bram_axi = 0;
                hough_item.acc0_we_cont = 4'b1111;
                hough_item.acc0_addr_cont_i = i*4;
                hough_item.acc0_data_cont_i = p_sequencer.cfg.acc0_data[i];

                hough_item.acc1_we_cont = 4'b1111;
                hough_item.acc1_addr_cont_i = i*4;
                hough_item.acc1_data_cont_i = p_sequencer.cfg.acc1_data[i];
                
            finish_item(hough_item);
        end

        $display("\nAccumulators preloaded!\n");


        //  ***********************    LOADING AN IMAGE    ***********************//

        $display("\nImage loading begins...\n");
            
            for ( i = 0 ; i < p_sequencer.cfg.width*p_sequencer.cfg.height ; i ++)
            begin
                start_item(hough_item);
                hough_item.img_we_cont = 4'b1111;
                hough_item.img_addr_cont_i = i*4;         
                hough_item.img_data_cont_i = p_sequencer.cfg.img_data[i];
                img_data_cover.sample();
                finish_item(hough_item);
            end

         start_item(hough_item);
             hough_item.bram_axi = 0;
             
             hough_item.img_we_cont = 4'b0000;
             hough_item.img_addr_cont_i = 19'd0;
             hough_item.img_data_cont_i = 32'd0;
         finish_item(hough_item);  

        $display("\nImage loaded and set!\n");

        //  ***********************     START THE PROCESSING   ***********************//   

        $display("\nStarting the system... \n");
        `uvm_do_with(hough_item,{   hough_item.bram_axi == 1; hough_item.s00_axi_awaddr == AXI_BASE+START_REG_OFFSET; hough_item.s00_axi_wdata == 32'd1;});  

        // ************************ READING ACCUMULATOR VALUES AFTER PROCESSING  ***********************//

        $display("Initiate reading from accumulators");
        for ( j = 0 ; j < p_sequencer.cfg.rho*135 ; j ++)
        begin
           start_item(hough_item);
               hough_item.bram_axi = 0;
        
               hough_item.acc0_we_cont = 4'd0;
               hough_item.acc0_addr_cont_i = j*4;
               hough_item.acc0_data_cont_i = 32'd0;

               hough_item.acc1_we_cont = 4'd0;
               hough_item.acc1_addr_cont_i = j*4;
               hough_item.acc1_data_cont_i = 32'd0;      
           finish_item(hough_item);
        end

        $display("\n All done!\n");

    endtask : body

endclass : hough_simple_sequence
`endif 
