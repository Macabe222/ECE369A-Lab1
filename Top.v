/*
Team Percentage: Everyone worked on it with the same percentage of effort and we split up everything equally. Ian: 33%, Kamil: 33%, Macabe: 33%
*/
`timescale 1ns / 1ps


module Top(Clk, Reset, out7, en_out);
    input Clk, Reset;
    wire [31:0] Instruction;
    output wire [6:0] out7;
    output wire [7:0] en_out;
    wire [7:0] en_raw;
    wire [31:0] PC, WriteData;
    wire ClkOut;
    ClkDiv u0(Clk, 0, ClkOut);
    CPU32Bit u1(ClkOut, Reset, WriteData, PC, Instruction);
    Two4DigitDisplay u2(Clk, PC[15:0], WriteData[15:0], out7, en_raw);
    assign en_out = (Instruction == 32'h0) ? 8'hFF : en_raw;
endmodule
