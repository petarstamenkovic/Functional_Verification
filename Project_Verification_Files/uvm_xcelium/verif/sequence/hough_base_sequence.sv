`ifndef HOUGH_BASE_SEQUENCE_SV
    `define HOUGH_BASE_SEQUENCE_SV


class hough_base_sequence extends uvm_sequence#(hough_seq_item);

    `uvm_object_utils(hough_base_sequence)
    `uvm_declare_p_sequencer(hough_sequencer)
    
    function new(string name = "hough_simple_sequence");
        super.new(name);
    endfunction : new

    virtual task pre_body();
        uvm_phase phase = get_starting_phase(); 
        if(phase != null)
            phase.raise_objection(this,{"Running sequence '", get_full_name(),"'"});
    endtask : pre_body       
                    
    virtual task post_body();
        uvm_phase phase = get_starting_phase();
        if(phase != null )
            phase.drop_objection(this,{"Completed sequence '",get_full_name(),"'"});
    endtask : post_body

endclass : hough_base_sequence

`endif 
