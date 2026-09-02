`timescale 1ns / 1ps

//We followed the top design shown in the power point to connect everything
module Top(Clk, Reset, out7, en_out);
    input Clk;
    output [6:0] out7;//out7 and en_put are outputs from the Two4DigitDisplay module, they connect with the board display
    output [7:0] en_out;
    input Reset; //Reset button
    wire [15:0] instruct; //All the wire are connecting between modules
    wire [15:0] Result;
    wire [31:0] Instruction;
    wire [31:0] PCResult;

    //Instruct grabs the first 16 bits of Instruction and Result does the same for PCResult since the diagram says to ignor the other 16
    
    wire ClkOut;
    ClkDiv u1(Clk, 1'b0, ClkOut);//It grabs the board clock input and makes clokout so humans can follow what it is doing
    InstructionFetchUnit u2(Instruction, PCResult, Reset, ClkOut);//This produces the instruction based on the slow clock from clkdiv
    assign instruct = Instruction[15:0];
    assign Result = PCResult[15:0];
    Two4DigitDisplay u3(Clk, instruct, Result, out7, en_out);//Displays instruct abd Result side by side
   
   
endmodule
