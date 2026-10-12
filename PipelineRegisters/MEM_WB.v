`timescale 1ns/1ps

module MEM_WB(
    RegWrite, MemToReg, ReadData, ALUResult, WriteReg, PCPlusFour, Clk, outRegWrite,
    outMemToReg, outReadData, outALUResult, outWriteReg, outPCPlusFour
);
    input RegWrite, Clk;
    input [1:0] MemToReg;
    input [4:0] WriteReg;
    input [31:0] ReadData, ALUResult, PCPlusFour;

    output reg outRegWrite;
    output reg [1:0] outMemToReg;
    output reg [4:0] outWriteReg;
    output reg [31:0] outReadData, outALUResult, outPCPlusFour;

    // Initialize register contents
    initial begin
        outRegWrite = 0; outMemToReg = 2'd0; outWriteRegg = 5'd0; outReadData = 32'd0;
        outALUResult = 32'd0; outPCPlusFour = 32'd0;
    end

    // Update at rising clock edge
    always @(posedge Clk) begin
        // Control Signals
        outRegWrite <= RegWrite;
        outMemToReg <= MemToReg;

        // Data
        outWriteReg <= WriteReg;
        outReadData <= ReadData;
        outALUResult <= ALUResult;
        outPCPlusFour <= PCPlusFour;
    end

endmodule
