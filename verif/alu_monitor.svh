class alu_monitor extends uvm_monitor;
    `uvm_component_utils(alu_monitor)

    virtual top_intf                     mon_vif;
    uvm_analysis_port #(basic_seq_item)  mon_ap;

    function new(string name = "alu_monitor", uvm_component p = null);
        super.new(name, p);
	mon_ap = new("mon_ap", this);
    endfunction : new

    function void build();
        super.build();
	if(!uvm_config_db#(virtual top_intf)::get(this,"", "top_intf_inst", mon_vif))
	    `uvm_fatal("NOVIF", {"virtual interface must be set for: ",get_full_name(),".vif"})
    endfunction : build

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
	get_xaction();
    endtask : run_phase

    task get_xaction();
        basic_seq_item txn, txn_clone;
	txn = basic_seq_item::type_id::create(.name("txn"),.contxt(get_full_name()));
	@(posedge mon_vif.intf_clk);
	forever begin
	@(negedge mon_vif.intf_clk )
	txn.seq_item_a = mon_vif.intf_a;
	txn.seq_item_b = mon_vif.intf_b;
	txn.seq_item_c = mon_vif.intf_c;
	txn.seq_item_start = mon_vif.intf_start;
	mon_ap.write(txn);
	//`uvm_info(get_type_name, $sformatf("Monitor transaction %s", txn.sprint()), UVM_LOW)
	end
    endtask : get_xaction

endclass : alu_monitor
