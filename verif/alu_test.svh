class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)

    alu_env         alu_env_inst;
  uvm_table_printer printer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        alu_env_inst = alu_env::type_id::create("alu_env_inst", this);
	uvm_config_db#(uvm_object_wrapper)::set(this, "*.seqr.run_phase", "default_sequence", alu_seq::type_id::get());
    printer = new();
    printer.knobs.depth = 5;
    endfunction: build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    // Set verbosity for the bus monitor for this demo
    `uvm_info(get_type_name(),
      $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
    //uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase

endclass : alu_test

class error_test extends alu_test;
    `uvm_component_utils(error_test)

    alu_drv_cb            cb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
	cb = new("cb");
    endfunction: new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase); 
	uvm_callbacks#(alu_driver, alu_drv_cb)::add(alu_env_inst.agent.drv,cb);
	uvm_callbacks#(alu_driver, alu_drv_cb)::display();
    endfunction : connect_phase

endclass: error_test
