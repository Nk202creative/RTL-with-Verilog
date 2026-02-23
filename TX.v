module tx(
    input wire clk, rst, tx_enable,wr_enb, 
    input wire [7:0] data_in,
    output reg tx, 
    output busy
);
// state define 
localparam idle_state = 2'b00;
localparam start_state= 2'b01;
localparam data_state = 2'b10;
localparam stop_state = 2'b11;
// internal register 
reg [7:0] data_reg=0;
reg [1:0] state=0;
reg [3:0] bit_cnt=0;

always @(posedge clk) begin
    if (rst) begin
        tx = 1'b1;
       // state = idle_state;
        //bit_cnt =0;
        //data_reg =0;
    end
end 
always @(posedge clk) begin
        case (state) 
        idle_state: begin
            if (wr_enb) begin
                state <= start_state;
                data_reg <= data_in;
                bit_cnt <=0;
            end
        
            else begin
                state <= idle_state;
            end
        end
        start_state : begin
            if (tx_enable) begin
                tx<= 1'b0;
                state <= data_state;
            end
            else begin
                state <= start_state;
            end
        end
        data_state: begin
            if (tx_enable) begin
                if (bit_cnt== 3'h7) 
                state<= stop_state;
                else begin
                    bit_cnt<= bit_cnt+1;
                    tx <= data_reg[bit_cnt];
                end
            end
        end
        stop_state: begin
            if (tx_enable) begin
                tx <= 1'b1;
                state<= idle_state;
            end
        end
        default: begin
            tx <= 1'b1;
            state<= idle_state;
        end
        endcase
    end
    
assign busy = (state !=idle_state);
endmodule