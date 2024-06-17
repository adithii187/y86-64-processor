module memory_reg(clk, M_bubble,E_stat,E_icode,e_Cnd,e_valE,E_valA,e_dstE,E_dstM,M_stat,M_icode, M_Cnd,M_valE,M_valA,M_dstE,M_dstM);

input clk;
input M_bubble;
input [3:0]E_stat;
input [3:0]E_icode; 
input e_Cnd; 
input [3:0]e_dstE;
input [3:0]E_dstM;
input [63:0]E_valA;
input [63:0]e_valE;

output reg [3:0] M_stat;
output reg [3:0] M_icode; 
output reg M_Cnd;
output reg [3:0]M_dstE;
output reg [3:0]M_dstM;
output reg [63:0]M_valE;
output reg [63:0]M_valA;

always @(posedge(clk))begin
	M_stat <= E_stat;
	M_Cnd <= e_Cnd;
	M_valE <= e_valE;
	M_dstM <= E_dstM;
	M_icode <= E_icode;
	M_dstE <= e_dstE;
	M_valA <= E_valA;
end
endmodule
