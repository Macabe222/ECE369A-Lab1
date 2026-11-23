`timescale 1ns/1ps

module HazardDetectionUnit(ID_Instruction, ID_Branch, ID_JumpReg, EX_RegWrite, EX_MemRead, EX_WriteReg, MEM_RegWrite, MEM_WriteReg, UsesRs, UsesRt, Stall);
    input [31:0] ID_Instruction;
    input ID_Branch, ID_JumpReg;
    input EX_RegWrite, EX_MemRead;
    input [4:0] EX_WriteReg;
    input MEM_RegWrite;
    input [4:0] MEM_WriteReg;
    input UsesRs, UsesRt;
    output reg Stall;

    wire [4:0] rs = ID_Instruction[25:21];
    wire [4:0] rt = ID_Instruction[20:16];

    // ID instruction reads a register that EX will write
    wire EX_Dep  = EX_RegWrite && (EX_WriteReg != 5'd0) &&
                   ((UsesRs && rs == EX_WriteReg) || (UsesRt && rt == EX_WriteReg));

    // ID instruction reads a register that MEM will write
    wire MEM_Dep = MEM_RegWrite && (MEM_WriteReg != 5'd0) &&
                   ((UsesRs && rs == MEM_WriteReg) || (UsesRt && rt == MEM_WriteReg));

    // Branches and jr read the register file directly in ID (no forwarding)
    wire ResolvesInID = ID_Branch || ID_JumpReg;

    always @(*) begin
        Stall = 1'b0;

        // Load-use: lw result isn't ready in time to forward to the next EX
        if (EX_MemRead && EX_Dep)
            Stall = 1'b1;

        // Branch/jr: must wait until the value reaches the register file
        if (ResolvesInID && (EX_Dep || MEM_Dep))
            Stall = 1'b1;
    end
endmodule
