module pwm(input clk, 
input rst,
input [7:0]data,
output pwm);
parameter clock= 27_00;
parameter pwm_freq=50; // hertz 
parameter pulse_0=clock/10;
parameter pulse_180=clock/5;
parameter freq_factore= clock/pwm_freq;
parameter bit_freq= $clog2(freq_factore-1);
reg [bit_freq-1:0] frec_fac_cnt=0;
reg pwd_st=0;
// data output 

reg [31:0] duty=0;
reg [31:0] duty_cnt=0;
always @(posedge clk) begin
    if(rst) begin
        pwd_st <=1;
        frec_fac_cnt<=0;
    end
    else begin
        
    if (frec_fac_cnt == freq_factore)
    begin 
        frec_fac_cnt <=0;
        duty_cnt<=0;
    end 
    else begin
        frec_fac_cnt <= frec_fac_cnt+1;
    if (duty_cnt< duty) begin
        pwd_st<=1'b1;
        duty_cnt <= duty_cnt+1;
    end
    else begin
        pwd_st <=0;
    end
    end 
    end
end
always @(*) begin
    duty= pulse_0 + ((pulse_0-pulse_180)*data)/255; 
end
assign pwm=pwd_st;
endmodule 

module tb;
reg rst;
reg [7:0] data=8'h20;
reg clk=0;
wire pwm;

pwm dut(clk,rst, data,pwm);
always #5clk=~clk;
initial begin

    $dumpvars(0,tb);
    $dumpfile("pwm.vcd");
    #5rst=1;
    #5 rst =0;
    
    #1000000; 
    $finish;
end



endmodule 