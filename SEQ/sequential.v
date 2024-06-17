`include "fetch.v"
`include "decode.v"
`include "execute/execute.v"
`include "pc_update.v"
`include "memory.v"

module sequential;

reg [63:0] pc;
reg clk;

wire [3:0] icode, ifun, rA, rB;

wire signed[63:0] val_P, val_C, val_A, val_B, val_E, val_M;

wire instr_valid, imem_error,dmem_er;

wire Cnd, halt;

wire [63:0] pc_update;

wire signed [63:0] rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14;
wire signed[63:0] alu_A;
wire signed[63:0] alu_B;
wire [0:2] CC;
wire idr_temp;
reg AOK;
reg INS;
reg HLT;
reg IDR;

initial begin

    AOK = 1'b1; // Indicates that the instruction is OK.
    INS = 1'b0; // Indicates that there is no invalid instruction.
    HLT = 1'b0; // Indicates that the system is not in a halt state.
    IDR = 1'b0; // Indicates that there is no invalid register.
    clk = 1'b0; // Sets the initial value of the clock signal.
    pc = 64'd0; // Sets the initial value of the program counter.
end

fetch inst0(icode,ifun, rA, rB, pc, val_P, val_C, halt, instr_valid,imem_error,idr_temp,clk);

decode inst1(clk,icode,rA,rB,Cnd,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,val_A,val_B,val_E,val_M);

ALU_A inst3(icode, val_A, val_C, alu_A);
ALU_B inst4(icode, val_B, alu_B);
ALU inst5(alu_A, alu_B, icode, ifun, val_E, CC);
cond inst6(icode, ifun, CC, Cnd);

memory inst7(clk,val_A, val_E,val_P,icode,val_M,dmem_er);

pc_update inst8(clk, icode, Cnd, val_C, val_M, val_P, pc_update);

// always  #10 clk = ~clk;



// always @(*) begin
//     pc = pc_update; 
// end

always @(*) begin
    if(halt || dmem_er) begin
        HLT = halt; // Sets the halt flag if there is a halt signal.
        INS = 1'b0; // Clears the invalid instruction flag.
        AOK = 1'b0; // Clears the OK flag.
        IDR = 1'b0;
    end else if(instr_valid) begin
            INS = instr_valid; // Sets the invalid instruction flag.
            HLT = 1'b0; // Clears the halt flag.
            AOK = 1'b0; // Clears the OK flag.
            IDR = 1'b0;
    end else if(idr_temp)begin
            AOK = 1'b0; // Sets the OK flag.
            HLT = 1'b0; // Clears the halt flag.
            INS = 1'b0; // Clears the invalid instruction flag.
            IDR = idr_temp;
    end else begin
            AOK = 1'b1; // Sets the OK flag.
            HLT = 1'b0; // Clears the halt flag.
            INS = 1'b0; // Clears the invalid instruction flag.
            IDR = 1'b0;
    end
end

always @(*) begin
    if(HLT == 1'b1) begin
        $finish; // Finishes the simulation if the halt signal is high.
    end
    if(INS == 1'b1) begin
        $finish; // Finishes the simulation if the ins signal is high.
    end
    if(IDR == 1'b1) begin
        $finish; // Finishes the simulation if the idr signal is high.
    end
end


always #10 clk = ~clk;
// // $finish;


initial begin
    $monitor("clk = %d PC = %d icode = %b ifun = %b rA = %b rB = %b\n valC = %d\n valP = %d \nvalA = %d \nvalB = %d \nvalE = %d \ncc = %b\ncnd = %b\nvalm = %d\npc _update= %d\n AOK=%d\n HLT=%d\n INS=%d\n IDR=%d\nimem_er=%d\ndmem_error=%b\ninstr_valid=%b",clk,pc,icode,ifun,rA,rB,val_C,val_P,val_A,val_B,val_E,CC,Cnd,val_M,pc,AOK,HLT,INS,IDR,imem_error, dmem_er, instr_valid);
    $dumpfile("seq3.vcd");
    $dumpvars(0,sequential);

    //  IDR = 0; // Indicates that there is no invalid register.
    // clk = 0; // Sets the initial value of the clock signal.
    // pc = 64'd0; // Sets the initial value of the program counter.
    // clk = 0;
    // // #10;

    // #10 clk = ~clk;
    // #10 clk = ~clk;
    // #10 clk = ~clk;
    // #10 clk = ~clk;
    // #10 clk = ~clk;
    // #10 clk = ~clk;
    // $finish;

end
always @(posedge clk) begin
    pc = pc_update; // Updates the program counter.
end
// always @(*) begin
//     pc = pc_update; // Updates the program counter.
// end

endmodule