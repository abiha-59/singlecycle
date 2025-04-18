module LoadStore_Unit(
    input logic[2:0] funct3,
    input logic[6:0] instr_opcode,
    input logic[31:0] ALUResult,
    input logic[31:0] data_rd,
    input logic[31:0] rdata2,
    output logic cs,wr,
    output logic [3:0]  mask,
    output logic[31:0] data_wr,
    output logic[31:0] addr,
    output logic[31:0] rdata
);

parameter[2:0] Byte = 3'b000;
parameter[2:0] HalfWord = 3'b001;
parameter[2:0] Word = 3'b010;
parameter[2:0] Byte_Unsigned = 3'b100;
parameter[2:0] HalfWord_Unsigned = 3'b101;

assign addr = ALUResult;

always_comb begin
    wr=1;
    case(instr_opcode)
        7'b0000011:begin
            wr=1;
            cs=0;
        end
        7'b0100011:begin
            wr=0;
            cs=0;
        end
    endcase
end

//now we have to read data from data memory aand write back into register file
// here we are handling different sizes byte(8bits) halfworld(16bits) and word(32bits)

logic[7:0] rdata_byte;
logic[15:0] rdata_hword;
logic[31:0] rdata_word;

always_comb begin
    rdata_byte='0;
    rdata_hword='0;
    rdata_word='0;

    case(instr_opcode)
        7'b0000011:begin
            case(funct3)
                Byte,Byte_Unsigned: case(addr[1:0])
                    2'b00 : rdata_byte = data_rd[7:0];
                    2'b01 : rdata_byte = data_rd[15:8];
                    2'b10 : rdata_byte = data_rd[23:16];
                    2'b11 : rdata_byte = data_rd[31:24];
                endcase
                HalfWord,HalfWord_Unsigned :case(addr[1])
                    1'b0 : rdata_hword = data_rd[15:0];
                    1'b1 : rdata_hword = data_rd[31:16];
                endcase
                Word : rdata_word = data_rd[31:0];
            endcase
        end
    endcase
end

//now we have to make 32bit data from byte/hword/word so that we can transfrer back to register file
// by handling different sizes of byte,halfword,word
always_comb begin
    case(funct3)
        Byte          : rdata = {{24{rdata_byte[7]}},rdata_byte};    //This will give me a 32 bit number
        Byte_Unsigned : rdata = {24'b0,rdata_byte};
        HalfWord      : rdata = {{16{rdata_hword[15]}},rdata_byte};
        HalfWord_Unsigned : rdata = {16'b0,rdata_hword};
        Word              : rdata = {rdata_word};
        default :           rdata ='0;
    endcase
end


// store operation
//here we basically write data from register file to data memory
always_comb begin
    data_wr = '0;   //here we are storing data so that we assign data_wr =0 so that we can store data in it
    case(instr_opcode)
        7'b0100011 : begin
            case(funct3)
                Byte : begin
                    case(addr[1:0])
                        2'b00 : begin
                            data_wr[7:0] = rdata2[7:0]; begin
                                mask = 4'b0001;
                            end
                        end

                        2'b01 : begin
                            data_wr[15:8] =rdata2[15:8]; begin
                                mask = 4'b0010;
                            end
                        end

                        2'b10 :begin
                            data_wr[23:16] =rdata2[23:16]; begin
                                mask = 4'b0100;
                            end
                        end
                    
                        2'b11 : begin
                            data_wr[31:24] =rdata2[31:24]; begin
                                mask = 4'b1000;
                            end
                        end

                        default:begin
                        end
                    endcase
                end

                HalfWord:begin
                    case(addr[1])
                        1'b0 : begin
                            data_wr[15:0] = rdata2[15:0]; begin
                                mask = 4'b0011;
                            end
                        end
                        1'b1 : begin
                            data_wr[31:16] = rdata2[31:16]; begin
                                mask = 4'b1100;
                            end
                        end
                    endcase
                end

                Word:begin
                    data_wr = rdata2;
                    mask =4'b1111;
                end
            endcase
        end
    endcase
end
endmodule

