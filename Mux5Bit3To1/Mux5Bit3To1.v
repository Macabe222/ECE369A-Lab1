`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
//
// Module - Mux32Bit2To1.v
// Description - Performs signal multiplexing between 3 5-Bit inputs.
////////////////////////////////////////////////////////////////////////////////

module Mux5Bit3To1(out, inA, inB, inC, sel);

    output reg [4:0] out;

    input [4:0] inA;
    input [4:0] inB;
    input [1:0] sel;

    always @(*) begin
        case (sel)
            2'b00: out = inA;
            2'b01: out = inB;
            2'b10: out = inC;
            default: out = inA;
        endcase
    end

endmodule
