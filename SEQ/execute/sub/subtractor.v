
module subtractor (Sum, A, B, sub_cc);
input  [63:0] A;
input  [63:0] B;
output reg[0:2]sub_cc;
output signed [63:0] Sum;
wire overflow;
wire [64:0]carry;

wire A_xor[63:0];
    generate
        for (genvar i = 0; i < 64; i = i + 1)
        begin
            xor(A_xor[i], A[i], 1);
        end
    endgenerate

assign carry[0]= 1'b1;

    generate
        for (genvar i = 0; i < 64; i = i + 1)
        begin
            full_adder inst1(A_xor[i],B[i],carry[i] ,Sum[i],carry[i+1]);
        end
    endgenerate
   
always @(*) begin

    if(Sum == 0) begin
        sub_cc[0] = 1'b1;
    end

    else begin
        sub_cc[0] = 1'b0;
    end

    if(Sum<0)begin
        sub_cc[1] = 1'b1;
    end

    else begin
        sub_cc[1] = 1'b0;
    end

    // if (carry[63] != carry[64]) begin
    //     sub_cc[2] = 1'b1; // Overflow
    // end else begin
    //     sub_cc[2] = 1'b0; 
    // end
    if(((A<0) == (B<0 ))&&((Sum<0) !=(A<0)))begin
        sub_cc[2] = 1'b1; // Overflow 
    end else begin
        sub_cc[2] = 1'b0; 
    end
end
endmodule