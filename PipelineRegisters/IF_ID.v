`timescale 1ns/1ps

////////////////////////////////////////////////////////////////////////////////
// Pipeline register to pass signals and data from the instruction fetch stage to instruction decode stage
////////////////////////////////////////////////////////////////////////////////

module IF_ID(PCPlusFour, Instruction, outPCPlusFour, outInstruction, Clk);
    input [31:0] PCPlusFour, Instruction;
    input Clk;
    output reg [31:0] outPCPlusFour, outInstruction;

    // Initialize register contents
    initial begin
        outPCPlusFour = 0; outInstruction = 0;
    end

    // Update at rising clock edge
    always @(posedge Clk) begin
        outPCPlusFour <= PCPlusFour;
        outInstruction <= Instruction;
    end
endmodule
