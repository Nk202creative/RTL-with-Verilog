module Debounce (
    input clk,
    input btn ,
    output reg  transmit
);
reg [18:0] de_counter;
reg sync_reg;
always @(posedge clk) begin
    if (btn != sync_reg) begin
        de_counter <= 0;
        sync_reg <= btn;
    end
    else begin
        if (de_counter < 19'd500_500) begin
            de_counter <= de_counter +1;
        end 
        else begin
            transmit <= sync_reg;
        end 
    end
    
end


endmodule 