`timescale 1ns / 1ps


module Top(Clk, Reset, out7, en_out);
    reg Clk;
    reg Reset;
    output reg [6:0] out7;
    output reg [7:0] en_out;

    wire [31:0] PC, WriteData;
    wire ClkOut;
    ClkDiv u0(Clk, 0, ClkOut);
    CPU32Bit u1(ClkOut, Reset, WriteData, PC);
    Two4DigitDisplay u2(Clk, PC[15:0], WriteData[15:0], out7, en_out);
endmodule
