module program_counter(
    input logic clk,rst,
    input logic [31:0] PC,
    output logic [31:0] Addr

);

always_ff @(posedge clk) begin
    if (rst) begin
        Addr <=32'd0;
    end
    else begin
        Addr <= PC;
    end
end
endmodule