module memory (
    input clk,
    input signed [63:0] val_A, val_E,val_P,
    //input readin, writein,
    input [3:0] icode,
    output reg signed [63:0] val_M,
    output reg dmem_er
    //output reg data_memory_error = 1'b0
);

    reg [63:0] mem[1023:0];

     always@(*)
     begin
        if(icode==4'b0101) //mrmov(5)
        if((val_E < 0 & val_E > 64'd1023))
        begin
            dmem_er=1;
        end
        else begin
            val_M=mem[val_E];
        end 

        if(icode==4'b1001) //ret(9)
        if((val_A < 0 & val_A > 64'd1023))
        begin
            dmem_er=1;
        end
        else begin
            val_M=mem[val_A];
        end

        if(icode==4'b1011) //pop(11)
        if((val_A < 0 & val_A > 64'd1023))
        begin
            dmem_er=1;
        end
        else begin
            val_M=mem[val_A];
        end

     end

    always@(posedge clk) 
    begin
    if(icode==4'b0100)  //rmmov(4)
    if((val_E < 0 & val_E > 64'd1023))
    begin
        dmem_er=1;
    end
    else
        begin
            mem[val_E]=val_A;
        end

    if(icode==4'b1000) // call(8)
    if((val_E < 0 & val_E > 64'd1023))
    begin
        dmem_er=1;
    end
        else begin
            mem[val_E]=val_P;
        end
    
    if(icode==4'b1010) //push(10)
    if((val_E < 0 & val_E > 64'd1023))
    begin
        dmem_er=1;
    end
        else begin
            mem[val_E]=val_A;
        end
    end

endmodule