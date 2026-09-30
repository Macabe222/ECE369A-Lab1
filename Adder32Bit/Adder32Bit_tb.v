`timescale 1ns/1ps

module Adder32Bit_tb();

    reg [31:0] input1, input2, result;
    Adder32Bit u0(.input1(input1), .input2(input2), .result(result));

    initial begin
        #100;
        input1 = 32'd5;
        input2 = 32'd5;
        $display("input1=%h, input2=%h, result=%h", input1, input2, result);

        #100
        input1 = 32'd7;
        input2 = 32'd8;
        $display("input1=%h, input2=%h, result=%h", input1, input2, result);
    end
endmodule
