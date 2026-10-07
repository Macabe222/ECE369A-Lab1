`timescale 1ns/1ps

module ALUControlUnit(ALUOp, funct, control_signal);
    input [5:0] funct;
    input [3:0] ALUOp;

    output reg [3:0] control_signal;

    always @(*) begin
        case (ALUOp)
            4'b0000: control_signal = 4'b0000; // Memory and ADDi
            4'b0001: control_signal = 4'b0001; // Branch
            4'b0010: // R-type
            case (funct)
                6'b100000: control_signal = 4'b0000; // ADD
                6'b100010: control_signal = 4'b0001; // SUB
                6'b100100: control_signal = 4'b0011; // AND
                6'b100101: control_signal = 4'b0100; // OR
                6'b101010: control_signal = 4'b0101; // SLT
                6'b100110: control_signal = 4'b0110; // XOR
                6'b100111: control_signal = 4'b0111; // NOR
                6'b000000: control_signal = 4'b1000; // SLL
                6'b000010: control_signal = 4'b1001; // SRL
                default: control_signal = 4'b1111;
            endcase
            4'b0011: control_signal = 4'b0011; // ANDi
            4'b0100: control_signal = 4'b0100; // ORi
            4'b0101: control_signal = 4'b0110; // XORi
            4'b0110: control_signal = 4'b0101; // SLTi
            4'b0111: control_signal = 4'b0010; // MUL, this is neccessary becasue  SRL and MUL have the same function code
            4'b1000: control_signal = 4'b1010; // BGEZ
            4'b1001: control_signal = 4'b1011; // BGTZ
            4'b1010: control_signal = 4'b1100; // BLEZ
            4'b1011: control_signal = 4'b1101; // BLTZ
        endcase
    end
endmodule
