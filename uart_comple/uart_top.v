module uart_echo_top #(
    parameter CLK_FREQ  = 27_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire rst,
    input  wire rx,
    output wire tx
);

// -------------------------------------
// Baud Generator
// -------------------------------------
wire baud_tick;
wire oversamples_16;

baud_gen #(
    .CLK_Freq(CLK_FREQ),
    .Baud_Rate(BAUD_RATE)
) baud_inst (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .oversamples_16(oversamples_16)
);

// -------------------------------------
// UART RX
// -------------------------------------
wire [7:0] rx_data;
wire [7:0] rx_data1=8'h54;
wire rx_done;

uart_rx rx_inst (
    .clk(clk),
    .rst(rst),
    .oversamples_16(oversamples_16),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

// -------------------------------------
// UART TX
// -------------------------------------
reg tx_start;
reg [7:0] tx_data;
wire tx_busy;
wire tx_done;

uart_tx tx_inst (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy),
    .tx_done(tx_done)
);
reg [31:0] cnt=0;
// -------------------------------------
// Echo Control Logic
// -------------------------------------
always @(posedge clk) begin
    if (rst) begin
        tx_start <= 0;
        tx_data  <= 0;
    end
    else begin
        tx_start <= 0;  // default
      if (cnt== 10_000_000) begin
        cnt <= 0;
        tx_start <= rx_data1;
      end
      else begin
        cnt<= cnt+1;
      end
    end
end

endmodule