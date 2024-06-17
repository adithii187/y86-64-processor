module w_reg(clk,W_stall,m_stat, M_icode, m_dstE, m_dstM,m_valE, m_valM,W_stat, W_icode, W_dstE, W_dstM,W_valE, W_valM);
input clk,W_stall;
input [3:0] m_stat, M_icode, m_dstE, m_dstM;
input [63:0] m_valE, m_valM;

output reg [3:0] W_stat, W_icode, W_dstE, W_dstM;
output reg [63:0] W_valE, W_valM;

always @(posedge clk)
    begin
        if(W_stall!=1)begin
            W_stat <= m_stat;
            W_icode <= M_icode;
            W_valE <= m_valE;
            W_valM <= m_valM;
            W_dstE <= m_dstE; 
            W_dstM <= m_dstM;
        end
    end

endmodule
