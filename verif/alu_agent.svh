class alu_agent extends uvm_agent;
    `uvm_component_utils(alu_agent)
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    alu_driver        drv;
    alu_monitor       mon;
    alu_seqr          seqr;

   uvm_analysis_port#(basic_seq_item) agent_ap_mon;
   uvm_analysis_port#(basic_seq_item) agent_ap_drv;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

	agent_ap_mon = new("agent_ap_mon", this);
	agent_ap_drv = new("agent_ap_drv", this);
	mon = alu_monitor::type_id::create("mon", this);
	if(get_is_active() == UVM_ACTIVE) begin
	    drv = alu_driver::type_id::create("drv", this);
	    seqr = alu_seqr::type_id::create("seqr", this);
	end
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
	if(get_is_active() == UVM_ACTIVE) begin	
	    drv.seq_item_port.connect(seqr.seq_item_export);
	    drv.drv_ap.connect(agent_ap_drv);
	end 
	    mon.mon_ap.connect(agent_ap_mon);
    endfunction : connect_phase

endclass : alu_agent    
