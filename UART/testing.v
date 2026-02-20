
module top(input a,
input b,
output c)
always @(posedge clk) begin
  a = b;
  c = a;
end

endmodule 
