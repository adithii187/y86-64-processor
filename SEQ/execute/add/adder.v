module full_adder
    (input  A, 
    input B, 
    input Cin, 
    output  signed sum, 
    output signed carry);

    xor xor1(AxorB, A, B);
    and and1(andout1, A, B);

    xor xor2(sum, AxorB, Cin);
    and and2(andout2, AxorB, Cin);
    
    or or1(carry, andout1, andout2);

endmodule
module adder (Sum, A, B, add_cc);
input  [63:0] A;
input  [63:0] B;
output reg[0:2]add_cc;
output signed [63:0] Sum;
wire overflow;
wire [64:0]carry;

assign carry[0] = 1'b0;

    generate
        for (genvar i = 0; i < 64; i = i + 1)
        begin
            full_adder inst1(A[i], B[i], carry[i], Sum[i], carry[i+1]);
        end
        // assign overflow=x1;
    endgenerate
   
always @(*) begin

    if(Sum == 0) begin
        add_cc[0] = 1'b1;
    end

    else begin
        add_cc[0] = 1'b0;
    end

    if(Sum<0)begin
        add_cc[1] = 1'b1;
    end

    else begin
        add_cc[1] = 1'b0;
    end

    // if (carry[63] != carry[64]) begin
    //     add_cc[2] = 1'b1; // Overflow 
    // end else begin
    //     add_cc[2] = 1'b0; 
    // end
    if(((A<0) == (B<0) )&&((Sum<0) !=(A<0)))begin
        add_cc[2] = 1'b1; // Overflow 
    end else begin
        add_cc[2] = 1'b0; 
    end
end
// if ((a < 1'b0 == b < 1'b0) && (result < 1'b0 != a < 1'b0)) begin
//             of = 2'b01;
//         end
endmodule