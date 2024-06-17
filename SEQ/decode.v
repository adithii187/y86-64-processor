module decode(
input clk,
input [3:0] icode,
input [3:0] rA,
input [3:0] rB,
input Cnd,
output reg signed [63:0] rax,
output reg signed [63:0] rcx,
output reg signed [63:0] rdx,
output reg signed [63:0] rbx,
output reg signed [63:0] rsp,
output reg signed [63:0] rbp,
output reg signed [63:0] rsi,
output reg signed [63:0] rdi,
output reg signed [63:0] r8,
output reg signed [63:0] r9,
output reg signed [63:0] r10,
output reg signed [63:0] r11,
output reg signed [63:0] r12,
output reg signed [63:0] r13,
output reg signed [63:0] r14,
output reg signed [63:0] val_A,
output reg signed [63:0] val_B,
input signed [63:0] val_E,
input signed [63:0] val_M
);

reg [63:0] register[0:14];

initial begin
    register[0] = 64'b0000;
    register[1] = 64'b0001;
    register[2] = 64'b0010;
    register[3] = 64'b0011;
    register[4] = 64'd4;   
    register[5] = 64'b0101;
    register[6] = 64'b0110;
    register[7] = 64'b0111;
    register[8] = 64'b1000;
    register[9] = 64'b1001;
    register[10] = 64'b1010;
    register[11] = 64'b1011;
    register[12] = 64'b1100;
    register[13] = 64'b1101;
    register[14] = 64'b1110;
end


always@(*)
begin

    if(icode==4'b0010) //cmovxx
    begin
      val_A=register[rA];
      val_B=register[rB];
    end

    if(icode==4'b0100) //rmmovq(4)
    begin
      val_A=register[rA];
      val_B=register[rB];
    end

    if(icode==4'b0101) //mrmovq(5)
    begin
        val_B=register[rB];
    end

    if(icode==4'b0110) //opq(6)
    begin
        val_A=register[rA];
        val_B=register[rB];
    end

    if(icode==4'b1000) //call(8)
    begin
        val_B=register[4]; //esp
    end

    if(icode==4'b1001) //ret(9)
    begin
        val_A=register[4]; //esp
        val_B=register[4]; //esp
    end

    if(icode==4'b1010) //pushq
    begin
        val_A=register[rA];
        val_B=register[4]; //esp
    end

    if(icode==4'b1011) //pop
    begin
        val_A=register[4]; //esp
        val_B=register[4]; //esp
    end

    rax = register[0];
    rcx = register[1];
    rdx = register[2];
    rbx = register[3];
    rsp = register[4];
    rbp = register[5];
    rsi = register[6];
    rdi = register[7];
    r8 = register[8];
    r9 = register[9];
    r10 = register[10];
    r11 = register[11];
    r12 = register[12];
    r13 = register[13];
    r14 = register[14];

end

always@(posedge clk)
begin
    case(icode)
        4'b0010 : begin                      // cmovXX
            if(Cnd == 1) register[rB] = val_E;
        end

        4'b0011 : begin                     // irmovq
            register[rB] = val_E;
        end

        4'b0101 : begin                     // mrmovq
            register[rA] = val_M;
        end

        4'b0110 : begin                     // OPq  
            register[rB] = val_E;
        end

        4'b1000 : begin                     //call
            register[4] = val_E;
        end

        4'b1001 : begin                     //ret
            register[4] = val_E;
        end

        4'b1010 : begin                     //pushq
            register[4] = val_E;
        end

        4'b1011 : begin                      // popq
            register[4] = val_E;
            register[rA] = val_M;
        end
    endcase
    rax = register[0];
    rcx = register[1];
    rdx = register[2];
    rbx = register[3];
    rsp = register[4];
    rbp = register[5];
    rsi = register[6];
    rdi = register[7];
    r8 = register[8];
    r9 = register[9];
    r10 = register[10];
    r11 = register[11];
    r12 = register[12];
    r13 = register[13];
    r14 = register[14];

end


endmodule

