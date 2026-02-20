
module tb;
reg clk=0;
wire TX;
wire led;
//clk=0;
uart dut(clk,TX,led);
always #5 clk=~clk;
initial begin 
//    alwaya clk= #5~clk;
//clk=0;
#100000 //$stop();
$finish;
end 
initial begin
     $dumpvars(0,tb);
     $dumpfile("uart.vcd");
end

endmodule 