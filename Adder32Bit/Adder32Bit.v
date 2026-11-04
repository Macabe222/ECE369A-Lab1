`timescale 1ns/1ps

////////////////////////////////////////////////////////////////////////////////
// Adds two 32 bit numbers and returns a 32 bit number
////////////////////////////////////////////////////////////////////////////////

module Adder32Bit(input1, input2, result);
    input [31:0] input1, input2;
    output reg [31:0] result;

    always @(*) begin
        result = input1 + input2;
    end
endmodule
