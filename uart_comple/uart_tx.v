module uart_tx (
    input  wire clk,
    input  wire rst,
    input  wire baud_tick,      // 1x baud tick
    input  wire tx_start,       // pulse to start transmission
    input  wire [7:0] tx_data,
    output reg  tx,
    output reg  tx_busy,
    output reg  tx_done
);

reg [3:0] bit_index;
reg [9:0] shift_reg;   // start + 8 data + stop

always @(posedge clk) begin
    if (rst) begin
        tx <= 1'b1;      // idle state
        tx_busy <= 0;
        tx_done <= 0;
        bit_index <= 0;
        shift_reg <= 10'b1111111111;
    end
    else begin
        tx_done <= 0;

        if (tx_start && !tx_busy) begin
            // Load frame: {stop, data, start}
            shift_reg <= {1'b1, tx_data, 1'b0};
            tx_busy <= 1;
            bit_index <= 0;
        end
        else if (baud_tick && tx_busy) begin
            tx <= shift_reg[0];          // send LSB first
            shift_reg <= shift_reg >> 1;
            bit_index <= bit_index + 1;

            if (bit_index == 9) begin
                tx_busy <= 0;
                tx_done <= 1;
                tx <= 1'b1;              // return to idle
            end
        end
    end
end

endmodule