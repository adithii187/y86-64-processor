

// `include "and/andgate.v"
// `include "sub/subtractor.v"
// `include "xor/xorgate.v"
// `include "sub/full_adder.v"
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

    
module xorgate(xor_out,A,B, xor_cc);

  input signed [63:0] A;    
  input signed [63:0] B;
  output [63:0] xor_out;
  output reg[2:0] xor_cc;
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
module andgate(AND,A,B, and_cc);

    input signed [63:0] A;    
    input signed [63:0] B;
    output signed [63:0] AND;
    output reg[2:0] and_cc;
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
module ALU_A(icode, valA, valC, alu_A);

input [3:0]icode;
input signed[63:0] valA;   //valA and valC are words(8bytes)
input signed[63:0] valC;

output reg signed [63:0] alu_A;

always@(icode, valA, valC)begin

case(icode)
    4'b0010, 4'b0110:begin
        alu_A = valA;
    end
    4'b0011, 4'b0100, 4'b0101:begin
        alu_A = valC;
    end
    4'b1000, 4'b1010:begin
        alu_A = -64'd8;
    end
    4'b1001, 4'b1011:begin
        alu_A = 64'd8; 
    end
endcase
end
endmodule

module ALU_B(icode, valB, alu_B);

input [3:0]icode;
input signed [63:0]  valB;
output reg signed [63:0]  alu_B;

always @(icode, valB) begin

case(icode)
    4'b1010, 4'b1011, 4'b0100, 4'b0101, 4'b1000, 4'b1001, 4'b0110:begin
        alu_B= valB;
    end
    4'b0010, 4'b0011:begin
        alu_B = 64'd0;
    end
endcase
end
endmodule

module ALU(alu_A, alu_B, icode, ifun, valE, CC);

input signed[63:0]alu_A;
input signed[63:0]alu_B;
input [3:0]icode;
input [3:0]ifun;
output reg signed [63:0]valE;
output reg[2:0]CC;

wire signed [63:0] add_out;
wire signed [63:0] sub_out;
wire signed [63:0] and_out;
wire signed [63:0] xor_out;

wire [2:0] add_cc;
wire [2:0] sub_cc;
wire [2:0] and_cc;
wire [2:0] xor_cc;

adder inst1(add_out, alu_A, alu_B, add_cc);
subtractor inst2(sub_out, alu_A, alu_B, sub_cc);
andgate inst3(and_out, alu_A, alu_B, and_cc);
xorgate inst4(xor_out, alu_A, alu_B, xor_cc);

always@(*)begin

case(icode)
//rrmovq, irmovq, rmmovq, mrmovq, call, ret, pushq, popq
    4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b1000, 4'b1001, 4'b1010, 4'b1011:begin
        // case(ifun)
        //     4'b0000:begin
            valE = add_out;
            CC = add_cc;
            // end
        // endcase
    end
    //opq
    4'b0110:begin
        case(ifun)
        4'b0000:begin
            valE = add_out;
            CC = add_cc;
        end
        4'b0001:begin
            valE = sub_out;
            CC = sub_cc;
        end
        4'b0010:begin
            valE = and_out;
            CC = and_cc;
        end
        4'b0011:begin
            valE = xor_out;
            CC = xor_cc;
        end
        endcase
    end
endcase
end
endmodule

module cond(icode, ifun, CC, cnd);

input [3:0]ifun;
input [3:0]icode;
input [2:0]CC;
output reg cnd;

assign zf = CC[0];
assign sf = CC[1];
assign of = CC[2];
//cmov and jmp
always@(*)begin
    case(icode)
        4'b0010, 4'b0111:begin
            case(ifun)
                4'b0000:begin
                    cnd <= 1'b1;
                end
                4'b0001:begin
                    if(sf^of||zf)begin
                        cnd = 1'b1;
                    end else begin
                        cnd = 1'b0;
                    end
                end
                4'b0010:begin
                    if(sf^of)begin
                       cnd = 1'b1;
                    end else begin
                        cnd = 1'b0;
                    end
                end
                4'b0011:begin
                     if(zf)begin
                       cnd = 1'b1;
                    end else begin
                        cnd = 1'b0;
                    end
                end
                4'b0100:begin
                     if(~zf)begin
                       cnd = 1'b1;
                    end else begin
                        cnd = 1'b0;
                    end
                end
                4'b0101:begin
                    if(~(sf^of))begin
                       cnd = 1'b1;
                    end else begin
                        cnd = 1'b0;
                    end
                end
                4'b0110:begin
                     if(~(sf^of)&~zf)begin
                       cnd = 1'b1;
                    end else begin
                        cnd = 1'b0;
                    end
                end
            endcase
        end
    endcase
end

endmodule