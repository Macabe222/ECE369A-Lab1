`timescale 1ns/1ps

////////////////////////////////////////////////////////////////////////////////
// Team members: Macabe Wood, Kamil Frem, Ian Caulin-Cardo
// Percent effort: 33%, 33%, 33%
//
// Wires together all components neccessary to implement a RISC cpu.
////////////////////////////////////////////////////////////////////////////////

module CPU32Bit(Clk, Rst, outWriteData, outPC, outInstruction);
    input Clk, Rst;

    // 1 bit instruction decode wires
    wire ID_Jump, ID_JumpReg, ID_RegWrite, ID_ALUSrc, ID_MemRead, ID_MemWrite, ID_Branch, ID_ExtOp;
    // 1 bit execute wires
    wire EX_RegWrite, EX_ALUSrc, EX_MemRead, EX_MemWrite, EX_Branch, EX_Zero;
    // 1 bit memory wires
    wire MEM_Branch, MEM_MemWrite, MEM_MemRead, MEM_RegWrite, MEM_PCSrc, MEM_Zero;
    // 1 bit write back wires
    wire WB_RegWrite;
    // 2 bit instruction decode wires
    wire [1:0] ID_RegDst, ID_MemToReg, ID_MemSize;
    // 2 bit execute wires
    wire [1:0] EX_RegDst, EX_MemToReg, EX_MemSize;
    // 2 bit memory wires
    wire [1:0] MEM_MemToReg, MEM_MemSize;
    // 2  bit write back wires
    wire [1:0] WB_MemToReg;
    // 4 bit instruction decode wires
    wire [3:0] ID_ALUOp;
    // 4 bit execute wires
    wire [3:0] EX_ALUOp, EX_ALUControlSignal;
    // 5 bit instruction decode wires
    wire [4:0] ID_Shamt;
    // 5 bit execute wires
    wire [4:0] EX_WriteReg, EX_PotWriteReg1, EX_PotWriteReg2, EX_Shamt;
    // 5 bit memory wires
    wire [4:0] MEM_WriteReg;
    // 5 bit write back wires
    wire [4:0] WB_WriteReg;
    // Miscellaneous / instruction fetch wires
    wire [31:0] Address, Instruction, PCPlusFour, PCInput, JumpAddress, MuxOneOut, MuxTwoOut, JumpShifted;
    // 32 bit instruction decode wires
    wire [31:0] ID_ReadData1, ID_ReadData2, ID_Instruction, ID_PCPlusFour, ID_Immediate;
    // 32 bit execute wires
    wire [31:0] EX_ReadData1, EX_ReadData2, EX_PCPlusFour, EX_Immediate, EX_AddResult, EX_AddIn, EX_ALUIn, EX_ALUResult;
    // 32 bit memory wires
    wire [31:0] MEM_AddResult, MEM_ReadData2, MEM_ALUResult, MEM_PCPlusFour, MEM_MemReadData;
    // 32 bit write back wires
    wire [31:0] WB_MemReadData, WB_ALUResult, WB_PCPlusFour, WB_WriteData;

    // Registers to keep track of the instruction throughout the pipeline
    reg [31:0] EX_Instruction, MEM_Instruction, WB_Instruction;

    // Output write data and program counter for display purposes
    output [31:0] outWriteData, outPC, outInstruction;

    //Hazard detection

    wire Stall;
    reg PCWrite;
    reg IFIDWrite;

    reg Next_RegWrite;
    reg Next_AluSrc;
    reg Next_MemRead;
    reg Next_MemWrite;
    reg Next_Branch;
    reg [3:0] Next_AluOp;
    reg [1:0] Next_RegDst;
    reg [1:0] Next_MemToReg;
    reg [1:0] Next_MemSize;

    always @(*) begin
        Next_RegWrite = ID_RegWrite;
        Next_ALUSrc = ID_ALUSrc;
        Next_MemRead = ID_MemRead;
        Next_MemWrite = ID_MemWrite;
        Next_ALUOp = ID_ALUOp;
        Next_RegDst = ID_RegDst;
        Next_MemToReg = ID_MemToReg;
        Next_MemSize = ID_MemSize
    end

    Next_Branch = 0;

    if (Stall == 1 || Reset == 1) begin
        
        Next_RegWrite = 0;
        Next_ALUSrc = 0;
        Next_MemRead = 0;
        Next_MemWrite = 0;
        Next_ALUOp = 4'd0;
        Next_RegDst = 2'd0;
        Next_MemToReg = 2'd0;
        Next_MemSize = 2'd0

    end

    HazardDetectionUnit hazard_unit(ID_Instruction, EX_RegWrite, EX_WriteReg, MEM_RegWrite, MEM, WriteReg, WB_RegWrite, WB_WriteReg, Stall);

    always @(*) begin
        PCWrite = 1;
        IFIDWrite = 1;

        if (Stall == 1) begin

            PCWrite = 1;
            IFIDWrite = 1;

        end

    end
    // Instruction fetch
    InstructionMemory u4(Address, Instruction); // Retrieve instruction from instruction memory
    ProgramCounter u5(PCInput, Address, Rst, Clk, PCWrite); // Store current instruction addresss in PC
    PCAdder u6(Address, PCPlusFour); // Increment intstruction address
    ShiftLeftTwo26Bit u7(ID_Instruction[25:0], JumpShifted); // Calculate jump address
    assign JumpAddress = {ID_PCPlusFour[31:28], JumpShifted[27:0]}; // Jump address is the top 4 bits of PC+4 and JumpShifter
    Mux32Bit2To1 u8(MuxOneOut, PCPlusFour, MEM_AddResult, MEM_PCSrc); // Select between PC+4, and branch memory address
    Mux32Bit2To1 u9(MuxTwoOut, MuxOneOut, JumpAddress, ID_Jump); // Select between mux one out jump address
    Mux32Bit2To1 u10(PCInput, MuxTwoOut, ID_ReadData1, ID_JumpReg); // Select between mux two out and jr address

    // Instruction fethc -> instruction decode register
    IF_ID u0(PCPlusFour, Instruction, ID_PCPlusFour, ID_Instruction, Clk, Reset, ID_Write, ID_Redirect);

    // Instruction decode

    // Pass correct instruction fields and control signals to the register file
    RegisterFile u11(ID_Instruction[25:21], ID_Instruction[20:16], WB_WriteReg, WB_WriteData, WB_RegWrite, Clk, ID_ReadData1, ID_ReadData2);
    // Pass intstruction and capture control signals
    Controller u12(ID_Instruction, ID_RegWrite, ID_ALUSrc, ID_MemToReg, ID_RegDst, ID_ALUOp, ID_MemRead, ID_MemWrite, ID_Branch, ID_MemSize, ID_JumpReg, ID_Jump, ID_ExtOp);
    // Sign extend immediate number
    SignExtension u13(ID_Instruction[15:0], ID_Immediate, ID_ExtOp);

    // Instruction decode -> execute register
    ID_EX u1(
        Next_RegWrite, Next_ALUSrc, Next_ALUOp, Next_RegDst, Next_MemToReg, Next_MemRead, Next_MemWrite, Next_MemSize, Next_Branch,
        ID_ReadData1, ID_ReadData2, ID_PCPlusFour, ID_Immediate, ID_Instruction[20:16], ID_Instruction[15:11], ID_Instruction[10:6], Clk,
        EX_RegWrite, EX_ALUSrc, EX_ALUOp, EX_RegDst, EX_MemToReg, EX_MemRead, EX_MemWrite,
        EX_MemSize, EX_Branch, EX_ReadData1, EX_ReadData2, EX_PCPlusFour, EX_Immediate,
        EX_PotWriteReg1, EX_PotWriteReg2, EX_Shamt
    );

    // Execute
    ShiftLeftTwo u14(EX_Immediate, EX_AddIn); // Calculate branch offset
    Adder32Bit u15(EX_PCPlusFour, EX_AddIn, EX_AddResult); // Add branch offset to PC+4
    Mux32Bit2To1 u16(EX_ALUIn, EX_ReadData2, EX_Immediate, EX_ALUSrc); // Select between immediate and read data 2
    ALUControlUnit u17(EX_ALUOp, EX_Immediate[5:0], EX_ALUControlSignal); // Capture correct ALU control signal
    ALU32Bit u18(EX_ALUControlSignal, EX_ReadData1, EX_ALUIn, EX_Shamt, EX_ALUResult, EX_Zero); // Calculate ALU result based on inputs and control signal
    Mux5Bit3To1 u19(EX_WriteReg, EX_PotWriteReg1, EX_PotWriteReg2, 5'd31, EX_RegDst); // Select correct write register (31 is $ra)

    // Execute -> memory register
    EX_MEM u2(
        EX_Branch, EX_MemWrite, EX_MemRead, EX_MemSize, EX_MemToReg, EX_RegWrite, EX_AddResult, EX_ReadData2,
        EX_Zero, EX_ALUResult, EX_WriteReg, EX_PCPlusFour, Clk, MEM_Branch, MEM_MemWrite, MEM_MemRead,
        MEM_MemSize, MEM_MemToReg, MEM_RegWrite, MEM_AddResult, MEM_ReadData2,
        MEM_Zero, MEM_ALUResult, MEM_WriteReg, MEM_PCPlusFour
    );

    // Memory
    assign MEM_PCSrc = MEM_Branch & MEM_Zero; // Capture PC src
    DataMemory u20(MEM_ALUResult, MEM_ReadData2, Clk, MEM_MemWrite, MEM_MemRead, MEM_MemSize, MEM_MemReadData); // Memory access

    // Memory -> write back register
    MEM_WB u3(
        MEM_RegWrite, MEM_MemToReg, MEM_MemReadData, MEM_ALUResult, MEM_WriteReg, MEM_PCPlusFour, Clk, WB_RegWrite,
        WB_MemToReg, WB_MemReadData, WB_ALUResult, WB_WriteReg, WB_PCPlusFour
    );

    // Write back
    Mux32Bit3To1 u21(WB_WriteData, WB_MemReadData, WB_ALUResult, WB_PCPlusFour, WB_MemToReg); // Select write back data
    assign outWriteData = WB_WriteData;  // Assign output
    assign outPC = WB_PCPlusFour - 32'd4; // Assign output

    // Keep track of instruction through pipeline so that the correct one is returned
    always @(posedge Clk) begin
        EX_Instruction <= ID_Instruction;
        MEM_Instruction <= EX_Instruction;
        WB_Instruction <= MEM_Instruction;
    end

    assign outInstruction = WB_Instruction;

endmodule
