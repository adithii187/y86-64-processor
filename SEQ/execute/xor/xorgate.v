module xorgate(xor_out,A,B, xor_cc);

  input signed [63:0] A;    
  input signed [63:0] B;
  output signed [63:0] xor_out;
  output reg[0:2] xor_cc;
  genvar i;
    generate
        for(i=0;i<64;i=i+1)
        begin
            xor A1(xor_out[i],A[i],B[i]);
        end
    endgenerate

    always @(*)begin
        if(xor_out == 64'b0)begin
            xor_cc[0] = 1'b1;
        end else begin
            xor_cc[0] = 1'b0;
        end

        if(xor_out[63] == 1'b1)begin
            xor_cc[1] = 1'b1;
        end else begin
            xor_cc[1] = 1'b0;
        end

        xor_cc[2] = 1'b0;
    end
endmodule