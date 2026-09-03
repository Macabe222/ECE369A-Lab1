`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2026 06:55:24 PM
// Design Name: 
// Module Name: Instructionfetchunit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
        Clk <= 1'b0;
        forever #10 Clk <= ~Clk;
    end
    
    initial begin 
        Reset <= 1'b1;
        #20;
        Reset <= 1'b0;
        end


endmodule
