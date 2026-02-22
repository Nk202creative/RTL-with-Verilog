module uart_rx (
    input  wire clk,
    input  wire rst,
    input  wire oversamples_16,   // 16x baud clock
    input  wire rx,
    output reg  [7:0] rx_data,
    output reg  rx_done
);

reg [3:0] sample_count = 0;
reg [3:0] bit_index = 0;
reg [7:0] data_reg = 0;
reg receiving = 0;

always @(posedge clk) begin
    if (rst) begin
        sample_count <= 0;
        bit_index <= 0;
        receiving <= 0;
        rx_done <= 0;
    end
    else begin
        rx_done <= 0;

        if (oversamples_16) begin

            // Detect start bit
            if (!receiving && rx == 0) begin
                receiving <= 1;
                sample_count <= 0;
                bit_index <= 0;
            end

            else if (receiving) begin
                sample_count <= sample_count + 1;

                // Sample in middle (8th tick)
                if (sample_count == 7) begin
                    if (bit_index == 0) begin
                        // start bit check
                        if (rx == 0)
                            bit_index <= 1;
                        else
                            receiving <= 0; // false start
                    end
                    else if (bit_index <= 8) begin
                        data_reg[bit_index-1] <= rx;
                        bit_index <= bit_index + 1;
                    end
                    else begin
                        // Stop bit
                        receiving <= 0;
                        rx_data <= data_reg;
                        rx_done <= 1;
                    end
                end

                // Reset sample counter every 16 ticks
                if (sample_count == 15)
                    sample_count <= 0;
            end
        end
    end
end

endmodule