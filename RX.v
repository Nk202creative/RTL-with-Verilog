module rx(
    input clk, rst, rx_enable,rdy_clr,rx,
    output reg  rdy,
    output reg [7:0] data_out
);
parameter start_state =2'b00;
parameter data_out_state =2'b01;
parameter stop_state=2'b10;

reg [1:0] state= start_state;
reg [3:0] sample =0;
reg [3:0] index =0;
reg [7:0] temp_data=0;

always @(posedge clk)  begin
    if(rst) begin
        rdy=0;
        data_out=8'h00;

    end
end

always @(posedge clk) begin
    if(rdy_clr)
    begin
        rdy <= 0;
        if (rx_enable) begin
         case (state)
        start_state: begin
            if (rx==0 && sample !=0)
              begin
                sample <= sample +1;

              end
              if (sample == 15) begin
                state<= data_out_state;
                temp_data <=0;
                index<=0;
              end
        end
        data_out_state: begin
            sample <= sample +1;
            if (sample == 4'h8) begin
            temp_data [index]<= rx;
            index <= index +1;

        end
        if (index==8 && sample ==15) begin
            state<= stop_state ;

        end
        end
        stop_state: begin
            if(sample==15) begin
                state <= start_state;
                data_out <= temp_data;
                rdy <= 1'b1;
                sample <= 0;

            end
            else begin
                sample <= sample+1;
            end
        end
         default: begin
            state <= start_state;
         end
         
         endcase
        end
    end
end
endmodule 