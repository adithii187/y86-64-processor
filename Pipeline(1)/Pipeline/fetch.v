module select_PC(clk, F_predPC, W_valM, M_valA, M_icode, W_icode, M_Cnd, f_PC);

input clk;
input [63:0] F_predPC, W_valM, M_valA;
input [3:0] M_icode, W_icode;
input M_Cnd;

output reg [63:0] f_PC;

always @(*)
begin

if (W_icode == 4'b1001)
    f_PC = W_valM;
else if (M_icode == 4'b0111)
    begin
        if(M_Cnd == 1'b0)
            f_PC = M_valA;
        // else pc_new = F_predPC;
    end
else begin
    f_PC = F_predPC;
end
// $display("pc_new = %d\n",pc_new);
end

endmodule


module fetch(
    output reg [3:0] f_icode,
    output reg [3:0] f_ifun, 
    output reg [3:0] f_rA, 
    output reg [3:0] f_rB, 
  //  input [63:0] f_PC, 
    input [3:0] W_icode,
    input [63:0] W_valM,
    input [63:0] M_valA,
    input [3:0] M_icode,
    //input [63:0] F_predPC,
    input M_Cnd,
    output reg [63:0] f_val_P, 
    output reg [63:0] f_val_C, 
    output reg [63:0] f_predPC,
    output reg halt, 
    output reg instr_valid,
    output reg imem_error, 
    output reg IDR,
    input [63:0] f_PC,
    // output reg [63:0] pc_new,
    input clk
    );

reg [7:0] imem [0:1023]; 
// reg [63:0] f_PC;
reg [7:0] c_f, A_B;
reg valbit, valbit_b;
// initial begin
//     imem[0]=8'h80; //1 0
//   // //call
//     {imem[8],imem[7],imem[6],imem[5],imem[4],imem[3],imem[2],imem[1]}=64'd60;
//     // imem[9] = 8'h00;
// // imem64'd
//   //imem
//     imem[60]=8'h90; // 9 0
// end

initial begin
    $readmemb("7.txt", imem);
end



always @(*)

begin

    c_f = imem[f_PC];
    f_icode = c_f [7:4];
    f_ifun = c_f [3:0];
    valbit=f_PC+2;
    valbit_b=f_PC+1;
    imem_error = (f_PC > 1023) ? 1 : 0;
    instr_valid = 1'b0;

    // if(imem_error==1)
    // begin
    //     halt=1'b1;

    // end

    if(f_icode==4'b0000) //halt (0)
    begin
        f_val_P=f_PC+64'b1;
        halt=1'b1;
    end

    else if(f_icode==4'b0001) // nop(1)
    begin
        f_val_P=f_PC+64'b1;
    end
    
    else if(f_icode==4'b0010)   //cmovxx (2)
    begin
        A_B = imem[f_PC+1];
        f_rA = A_B[7:4];
        f_rB = A_B[3:0];
        f_val_C = {imem[f_PC+1+7],imem[f_PC+1+6],imem[f_PC+1+5],imem[f_PC+1+4],imem[f_PC+1+3],imem[f_PC+1+2],imem[f_PC+1+1],imem[f_PC+1]};
        if((f_rA>4'b1110 || f_rB>4'b1110) || f_rA<0 || f_rB<0)
        begin
            IDR = 1'b1;
        end
        f_val_P = f_PC + 64'b10;
    end

    else if(f_icode==4'b0011)   //irmovq (3)
    begin
        A_B = imem[f_PC+1];
        f_rA = A_B[7:4];
        f_rB = A_B[3:0];
        f_val_C = {imem[f_PC+2+7],imem[f_PC+2+6],imem[f_PC+2+5],imem[f_PC+2+4],imem[f_PC+2+3],imem[f_PC+2+2],imem[f_PC+2+1],imem[f_PC+2]};
        f_val_P = f_PC + 64'b1010;
        if((f_rA>4'b1110 && f_rB>4'b1110) || f_rA<0 || f_rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(f_icode==4'b0100)  //rmmovq (4)
    begin
        A_B = imem[f_PC+1];
        f_rA = A_B[7:4];
        f_rB = A_B[3:0];
        f_val_C = {imem[f_PC+2+7],imem[f_PC+2+6],imem[f_PC+2+5],imem[f_PC+2+4],imem[f_PC+2+3],imem[f_PC+2+2],imem[f_PC+2+1],imem[f_PC+2]};
        f_val_P = f_PC + 64'b1010;
        if((f_rA>4'b1110 || f_rB>4'b1110) || f_rA<0 || f_rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(f_icode==4'b0101)  //mrmovq (5)
    begin
        A_B = imem[f_PC+1];
        f_rA = A_B[7:4];
        f_rB = A_B[3:0];
        f_val_C = {imem[f_PC+2+7],imem[f_PC+2+6],imem[f_PC+2+5],imem[f_PC+2+4],imem[f_PC+2+3],imem[f_PC+2+2],imem[f_PC+2+1],imem[f_PC+2]};
        f_val_P = f_PC + 64'b1010;
        if((f_rA>4'b1110 || f_rB>4'b1110) || f_rA<0 || f_rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(f_icode==4'b0110)  //opq (6)
    begin
        A_B = imem[f_PC+1];
        f_rA = A_B[7:4];
        f_rB = A_B[3:0];
        f_val_P = f_PC + 64'b10;
        if((f_rA>4'b1110 || f_rB>4'b1110) || f_rA<0 || f_rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(f_icode==4'b0111)  //jxx (7)
    begin
    
        f_val_C = {imem[f_PC+1+7],imem[f_PC+1+6],imem[f_PC+1+5],imem[f_PC+1+4],imem[f_PC+1+3],imem[f_PC+1+2],imem[f_PC+1+1],imem[f_PC+1]};
        f_val_P = f_PC + 64'b1001;
    end

    else if(f_icode==4'b1000)  //call (8)
    begin
    
        f_val_C ={imem[f_PC+1+7],imem[f_PC+1+6],imem[f_PC+1+5],imem[f_PC+1+4],imem[f_PC+1+3],imem[f_PC+1+2],imem[f_PC+1+1],imem[f_PC+1]};
        f_val_P = f_PC + 64'b1001;
    end

    else if(f_icode==4'b1001)  //ret(9)
    begin
        f_val_P = f_PC + 64'b1;
    end

    else if(f_icode==4'b1010)  //push(10)
    begin
        A_B = imem[f_PC+1];
        f_rA = A_B[7:4];
        f_rB = A_B[3:0];
        f_val_P = f_PC + 64'b10;
        if((f_rA>4'b1110 && f_rB>4'b1110) || f_rA<0 || f_rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(f_icode==4'b1011)  //pop(11)
    begin
        A_B = imem[f_PC+1];
        f_rA = A_B[7:4];
        f_rB = A_B[3:0];
        f_val_P = f_PC + 64'b10;
        if((f_rA>4'b1110 && f_rB>4'b1110) || f_rA<0 || f_rB<0)
        begin
            IDR = 1'b1;
        end
    end
    
    else begin
        instr_valid=1'b1;
    end

end

always @ (*)
begin
    case (f_icode)
        4'b0111, 4'b1000: f_predPC = f_val_C;
        default: f_predPC = f_val_P;
    endcase
end

endmodule
