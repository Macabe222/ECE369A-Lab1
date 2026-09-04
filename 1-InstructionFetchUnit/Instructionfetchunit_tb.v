`timescale 1ns / 1ps

module Instructionfetchunit_tb();
    
    reg Reset;
    reg Clk;
    
    wire [31:0] Instruction;
    wire [31:0] PCResult;
    
    InstructionFetchUnit u0(
            .Instruction(Instruction),
            .PCResult (PCResult),
            .Reset (Reset),
            .Clk (Clk)
    );
    
    initial begin
        Clk <= 1'b0; //Clk starts at 0
        forever #10 Clk <= ~Clk;//Clk flips every 10 ns
    end
    
    initial begin 
        Reset <= 1'b1;//Reset
        #20;
        Reset <= 1'b0; //Continue with the normal process
        end


endmodule
