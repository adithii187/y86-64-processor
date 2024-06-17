module fetch_reg(clk,F_stall,f_predPC,F_predPC,f_PC,f_stat,F_stat);

input clk;
input F_stall;
input [63:0] f_predPC;
input [63:0] f_PC;
input [3:0] F_stat;
output reg[63:0] F_predPC;
output reg [3:0] f_stat;
//1 [3] AOK, 2 [2] HLT, 3 [1] invalid address, 4 [0] invalid instr

always @(posedge(clk)) begin
    // F_stat = 4'b0001; 
    f_stat <= F_stat;
	if(!F_stall) begin
		F_predPC <= f_predPC;
    end else begin
        F_predPC <= f_PC;
    end
	
end

endmodule
