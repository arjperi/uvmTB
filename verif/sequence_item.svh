class basic_seq_item extends uvm_sequence_item;

    function new(string name = "basic_seq_item");
        super.new(name);
    endfunction : new

    rand bit [31:0] seq_item_a;
    rand bit [31:0] seq_item_b;
    bit [31:0] seq_item_c;
    rand bit seq_item_start;

    `uvm_object_utils_begin(basic_seq_item)
        `uvm_field_int(seq_item_a,UVM_ALL_ON)
        `uvm_field_int(seq_item_b,UVM_ALL_ON)
        `uvm_field_int(seq_item_c,UVM_ALL_ON)
        `uvm_field_int(seq_item_start,UVM_ALL_ON)
    `uvm_object_utils_end

endclass : basic_seq_item

typedef  uvm_sequencer#(basic_seq_item) alu_seqr;
