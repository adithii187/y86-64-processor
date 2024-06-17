module full_adder
    (input A, 
    input B, 
    input Cin, 
    output sum, 
    output carry);

    xor xor1(AxorB, A, B);
    and and1(andout1, A, B);

    xor xor2(sum, AxorB, Cin);
    and and2(andout2, AxorB, Cin);
    
    or or1(carry, andout1, andout2);

endmodule