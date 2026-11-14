`timescale 1ns/1ps

module ShiftLeftTwo26Bit(input1, result);
    input [25:0] input1;
    output reg[27:0] result;

    always @(*) begin
        result = input1 << 26'd2;
    end
endmodule
