module uart(
    input wire clk,
    output wire TX,
    output wire led 
);
// Parameter 
parameter CLK_Freq= 25_0;
parameter Baud_Rate= 60;
parameter Baud_Div= CLK_Freq/Baud_Rate; // find the 
parameter Delay_500ms = CLK_Freq/2;
// message Store ine ROM
reg [7:0] msg [0:12]; 
initial begin 
msg[0]= "H";
msg[1]="e";
msg[2]="l";
msg[3]="l";
msg[4]="o";
msg[5]=" ";
msg[6]="W";
msg[7]= "o";
msg[8]="r";
msg[9]="l";
msg[10]="d";
msg[11]=8'h0D;
msg[12]=8'h0A;
end 
// Local paramete 
localparam Bud_bit= $clog2(Delay_500ms+1);
reg [Bud_bit:0] delay_cnt=0;
reg start_send=0;

// for delay 
always @(posedge clk) begin 
if (delay_cnt==Delay_500ms) begin
delay_cnt <= 0;
start_send<= 1;
end 
else begin 
    delay_cnt <= delay_cnt+1;
    start_send <= 0;
end 
end 
// Uart Tranmsitter 
localparam baud_bit=$clog2(Baud_Div+1);
reg [baud_bit:0] baud_cnt=0;
reg [3:0] bit_cnt=0;
reg [3:0] char_cnt=0;
reg[9:0] shift_reg=10'b1111_1111_11;
reg sending =0;
assign TX =shift_reg[0];


// continous blocking 

always @(posedge clk) begin 
if (start_send && !sending) begin 
sending <= 1;
char_cnt = 0;
bit_cnt <=0;
baud_cnt <=0;
shift_reg <= {1'b1,msg[0],1'b0}; // stop bit, data,start

end 
else  if (sending) begin
    if (baud_cnt == Baud_Div-1) begin
        baud_cnt <= 0;
        shift_reg <= {1'b1,shift_reg[9:1]};
        bit_cnt <= bit_cnt +1;
        if (bit_cnt ==9) begin
            bit_cnt <=0;
            char_cnt <= char_cnt+1;
            if (char_cnt ==12)
            begin
                sending<=0;
            end
            else begin
                shift_reg<= {1'b1,msg[char_cnt+1],1'b0};
            end
        end
    end else begin
      baud_cnt <= baud_cnt+1;
    end
end
end 
assign  led = sending;
endmodule

module tb;
reg clk=0;
wire TX;
wire led;
//clk=0;
uart dut(clk,TX,led);
always #5 clk=~clk;
initial begin 
//    alwaya clk= #5~clk;
//clk=0;
#100000 //$stop();
$finish;
end 
initial begin
     $dumpvars(0,tb);
     $dumpfile("uart.vcd");
end

endmodule 