module fetch(
    output reg [3:0] icode,
    output reg [3:0] ifun, 
    output reg [3:0] rA, 
    output reg [3:0] rB, 
    input [63:0] PC, 
    output reg signed [63:0] val_P, 
    output reg signed [63:0] val_C, 
    output reg halt, 
    output reg instr_valid,
    output reg imem_error, 
    output reg IDR,
    input clk);

reg [7:0] imem [0:1023]; 

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
    $readmemb("1.txt", imem);
end

always @(*)

begin

    c_f = imem[PC];
    icode = c_f [7:4];
    ifun = c_f [3:0];
    valbit=PC+2;
    valbit_b=PC+1;
    imem_error = (PC > 1023) ? 1 : 0;

    if(imem_error==1)
    begin
        halt=1'b1;

    end

    if(icode==4'b0000) //halt (0)
    begin
        val_P=PC+64'b1;
        halt=1'b1;
    end

    else if(icode==4'b0001) // nop(1)
    begin
        val_P=PC+64'b1;
    end
    
    else if(icode==4'b0010)   //cmovxx (2)
    begin
        A_B = imem[PC+1];
        rA = A_B[7:4];
        rB = A_B[3:0];
        val_C = {imem[PC+1+7],imem[PC+1+6],imem[PC+1+5],imem[PC+1+4],imem[PC+1+3],imem[PC+1+2],imem[PC+1+1],imem[PC+1]};
        if((rA>4'b1110 || rB>4'b1110) || rA<0 || rB<0)
        begin
            IDR = 1'b1;
        end
        val_P = PC + 64'b10;
    end

    else if(icode==4'b0011)   //irmovq (3)
    begin
        A_B = imem[PC+1];
        rA = A_B[7:4];
        rB = A_B[3:0];
        val_C = {imem[PC+2+7],imem[PC+2+6],imem[PC+2+5],imem[PC+2+4],imem[PC+2+3],imem[PC+2+2],imem[PC+2+1],imem[PC+2]};
        val_P = PC + 64'b1010;
        if((rA>4'b1110 && rB>4'b1110) || rA<0 || rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(icode==4'b0100)  //rmmovq (4)
    begin
        A_B = imem[PC+1];
        rA = A_B[7:4];
        rB = A_B[3:0];
        val_C = {imem[PC+2+7],imem[PC+2+6],imem[PC+2+5],imem[PC+2+4],imem[PC+2+3],imem[PC+2+2],imem[PC+2+1],imem[PC+2]};
        val_P = PC + 64'b1010;
        if((rA>4'b1110 || rB>4'b1110) || rA<0 || rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(icode==4'b0101)  //mrmovq (5)
    begin
        A_B = imem[PC+1];
        rA = A_B[7:4];
        rB = A_B[3:0];
        val_C = {imem[PC+2+7],imem[PC+2+6],imem[PC+2+5],imem[PC+2+4],imem[PC+2+3],imem[PC+2+2],imem[PC+2+1],imem[PC+2]};
        val_P = PC + 64'b1010;
        if((rA>4'b1110 || rB>4'b1110) || rA<0 || rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(icode==4'b0110)  //opq (6)
    begin
        A_B = imem[PC+1];
        rA = A_B[7:4];
        rB = A_B[3:0];
        val_P = PC + 64'b10;
        if((rA>4'b1110 || rB>4'b1110) || rA<0 || rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(icode==4'b0111)  //jxx (7)
    begin
    
        val_C = {imem[PC+1+7],imem[PC+1+6],imem[PC+1+5],imem[PC+1+4],imem[PC+1+3],imem[PC+1+2],imem[PC+1+1],imem[PC+1]};
        val_P = PC + 64'b1001;
    end

    else if(icode==4'b1000)  //call (8)
    begin
    
        val_C ={imem[PC+1+7],imem[PC+1+6],imem[PC+1+5],imem[PC+1+4],imem[PC+1+3],imem[PC+1+2],imem[PC+1+1],imem[PC+1]};
        val_P = PC + 64'b1001;
    end

    else if(icode==4'b1001)  //ret(9)
    begin
        val_P = PC + 64'b1;
    end

    else if(icode==4'b1010)  //push(10)
    begin
        A_B = imem[PC+1];
        rA = A_B[7:4];
        rB = A_B[3:0];
        val_P = PC + 64'b10;
        if((rA>4'b1110 && rB>4'b1110) || rA<0 || rB<0)
        begin
            IDR = 1'b1;
        end
    end

    else if(icode==4'b1011)  //pop(11)
    begin
        A_B = imem[PC+1];
        rA = A_B[7:4];
        rB = A_B[3:0];
        val_P = PC + 64'b10;
        if((rA>4'b1110 && rB>4'b1110) || rA<0 || rB<0)
        begin
            IDR = 1'b1;
        end
    end
    
    else begin
        instr_valid=1'b1;
    end

end
endmodule