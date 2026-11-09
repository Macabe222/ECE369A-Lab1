`timescale 1ps/1ps

module HazardDetectionUnit(ID_Instruction, EX_RegWrite, EX_WriteReg, MEM_RegWrite, MEM_WriteReg, WB_RegWrite, WB_WriteReg, Stall);

    input [31:0] ID_Instruction;

    input EX_RegWrite;
    input [4:0] EX_WriteReg;

    input MEM_RegWrite;
    input [4:0] MEM_WriteReg;

    input WB_RegWrite;
    input [4:0] WB_WriteReg;

    output reg Stall;

    wire [5:0] opcode;
    wire [5:0] funct;
    wire [4:0] rs;
    wire [4:0] rt;

    assign opcode = ID_Instruction [31:26];
    assign funct = ID_Instruction[5:0];
    assign rs = ID_Instruction[25:21];
    assign rt = ID_Instruction [20:16];

    reg UsesRS;
    reg UsesRt;
    reg EX_Hazard;
    reg MEM_Hazard;
    reg WB_Hazard;

    always @(*) begin
        UsesRs = 0;
        UsesRt = 0;

        case (opcode)
            6'b000000: begin //R-type Instructions
                case (funct)
                    6'b000000: begin //sll
                        UsesRs = 0;
                        UsesRt = 1;
                    end 
                    6'b000010: begin // srl
                        UsesRs = 0;
                        UsesRt = 1;
                    end 
                    6'b001000: begin //jr
                        UsesRs = 1;
                        UsesRt = 0;
                    end 
                    6'b100000: begin //add
                        UsesRs = 1;
                        UsesRt = 1;
                    end 
                    6'b100010: begin //sub
                        UsesRs = 1;
                        UsesRt = 1;
                    end 
                   6'b100100: begin // and
                        UsesRs = 1'b1;
                        UsesRt = 1'b1;
                    end
                    6'b100101: begin // or
                        UsesRs = 1'b1;
                        UsesRt = 1'b1;
                    end
                    6'b100110: begin // xor
                        UsesRs = 1'b1;
                        UsesRt = 1'b1;
                    end
                    6'b100111: begin // nor
                        UsesRs = 1'b1;
                        UsesRt = 1'b1;
                    end
                    6'b101010: begin // slt
                        UsesRs = 1'b1;
                        UsesRt = 1'b1;
                    end
                    default: begin
                        UsesRs = 1'b0;
                        UsesRt = 1'b0;
                    end
                endcase
            end 
            6'b011100: begin // mul
                UsesRs = 1'b1;
                UsesRt = 1'b1;
            end
            6'b000100: begin // beq
                UsesRs = 1'b1;
                UsesRt = 1'b1;
            end
            6'b000101: begin // bne
                UsesRs = 1'b1;
                UsesRt = 1'b1;
            end
            6'b101000: begin // sb
                UsesRs = 1'b1;
                UsesRt = 1'b1;
            end
            6'b101001: begin // sh
                UsesRs = 1'b1;
                UsesRt = 1'b1;
            end
            6'b101011: begin // sw
                UsesRs = 1'b1;
                UsesRt = 1'b1;
            end
            6'b000001: begin // bgez or bltz
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b000110: begin // blez
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b000111: begin // bgtz
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b001000: begin // addi
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b001010: begin // slti
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b001100: begin // andi
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b001101: begin // ori
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b001110: begin // xori
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b100000: begin // lb
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b100001: begin // lh
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b100011: begin // lw
                UsesRs = 1'b1;
                UsesRt = 1'b0;
            end
            6'b000010: begin // j
                UsesRs = 1'b0;
                UsesRt = 1'b0;
            end
            6'b000011: begin // jal
                UsesRs = 1'b0;
                UsesRt = 1'b0;
            end
            default: begin
                UsesRs = 1'b0;
                UsesRt = 1'b0;
            end
        endcase
    end

     always @(*) begin
        EX_Hazard  = 1'b0;
        MEM_Hazard = 1'b0;
        WB_Hazard  = 1'b0;

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

        // Checks for a read after write dependency in WB
        if (WB_RegWrite == 1'b1) begin
            if (WB_WriteReg != 5'd0) begin
                if (UsesRs == 1'b1) begin
                    if (rs == WB_WriteReg) begin
                        WB_Hazard = 1'b1;
                    end
                end
                if (UsesRt == 1'b1) begin
                    if (rt == WB_WriteReg) begin
                        WB_Hazard = 1'b1;
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