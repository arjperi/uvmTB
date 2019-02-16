parameter N = 32;
`include "src/qadd.sv"

module top(
    input [31:0] a,
    input [31:0] b,
    output [31:0] c,
         input clk,
         input start
    );
        // Inputs
        reg [31:0] a_sig;
        reg [31:0] b_sig;
 
        // Outputs
        reg [31:0] c_sig;
 
        // Instantiate the Unit Under Test (UUT)
        qadd  qadd (a, b, c);
endmodule
