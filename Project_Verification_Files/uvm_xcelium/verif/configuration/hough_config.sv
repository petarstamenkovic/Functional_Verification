parameter HALF_THETA = 135;
parameter NUMBER_OF_PICTURES = 12;

class hough_config extends uvm_object;

    uvm_active_passive_enum is_active = UVM_ACTIVE;  // Decide if agents are ACTIVE(monitor,agent,sqr) or PASSIVE(monitor only)

    randc int rand_test_init;
    int rand_test_num;

    string img_properties[NUMBER_OF_PICTURES];
    string acc0_gv_file[NUMBER_OF_PICTURES];
    string acc1_gv_file[NUMBER_OF_PICTURES];
    string img_file[NUMBER_OF_PICTURES];
    string acc0_file[NUMBER_OF_PICTURES];
    string acc1_file[NUMBER_OF_PICTURES];
    string num;

    int width = 0;
    int height = 0;
    int rho = 0;

    int fd = 0;
    int i = 0;
    int tmp;

    int acc0_gv_arr[$];
    int acc1_gv_arr[$];
    int coverage_goal_cfg;

    int img_data[$];
    int acc0_data[$];
    int acc1_data[$];

    `uvm_object_utils_begin(hough_config)
        `uvm_field_enum(uvm_active_passive_enum,is_active,UVM_DEFAULT)
    `uvm_object_utils_end

    constraint rand_constr { 
        rand_test_init>0;
        rand_test_init<12;} 

    function new(string name = "hough_config");
        super.new(name);
        
        img_properties[0] = "../../../../../files\/img_properties.txt";
        acc0_gv_file[0] = "../../../../../golden_vectors\/acc0_gv.txt";
        acc1_gv_file[0] = "../../../../../golden_vectors\/acc1_gv.txt";
        img_file[0] = "../../../../../files\/slika.txt";
        acc0_file[0] = "../../../../../files\/acc0.txt";
        acc1_file[0] = "../../../../../files\/acc1.txt";

        for(int j = 1; j <= NUMBER_OF_PICTURES;j++)
        begin
            num.itoa(j);
            img_properties[j] = {"../../../../../files\/img_properties_",num,".txt"};
            
            acc0_gv_file[j] =   {"../../../../../golden_vectors\/acc0_gv_",num,".txt"};
            acc1_gv_file[j] =   {"../../../../../golden_vectors\/acc1_gv_",num,".txt"};

            img_file[j] =       {"../../../../../files\/slika_",num,".txt"};
            acc0_file[j] =      {"../../../../../files\/acc0_",num,".txt"};
            acc1_file[j] =      {"../../../../../files\/acc1_",num,".txt"};
            
        end
    endfunction 

    function void extracting_data();

        rand_test_num = rand_test_init;
        $display("rand_test_num : %d", rand_test_num);

    //**************************          UCITAVANJE PARAMETARA SLIKE         **************************//
        
        fd = $fopen(img_properties[rand_test_num],"r");
        if(fd) begin 
            `uvm_info(get_name(), $sformatf("Successfully opened img_file"),UVM_HIGH)

            $fscanf(fd, "%d\n", width);
            $display("width: %d", width);
            $fscanf(fd, "%d\n", height);
            $display("height: %d", height);
            $fscanf(fd, "%d\n", rho);
            $display("rho: %d", rho);  
        end
        else begin
            `uvm_info(get_name(), $sformatf("Error opening slika.txt"),UVM_HIGH)    
        end
        $fclose(fd);
 

    //**************************   FUNKCIJA ZA UCITAVANJE ZLATNIH VEKTORA    **************************//
    //**************************        ZA AKUMULATORE ACC0 I ACC1           **************************//

        fd = $fopen(acc0_gv_file[rand_test_num],"r");
        if(fd) begin 
            `uvm_info(get_name(), $sformatf("Successfully opened acc0_gv file"),UVM_HIGH)
            while(!$feof(fd)) 
            begin
                $fscanf(fd ,"%f\n",tmp);
                acc0_gv_arr.push_back(tmp);
            end
        end
        else begin
            `uvm_info(get_name(), $sformatf("Error opening acc0_gv_file"),UVM_HIGH)    
        end
        $display("ACC0 golden vectors stored to acc0_gv_arr successfully %d",rand_test_num);
        $fclose(fd);

        fd = $fopen(acc1_gv_file[rand_test_num],"r");
        if(fd) begin 
            `uvm_info(get_name(), $sformatf("Successfully opened acc1_gv_file"),UVM_HIGH)
            while(!$feof(fd)) 
            begin
                $fscanf(fd ,"%f\n",tmp);
                acc1_gv_arr.push_back(tmp);
            end
        end
        else begin
            `uvm_info(get_name(), $sformatf("Error opening acc1_gv_file"),UVM_HIGH)    
        end
        $display("ACC1 golden vectors stored to acc1_gv_arr successfully %d",rand_test_num);
        $fclose(fd);

        coverage_goal_cfg = rho * HALF_THETA;


    //**************************   READING FROM AN IMAGE FILE    **************************//



        img_data.delete();

        fd = $fopen(img_file[rand_test_num],"r");
        if(fd) begin 
            `uvm_info(get_name(), $sformatf("Successfully opened img_file %d", rand_test_num),UVM_LOW)
            while(!$feof(fd)) 
            begin
                $fscanf(fd ,"%f\n",tmp);
                img_data.push_back(tmp);
            end
        end
        else begin
            `uvm_info(get_name(), $sformatf("Error opening slika.txt"),UVM_HIGH)    
        end
        $fclose(fd);



    // ************************   READING FROM A ACC0 FILE ********************************//
    

        acc0_data.delete();

        fd = $fopen(acc0_file[rand_test_num],"r");
        if(fd) begin 
            `uvm_info(get_name(), $sformatf("Successfully opened acc0_file"),UVM_HIGH)

            while(!$feof(fd)) 
            begin
                $fscanf(fd ,"%f\n",tmp);
                acc0_data.push_back(tmp);
            end    
        end
        else begin
            `uvm_info(get_name(), $sformatf("Error opening acc0.txt"),UVM_HIGH)    
        end
        $fclose(fd);

   
    // ************************   READING FROM A ACC1 FILE ********************************//
   


        acc1_data.delete();

        fd = $fopen(acc1_file[rand_test_num],"r");
        if(fd) begin 
            `uvm_info(get_name(), $sformatf("Successfully opened acc1_file"),UVM_HIGH)

            while(!$feof(fd)) 
            begin
                $fscanf(fd ,"%f\n",tmp);
                acc1_data.push_back(tmp);
            end 
        end
        else begin
            `uvm_info(get_name(), $sformatf("Error opening acc1.txt"),UVM_HIGH)    
        end
        $fclose(fd);

    endfunction : extracting_data

endclass : hough_config 
