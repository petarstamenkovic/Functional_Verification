class hough_config extends uvm_object;

    uvm_active_passive_enum is_active = UVM_ACTIVE;  // Decide if agents are ACTIVE(monitor,agent,sqr) or PASSIVE(monitor only)

    `uvm_object_utils_begin(hough_config)
        `uvm_field_enum(uvm_active_passive_enum,is_active,UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "hough_config");
        super.new(name);
    endfunction 

endclass : hough_config 