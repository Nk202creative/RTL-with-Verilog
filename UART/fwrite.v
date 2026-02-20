module tb;
    integer i;
    integer fd;
     integer a,b,c;
    initial begin
        fd = $fopen("output.txt", "w");

        for (i = 0; i < 10; i = i + 1) begin
            a=3*i;
            b=2*i;
            c=4*i;
            $fdisplay(fd, "%0d %0d %0d %0d ", i,a,b,c);
        end

        $fclose(fd);
    end
endmodule
