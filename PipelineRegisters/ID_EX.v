`timescale 1ns/1ps

module ID_EX(
    RegWrite, ALUSrc, ALUOp, RegDst, MemToReg, MemRead, MemWrite, MemSize, Branch,
    ReadData1, ReadData2, PCPlusFour, Immediate, PotWriteReg1, PotWriteReg2, Shamt, Clk,
    outRegWrite, outALUSrc, outALUOp, outRegDst, outMemToReg, outMemRead, outMemWrite,
    outMemSize, outBranch, outReadData1, outReadData2, outPCPlusFour, outImmediate,
    outPotWriteReg1, outPotWriteReg2, outShamt
);
    input RegWrite, ALUSrc, MemRead, MemWrite, Branch, Clk;
    input [1:0] RegDst, MemToReg, MemSize;
    input [3:0] ALUOp;
    input [4:0] PotWriteReg1, PotWriteReg2, Shamt;
    input [31:0] ReadData1, ReadData2, PCPlusFour, Immediate;

    output reg outRegWrite, outALUSrc, outMemRead, outMemWrite, outBranch;
    output reg [1:0] outRegDst, outMemToReg, outMemSize;
    output reg [3:0] outALUOp;
    output reg [4:0] outPotWriteReg1, outPotWriteReg2, outShamt;
    output reg [31:0] outReadData1, outReadData2, outPCPlusFour, outImmediate;

    always @(posedge Clk) begin
        // Control Signals
        outRegWrite <= RegWrite;
        outALUSrc <= ALUSrc;
        outMemRead <= MemRead;
        outMemWrite <= MemWrite;
        outMemSize <= MemSize;
        outBranch <= Branch;
        outRegDst <= RegDst;
        outMemToReg <= MemToReg;
        outALUOp <= ALUOp;

        // Data
        outReadData1 <= ReadData1;
        outReadData2 <= ReadData2;
        outPCPlusFour <= PCPlusFour;
        outImmediate <= Immediate;
        outPotWriteReg1 <= PotWriteReg1;
        outPotWriteReg2 <= PotWriteReg2;
        outShamt <= Shamt;
    end
endmodule
