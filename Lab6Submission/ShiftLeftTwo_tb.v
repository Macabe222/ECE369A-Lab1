`timescale 1ns/1ps

module ShiftLeftTwo_tb();
    reg [31:0] input1;
    wire [31:0] result;

    ShiftLeftTwo u0(.input1(input1), .result(result));

    initial begin
        #100;
        input1 = 32'd4;
        $display("input1=%h, result=%h", input1, result);

        #100;
        input1 = 32'd7;
        $display("input1=%h, result=%h", input1, result);

        #100;
        input1 = 32'd0;
        $display("input1=%h, result=%h", input1, result);
    end
endmodule
