`timescale 1ns/1ps

module Controller(Instruction, RegWrite, ALUSrc, MemToReg, RegDst, ALUOp, MemRead, MemWrite, Branch, MemSize, JumpReg, Jump);
    input reg [31:0] Instruction;
    output reg RegWrite, ALUSrc, MemToReg, RegDst, ALUOp, MemRead, MemWrite, Branch, MemSize;

    reg OpCode;
    reg FuncCode;

    always @ (*) begin
        OpCode = Instruction[31:26];
        FuncCode = Instruction[5:0];
        MemSize = 2'b00;
        case (OpCode)
            6'b000000 begin // R-type instructions
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b01;
                MemToReg = 1;
                Branch = 0;
                ALUSrc = 0;
                ALUOp = 4'b0010
                JumpReg = 0;
                Jump = 0;
            end
            6'b000001 begin // BGEZ, BLTZ
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 0;
                MemToReg = 0;
                Branch = 1;
                ALUOp = 4'b0001;
                JumpReg = 0;
                Jump = 0;
            end
            6'b000010 begin // J
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
            6'b000011 begin // JAL
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
            6'b000100 begin // BEQ
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
            6'b000101 begin //BNE
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
            6'b000110 begin // BLE
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
            6'b000111 begin //BGTZ
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
            6'b001000 begin // ADDi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0001;
                JumpReg = 0;
                Jump = 0;
            end
            6'b001010 begin // SLTi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0110;
                JumpReg = 0;
                Jump = 0;
            end
            6'b001100 begin // ANDi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0011;
                JumpReg = 0;
                Jump = 0;
            end
            6'b001101 begin // ORi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0100;
                JumpReg = 0;
                Jump = 0;
            end
            6'001110 begin // XORi
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b0101;
                JumpReg = 0;
                Jump = 0;
            end
            6'b011100 begin // MUL
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
            6'b100000 begin // LB
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b0000;
                JumpReg = 0;
                Jump = 0;
            end
            6'b1000011 begin // LW
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b;
                JumpReg = 0;
                Jump = 0;
                MemSize = 2'b10;
            end
            6'b100001 begin // LH
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b;
                JumpReg = 0;
                Jump = 0;
                MemSize = 2'b01;
            end
            6'b101000 begin // SB
                RegWrite = 0;
                MemWrite = 1;
                MemRead = 0;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b00;
                Branch = 0;
                ALUOp = 4'b;
                JumpReg = 0;
                Jump = 0;
            end
            6'b101001 begin // SH
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b;
                JumpReg = 0;
                Jump = 0;
                MemSize = 2'b01;
            end
            6'101011 begin // SW
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                RegDst = 2'b00;
                ALUSrc = 1;
                MemToReg = 2'b01;
                Branch = 0;
                ALUOp = 4'b;
                JumpReg = 0;
                Jump = 0;
                MemSize = 2'b10;
            end
        endcase

    end
endmodule
