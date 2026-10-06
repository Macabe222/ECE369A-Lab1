~timescale 1ns/1ps

module ALUControl(ALUOp, function);
    input [5:0] function;
    input [2:0] ALUOp;

    output reg [3:0] control_signal;

    always @(*) begin
        case (ALUOp)
            3'b000: control_signal = 4'b0000; // Memory and ADDi
            3'b001: control_signal = 4'b0001; // Branch
            3'b010: // R-type
            case (function)
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
            3'b011: control_signal = 4'b0011; // ANDi
            3'b100: control_signal = 4'b0100; // ORi
            3'b101: control_signal = 4'b0110; // XORi
            3'b110: control_signal = 4'b0101; // SLTi
            3'b111: control_signal = 4'b0010; // MUL, this is neccessary becasue  SRL and MUL have the same function code
        endcase
    end
endmodule
