`timescale 1ns/1ps

module HazardDetectionUnit(ID_Instruction, EX_RegWrite, EX_WriteReg, MEM_RegWrite, MEM_WriteReg, UsesRt, UsesRs Stall);

    input [31:0] ID_Instruction;

    input EX_RegWrite, UsesRs, UsesRt;
    input [4:0] EX_WriteReg;

    input MEM_RegWrite;
    input [4:0] MEM_WriteReg;

    output reg Stall;

    wire [5:0] opcode;
    wire [5:0] funct;
    wire [4:0] rs;
    wire [4:0] rt;

    assign opcode = ID_Instruction [31:26];
    assign funct = ID_Instruction[5:0];
    assign rs = ID_Instruction[25:21];
    assign rt = ID_Instruction [20:16];

    reg EX_Hazard;
    reg MEM_Hazard;

    always @(*) begin
        EX_Hazard  = 1'b0;
        MEM_Hazard = 1'b0;

        // Checks for a read after write dependency in EX
        if (EX_RegWrite == 1'b1) begin
            if (EX_WriteReg != 5'd0) begin
                if (UsesRs == 1'b1) begin
                    if (rs == EX_WriteReg) begin
                        EX_Hazard = 1'b1;
                    end
                end
                if (UsesRt == 1'b1) begin
                    if (rt == EX_WriteReg) begin
                        EX_Hazard = 1'b1;
                    end
                end
            end
        end

        // Checks for a read after write dependency in MEM
        if (MEM_RegWrite == 1'b1) begin
            if (MEM_WriteReg != 5'd0) begin
                if (UsesRs == 1'b1) begin
                    if (rs == MEM_WriteReg) begin
                        MEM_Hazard = 1'b1;
                    end
                end
                if (UsesRt == 1'b1) begin
                    if (rt == MEM_WriteReg) begin
                        MEM_Hazard = 1'b1;
                    end
                end
            end
        end
    end

    //Any dependency is enough to make ID wait.
    always @(*) begin
        Stall = 1'b0;
        if (EX_Hazard == 1'b1) begin
            Stall = 1'b1;
        end
        if (MEM_Hazard == 1'b1) begin
            Stall = 1'b1;
        end
        if (WB_Hazard == 1'b1) begin
            Stall = 1'b1;
        end
    end


endmodule
