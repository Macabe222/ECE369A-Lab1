`timescale 1ns / 1ps

module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
	// Inputs
    input [4:0] ReadRegister1;
    input [4:0] ReadRegister2;
    input [4:0] WriteRegister;
    input [31:0] WriteData;
    input RegWrite;
    input Clk;

    // Outputs
    output reg [31:0] ReadData1;
    output reg [31:0] ReadData2;

    // 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];

    // Initialize registers to 0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) registers[i] = 32'h0;
        registers[29] = 32'd16380; // Stack pointer
    end

    // Write to register file on falling edge
    always @(negedge Clk) begin
        if (RegWrite && WriteRegister != 5'b00000) begin
            registers[WriteRegister] <= WriteData;
        end
    end

    always @(*) begin

        // Register 0 always contains 0
        if (ReadRegister1 == 5'b00000)
            ReadData1 = 32'b0;
        else
            ReadData1 = registers[ReadRegister1];

        if (ReadRegister2 == 5'b00000)
            ReadData2 = 32'b0;
        else
            ReadData2 = registers[ReadRegister2];

    end

endmodule
