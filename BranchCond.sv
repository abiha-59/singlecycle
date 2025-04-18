module BranchCond(
    input logic [6:0] instr_opcode,
    input logic [2:0] funct3,
    input logic [31:0] rdata1,rdata2,
    output logic br_taken
);

//page number 732 of Harrson Harris

localparam [2:0] BEQ  = 3'b000;
localparam [2:0] BNE  = 3'b001;
localparam [2:0] BLT  = 3'b100;
localparam [2:0] BGE  = 3'b101;
localparam [2:0] BLTU = 3'b110;
localparam [2:0] BGEU = 3'b111;

always_comb begin
    case(instr_opcode)
        7'b1100011: begin      // B_type instructions set
            case(funct3)
                BEQ : br_taken = (rdata1 == rdata2);
                BNE : br_taken = (rdata1 != rdata2);
                BLT : br_taken = (rdata1 < rdata2);
                BGE : br_taken = (rdata1 >= rdata2);
                BLTU : br_taken = (rdata1 < rdata2);
                BGEU : br_taken = (rdata1 >= rdata2);
                default : br_taken = 1'b0;
            endcase
        end

        7'b1100111 , 7'b1101111 : br_taken = 1'b1;    // JAL and JALR_type instructions set
        default : br_taken = 1'b0;

    endcase
end
endmodule

