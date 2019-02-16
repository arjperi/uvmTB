class alu_drv_cb extends uvm_callback;

    
    function new(string name = "alu_drv_cb");
        super.new(name);
    endfunction : new


    virtual task corrupt_data(basic_seq_item item);
    item.seq_item_a = 'h1111_1111;
    endtask : corrupt_data

endclass : alu_drv_cb


class alu_driver extends uvm_driver#(basic_seq_item);
    `uvm_component_utils(alu_driver)

    `uvm_register_cb(alu_driver, alu_drv_cb)

    virtual top_intf                     drv_vif;
    uvm_analysis_port #(basic_seq_item)  drv_ap;

    function new(string name = "alu_driver", uvm_component p = null);
        super.new(name, p);
        drv_ap = new("drv_ap",this);
    endfunction : new

    function void build();
        super.build();
        if(!uvm_config_db#(virtual top_intf)::get(this, "" ,"top_intf_inst", drv_vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ",get_full_name(),".vif"})
    endfunction : build

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        get_and_drive();
    endtask : run_phase

    task get_and_drive();
        basic_seq_item     req;
        drv_vif.intf_a = 0;drv_vif.intf_b = 0;drv_vif.intf_c = 0;drv_vif.intf_start = 0;
        forever begin
            @(posedge drv_vif.intf_clk);
            seq_item_port.get_next_item(req);
            drv_vif.intf_a = req.seq_item_a;
            drv_vif.intf_b = req.seq_item_b;
            //drv_vif.intf_c = req.seq_item_c;
            drv_vif.intf_start = req.seq_item_start;
            `uvm_do_callbacks(alu_driver, alu_drv_cb, corrupt_data(req))
            drv_ap.write(req);
            //`uvm_info(get_type_name, $sformatf("Driver transaction %s", req.sprint()), UVM_LOW)
            seq_item_port.item_done();
        end 
    endtask : get_and_drive

endclass : alu_driver
