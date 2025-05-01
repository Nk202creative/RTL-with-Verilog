`include "clock.v"
module tb;
wire clk1;
wire clk2;
wire clk3;
wire clk4;
reg enable ;
reg [7:0] dly;
clock_gen u0(enable,clk1);
clock_gen #(.FREQ(50000), .PHASE(90)) u1 (enable, clk2);

clock_gen #(.FREQ(50000), .PHASE(180)) u2 (enable, clk3);
clock_gen #(.FREQ(50000), .PHASE(45)) u3 (enable, clk4);

initial begin
    $dumpfile(" phase.vcd");
    $dumpvars(0,tb);
end
initial begin
    enable <= 0;
    repeat(10)
    begin
        dly =$random;
        #(dly) enable <= ~enable;
        $display("clock =%0t dly =%0d",$time,dly);

    end
    #50 $finish();
end

endmodule 