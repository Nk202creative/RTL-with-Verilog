
`include "uart_top.v"
module uart_tb;
reg clk = 0,rst = 0;
reg rx = 1;
reg [7:0] dintx;
reg newd;
wire rx_tx; 
wire [7:0] doutrx;
wire donetx;
wire donerx;
 
uart_top #(1000000, 9600) dut (.clk(clk), .rst(rst), .rx(rx_tx), .dintx(dintx), .newd(newd), .tx(rx_tx), .doutrx(doutrx)
, .donetx(donetx), .donerx(donerx));
  
always #5 clk = ~clk;  
 
reg [7:0] rx_data = 0;
reg [7:0] tx_data = 0;

initial begin
    $dumpvars(0);
    $dumpfile("uart_pr.vcd");


end
 initial begin
    rst=1;
    #100;
    rst=0;
    dintx=8'h81;
    newd=1;
    #10000;
    newd=0;
    #100;
    newd=1;
    dintx=8'hAA;
    newd=1;
    #100000;

   rst =1; #100 $finish;
 end
endmodule 