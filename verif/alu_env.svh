class alu_env extends uvm_env;
    `uvm_component_utils(alu_env)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    alu_agent         agent;
    alu_scoreboard    scbd;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
	agent = alu_agent::type_id::create("agent", this);
	scbd  = alu_scoreboard::type_id::create("scbd",this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.agent_ap_mon.connect(scbd.sb_mon_ap);
        agent.agent_ap_drv.connect(scbd.sb_drv_ap);
    endfunction : connect_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
	if(uvm_verbosity'(recording_detail)> UVM_HIGH) begin
	scbd.sb_mon_ap.debug_connected_to();
	scbd.sb_mon_ap.debug_provided_to();
	scbd.sb_drv_ap.debug_connected_to();
	scbd.sb_drv_ap.debug_provided_to();
	end
   endfunction

endclass : alu_env
