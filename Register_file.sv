module Register_file(
    input logic clk,rst,reg_wr,
    input logic [4:0] raddr1,
    input logic [4:0] raddr2,
    input logic [4:0] waddr,
    input logic [31:0] wdata,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2

);

    logic [31:0] register_file[30:0];

    //Asynchronous Read 
    always_comb begin
        rdata1=(|raddr1) ? register_file[raddr1] :'0; // |raddr1 mean if any bit off addr1 is high then write the 
        rdata2=(|raddr2) ? register_file[raddr2] :'0;    //value from register file present at that bit and assign to rdata1......
    end

    //Synchronous Write
    always_ff @(negedge clk) begin    //write operation occurs synchronously with the falling edge of the clock signal.
        if (reg_wr&&|waddr) begin           //if reg_wr is active high then write the data in register file at 'waddr' address
            register_file[waddr] <= wdata;
        end
        else if (rst) begin
            for(int i=1;i<=32;i++) begin
                register_file[i]<=32'd0; // Reset all registers
            end
            
        end
    end
endmodule