module Instruction_Fetch(
    input  logic [31:0] Inst,
    output logic [4:0] raddr1,
    output logic [4:0] raddr2,
    output logic [4:0] waddr
);

always_comb begin
    raddr1 = Inst[19:15];
    raddr2 = Inst[24:20];
    waddr  = Inst[11:7];
end
endmodule
