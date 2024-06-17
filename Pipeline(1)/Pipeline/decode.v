module decode(
input clk,
input [3:0] D_icode,
input [3:0] D_ifun,
input [3:0] D_stat,
input [3:0] W_icode,
input [3:0] D_rA,
input [3:0] D_rB,
// input signed [63:0] val_E,
// input signed [63:0] val_M,
input [63:0] D_valC, D_valP,

input [3:0] e_dstE,
input [3:0] M_dstE,
input [3:0] M_dstM,
input [3:0] W_dstM,
input [3:0] W_dstE,
input [63:0] e_valE,
input [63:0] M_valE,
input [63:0] m_valM,
input [63:0] W_valM,
input [63:0] W_valE,

output reg [63:0] d_valA ,d_valB, d_valC,
output reg [3:0] d_srcA ,d_srcB,
output reg [3:0] d_dstE, d_dstM,


output reg  [63:0] rax,
output reg  [63:0] rcx,
output reg  [63:0] rdx,
output reg  [63:0] rbx,
output reg  [63:0] rsp,
output reg  [63:0] rbp,
output reg  [63:0] rsi,
output reg  [63:0] rdi,
output reg  [63:0] r8,
output reg  [63:0] r9,
output reg  [63:0] r10,
output reg  [63:0] r11,
output reg  [63:0] r12,
output reg  [63:0] r13,
output reg  [63:0] r14,
output reg [3:0] d_icode ,d_ifun,
output reg [3:0] d_stat

);

reg [63:0] register[0:14];
// reg  [63:0] d_rvalB, d_rvalA;

initial begin
    // register[0] = 64'b0000;
    // register[1] = 64'b0001;
    // register[2] = 64'b0010;
    // register[3] = 64'b0011;
    // register[4] = 64'd4;   
    // register[5] = 64'b0101;
    // register[6] = 64'b0110;
    // register[7] = 64'b0111;
    // register[8] = 64'b1000;
    // register[9] = 64'b1001;
    // register[10] = 64'b1010;
    // register[11] = 64'b1011;
    // register[12] = 64'b1100;
    // register[13] = 64'b1101;
    // register[14] = 64'b1110;
     register[0] = 64'b0000;
    register[1] = 64'b0000;
    register[2] = 64'b0000;
    register[3] = 64'b0000;
    register[4] = 64'd28;   
    register[5] = 64'b0000;
    register[6] = 64'b0000;
    register[7] = 64'b0000;
    register[8] = 64'b0000;
    register[9] = 64'b0000;
    register[10] = 64'b0000;
    register[11] = 64'b0000;
    register[12] = 64'b0000;
    register[13] = 64'b0000;
    register[14] = 64'b0000;
end


always@(*)    //dstE
begin

   d_icode <= D_icode;
   d_ifun <= D_ifun;
   d_valC <= D_valC;
   d_stat <= D_stat;
   d_dstE = 4'b1111;

    case(D_icode)

        4'b0010,
        4'b0011,
        4'b0110:
        begin
            d_dstE = D_rB;   
        end

        4'b1000,  
        4'b1001,
        4'b1010,
        4'b1011:
        begin
            d_dstE = 4'b0100; 
        end
        
        default
        begin
            d_dstE = 4'b1111;
        end
    endcase
end



always @ (*)  //dstM
begin
    d_dstM = 4'b1111;
    if (D_icode == 4'b0101 || D_icode == 4'b1011) begin
        d_dstM = D_rA;
    end
    else 
    begin
        d_dstM = 4'b1111;
    end
end


always @ (*)  // srcA and srcB
begin
     d_srcA = 4'b1111;
        d_srcB = 4'b1111;
    if (D_icode == 4'b0010) begin // cmovxx
        d_srcA = D_rA;
        //d_srcB = D_rB;
    end
    // else if (D_icode == 4'b0011) begin // irmovq(3)
    //     d_dstE = D_rB;
    // end
    else if (D_icode == 4'b0100) begin // rmmovq(4)
        d_srcA = D_rA;
        d_srcB = D_rB;
    end
    else if (D_icode == 4'b0101) begin // mrmovq(5)
        d_srcB = D_rB;
    end
    else if (D_icode == 4'b0110) begin // opq(6)
        d_srcA = D_rA;
        d_srcB = D_rB;
    end
    else if (D_icode == 4'b1000) begin // call(8)
        d_srcB = 4'b0100; 
    end
    else if (D_icode == 4'b1001) begin // ret(9)
        d_srcA = 4'b0100; 
        d_srcB = 4'b0100; 
    end
    else if (D_icode == 4'b1010) begin // pushq
        d_srcA = D_rA;
        d_srcB = 4'b0100; 
    end
    else if (D_icode == 4'b1011) begin // pop
        d_srcA = 4'b0100; 
        d_srcB = 4'b0100; 
    end
    else begin
        d_srcA = 4'b1111;
        d_srcB = 4'b1111;
    end
end

always@(*)   //valA
   begin
    //d_rvalA=register[d_srcA];
      if(D_icode == 4'b1000 || D_icode == 4'b0111)
         d_valA = D_valP;
      else if((d_srcA == e_dstE) && (e_valE!=4'hF))
         d_valA = e_valE;
      else if((d_srcA == M_dstM) && (m_valM!=4'hF) )
         d_valA = m_valM;
      else if((d_srcA == M_dstE) && ((M_valE!=4'hF)))
         d_valA = M_valE;
      else if((d_srcA == W_dstM) && (W_valM!=4'hF))
         d_valA = W_valM;
      else if((d_srcA == W_dstE) && (W_valE!=4'hF))
         d_valA = W_valE;
      else
         d_valA = register[d_srcA];
   end
   

always@(*)   //valB
   begin
   // d_rvalB=register[d_srcB];
      if(d_srcB == e_dstE)
         d_valB = e_valE;
      else if(d_srcB == M_dstM)
         d_valB = m_valM;
      else if(d_srcB == M_dstE)
         d_valB = M_valE;
      else if(d_srcB == W_dstM)
         d_valB = W_valM;
      else if(d_srcB == W_dstE)
         d_valB = W_valE;
      else
         d_valB = register[d_srcB];
   end
always @ (*)  
begin
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
    case(W_icode)
        4'b0010 : begin                      // cmovXX
            register[W_dstE] = W_valE;
        end

        4'b0011 : begin                     // irmovq
            register[W_dstE] = W_valE;
        end

        4'b0101 : begin                     // mrmovq
            register[W_dstM] = W_valM;
        end

        4'b0110 : begin                     // OPq  
            register[W_dstE] = W_valE;
        end

        4'b1000 : begin                     //call
            register[4] = W_valE;
        end

        4'b1001 : begin                     //ret
            register[4] = W_valE;
        end

        4'b1010 : begin                     //pushq
            register[4] = W_valE;
        end

        4'b1011 : begin                      // popq
            register[4] = W_valE;
            register[W_dstM] = W_valM;
        end
    endcase
end
always @ (posedge clk)  
begin
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