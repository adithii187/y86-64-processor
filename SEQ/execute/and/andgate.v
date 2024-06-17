module andgate(AND,A,B, and_cc);

    input signed [63:0] A;    
    input signed [63:0] B;
    output signed [63:0] AND;
    output reg[0:2] and_cc;
  genvar i;
    generate
        for(i=0;i<64;i=i+1)
        begin
            and A1(AND[i],A[i],B[i]);
        end
    endgenerate

    always @(*)begin
        if(AND == 64'b0)begin
            and_cc[0] = 1'b1;
        end else begin
            and_cc[0] = 1'b0;
        end

        if(AND[63] == 1'b1)begin
            and_cc[1] = 1'b1;
        end else begin
            and_cc[1] = 1'b0;
        end

        and_cc[2] = 1'b0;
    end

endmodule