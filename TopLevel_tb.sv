module TopLevel_tb;
  logic clk, rst;

  // Instantiate the TopLevel module
  TopLevel TOPLevel (.clk(clk), .rst(rst));

  // Clock generation
  initial begin
    clk = 0;
    forever #1 clk = ~clk; 
  end

  // Reset sequence
  initial begin
    rst = 1;
    #1 rst = 0;
  end

  
  initial begin
    #3;

    // Sample instructions:
    // ADD x1, x2, x3
    TOPLevel.InstMem.inst_memory[0] = 32'h003100B3;

    // SUB x4, x5, x6
    TOPLevel.InstMem.inst_memory[1] = 32'h40628233;

  
    TOPLevel.dmem.mem[1] = 32'hDEADBEEF;
  end

endmodule
