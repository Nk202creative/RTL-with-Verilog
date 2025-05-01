// started a cock in geenration in verilog with using directive 
`timescale 1ns/1ps
module clock_gen(
    input enable ,
    output reg clk
);
parameter FREQ =1000000 ; // in Khz
parameter PHASE = 0; // in degree 
parameter DUTY = 50;// in percentage 
localparam real clk_pd = 1.0/(FREQ*1e3)*1e9; // convert time period in neno second
 localparam real clk_on = DUTY/100.0*clk_pd; // one period time in ns
localparam real clk_off = (100.0-DUTY)/100.0*clk_pd;// off period time in ns
 localparam real quarter = clk_pd/4; // 1/4 part of period 
 localparam real start_dly = quarter*PHASE/90.0;// delay for phase 

reg start_clk;

initial begin
    $display(" frequency = %0d khz",FREQ);
    $display(" phase  = %0d deg ",PHASE);
    $display("duty = %0d %%",DUTY);
    $display(" period = %0.3f ns",clk_pd);
    $display(" clk on = %0.3f ns", clk_on);
    $display(" clk off = %0.3f ns", clk_off);
    $display(" quarte  = %0.3f ns", quarter);
    $display("start dly = %0.3f ns", start_dly);
end

initial begin
    clk <=  0;
    start_clk <= 0;
end

always @(posedge enable or negedge enable) begin
    if (enable) begin
    #(start_dly) start_clk =1; end
    else 
    begin
        #(start_dly) start_clk =0;
    end
    
end
 
 always @(posedge start_clk) begin
    if (start_clk)
    begin
        clk=1;
        while (start_clk)
         begin
            #(clk_on) clk =0;
            #(clk_off) clk =1;
         end
         clk =0;
    end
 end
endmodule 