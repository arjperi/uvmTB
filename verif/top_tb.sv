`include "src/qtop.sv"
`include "intf/top_intf.sv"
`include "uvm_macros.svh"
`include "verif/env_comp.svh"
module tb_top;

    import uvm_pkg::*;
    top_intf top_intf_inst();

    top dut_inst(
        .a(top_intf_inst.intf_a),
        .b(top_intf_inst.intf_b),
        .c(top_intf_inst.intf_c),
        .clk(top_intf_inst.intf_clk),
        .start(top_intf_inst.intf_start)
    );

    initial begin
        uvm_config_db#(virtual top_intf)::set(null, "*", "top_intf_inst",top_intf_inst);

        top_intf_inst.intf_clk <= 0;
        run_test();
    end

    always
        #5 top_intf_inst.intf_clk = ~top_intf_inst.intf_clk;

endmodule : tb_top
