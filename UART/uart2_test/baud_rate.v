module baud_rate(
    input wire clk,
    output  baud_tick
);
parameter clock= 25_00;
parameter baud_rate= 960;
parameter index= clock/baud_rate;
parameter bit_baud_cnt= $clog2(index-1);

reg [bit_baud_cnt-1:0] bd_cnt=0;
reg bd_st;
initial begin
    $display(" bit index %d",index);
    $display(" bit bau cnd %d",bit_baud_cnt);

end
always @(posedge clk) begin
    if(index==bd_cnt)
    begin
        bd_st<=1'b1;
        bd_cnt <=0;
    end
    else begin
        bd_st<=0;
        bd_cnt <= bd_cnt+1;
    end
    
end
assign baud_tick = bd_st;
endmodule
module tb;
reg clk=0;
wire baud_tick;
always #5 clk=~clk;
baud_rate dut(clk,baud_tick);
initial begin
    $dumpfile("RAW.vcd");
    $dumpvars(0,tb);
    #1000_00;
    $finish;
    
end

endmodule 