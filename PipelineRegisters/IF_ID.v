`timescale 1ns/1ps

module IF_ID(PCPlusFour, Instruction, outPCPlusFour, outInstruction, Clk);
    input [31:0] PCPlusFour, Instruction;
    input Clk;
    output reg [31:0] outPCPlusFour, outInstruction;

    always @(posedge Clk) begin
        outPCPlusFour <= PCPlusFour;
        outInstruction <= Instruction;
    end
endmodule
