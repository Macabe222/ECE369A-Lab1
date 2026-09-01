`timescale 1ns / 1ps


module Top(Clk, Reset, out7, en_out);
    input Clk;
    output [6:0] out7;
    output [7:0] en_out;
    input Reset;
    wire [15:0] instruct;
    wire [15:0] Result;
    wire [31:0] Instruction;
    wire [31:0] PCResult;
    wire ClkOut;
    ClkDiv u1(Clk, 1'b0, ClkOut);
    InstructionFetchUnit u2(Instruction, PCResult, Reset, ClkOut);
    assign instruct = Instruction[15:0];
    assign Result = PCResult[15:0];
    Two4DigitDisplay u3(Clk, instruct, Result, out7, en_out);
   
   
endmodule
