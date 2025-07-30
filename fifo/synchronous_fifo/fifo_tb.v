`timescale 1ns/1ns
`include "fifo.v"
module tb();
parameter fifo_depth=8;
parameter data_width=32;
reg clk,rst_n,cs,wr_en,rd_en;
reg [data_width-1:0] data_in;
wire [data_width-1:0] data_out;
wire empty,full;
/*
fifo1 #(fifo_depth,
            data_width) dut (
                    clk,
                    rst_n,
                     cs,
                    wr_en,
                    rd_en,
                    data_in,
                    data_out,
                    empty,
                    full);*/
 


 fifo1 #(.fifo_depth(fifo_depth),
            .data_width(data_width)) dut (
                    .clk(clk),
                    .rst_n(rst_n),
                     .cs(cs),
                    .wr_en(wr_en),
                    .rd_en(rd_en),
                    .data_in(data_in),
                    .data_out(data_out),
                    .empty(empty),
                    .full(full)); 
  // signal stimulation 
initial begin
    clk=0;
end

      always begin #5 clk=~clk; end

   // clock generate for this simulation 
  // create task 
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

  task rd_data ();
    begin
        @(posedge clk)
        cs=1; rd_en=1;
        //#1
        
        @(posedge clk)
        $display($time, " data_ read  %0d",data_out);
        cs =1; rd_en=0;
    end
  endtask
// create signals for test bench 
initial begin
    #1; 
    rst_n =0; rd_en =0; wr_en =0;
    @(posedge clk)
    rst_n =1;
    $display ($time, "\n scenario 1");
    wrt_data(1);
    wrt_data(20);
    wrt_data(120);
    rd_data();
    rd_data();
    rd_data();
    rd_data();
    // second test 
    $display($time,"\n second test");
    for(integer i=0;i<fifo_depth;i=1+i) begin
        wrt_data(2**i);
        rd_data();
    end
    $display($time,"\n second test");
    for(integer i=0;i<fifo_depth;i=1+i) begin
        wrt_data(2**i);
       // rd_data();
    end
    $display($time,"\n second test");
    for(integer i=0;i<fifo_depth;i=1+i) begin
       // wrt_data(2**i);
        rd_data();
    end   
  #50 $finish;

end

  initial begin
      $dumpfile("dump.vcd"); $dumpvars;
   end
endmodule 