`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
//
// Module - DataMemory_tb.v
// Description - Test the 'DataMemory.v' module.
////////////////////////////////////////////////////////////////////////////////

module DataMemory_tb();

    reg     [31:0]  Address;
    reg     [31:0]  WriteData;
    reg             Clk;
    reg             MemWrite;
    reg             MemRead;

    wire [31:0] ReadData;

    DataMemory u0(
        .Address(Address),
        .WriteData(WriteData),
        .Clk(Clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ReadData(ReadData)
    );

	initial begin
		Clk <= 1'b0;
		forever #10 Clk <= ~Clk;
	end

	initial begin
        Address = 32'h00000000;
        MemWrite = 0;
        MemRead = 0;

        #20;
        WriteData = 32'h12345678;
        MemWrite = 1;

        #20;
        MemWrite = 0;
        MemRead = 1;

        #10;
        $display("Address: %h, WriteData: %h, ReadData: %h", Address, WriteData, ReadData);

        #10;
        Address = 32'h00000004;
        WriteData = 32'hABCDEF01;
        MemWrite = 1;

        #20;
        MemWrite = 0;
        MemRead = 1;

        #10
        $display("Address: %h, WriteData: %h, ReadData: %h", Address, WriteData, ReadData);

        #10
        Address = 32'h00000000;
        MemRead = 1;

        #10;
        $display("Address: %h, WriteData: %h, ReadData: %h", Address, WriteData, ReadData);

        #10;
        MemRead = 0;

        #10;
        $display("Address: %h, WriteData: %h, ReadData: %h", Address, WriteData, ReadData);

        #10;
        $finish;

	end

endmodule
