`include "transmitter.v"
`include "debounce.v"

module top_uart (
    input  wire clk,        // 25 MHz
    input  wire btn,
    input wire reset,
    output wire TXD
);

    wire btn_db;
    wire btn_pulse;

    reg [7:0] data;
    reg transmit;
    reg [3:0] state;

    // --------------------------------------------------
    // Debounce
    // --------------------------------------------------
    Debounce d1 (
        .clk(clk),
        .btn(btn),
        .transmit(btn_db)
    );

    // --------------------------------------------------
    // One pulse generator
    // --------------------------------------------------
    reg btn_db_d;
    always @(posedge clk) begin
        btn_db_d <= btn_db;
    end
    assign btn_pulse = btn_db & ~btn_db_d;

    // --------------------------------------------------
    // UART Transmitter
    // --------------------------------------------------
    Transmitter t1 (
        .clk(clk),
        .data(data),
        .tranmit(transmit),
        .reset(reset),
        .TxD(TXD)
    );

    // --------------------------------------------------
    // FSM to send "Hello world"
    // --------------------------------------------------
    always @(posedge clk) begin
        transmit <= 0;

        case (state)

            0: if (btn_pulse) begin
                    data <= "H"; state <= 1; transmit <= 1;
               end
            1: begin data <= "e"; state <= 2; transmit <= 1; end
            2: begin data <= "l"; state <= 3; transmit <= 1; end
            3: begin data <= "l"; state <= 4; transmit <= 1; end
            4: begin data <= "o"; state <= 5; transmit <= 1; end
            5: begin data <= " "; state <= 6; transmit <= 1; end
            6: begin data <= "w"; state <= 7; transmit <= 1; end
            7: begin data <= "o"; state <= 8; transmit <= 1; end
            8: begin data <= "r"; state <= 9; transmit <= 1; end
            9: begin data <= "l"; state <= 10; transmit <= 1; end
           10: begin data <= "d"; state <= 0; transmit <= 1; end

            default: state <= 0;
        endcase
    end

endmodule
