`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory  
// Module - PCAdder.v
// Description - 32-Bit program counter (PC) adder.
// 
// INPUTS:-
// PCResult: 32-Bit input port.
// 
// OUTPUTS:-
// PCAddResult: 32-Bit output port.
//
// FUNCTIONALITY:-
// Design an incrementor (or a hard-wired ADD ALU whose first input is from the 
// PC, and whose second input is a hard-wired 4) that computes the current 
// PC + 4. The result should always be an increment of the signal 'PCResult' by 
// 4 (i.e., PCAddResult = PCResult + 4).
////////////////////////////////////////////////////////////////////////////////
//We are incrementing by 4 in this PCAdder; PCAddResult will update when PCResult updates.
//It takes the PCResult and adds 4 in a 32-bit instruction memory; since every instruction is 4 bytes, that is why we are adding 4


module PCAdder(PCResult, PCAddResult);

    input [31:0] PCResult; //Delaring the input 

    output reg [31:0] PCAddResult; //Declaring output

    always @(*) begin //We use blocking assignment because it is combinational logic @(*)
        PCAddResult = PCResult + 32'd4;  //We are adding by 4 using 32'd4 whihc is a 32 bit wide constant that has the decimal value 4
    end
endmodule

