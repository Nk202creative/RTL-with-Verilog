// Code your design here
module tp(clk,rst,en,wr_en,rd_en,wr_addr,rd_addr,wr_data,rd_data);
  
  input clk, rst, wr_en,rd_en,en;
  input [7:0] wr_data;
  input [4:0] wr_addr,rd_addr;
  output reg [7:0] rd_data;
   integer i;
  reg [7:0] mem[15:0];
  always @(posedge clk)
    begin 
      if (!rst)
        begin 
        /*
        fisrt signal to process
         rst low all memory location contain random unknown value */
          for (i=0; i<16;i=1+i)
            begin 
              mem[i] <= 8'hxx;
            end
        end 
      else begin
        if (en==1)
          begin
          /*
          enle pin high after that is for combination 
          rd , wr 
          0,0 memory contain it data 
          1,0 read operation only 
          0,1 writte operation only
          1,1  both operation */
            if (rd_en==1 && wr_en==0)
              begin
                //mem[w_addr] <= wr_data;
                rd_data <= mem[rd_addr];
              end 
            else if (rd_en==0 && wr_en==1)
              begin
                mem[wr_addr] <= wr_data;
               // rd_data <= mem[rd_addr];
              end 
            else if (rd_en==1 && wr_en==1)
              begin 
                // writte and read both operation 
                mem[wr_addr] <= wr_data;
                rd_data <= mem[rd_addr];
              end 
            else 
              begin
                // memory at is value 
                for (i=0; i<16; i=1+i)
                  begin
                    mem[i]<= mem[i];
                  end 
              end 
          end
        // if enable pin is low 
        else begin
       // memory return it original value 
          for (i=0; i<16; i=1+i)
            begin 
              mem[i]<= mem[i];
            end
        end 
      
        end 
      
       end
    
  

  
    
endmodule  