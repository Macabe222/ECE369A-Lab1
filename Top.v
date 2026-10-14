`timescale 1ns / 1ps


module Top();
    reg Clk;
    reg Reset;

    wire [31:0] PC, WriteData
    wire ClkOut;
    ClkDiv u0(Clk, 0, ClkOut);
    CPU32Bit u1(ClkOut, Reset, WriteData, PC);
    Two4DigitDisplay u2(Clk, PC, WriteData, out7, en_out);
endmodule
