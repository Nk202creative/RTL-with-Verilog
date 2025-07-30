module fifo1 #(parameter fifo_depth=8,
                parameter data_width=32) (
                    input clk,
                    input rst_n,
                    input cs,
                    input wr_en,
                    input rd_en,
                    input [data_width-1:0] data_in,
                    output reg [data_width-1:0] data_out,
                    output empty,
                    output full
                );
// find the counter bit according to depth of fifo 
localparam  fifo_depth_log = $clog2(fifo_depth) ;
// define the dimension of aaray to store the data
reg [data_width-1:0]fifo [0:fifo_depth-1];
// poniter decalartion 
reg [fifo_depth_log:0] write_ptr;  // here we take 1 extra bit in counter for calculation of full and empty 
reg [fifo_depth_log:0] read_ptr; // condition 

// write operation 
always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      begin
        write_ptr <= 0;
      end
      else if (cs && wr_en && !full) begin
   // thid condition for the data in fifo data <= data_in 
           fifo [write_ptr[fifo_depth_log-1:0]] <=   data_in;
           write_ptr <= write_ptr + 1'b1;        
      end
  end
  // read operation

always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
     begin
        read_ptr <= 0;
        data_out <= 0;
    
     end
     else if (cs && rd_en && !empty) begin
        data_out <= fifo[read_ptr[fifo_depth_log-1:0]];
        read_ptr <= read_ptr + 1'b1;
     end
  end

  // flag signala and control logic 
  assign  empty = (read_ptr == write_ptr);
  assign full = (read_ptr == ({~write_ptr[fifo_depth_log],write_ptr[fifo_depth_log-1:0]}));


endmodule

// all module should declare in this way to make the file function well 