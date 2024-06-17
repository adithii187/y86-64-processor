module Addr(M_valE, M_valA, M_icode, addr);

    input [3:0] M_icode;
    input [63:0] M_valE;
    input [63:0] M_valA;
    output reg [63:0] addr;

    always@(*)
    begin
    case(M_icode)
    4'b1001, 4'b1011:begin
        addr = M_valA;
    end
    4'b0100, 4'b0101, 4'b1001, 4'b1000:begin
        addr = M_valE;
    end
    endcase
    end
endmodule

module mem_read(M_icode, read);

    input [3:0] M_icode;
    output reg read;

    always@(*)begin
        case(M_icode)
        4'b0101, 4'b1011, 4'b1001:begin
            read = 1'b1;
        end
        default: begin
            read = 'b0;
        end
    endcase
    end
endmodule

module mem_write(M_icode, write);

    input [3:0] M_icode;
    output reg write;

    always@(*)begin
        case(M_icode)
        4'b0100, 4'b1010, 4'b1000:begin
            write = 1'b1;
        end
        default: begin
            write = 'b0;
        end
    endcase
    end
endmodule

module data_memory(addr, M_valA, read, write, m_valM, dmem_error);

    input [63:0] addr;
    input [63:0]M_valA;
    input read;
    input write;
    
    output reg [63:0] m_valM;
    output reg dmem_error;

    reg [63:0] mem[1023:0];


    always@(*) begin
        dmem_error = 1'b0; //do i have to initialize 
        if((addr < 0) || (addr > 64'd1023)) begin
            dmem_error=1'b1;
        end else begin

            if(write == 1'b1 & read == 1'b0)begin //double && or &
                mem[addr] = M_valA;
            end

            if(read == 1'b1 & write == 1'b0)begin
                m_valM = mem[addr];
            end
        end
    end
      
endmodule

module stat(M_stat, dmem_error, m_stat);

    input dmem_error;
    input [3:0] M_stat;
    output reg[3:0] m_stat;

    always@(*)begin
        if(dmem_error)begin
            // m_stat[0] = 1'b0;
            // m_stat[1] = 1'b1;
            // m_stat[2] = 1'b0;
            m_stat = 4'b0100;
        end else begin
            m_stat = M_stat;
        end
    end
endmodule
