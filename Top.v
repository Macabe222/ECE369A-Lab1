`timescale 1ns / 1ps


module Top();
    reg Clk;
    reg Reset;
    wire [15:0] instruct;
    wire [15:0] Result;
    wire [31:0] Instruction;
    wire [31:0] PCResult;
    wire ClkOut;
    ClkDiv(Clk, 0, ClkOut);
    InstructionFetchUnit(Instruction, PCResult, Reset, ClkOut);
    assign instruct = Instruction[15:0];
    assign Result = PCResult[15:0];
    Two4DigitDisplay(Clk, instruct, Result, out7, en_out);
   
   
endmodule
