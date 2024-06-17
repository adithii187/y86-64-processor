`include "decode.v"
`include "execute_reg.v"
`include "execute.v"
`include "fetch_reg.v"
`include "fetch.v"
`include "memory_reg.v"
`include "memory.v"
`include "w_reg.v"
`include "control_logic.v"
`include "decode_reg.v"
module processor;

    reg clk;
    wire [63:0] f_PC;
    reg [3:0]F_stat;
    // decode reg
    wire D_bubble;
    wire D_stall;
    wire [3:0]f_rA;
    wire [3:0]f_rB;
    wire [63:0]f_valC;
    wire [63:0]f_valP;
    wire [3:0]f_icode;
    wire [3:0]f_ifun;
    wire instr_valid, imem_error, halt;
    wire [3:0] d_icode,d_ifun,d_stat;

    wire [3:0] D_stat;
    wire [3:0] D_icode;
    wire [3:0] D_ifun;
    wire [63:0] pc_new;
    wire [3:0] f_stat;
    //decode

wire [3:0] D_rA;
wire [3:0] D_rB;
wire Cnd;
// input signed [63:0] val_E,
// input signed [63:0] val_M,
wire [63:0] D_valC, D_valP;

wire [3:0] e_dstE;
wire [3:0] M_dstE;
wire [3:0] M_dstM;
wire [3:0] W_dstM;
wire [3:0] W_dstE;
wire [63:0] e_valE;
wire [63:0] M_valE;
wire [63:0] m_valM;
wire [63:0] W_valM;
wire [63:0] W_valE;

wire [63:0] d_valA ,d_valB, d_valC;
wire [3:0] d_srcA ,d_srcB;
wire [3:0] d_dstE, d_dstM;
wire  [63:0] rax;
wire  [63:0] rcx;
wire  [63:0] rdx;
wire  [63:0] rbx;
wire  [63:0] rsp;
wire  [63:0] rbp;
wire  [63:0] rsi;
wire  [63:0] rdi;
wire  [63:0] r8;
wire  [63:0] r9;
wire  [63:0] r10;
wire  [63:0] r11;
wire  [63:0] r12;
wire  [63:0] r13;
wire  [63:0] r14;

// execute_reg
wire E_bubble;
wire [3:0] E_stat;
wire [3:0] E_icode; 
wire [3:0] E_ifun;
wire [3:0]E_dstE;
wire [3:0]E_dstM;
wire [3:0]E_srcA;
wire [3:0]E_srcB;
wire [63:0]E_valC;
wire [63:0]E_valA;
wire [63:0]E_valB;

//execute
wire  [63:0] alu_A;


wire [63:0]alu_B;


wire [3:0]W_stat;

wire [2:0]CC;
wire outp;

//fetch_reg
wire F_stall;
wire [63:0] f_predPC;
reg [63:0] F_predPC;
  //  input [63:0] f_PC, 
    wire [3:0] W_icode;
    wire [63:0] M_valA;
    wire [3:0] M_icode;
    wire M_Cnd;
    wire [63:0] f_val_P;
    wire [63:0] f_val_C; 
    wire IDR;

    //memory_reg

wire M_bubble;
wire e_Cnd;

wire [3:0] M_stat;
    wire [63:0] addr;

    wire [63:0]data;
    wire read;
    wire write;

    wire dmem_error;
    wire [3:0] m_stat;

wire W_stall;

decode inst0(clk,D_icode,D_ifun,D_stat,W_icode,D_rA, D_rB,D_valC, D_valP,e_dstE,M_dstE,M_dstM,W_dstM,W_dstE,e_valE,M_valE,m_valM,W_valM,W_valE,d_valA ,d_valB, d_valC,d_srcA ,d_srcB,d_dstE, d_dstM,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,d_icode,d_ifun,d_stat);
select_PC inst19(clk, F_predPC, W_valM, M_valA, M_icode, W_icode, M_Cnd, f_PC);

fetch inst1(f_icode,f_ifun, f_rA, f_rB,W_icode,W_valM,M_valA,M_icode,M_Cnd,f_val_P, f_val_C, f_predPC,halt, instr_valid,imem_error, IDR,f_PC,clk);

Addr inst6(M_valE, M_valA, M_icode, addr);
mem_read inst5(M_icode, read);
mem_write inst4(M_icode, write);

data_memory inst3(addr, M_valA, read, write, m_valM, dmem_error);

stat inst2(M_stat, dmem_error, m_stat);

ALU_A inst7(E_icode, E_valA, E_valC, alu_A);

ALU_B inst8(E_icode, E_valB, alu_B);

ALU inst9(alu_A, alu_B,outp, E_icode, E_ifun, e_valE, CC);

destE inst10(e_Cnd, E_dstE, E_icode, e_dstE);

set_CC inst11(W_stat, m_stat, E_icode, outp);
cond inst12(E_icode, E_ifun, CC, e_Cnd);

execute_reg inst13(clk,E_bubble,d_stat,d_icode,d_ifun,d_valC,d_valA,d_valB,d_dstE,d_dstM,d_srcA,d_srcB,E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,
E_srcA,E_srcB,M_icode,e_Cnd);

decode_reg inst14(clk,D_bubble, D_stall,f_rA,f_rB,f_val_C,f_val_P,f_stat,f_icode,f_ifun,instr_valid, imem_error, halt,D_rA,D_rB,D_valC,D_valP,D_stat,D_icode,D_ifun);


memory_reg inst16(clk, M_bubble,E_stat,E_icode,e_Cnd,e_valE,E_valA,e_dstE,E_dstM,M_stat,M_icode, M_Cnd,M_valE,M_valA,M_dstE,M_dstM);

w_reg inst17(clk,W_stall,m_stat, M_icode, M_dstE, M_dstM,M_valE, m_valM,W_stat, W_icode, W_dstE, W_dstM,W_valE, W_valM);

control_logic inst18(D_icode,M_icode,E_icode,m_stat,W_stat,d_srcA,d_srcB,E_dstM,e_Cnd,F_stall,D_stall,W_stall,D_bubble,E_bubble,M_bubble);

initial
    begin
    
    $dumpfile("processor.vcd");
    $dumpvars(0, processor);
    clk = 0;
    F_predPC = 64'd0;
    F_stat=4'b0001;
    //$display("cnd=%d\n",e_Cnd);
    end

always@(posedge clk)
    begin
    F_predPC <= f_predPC;
    if(F_stall)begin
    	F_predPC <= f_PC;
    end
    //$display("f_PC=%d\n",f_PC);
    // if(f_PC==15)begin
    //     $finish;
    // end
    end
    
always #10 clk = ~clk;   
// always@(*)
// begin
//     #10 clk = ~clk;
//     #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// #10 clk = ~clk;
// end

always@(W_stat)
    begin
        
       if(W_stat == 4'b0010)  
            $finish;
        if(W_stat == 4'b0100)  
            $finish;
        if(W_stat == 4'b1000)  
            $finish;
        if(W_stat == 4'b0000)  
            $finish;
    end

endmodule
