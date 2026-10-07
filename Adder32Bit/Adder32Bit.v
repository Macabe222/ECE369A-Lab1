`timescale 1ns/1ps

module Adder32Bit(input1, input2, result);
    input [31:0] input1, input2;
    output reg [31:0] result;

    always @(*) begin
        result = input1 + input2;
    end
endmodule
