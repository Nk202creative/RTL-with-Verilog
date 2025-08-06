`timescale 1ns/1ns
`include "dp_ram.v"

module tb;
 reg clk,rst,en,wr_en,rd_en;
// input clk, rst, wr_en,rd_en,en;
  reg [7:0] wr_data;
  reg [4:0] wr_addr,rd_addr;
  wire [7:0] rd_data;
 integer i=0;
 tp dut(clk,rst,en,wr_en,rd_en,wr_addr,rd_addr,wr_data,rd_data);
 
 /*
 task wrt_data(input [data_width-1:0] d_in);
    begin 
        @ (posedge clk)
        cs=1; wr_en =1;
        data_in = d_in;
        $display($time, " data_ enter %0d",data_in);
        @ (posedge clk)
        cs=1; wr_en =0;

    end
  endtask

 */
 // write operation 
  task write( input [7:0]d_in,input [4:0]addr);
  begin
    @(posedge clk)
    en=1;wr_en=1;rd_en=0;
    wr_addr=addr;
    wr_data = d_in;
    $display($time,"data write: address: %h  %h ",wr_data,wr_addr);
    @(posedge clk)
    en=1;wr_en=0;rd_en=0;
  end 
  endtask
// read operation 
  task read(input [4:0] addr_rd);
  begin
    @(posedge clk)
    en=1; rd_en =1; wr_en=0;
    rd_addr=addr_rd;
     $display($time,"data read: address: %h  %h ",rd_data,addr_rd);
     @(posedge clk)
     en=1; rd_en =0; wr_en =0;
  end
  endtask
 initial begin clk=0; end
 always begin clk=#5 ~clk; end

 initial begin
    #10 rst =0;
    #5 rst =1;
    for (i=0; i<20; i=1+i)
    begin 
        
        #10 write($random % 255,i);
    end

    $display(" read operation ");

    for (i=0; i<20; i=1+i)
    begin 
        
        #10 read(i);
    end

    #100 $finish;
 end

initial begin
$dumpvars;
$dumpfile("dp.vcd");
end

endmodule
