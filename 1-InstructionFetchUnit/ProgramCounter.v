`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory 1
// Module - pc_register.v
// Description - 32-Bit program counter (PC) register.
//
// INPUTS:-
// Address: 32-Bit address input port.
// Reset: 1-Bit input control signal.
// Clk: 1-Bit input clock signal.
//
// OUTPUTS:-
// PCResult: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design a program counter register that holds the current address of the 
// instruction memory.  This module should be updated at the positive edge of 
// the clock. The contents of a register default to unknown values or 'X' upon 
// instantiation in your module.  
// You need to enable global reset of your datapath to point 
// to the first instruction in your instruction memory (i.e., the first address 
// location, 0x00000000H).
////////////////////////////////////////////////////////////////////////////////
//Sequential register which updates on the positive edfe of clk, the output depends mainly on reset, since if it is 1 it will be forced to 0x000000000 but if it is 0 it will store whatever is on Address into PCResult

module ProgramCounter(Address, PCResult, Reset, Clk);

	input [31:0] Address;
	input Reset, Clk;

	output reg [31:0] PCResult;

	always @(posedge Clk) begin//This will happen on the positive edge of clock we have the Non Blocking <= since it is a sequential register
        if (Reset == 1)begin 
            PCResult <= 32'h00000000; //When reset is selected it will set PCResult to 0
        end
        else begin
            PCResult <= Address; //This grabs whatever is inside Address and gives it to PCResult
        end
    end

endmodule

