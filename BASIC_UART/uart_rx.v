module uartrx #( parameter clk_freq = 27_000_000,
parameter baud_rate =9600) (
    input clk,
   input rst,
   input  rx,
    output reg done,
    output reg [7:0] rxdata
);

localparam clkcount = clk_freq /baud_rate;
integer count=0;
integer counts=0;
reg uclk=0;
localparam idle=2'b00, start=2'b01;
reg [1:0]state=0;
always @(posedge clk)
    begin
      if(count < clkcount/2)
        count <= count + 1;
      else begin
        count <= 0;
        uclk <= ~uclk;
      end 
    end

reg [7:0] data=0;
    always @(posedge uclk) begin
        if(rst) begin
            rxdata <= 8'h00;
            counts <=0;
            done<=1'b0;

        end
        else begin
            case (state) 
            idle:
            begin
                rxdata<= 8'h00;
                counts<=0;
                done<= 1'b0;
                if(rx== 1'b0) 
                state <= start;
                else 
                state <= idle ;
            end
            start: begin
                if (counts <=7) begin
                    counts <= counts +1;
                    data <= {rx,data[7:1]};
                 end 
                 else begin
                    rxdata<=data;
                    counts <= 0;
                    done <= 1'b1;
                    state <= idle ;
                 end
            end
                default : state <= idle ;
            endcase
        end
    end
endmodule