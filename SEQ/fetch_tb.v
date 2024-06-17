// `include "fetch.v"
module fetch_tb;

reg [63:0]PC;
reg clk;

wire halt, instr_valid, imem_error,IDR;
wire [63:0]val_P;
wire [63:0]val_C;
wire [3:0] icode;
wire [3:0] ifun;
wire [3:0] rA;
wire [3:0] rB;

fetch uut(
    .icode(icode),
    .ifun(ifun),
    .rA(rA),
    .rB(rB),
    .PC(PC), 
    .val_P(val_P),
    .val_C(val_C),
    .halt(halt),
    .instr_valid(instr_valid),
    .imem_error(imem_error), 
    .IDR(IDR),
    .clk(clk)
    );
     
initial 
     begin
        $dumpfile("fetch_tb.vcd");
        $dumpvars(0,fetch_tb);
     
    clk = 0;
    PC = 64'd0;
#100
    #10 clk=~clk;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;

    #10 clk=~clk;PC=val_P;

    #10 clk=~clk;


     end

initial begin
    
        $monitor("clk = %d, PC = %d, icode = %d, ifun = %d, rA = %d, rB = %d,\n valC = %h,\n valP = %d \n",clk,PC,icode,ifun,rA,rB,val_C,val_P);
end

endmodule