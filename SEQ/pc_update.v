module pc_update(clk, icode, cnd, valC, valM, valP, pc_update);
    input clk;
    input [3:0] icode;
    input cnd;
    input signed [63:0] valC;
    input signed [63:0]valM;
    input signed [63:0] valP;
    output reg [63:0] pc_update;

    always @(*) begin
        case (icode)
            4'b1000: begin 
                pc_update = valC; 
            end
            4'b1001: begin 
                pc_update = valM; 
            end
            4'b0111: begin 
                if (cnd == 1'b1) begin
                    pc_update = valC; 
                end else begin
                    pc_update = valP; 
                end
            end
            default: begin
                pc_update = valP;
            end
        endcase
    end
endmodule