class alu_seq extends uvm_sequence#(basic_seq_item);
    `uvm_object_utils(alu_seq)
     basic_seq_item   txn;

     function new(string name = "");
         super.new(name);
     endfunction: new

     task body();
      uvm_test_done.raise_objection(this);
     repeat(15) begin
         txn = basic_seq_item::type_id::create(.name("txn"), .contxt(get_full_name()));
         start_item(txn);
         assert(txn.randomize());
         finish_item(txn);
     end
      uvm_test_done.drop_objection(this);
     endtask : body

endclass : alu_seq
