`timescale 1ns/1ps

module ShiftLeftTwo(input1, result);
    input [31:0] input1;
    output reg[31:0] result;

    always @(*) begin
        result = input1 << 32'd2;
    end
endmodule
