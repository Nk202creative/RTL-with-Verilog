module servo_top(
    input clk,
    output pwm
);
parameter delay =10;
parameter clock=27_000_000;
parameter index=clock/delay;
parameter bit_delay= $clog2(index-1);
reg [bit_delay-1:0] cnt_delay=0;
reg [7:0] data=0;

pwm u0(.clk(clk), 
.rst(send),
.data(data),
.pwm(pwm));

always @(posedge clk) begin 
    if (cnt_delay == index-1) begin
        data<= data +1;
        
    end
    else begin
        cnt_delay <= cnt_delay +1;
    end

end 

endmodule 