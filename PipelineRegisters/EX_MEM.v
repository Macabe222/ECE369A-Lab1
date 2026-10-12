`timescale 1ns/1ps
module EX_MEM(
    Branch, MemWrite, MemRead, MemSize, MemToReg, RegWrite, AddResult, ReadData2,
    Zero, ALUResult, WriteReg, PCPlusFour, Clk, outBranch, outMemWrite, outMemRead,
    outMemSize, outMemToReg, outRegWrite, outAddResult, outReadData2,
    outZero, outALUResult, outWriteReg, outPCPlusFour
);

    input Branch, MemWrite, MemRead, RegWrite, Zero, Clk;
    input [1:0] MemSize, MemToReg;
    input [4:0] WriteReg;
    input [31:0] AddResult, ReadData2, ALUResult, PCPlusFour;

    output reg outBranch, outMemWrite, outMemRead, outRegWrite, outZero;
    output reg [1:0] outMemSize, outMemToReg;
    output reg [4:0] outWriteReg;
    output reg [31:0] outAddResult, outReadData2, outALUResult, outPCPlusFour;

    // Initialize register contents
    initial begin
        outBranch = 0; outMemWrite = 0; outMemRead = 0; outRegWrite = 0; outZero = 0;
        outMemSize = 2'd0; outMemToReg = 2'd0; outWriteReg = 5'd0; outAddResult = 32'd0;
        outReadData2 = 32'd0; outALUResult = 32'd0; outPCPlusFour = 32'd0;
    end

    // Update at rising clock edge
    always @(posedge Clk) begin
        // Control Signals
        outBranch <= Branch;
        outMemWrite <= MemWrite;
        outMemRead <= MemRead;
        outRegWrite <= RegWrite;
        outMemSize <= MemSize;
        outMemToReg <= MemToReg;

        // Data
        outZero <= Zero;
        outAddResult <= AddResult;
        outReadData2 <= ReadData2;
        outALUResult <= ALUResult;
        outWriteReg <= WriteReg;
        outPCPlusFour <= PCPlusFour;
    end

endmodule
