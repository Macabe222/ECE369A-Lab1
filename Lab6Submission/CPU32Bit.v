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
    wire MEM_Branch, MEM_MemWrite, MEM_MemRead, MEM_RegWrite, MEM_Zero;
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
    wire [31:0] Address, Instruction, PCPlusFour;
    wire [31:0] JumpAddress;
    wire [27:0] JumpShifted;
    reg [31:0] PCInput;
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
    output reg [31:0] outWriteData;
    output [31:0] outPC;
    output [31:0] outInstruction;

    //Hazard detection

    wire Stall;
    reg PCWrite;
    reg IFIDWrite;

    reg Next_RegWrite;
    reg Next_ALUSrc;
    reg Next_MemRead;
    reg Next_MemWrite;
    reg Next_Branch;
    reg [3:0] Next_ALUOp;
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
        Next_MemSize = ID_MemSize;

         Next_Branch = 0;

        //The next will clear the controls going into EX. This can pass down the pipeline without writing a register or accessing memory
        // This idea will help have an empty spot in the pipeline that gives the instruction in ID that goes to EX time to wait for the value it needs

        if (Stall == 1 || Rst == 1) begin
            
            Next_RegWrite = 0;
            Next_ALUSrc = 0;
            Next_MemRead = 0;
            Next_MemWrite = 0;
            Next_ALUOp = 4'd0;
            Next_RegDst = 2'd0;
            Next_MemToReg = 2'd0;
            Next_MemSize = 2'd0;

        end
    end

   
    // ID sends its instructions to the hazard unit, EX, MEM and WB will send their write enable and destination registers depending on what happens inside the unit

    HazardDetectionUnit hazard_unit(ID_Instruction, EX_RegWrite, EX_WriteReg, MEM_RegWrite, MEM_WriteReg, WB_RegWrite, WB_WriteReg, Stall);

    always @(*) begin
        PCWrite = 1;
        IFIDWrite = 1;

    //Hold the fetch address and keep the same instruction in the decode so it will run in the next cycle since if there is a hazard it could add a stall that is why we setup to 0
    
        if (Stall == 1) begin

            PCWrite = 0;
            IFIDWrite = 0;

        end

    end

    //ID_BranchCondition and Id_BranchTarget will help decide whether to take branch in ID.

    //ID_RedirectAddress will pick the new PC in ID.

    reg ID_BranchCondition;
    wire [31:0] ID_SignedOffset;
    wire [31:0] ID_BranchOffset;
    wire [31:0] ID_BranchTarget;
    reg ID_Redirect;
    reg [31:0] ID_RedirectAddress;

    // Extend the signed 16 bit branch displacement to 32 bits.

    assign ID_SignedOffset = {{16{ID_Instruction[15]}}, ID_Instruction[15:0]};

    // Convert a displacement in instruction words to bytes.
    assign ID_BranchOffset = ID_SignedOffset << 2;
    assign ID_BranchTarget = ID_PCPlusFour + ID_BranchOffset;

    always @(*) begin
        ID_BranchCondition = 1'b0;

        case (ID_Instruction[31:26])
            6'b000100: begin // beq
                if (ID_ReadData1 == ID_ReadData2) begin
                    ID_BranchCondition = 1'b1;
                end
            end
            6'b000101: begin // bne
                if (ID_ReadData1 != ID_ReadData2) begin
                    ID_BranchCondition = 1'b1;
                end
            end
            6'b000110: begin // blez
                if ($signed(ID_ReadData1) <= 0) begin
                    ID_BranchCondition = 1'b1;
                end
            end
            6'b000111: begin // bgtz
                if ($signed(ID_ReadData1) > 0) begin
                    ID_BranchCondition = 1'b1;
                end
            end
            6'b000001: begin // bltz or bgez
                if (ID_Instruction[20:16] == 5'b00000) begin
                    if ($signed(ID_ReadData1) < 0) begin
                        ID_BranchCondition = 1'b1;
                    end
                end
                if (ID_Instruction[20:16] == 5'b00001) begin
                    if ($signed(ID_ReadData1) >= 0) begin
                        ID_BranchCondition = 1'b1;
                    end
                end
            end
            default: begin
                ID_BranchCondition = 1'b0;
            end
        endcase
    end

    always @(*) begin
        ID_Redirect = 1'b0;
        ID_RedirectAddress = 32'd0;

        // Only use register values after dependencies are resolved.
        if (Rst == 1'b0) begin
            if (Stall == 1'b0) begin
                if (ID_JumpReg == 1'b1) begin // jr
                    ID_Redirect = 1'b1;
                    ID_RedirectAddress = ID_ReadData1;
                end else if (ID_Jump == 1'b1) begin // j or jal
                    ID_Redirect = 1'b1;
                    ID_RedirectAddress = JumpAddress;
                end else if (ID_Branch == 1'b1) begin
                    if (ID_BranchCondition == 1'b1) begin
                        ID_Redirect = 1'b1;
                        ID_RedirectAddress = ID_BranchTarget;
                    end
                end
            end
        end
    end

    always @(*) begin
        PCInput = PCPlusFour;
        if (ID_Redirect == 1'b1) begin
            PCInput = ID_RedirectAddress;
        end
    end


    // Instruction fetch
    InstructionMemory u4(Address, Instruction); // Retrieve instruction from instruction memory
    ProgramCounter u5(PCInput, Address, Rst, Clk, PCWrite); // Store current instruction addresss in PC
    PCAdder u6(Address, PCPlusFour); // Increment intstruction address
    ShiftLeftTwo26Bit u7(ID_Instruction[25:0], JumpShifted); // Calculate jump address
    assign JumpAddress = {ID_PCPlusFour[31:28], JumpShifted[27:0]}; // Jump address is the top 4 bits of PC+4 and JumpShifter

    //A redirect will flush the younger instruction fetched from the old path.
    // Instruction fethc -> instruction decode register
    IF_ID u0(PCPlusFour, Instruction, ID_PCPlusFour, ID_Instruction, Clk, Rst, IFIDWrite, ID_Redirect);

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
        EX_PotWriteReg1, EX_PotWriteReg2, EX_Shamt, Rst
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
        MEM_Zero, MEM_ALUResult, MEM_WriteReg, MEM_PCPlusFour, Rst
    );

    // Memory
   
    DataMemory u20(MEM_ALUResult, MEM_ReadData2, Clk, MEM_MemWrite, MEM_MemRead, MEM_MemSize, MEM_MemReadData); // Memory access

    // Memory -> write back register
    MEM_WB u3(
        MEM_RegWrite, MEM_MemToReg, MEM_MemReadData, MEM_ALUResult, MEM_WriteReg, MEM_PCPlusFour, Clk, WB_RegWrite,
        WB_MemToReg, WB_MemReadData, WB_ALUResult, WB_WriteReg, WB_PCPlusFour, Rst
    );

    // Write back
    Mux32Bit3To1 u21(WB_WriteData, WB_MemReadData, WB_ALUResult, WB_PCPlusFour, WB_MemToReg); // Select write back data

    
    // Assign output

        always @(*) begin

        //Shows zeros when the instruction writes no register or targets $zero
        outWriteData = 32'd0;
        if (WB_RegWrite == 1'b1) begin
            if (WB_WriteReg != 5'd0) begin
                outWriteData = WB_WriteData;
            end
        end
    end

    
    assign outPC = WB_PCPlusFour - 32'd4; // Assign output

    // Keep track of instruction through pipeline so that the correct one is returned
    always @(posedge Clk or posedge Rst) begin
    if (Rst == 1'b1) begin
        //This will mark EX instructions with zeros, the older instructions will sitll advance 
        EX_Instruction <= 32'd0;
        MEM_Instruction <= 32'd0;
        WB_Instruction <= 32'd0;
    end else begin
        if (Stall == 1'b1) begin
            EX_Instruction <= 32'd0;
        end else begin
            EX_Instruction <= ID_Instruction;
        end

        MEM_Instruction <= EX_Instruction;
        WB_Instruction <= MEM_Instruction;
    end
end

    assign outInstruction = WB_Instruction;

endmodule

