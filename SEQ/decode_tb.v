`timescale 1ns / 1ps

module decode_tb;

    parameter CLK_PERIOD = 10; 

  
    reg clk;
    reg [3:0] icode;
    reg [3:0] rA;
    reg [3:0] rB;
    reg [63:0] v0;
    reg [63:0] v1;
    reg [63:0] v2;
    reg [63:0] v3;
    reg [63:0] v4;
    reg [63:0] v5;
    reg [63:0] v6;
    reg [63:0] v7;
    reg [63:0] v8;
    reg [63:0] v9;
    reg [63:0] v10;
    reg [63:0] v11;
    reg [63:0] v12;
    reg [63:0] v13;
    reg [63:0] v14;

    wire signed [63:0] rax;
    wire signed [63:0] rcx;
    wire signed [63:0] rdx;
    wire signed [63:0] rbx;
    wire signed [63:0] rsp;
    wire signed [63:0] rbp;
    wire signed [63:0] rsi;
    wire signed [63:0] rdi;
    wire signed [63:0] r8;
    wire signed [63:0] r9;
    wire signed [63:0] r10;
    wire signed [63:0] r11;
    wire signed [63:0] r12;
    wire signed [63:0] r13;
    wire signed [63:0] r14;
    wire signed [63:0] val_A;
    wire signed [63:0] val_B;

    // Instantiate the unit under test (UUT)
    decode uut (
        .clk(clk),
        .icode(icode),
        .rA(rA),
        .rB(rB),
        .rax(rax),
        .rcx(rcx),
        .rdx(rdx),
        .rbx(rbx),
        .rsp(rsp),
        .rbp(rbp),
        .rsi(rsi),
        .rdi(rdi),
        .r8(r8),
        .r9(r9),
        .r10(r10),
        .r11(r11),
        .r12(r12),
        .r13(r13),
        .r14(r14),
        .val_A(val_A),
        .val_B(val_B)
    );

    // Clock generation
    always begin
        clk = 1'b0;
        #(CLK_PERIOD / 2);
        clk = 1'b1;
        #(CLK_PERIOD / 2);
    end

    // Initialize inputs
    initial begin

        $dumpfile("decode_tb.vcd");
    $dumpvars(0,decode_tb);
    #100
        icode = 4'b0;
        rA = 4'b0;
        rB = 4'b0;
    

        // Wait for some time for initialization
        #100;

        // Test case 1: Cmovxx
        icode = 4'b0010;
        rA = 4'b0101; // Choose any valid register index
        rB = 4'b0001; // Choose any valid register index
        #100;
        $display("Test case 1 cmovxx - val_A = %d, val_B = %d", val_A, val_B);

        // Test case 2: Rmmovq
        icode = 4'b0100;
        rA = 4'b0110; // Choose any valid register index
        rB = 4'b1001; // Choose any valid register index
        #100;
        $display("Test case 2 rmmovq- val_A = %d, val_B = %d", val_A, val_B);

        // Test case 3: Mrmovq
        icode = 4'b0101;
        rA = 4'b1010; // Choose any valid register index
        rB = 4'b0000; // Choose any valid register index
        #100;
        $display("Test case 3 mrmovq- val_A = %d, val_B = %d", val_A, val_B);

        // Test case 4: Opq
        icode = 4'b0110;
        rA = 4'b0111; // Choose any valid register index
        rB = 4'b0010; // Choose any valid register index
        #100;
        $display("Test case 4 opq- val_A = %d, val_B = %d", val_A, val_B);

        // Test case 5: Call
        icode = 4'b1000;
        #100;
        $display("Test case 5 call - val_A = %d, val_B = %d", val_A, val_B);

        // Test case 6: Ret
        icode = 4'b1001;
        #100;
        $display("Test case 6 ret - val_A = %d, val_B = %d", val_A, val_B);

        // Test case 7: Pushq
        icode = 4'b1010;
        rA = 4'b1100; // Choose any valid register index
        #100;
        $display("Test case 7 pushq - val_A = %d, val_B = %d", val_A, val_B);

        // Test case 8: Pop
        icode = 4'b1011;
        #100;
        $display("Test case 8 pop - val_A = %d, val_B = %d", val_A, val_B);

       
        $finish;
    end

endmodule
