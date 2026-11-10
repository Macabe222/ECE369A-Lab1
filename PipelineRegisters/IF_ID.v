`timescale 1ns/1ps

////////////////////////////////////////////////////////////////////////////////
// Pipeline register to pass signals and data from the instruction fetch stage to instruction decode stage
////////////////////////////////////////////////////////////////////////////////

module IF_ID(PCPlusFour, Instruction, outPCPlusFour, outInstruction, Clk, Reset, WriteEnable, Flush);
    input [31:0] PCPlusFour, Instruction;
    input Clk, Reset, WriteEnable, Flush;
    output reg [31:0] outPCPlusFour, outInstruction;

    // Initialize register contents

    // Update at rising clock edge
    always @(posedge Clk or posedge Reset) begin
        if (Reset == 1) begin
            outPCPlusFour <= 0;
            outInstruction <= 0;
        end
        else if (Flush == 1) begin
            outPCPlusFour <= 0;
            outInstruction <= 0;
        end

        else if (WriteEnable == 1) begin
            outPCPlusFour <= PCPlusFour;
            outInstruction <= Instruction;
        end
        
    end
endmodule
