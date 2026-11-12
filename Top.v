/*
Team Percentage: Everyone worked on it with the same percentage of effort and we split up everything equally. Ian: 33%, Kamil: 33%, Macabe: 33%
*/
`timescale 1ns / 1ps


module Top(Clk, Reset, out7, en_out);
    // The board uses the default divider. A smaller value speeds up simulation.
    parameter integer CPU_DIV_VALUE = 50000000;
    input Clk, Reset;
    (* DONT_TOUCH = "yes" *) wire [31:0] Instruction;
    output wire [6:0] out7;
    output wire [7:0] en_out;
    wire [7:0] en_raw;
    // Preserve the full buses for the implemented waveform. The display uses 16 bits.
    (* DONT_TOUCH = "yes" *) wire [31:0] PC;
    (* DONT_TOUCH = "yes" *) wire [31:0] WriteData;
    (* DONT_TOUCH = "yes" *) wire ClkOut;
    ClkDiv #(.DivVal(CPU_DIV_VALUE)) u0(Clk, Reset, ClkOut);
    CPU32Bit u1(ClkOut, Reset, WriteData, PC, Instruction);
    Two4DigitDisplay u2(Clk, PC[15:0], WriteData[15:0], out7, en_raw);
    assign en_out = (Instruction == 32'h0) ? 8'hFF : en_raw;
endmodule
