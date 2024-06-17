module decode_reg(clk,D_bubble,D_stall,f_rA,f_rB,f_valC,f_valP,f_stat,f_icode,f_ifun,instr_valid, imem_error, halt,D_rA,D_rB,D_valC,D_valP,D_stat,D_icode,D_ifun);
input clk;
input D_bubble;
input D_stall;
input [3:0]f_rA;
input [3:0]f_rB;
input [63:0]f_valC;
input [63:0]f_valP;
input [3:0]f_stat;
input [3:0]f_icode;
input [3:0]f_ifun;
input instr_valid, imem_error, halt;

output reg [3:0] D_rA;
output reg [3:0] D_rB;
output reg [63:0] D_valC;
output reg [63:0] D_valP;
output reg [3:0] D_stat;
output reg [3:0] D_icode;
output reg [3:0] D_ifun;
reg [3:0] stat;
// always @(posedge(clk)) begin
//     if(!D_stall)
//     begin
//         case (D_bubble)
// 				4'h1: begin
// 					D_icode <= 4'h1;
// 					D_ifun <= 4'h0;
//           D_rA <= 4'hF;
//         D_rB <= 4'hF;
//         D_valC <= 64'b0;
//         D_valP <= 64'b0;
//           D_stat<=4'b0001;
// 				end
// 				default: begin
// 					//D_stat = f_stat;
// 					D_icode <= f_icode;
// 					D_ifun <= f_ifun;
// 					D_rA <= f_rA;
// 					D_rB <= f_rB;
// 					D_valC <= f_valC;
// 					D_valP <= f_valP;
// 				end
// 		endcase 
//     end
//     else begin
//    D_icode <= D_icode;
//         D_ifun <= D_ifun;
//         D_rA <= D_rA;
//         D_rB <= D_rB;
//         D_valC <= D_valC;
//         D_valP <= D_valP;
//         D_stat <= D_stat;
//  end
    
// end
// always @(posedge(clk)) begin
//      if(!D_stall)
//    begin
//       if(!D_bubble) begin
//      D_stat<=stat;
//       end
//    end
  
// end


always @(posedge clk)
begin
if (D_stall==1'b0 && D_bubble==1'b0)
begin
   D_icode <= f_icode;
        D_ifun <= f_ifun;
        D_rA <= f_rA;
        D_rB <= f_rB;
        D_valC <= f_valC;
        D_valP <= f_valP;
        D_stat <= stat;
end

if (D_stall==1'b1 && D_bubble==1'b0)
begin
  D_icode <= D_icode;
        D_ifun <= D_ifun;
        D_rA <= D_rA;
        D_rB <= D_rB;
        D_valC <= D_valC;
        D_valP <= D_valP;
        D_stat <= D_stat;
end

if (D_stall==1'b0 && D_bubble==1'b1)
begin
   D_icode <= 4'h1;
        D_ifun <= 4'h0;
        D_rA <= 4'hF;
        D_rB <= 4'hF;
        D_valC <= 64'b0;
        D_valP <= 64'b0;
        D_stat <= 4'b0001;
end

if (D_stall==1'b1 && D_bubble==1'b1)
begin
   D_icode <= D_icode;
        D_ifun <= D_ifun;
        D_rA <= D_rA;
        D_rB <= D_rB;
        D_valC <= D_valC;
        D_valP <= D_valP;
        D_stat <= D_stat;
end

end



always @(*)
begin
    if (instr_valid)
    stat = 4'b1000;
    else if (imem_error)
    stat = 4'b0100;
    else if (f_icode==4'h0)
    stat = 4'b0010;
    else 
    stat = 4'b0001;
end


			
endmodule
