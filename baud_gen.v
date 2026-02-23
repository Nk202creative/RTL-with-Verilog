module baud_gen #(
    parameter CLK_Freq= 27_000_000,
    parameter Baud_Rate =115200
) (
    input  wire clk,
    input  wire rst,
    output wire  tx_enable,
    output wire rx_enable
);
localparam baud_index= CLK_Freq/Baud_Rate;
localparam over_index= (CLK_Freq)/(Baud_Rate*16);
reg [$clog2(baud_index):0] baud_cnt=0;
reg [$clog2(over_index):0] oversample_cnt=0;

always @(posedge clk ) begin
  if (rst) begin
    baud_cnt<=0;
    oversample_cnt<= 0;
    //baud_tick<=0;
   // oversamples_16<=0;
  end    
  else begin
    if(baud_index == baud_cnt) begin
        baud_cnt<=0;
       // baud_tick<=1;
        
    end
    else begin
        baud_cnt<= baud_cnt+1;
       // baud_tick<=0;
    end

    if (over_index == oversample_cnt) begin
       // oversamples_16<=1;
       oversample_cnt<=0;
    end
    else begin
        oversample_cnt <= oversample_cnt+1;
      //  oversamples_16<= 0;
    end
  end
end
    assign tx_enable = (baud_index == baud_cnt);
    assign rx_enable = (over_index == oversample_cnt);
endmodule

`timescale 1ns/1ps

module tb_baud_gen;

parameter CLK_Freq  = 27_000_000;
parameter Baud_Rate = 115200;

reg clk = 0;
reg rst = 1;

wire baud_tick;
wire oversamples_16;

// Instantiate DUT
baud_gen #(
    .CLK_Freq(CLK_Freq),
    .Baud_Rate(Baud_Rate)
) uut (
    .clk(clk),
    .rst(rst),
    .tx_enable(baud_tick),
    .rx_enable(oversamples_16)
);

// 27 MHz clock → period = 37ns
always #18.5 clk = ~clk;

initial begin
    $dumpfile("baud.vcd");
    $dumpvars(0, tb_baud_gen);

    #100 rst = 0;   // release reset
    
    #5_000_000;     // run simulation
    
    $finish;
end

endmodule