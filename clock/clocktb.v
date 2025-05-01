`include "clock.v"
`timescale 1ns/1ps
module tb;
    wire clk1;
    wire clk2;
    wire clk3;
    wire clk4;
  reg enable ;
reg [2:0]  dly;
// for clock eneration 
reg [31:0] seed;
clock_gen u0(enable, clk1);
clock_gen #(.FREQ(200000)) u1(enable,clk2);
clock_gen #(.FREQ(400000)) u2(enable,clk3);
clock_gen #(.FREQ(600000)) u3(enable,clk4);
// vcd file create in this test bench 
initial begin
    $dumpfile("clock.vcd");
    $dumpvars(0,tb);
end
 initial begin
    enable <=0;
    for (integer i=0; i<10; i=1+i)
    begin
        dly = $random;
        #(dly) enable <= ~enable;
         $display("i=%0d dly =%0d",i,dly);
         #50;
         
        
    end
     #50 $finish();
  end

 endmodule 