module segment7(
    in,
    out
);
input [3:0] in;
output reg [7:0] out;

    always @(*)
     begin
         case (in)
        // decimal  hexavalue
        4'h0: out =8'h3f;
        4'h1: out =8'h06;
        4'h2: out =8'h5b;
        4'h3: out =8'h4f;
        4'h4: out =8'h66;
        4'h5: out =8'h6d;
        4'h6: out =8'h7d;
        4'h7: out =8'h07;
        4'h8: out =8'h7f;
        4'h9: out = 8'h67;
    
        default : out=8'h00;
        endcase
     end

endmodule 

module tb;
reg [3:0] in;
wire [7:0] out;

 segment7 dut(in,out);

 initial begin
     $dumpvars(0,tb);
    $dumpfile("tets.vcd");
    repeat(20) begin
        in= $random % 4'b1111; #10
        $monitor("time:%d in =%b out vale %h",$time,in,out);
        
    end
    #10 $finish;
 end
endmodule 