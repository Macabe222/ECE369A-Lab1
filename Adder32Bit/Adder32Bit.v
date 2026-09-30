`timescale 1ns/1ps

module Adder32Bit(input1, input2, result);
    input1 [31:0];
    input2 [31:0];
    output reg [31:0] result;

    always @(*) begin
        result = input1 + input2;
    end
endmodule
