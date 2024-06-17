module execute_reg(clk,E_bubble,d_stat,d_icode,d_ifun,d_valC,d_valA,d_valB,d_dstE,d_dstM,d_srcA,d_srcB,E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,
E_srcA,E_srcB,M_icode,e_Cnd);

input clk;
input E_bubble;
input [3:0]d_stat;
input [3:0]d_icode; 
input [3:0]d_ifun; 
input [3:0]d_dstE;
input [3:0]d_dstM;
input [3:0]d_srcA;
input [3:0]d_srcB;
input [63:0]d_valA;
input [63:0]d_valB;
input [63:0]d_valC;
input [3:0] M_icode; 
input e_Cnd;

output reg [3:0] E_stat;
output reg [3:0] E_icode; 
output reg [3:0] E_ifun;
output reg [3:0]E_dstE;
output reg [3:0]E_dstM;
output reg [3:0]E_srcA;
output reg [3:0]E_srcB;
output reg [63:0]E_valC;
output reg [63:0]E_valA;
output reg [63:0]E_valB;


always @(posedge(clk)) begin
	
	if (E_bubble == 1'b1) begin
		
		E_icode <= 4'b0001;
		E_ifun <= 4'b0000;
		E_valA <= 4'b0000;
		E_valB <= 4'b0000;

    end 

	else
	begin
		if(M_icode==7 && e_Cnd==0 && d_stat!=4'b0001)
                E_stat <=4'b0001;
    else begin
        E_stat <= d_stat ;
    end
		E_ifun <= d_ifun;
		E_icode <= d_icode;
		E_valB <= d_valB;
		E_dstE <= d_dstE;
		E_srcB <= d_srcB;
		E_valC <= d_valC;
		E_srcA <= d_srcA;
		E_valA <= d_valA;
		E_dstM <= d_dstM;
		
    end
	
	
end
// always @(posedge(clk)) begin
// if(M_icode==7 && e_Cnd==0 && d_stat!=1)
//                 E_stat <=4'h1;
//     else begin
//         E_stat <= d_stat ;
//     end
// end
endmodule
