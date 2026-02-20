module uart(
    //input clk
    input bd_tick,
    output Tx
    //output led
);
reg [7:0] data;
reg [3:0] bit_cnt;
reg [9:0] data_buf={1'b1,8'h41,1'b0};// stop bit< data > start bit 
assign Tx=data_buf[0];
reg [18:0] delay=0;
always @(posedge bd_tick) begin
    if (delay== 10_0) begin
        delay <=0;
    if (bit_cnt < 10) begin
        data_buf<= data_buf>>1;
        bit_cnt<= bit_cnt+1;
    end 
    else begin
        bit_cnt<=0;
        delay <=0;
        
    end
    end
    else begin
        delay<= delay+1;
    end
    
end

endmodule 

module tb;

    reg bd_tick=0;
    wire Tx;
    uart dut0(
    //input clk
    bd_tick,
    Tx
    //output led
);
always #5 bd_tick=~bd_tick;

initial begin
    $dumpvars(0,tb);
    $dumpfile("UART.vcd");
    #10000;
    $finish;
end

endmodule 