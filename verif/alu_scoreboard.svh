`uvm_analysis_imp_decl(_mon);
`uvm_analysis_imp_decl(_drv);
class alu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_scoreboard)
   

    uvm_analysis_imp_mon #(basic_seq_item, alu_scoreboard) sb_mon_ap;
    uvm_analysis_imp_drv #(basic_seq_item, alu_scoreboard) sb_drv_ap;

    protected basic_seq_item mon_txn_q[$];
    protected basic_seq_item drv_txn_q[$];
    int match, mismatch;

    function new (string name, uvm_component parent);
      super.new(name, parent);
      sb_mon_ap = new("sb_mon_ap", this);
      sb_drv_ap = new("sb_drv_ap", this);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    protected function void comp_fn();
        basic_seq_item    mon = mon_txn_q.pop_front();
	basic_seq_item    drv = drv_txn_q.pop_front();
	if(!mon.compare(drv)) begin
	    `uvm_error("Scoreboard Mismatch", $sformatf("%s does not match %s",mon.sprint(), drv.sprint()))
	    mismatch++;
	end 
	else begin
	    `uvm_info(get_type_name(), "SCBD : Transations Matched", UVM_FULL)
	    match++;
	end

    endfunction 

    function void write_mon(basic_seq_item mon_txn);
	`uvm_info(get_type_name, $sformatf("SCBD Monitor transaction %s", mon_txn.sprint()), UVM_FULL)
        mon_txn_q.push_back(mon_txn);
	if(drv_txn_q.size())
	    comp_fn();
    endfunction : write_mon

    function void write_drv(basic_seq_item drv_txn);
	`uvm_info(get_type_name, $sformatf("SCBD Driver transaction %s", drv_txn.sprint()), UVM_FULL)
	prediction(drv_txn);
        drv_txn_q.push_back(drv_txn);
	if(mon_txn_q.size())
	    comp_fn();
    endfunction: write_drv

    function void report_phase( uvm_phase phase );
        `uvm_info("Inorder Comparator", $sformatf("Matches:    %0d", match), UVM_LOW);
        `uvm_info("Inorder Comparator", $sformatf("Mismatches: %0d", mismatch), UVM_LOW);
    endfunction

    function void prediction(basic_seq_item txn);
    /*
    N-1 th bit is Sign
    N-1-Q bits are Integer Part
    Qbits are fractional part
    */
    if (txn.seq_item_a[N-1] == txn.seq_item_b[N-1]) begin
        case(txn.seq_item_a[N-1])
	0: begin
	txn.seq_item_c[N-1] = 0;
	txn.seq_item_c[N-2:0] = txn.seq_item_a[N-2:0] + txn.seq_item_b[N-2:0];
	end
	1: begin
	txn.seq_item_c[N-1] = 1;
	txn.seq_item_c[N-2:0] = txn.seq_item_a[N-2:0] + txn.seq_item_b[N-2:0];
	end
	endcase
    end else if (txn.seq_item_a[N-1] == 0 && txn.seq_item_b[N-1] == 1) begin //a-b
        if(txn.seq_item_a[N-2:0] > txn.seq_item_b[N-2:0]) begin
	    txn.seq_item_c[N-1] = 1;
	end else begin
	    txn.seq_item_c[N-1] = 0;
	end
	txn.seq_item_c[N-2:0] = txn.seq_item_a[N-2:0] - txn.seq_item_b[N-2:0];
    end else begin //b-a
        if(txn.seq_item_a[N-2:0] < txn.seq_item_b[N-2:0]) begin
	    txn.seq_item_c[N-1] = 1;
	end else begin
	    txn.seq_item_c[N-1] = 0;
	end
	txn.seq_item_c[N-2:0] = txn.seq_item_b[N-2:0] - txn.seq_item_a[N-2:0];
    end
    endfunction : prediction

endclass: alu_scoreboard

