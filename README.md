# Barebone UVM TB
Barebone test bench for an addsub hardware unit.

The purpose of this repository is to show a simple UVM testbench for a small DUT. The target audience is anyone try to learn UVM or create a TB from scratch.  A makefile for VCS is available and will be provided on request. 

This testbench is handy when you want to run any small experients or implement a proof of concept. The compile and run time is very fast (<1min) when compared to your local IP/SoC verification enviroment which tend to compile and run slower owing to a large design and other dependencies. 

The AddSub unit dut code is from [opencores](https://opencores.org/projects/fixed_point_arithmetic_parameterized).

The top level block diagram of the testbench is shown below. 
![tb_top](https://user-images.githubusercontent.com/4466487/54466847-07bf4c80-473f-11e9-95a4-32c7e403a15a.png)
