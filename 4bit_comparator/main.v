module com4bit(a,b,eq,gr,le);

input [3:0] a,b;
output eq,gr,le;
assign eq = a==b;
assign le =a<b;
assign gr = a>b;



endmodule 


module tb;
reg [3:0] a,b;
wire  eq,gr,le;

com4bit dut(a,b,eq,gr,le);
integer i;
initial begin
    $dumpvars(0,tb);
    $dumpfile("dut.vcd");
    repeat(10) begin
     #10 a=$random % 4'b1111; b=$random % 4'b1111 ;#10
     $display(" a=%d b= %d eq=%b gr =%b le = %b",a,b,eq,gr,le);
    end
    #10 $finish;
end

endmodule
