module Transmitter(
    input clk,
    input [7:0] data,
    input tranmit,
    input reset,
    output reg TxD

);

// internal register for store the data 
// mimic the timing diagram of UART 
/*
/start_bit\/data[7:0]\/stop bit\
\         /\         /\        /
clk rate = 25Mhz 
Baud rate = 9600
*/
reg [3:0] bit_counter;// total data bit in one fram of UART 
reg [12:0] baud_counter;// baud rate come out clk/baud rate
reg [9:0] shiftRight_register; // for UART Buffer storing 
reg state , next_state; // there is only two mode stanmit or idle mode 
// other flag and status register 
reg shift;
reg load;
reg clear;
// UART transmitting 
always @(posedge clk) begin
if(reset) begin
    state <= 0;// state should goes in 0
    bit_counter<=0; // bit set to 0
    baud_counter<=0; // baud counter also set =0
end    
else  begin
    baud_counter<= baud_counter+1; // baud counter increment by 1 
    if (baud_counter==2604)
    begin
        state <= next_state;
        baud_counter <= 0;
        if (load) begin
        shiftRight_register <={1'b1,data,1'b0};
        if (clear)
        bit_counter <= 0;
        if (shift)
        shiftRight_register <= shiftRight_register >> 1;
        bit_counter <= bit_counter+1;
        end 
    end
    
end
end

// Mealy Machine State 
always @(posedge clk) begin
    load <= 0;
    shift <= 0;
    clear <= 0;
    TxD <= 1;

    case(state)
        0: begin
            if (tranmit)  begin // tranmit button is pressed 
            next_state <= 1; // it move/ switch to tranmission 
            load <= 1;
            shift <= 0; 
            clear <= 0;
        end
        else begin
            next_state <= 0;
            TxD <= 1;
        end
    end
    1: begin 
        if (bit_counter ==10) begin
            next_state <= 0;// it should switch tranmission mode to idle mode 
            clear  <= 0;
        end 
            else begin
                next_state <=0;
                TxD <= 1;
            end
        end
        default: next_state <= 0;
    
    endcase
end  

endmodule 