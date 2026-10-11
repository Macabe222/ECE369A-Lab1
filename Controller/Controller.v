`timescale 1ns/1ps

module Controller(Instruction, RegWrite, ALUSrc, MemToReg, RegDst, ALUOp, MemRead, MemWrite, Branch, MemSize, JumpReg, Jump, ExtOp);
    input [31:0] Instruction;
    output reg RegWrite, ALUSrc, MemRead, MemWrite, Branch, Jump, JumpReg, ExtOp;
    output reg [1:0] MemToReg, MemSize, RegDst;
    output reg [3:0] ALUOp;

    reg [5:0] OpCode;

    always @ (*) begin
        OpCode = Instruction[31:26];
        MemSize = 2'b00;
        ExtOp = 0;
        case (OpCode)
            6'b000000: begin // R-type instructions
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b01;
                MemToReg = 2'b01;
                Branch = 0;
                ALUSrc = 0;
                ALUOp = 4'b0010;
                JumpReg = (Instruction[5:0] == 6'b001000);
                Jump = 0;
            end
            6'b000001: begin // BGEZ, BLTZ
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 0;
                MemToReg = 2'b00;
                Branch = 1;
                JumpReg = 0;
                Jump = 0;
                case (Instruction[20:16]) // BGEZ
                    5'b00001: ALUOp = 4'b1000;
                    5'b00000: ALUOp = 4'b1100;
                endcase
            end
            6'b000010: begin // J
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 0;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 1;
            end
            6'b000011: begin // JAL
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b10;
                ALUSrc = 0;
                MemToReg = 2'b10;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 1;
            end
            6'b000100: begin // BEQ
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 0;
                MemToReg = 2'b00;
                Branch = 1;
                ALUOp = 4'b0001;
                JumpReg = 0;
                Jump = 0;
            end
            6'b000101: begin //BNE
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 0;
                MemToReg = 2'b00;
                Branch = 1;
                ALUOp = 4'b1100;
                JumpReg = 0;
                Jump = 0;
            end
            6'b000110: begin // BLEZ
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 0;
                MemToReg = 2'b00;
                Branch = 1;
                ALUOp = 4'b1010;
                JumpReg = 0;
                Jump = 0;
            end
            6'b000111: begin //BGTZ
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 0;
                MemToReg = 2'b00;
                Branch = 1;
                ALUOp = 4'b1001;
                JumpReg = 0;
                Jump = 0;
            end
            6'b001000: begin // ADDi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 0;
            end
            6'b001010: begin // SLTi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b0110;
                JumpReg = 0;
                Jump = 0;
            end
            6'b001100: begin // ANDi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b0011;
                JumpReg = 0;
                Jump = 0;
                ExtOp = 1;
            end
            6'b001101: begin // ORi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b0100;
                JumpReg = 0;
                Jump = 0;
                ExtOp = 1;
            end
            6'b001110: begin // XORi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b0101;
                JumpReg = 0;
                Jump = 0;
                ExtOp = 1;
            end
            6'b011100: begin // MUL
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b01;
                ALUSrc = 0;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0111;
                JumpReg = 0;
                Jump = 0;
            end
            6'b100000: begin // LB
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 0;
            end
            6'b100011: begin // LW
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 0;
                MemSize = 2'b10;
            end
            6'b100001: begin // LH
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 0;
                MemSize = 2'b01;
            end
            6'b101000: begin // SB
                RegWrite = 0;
                MemWrite = 1;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 0;
            end
            6'b101001: begin // SH
                RegWrite = 0;
                MemWrite = 1;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 0;
                MemSize = 2'b01;
            end
            6'b101011: begin // SW
                RegWrite = 0;
                MemWrite = 1;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 0;
                MemSize = 2'b10;
            end
        endcase

    end
endmodule
