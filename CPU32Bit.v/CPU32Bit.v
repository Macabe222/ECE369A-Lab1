`timescale 1ns/1ps

module CPU32Bit(unDivClk, Rst);
    input unDivClk, Rst;

    wire Clk;
    wire ID_Jump, ID_JumpReg, ID_RegWrite, ID_ALUSrc, ID_MemRead, ID_MemWrite, ID_Branch, ID_ExtOp;
    wire EX_RegWrite, EX_ALUSrc, EX_MemRead, EX_MemWrite, EX_Branch, EX_Zero;
    wire MEM_Branch, MEM_MemWrite, MEM_MemRead, MEM_RegWrite, MEM_PCSrc, MEM_Zero;
    wire WB_RegWrite;
    wire [1:0] ID_RegDst, ID_MemToReg, ID_MemSize;
    wire [1:0] EX_RegDst, EX_MemToReg, EX_MemSize;
    wire [1:0] MEM_MemToReg, MEM_MemSize;
    wire [1:0] WB_MemToReg;
    wire [3:0] ID_ALUOp;
    wire [3:0] EX_ALUOp, EX_ALUControlSignal;
    wire [4:0] ID_Shamt;
    wire [4:0] EX_WriteReg, EX_PotWriteReg1, EX_PotWriteReg2, EX_Shamt;
    wire [4:0] MEM_WriteReg;
    wire [4:0] WB_WriteReg;
    wire [31:0] Address, Instruction, PCPlusFour, PCInput, JumpAddress, MuxOneOut, MuxTwoOut, JumpShifted;
    wire [31:0] ID_ReadData1, ID_ReadData2, ID_Instruction, ID_PCPlusFour, ID_Immediate;
    wire [31:0] EX_ReadData1, EX_ReadData2, EX_PCPlusFour, EX_Immediate, EX_AddResult, EX_AddIn, EX_ALUIn, EX_ALUResult;
    wire [31:0] MEM_AddResult, MEM_ReadData2, MEM_ALUResult, MEM_PCPlusFour, MEM_MemReadData;
    wire [31:0] WB_MemReadData, WB_ALUResult, WB_PCPlusFour, WB_WriteData;

    ClkDiv u22(unDivClk, Rst, Clk);

    InstructionMemory u4(Address, Instruction);
    ProgramCounter u5(PCInput, Address, Rst, Clk);
    PCAdder u6(Address, PCPlusFour);
    ShiftLeftTwo26Bit u7(ID_Instruction[25:0], JumpShifted);
    assign JumpAddress = {ID_PCPlusFour[31:28], JumpShifted[27:0]};
    Mux32Bit2To1 u8(MuxOneOut, PCPlusFour, MEM_AddResult, MEM_PCSrc);
    Mux32Bit2To1 u9(MuxTwoOut, MuxOneOut, JumpAddress, ID_Jump);
    Mux32Bit2To1 u10(PCInput, MuxTwoOut, ID_ReadData1, ID_JumpReg);

    IF_ID u0(PCPlusFour, Instruction, ID_PCPlusFour, ID_Instruction, Clk);

    RegisterFile u11(ID_Instruction[25:21], ID_Instruction[20:16], WB_WriteReg, WB_WriteData, WB_RegWrite, Clk, ID_ReadData1, ID_ReadData2);
    Controller u12(ID_Instruction, ID_RegWrite, ID_ALUSrc, ID_MemToReg, ID_RegDst, ID_ALUOp, ID_MemRead, ID_MemWrite, ID_Branch, ID_MemSize, ID_JumpReg, ID_Jump, ID_ExtOp);
    SignExtension u13(ID_Instruction[15:0], ID_Immediate, ID_ExtOp);

    ID_EX u1(
        ID_RegWrite, ID_ALUSrc, ID_ALUOp, ID_RegDst, ID_MemToReg, ID_MemRead, ID_MemWrite, ID_MemSize, ID_Branch,
        ID_ReadData1, ID_ReadData2, ID_PCPlusFour, ID_Immediate, ID_Instruction[20:16], ID_Instruction[15:11], ID_Shamt Clk,
        EX_RegWrite, EX_ALUSrc, EX_ALUOp, EX_RegDst, EX_MemToReg, EX_MemRead, EX_MemWrite,
        EX_MemSize, EX_Branch, EX_ReadData1, EX_ReadData2, EX_PCPlusFour, EX_Immediate,
        EX_PotWriteReg1, EX_PotWriteReg2, EX_Shamt
    );

    ShiftLeftTwo u14(EX_Immediate, EX_AddIn);
    Adder32Bit u15(EX_PCPlusFour, EX_AddIn, EX_AddResult);
    Mux32Bit2To1 u16(EX_ALUIn, EX_ReadData2, EX_Immediate, EX_ALUSrc);
    ALUControlUnit u17(EX_ALUOp, EX_Immediate[5:0], EX_ALUControlSignal);
    ALU32Bit u18(EX_ALUControlSignal, EX_ReadData1, EX_ALUIn, EX_Shamt, EX_ALUResult, EX_Zero);
    Mux5Bit3To1 u19(EX_WriteReg, EX_PotWriteReg1, EX_PotWriteReg2, 5'd31, EX_RegDst);

    EX_MEM u2(
        EX_Branch, EX_MemWrite, EX_MemRead, EX_MemSize, EX_MemToReg, EX_RegWrite, EX_AddResult, EX_ReadData2,
        EX_Zero, EX_ALUResult, EX_WriteReg, EX_PCPlusFour, Clk, MEM_Branch, MEM_MemWrite, MEM_MemRead,
        MEM_MemSize, MEM_MemToReg, MEM_RegWrite, MEM_AddResult, MEM_ReadData2,
        MEM_Zero, MEM_ALUResult, MEM_WriteReg, MEM_PCPlusFour
    );

    assign MEM_PCSrc = MEM_Branch & MEM_Zero;
    DataMemory u20(MEM_ALUResult, MEM_ReadData2, Clk, MEM_MemWrite, MEM_MemRead, MEM_MemSize, MEM_MemReadData);

    MEM_WB u3(
        MEM_RegWrite, MEM_MemToReg, MEM_MemReadData, MEM_ALUResult, MEM_WriteReg, MEM_PCPlusFour, Clk, WB_RegWrite,
        WB_MemToReg, WB_MemReadData, WB_ALUResult, WB_WriteReg, WB_PCPlusFour
    );

    Mux32Bit3To1 u21(WB_WriteData, WB_MemReadData, WB_ALUResult, WB_PCPlusFour, WB_MemToReg);

endmodule
