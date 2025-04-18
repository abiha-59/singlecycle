module immediate_gen (
    input  logic [31:0] Inst,
    input  logic [2:0]  ImmSrcD,
    output logic [31:0] ImmExtD
  );
  
  //logic [24:0] Imm;
  assign Imm =Inst [31:7];
  
    always_comb begin
      casex(ImmSrcD)
      // I Type
      3'b000:   ImmExtD = {{21{Inst[31]}}, Inst[30:20]};
      // S Typ
      3'b001:   ImmExtD = {{21{Inst[31]}}, Inst[30:25],Inst[11:7]};
      // B Typ
      3'b010:   ImmExtD = {{20{Inst[31]}}, Inst[7],Inst[30:25],Inst[11:8],1'b0};
      // J Typ
      3'b011:   ImmExtD = {{12{Inst[31]}}, Inst[19:12],Inst[20],Inst[30:21],1'b0};
      // U Typ
      3'b100:   ImmExtD = {    Inst[31],   Inst[30:12], {12{1'b0}}};
      default: 	ImmExtD = 32'dx; // undefined
      endcase
    end
  
  endmodule
  