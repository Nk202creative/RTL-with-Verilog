module evenparity(in,p);
input [3:0] in;
output p;
assign p= in[3]^in[2]^in[1]^in[0];
endmodule

// even parity checked by this , if there if even number of i's in given data so 
// p = zero or wise it high 
// test bench in v 
module tb;
reg [3:0] in;
wire p;
evenparity dut(in,p);
initial begin
    $dumpvars(0,tb);
    $dumpfile("tets.vcd");
    repeat(10) begin
        in= $random % 4'b1111; #10
        $monitor("time :  %d in =%b parity %b",$time,in,p);
        
    end
    #10 $finish;
end

endmodule 