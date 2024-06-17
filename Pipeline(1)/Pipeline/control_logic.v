module control_logic(D_icode,M_icode,E_icode,m_stat,W_stat,d_srcA,d_srcB,E_dstM,e_Cnd,F_stall,D_stall,W_stall,D_bubble,E_bubble,M_bubble);

input [3:0] D_icode;
input [3:0] M_icode;
input [3:0] E_icode;
input [3:0] m_stat;
input [3:0] W_stat;
input [3:0] d_srcA;
input [3:0] d_srcB;
input [3:0] E_dstM; 
input e_Cnd;

output reg F_stall;
output reg D_stall;
output reg W_stall;
output reg D_bubble;
output reg E_bubble;
output reg M_bubble;

initial 
begin
    F_stall=1'b0;
    D_stall=1'b0;
    D_bubble=1'b0; 
    E_bubble=1'b0;
    W_stall=1'b0;

end

always@(*)  begin
    if(((E_icode == 4'b0101) || (E_icode == 4'b1011)) && (E_dstM==4)&& ((E_dstM == d_srcA) || (E_dstM == d_srcB)) ||((D_icode == 4'b1001) || (E_icode == 4'b1001) || (M_icode == 4'b1001)))
        F_stall=1'b1;
    else
    F_stall=1'b0;
    if(((E_icode == 4'b0101) || (E_icode == 4'b1011)) && ((E_dstM == d_srcA) || (E_dstM == d_srcB)))
        D_stall=1'b1;
    else
    D_stall=1'b0;
    if(W_stat == 4'b0100 || W_stat == 4'b1000 || W_stat == 4'b0010) 
    // if(W_stat!=0)
    W_stall = 1'b1;
    else
    W_stall=1'b0;
    if (D_icode==4'b1001 || E_icode==4'b1001 || M_icode==4'b1001) // stall/bubble condition for ret
    begin
    	F_stall <= 1'b1;
    	D_bubble <= 1'b1; 
    end

//changes 3 to 5 
if(( E_icode == 4'h7 && e_Cnd==0) || !(E_icode == 4'h5 || E_icode == 4'hB)  && (E_dstM == d_srcA || E_dstM== d_srcB)&& (D_icode == 4'h9 || E_icode == 4'h9 || M_icode == 4'h9))
D_bubble =1'd1;
else
D_bubble = 1'd0;
//$display(e_Cnd);

//changes 3 to 5 
if (((E_icode == 4'd7) && !e_Cnd) || ((E_icode == 4'd5 || E_icode == 4'd11) && (E_dstM == d_srcA || E_dstM == d_srcB)))
E_bubble =1'd1;
else
E_bubble = 1'd0;    


if((m_stat == 4'b0100 || m_stat == 4'b1000 || m_stat == 4'b0010) || (W_stat == 4'b0100 || W_stat == 4'b1000 || W_stat == 4'b0010))
M_bubble =1'd1;
else
M_bubble = 1'd0;
end




endmodule
