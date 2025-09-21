module tb;
  
  logic signed [3:0] a, b, result;
  logic sign, cout, overflow,sign_flagh,zero_flagh;
  int expected;

  alu dut(.A(a),
          .B(b),
          .sign(sign),
          .Result(result),
          .Cout(cout),
          .Overflow(overflow),
          .sign_flagh(sign_flagh),
          .zero_flagh(zero_flagh));

  initial begin
    // additon 
    sign = 0;
    $display("Addition test");
    for (int i = -8; i < 8; i++) begin
      for (int j = -8; j < 8; j++) begin
        a = i; b = j;
         #10;

        expected = i + j;

        if (expected > 7 || expected < -8) begin
          // expect overflow
          if (overflow != 1)
            $display("ERROR: %0d+%0d expected overflow, got sum=%0d ovf=%0d  sign_flagh %0b  zero_flagh %0b",i,j,$signed(result),overflow,sign_flagh,zero_flagh);
          else
            $display("PASS:  %0d+%0d= sum=%0d ovf=%0d (overflow OK) sign_flagh %0b  zero_flagh %0b", i,j,$signed(result),overflow,sign_flagh,zero_flagh);
        end else begin
          // no overflow
          if ($signed(result) != expected || overflow != 0)
            $display("ERROR: %0d+%0d = %0d , got sum=%0d ovf=%0d sign_flagh %0b  zero_flagh %0b",i,j,expected,$signed(result),overflow,sign_flagh,zero_flagh);
          else
            $display("PASS:  %0d+%0d = %0d (ovf=%0d) sign_flagh %0b  zero_flagh %0b", i,j,expected,overflow,sign_flagh,zero_flagh);
        end
      end
    end

    // subtraction 
    sign = 1;
    $display("\nSubtraction tests:");
    for (int i = -8; i < 8; i++) begin
      for (int j = -8; j < 8; j++) begin
        a = i; b = j; #1;

        expected = i - j;

        if (expected > 7 || expected < -8) begin
          if (overflow != 1)
            $display("ERROR: %0d-%0d expected overflow, got sum=%0d ovf=%0d sign_flagh %0b  zero_flagh %0b", i,j,$signed(result),overflow ,sign_flagh,zero_flagh);
          else
            $display("PASS:  %0d-%0d sum=%0d ovf=%0d (overflow OK) sign_flagh %0b  zero_flagh %0b",i,j,$signed(result),overflow ,sign_flagh,zero_flagh);
        end else begin
          if ($signed(result) != expected || overflow != 0)
            $display("ERROR: %0d-%0d = %0d , got sum=%0d ovf=%0d sign_flagh %0b  zero_flagh %0b", i,j,expected,$signed(result),overflow,sign_flagh,zero_flagh);
          else
            $display("PASS:  %0d-%0d = %0d (ovf=%0d) sign_flagh %0b  zero_flagh %0b",i,j,expected,overflow,sign_flagh,zero_flagh);
        end
      end
    end
    #10 $stop;
    #100$finish;
  end
endmodule
