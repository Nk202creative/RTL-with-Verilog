
// signa add and sub stract 
module alu(input logic [3:0]A,B,
                input logic sign,
                output logic [3:0] Result,
                output logic Cout,Overflow,sign_flagh,zero_flagh );
wire x0,x1,x2,x3;
wire cin;
reg [3:0] result_buff;
XOR_GATE xr0(.A(sign),.B(B[0]),
  .Y(x0));

  XOR_GATE xr1(.A(sign),.B(B[1]),
  .Y(x1));
  XOR_GATE xr2(.A(sign),.B(B[2]),
  .Y(x2));
  XOR_GATE xr3(.A(sign),.B(B[3]),
  .Y(x3));

ripple_adder rc0(
    .A(A),.B({x3,x2,x1,x0}),
    .Cin(sign),
    .sum(result_buff),
    .Cout(Cout),
    .Cin2(cin)
);
 

// Signed overflow detection
assign Overflow = (A[3] == {x3}) && (Result[3] != A[3]);
assign sign_flagh=result_buff[3];
assign Result=result_buff;
nor g0(zero_flagh,result_buff[3],result_buff[2],result_buff[1],result_buff[0]);

endmodule 


// RC 
module ripple_adder(
    input logic [3:0] A,B,
    input logic Cin,
    output logic [3:0] sum,
    output logic Cout,Cin2
);
 wire w0,w1,w2;
 

 full_adder a0(.A(A[0]),.B(B[0]),.Cin(Cin),.Sum(sum[0]),.Cout(w0));
 full_adder a1(.A(A[1]),.B(B[1]),.Cin(w0),.Sum(sum[1]),.Cout(w1));
 full_adder a2(.A(A[2]),.B(B[2]),.Cin(w1),.Sum(sum[2]),.Cout(w2));
 full_adder a3(.A(A[3]),.B(B[3]),.Cin(w2),.Sum(sum[3]),.Cout(Cout));

assign Cin2= w2;
endmodule 

module full_adder(
    input logic A, // input signal  logic 
    input logic B,
    input logic Cin,
    output logic Sum, // ouput signal logic 
    output logic Cout
);
// implemet by boolean equation 

wire w0,w1,w2;
half_adder g0(A,B,w0,w1);
half_adder g1 (w0,Cin,Sum,w2);
 or g3(Cout,w1,w2); 


endmodule

module half_adder( input logic in1,
                    input logic in2,
                    output logic sum,
                    output logic cout);
                 xor g0(sum,in1,in2);
               // assign sum = in1^in2; // inplimentation of logic 
                and g1(cout,in1,in2);
               // assign cout = in1 & in2;


endmodule 
 
module XOR_GATE( input logic A,B, // IN put signals
  output logic Y); // output signal
// boolean form of XOR gate 
// y = ((~ a & b) | (~ b & a));
wire w0,w1,w2,w3,w4;
   not_gate g0(A,w0);
   not_gate g1(B,w1);
   and_gate g2(A,w1,w2);
   and_gate g3(B,w0,w3);
   or_gate g4(w3,w2,Y);


endmodule
// modules of xor 
// NOT module 
module not_gate(input logic in1, 
          output logic out1);

 not g0(out1,in1);
endmodule
// AND gate module 
module and_gate (input logic in1,in2,
                  output logic out1);
        and g0(out1,in1,in2);

endmodule 
// OR Gate application 

module or_gate(input logic in1,in2,
                  output logic out1);
       or g0(out1,in1,in2);

endmodule 