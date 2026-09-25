`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
//
// Module - ALU32Bit_tb.v
// Description - Test the 'ALU32Bit.v' module.
////////////////////////////////////////////////////////////////////////////////

module ALU32Bit_tb();

	reg [3:0] ALUControl;   // control bits for ALU operation
	reg [31:0] A, B;	        // inputs

	wire [31:0] ALUResult;	// answer
	wire Zero;	        // Zero=1 if ALUResult == 0

    ALU32Bit u0(
        .ALUControl(ALUControl),
        .A(A),
        .B(B),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

	initial begin
	    // ADD 3+3 ALUResult should be 6
	    #100 ALUControl = 4'b0000;
		A = 32'd3;
		B = 32'd3;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

        // SUB 7-3 ALUResult should be 4
        #100 ALUControl = 4'b0001;
		A = 32'd7;
		B = 32'd3;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

        // SUB 3-3 ALUResult should be 0, Zero should be 1
		#100 ALUControl = 4'b0001;
		A = 32'd3;
		B = 32'd3;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

		// MUL 3*3 ALUResult should be 9
		#100 ALUControl = 4'b0010;
		A = 32'd3;
		B = 32'd3;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

		// Bitwise AND 32d'11 32d'2 ALUResult should be 32d'2
		#100 ALUControl = 4'b0011;
		A = 32'd11;
		B = 32'd2;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

		// Bitwise OR 32d'11 32d'2 ALUResult should be 32d'11
		#100 ALUControl = 4'b0100;
		A = 4'b1011;
		B = 4'b0010;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

		// SLT 2 5 ALUResult should be 32'h00000001
		#100 ALUControl = 4'b0101;
		A = 32'd2;
		B = 32'd5;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

		// Bitwise XOR 32d'11 32d'2 ALUResult should be 32d'7
		#100 ALUControl = 4'b0110;
		A = 32'd2;
		B = 32'd5;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

		// Bitwise NOR 32d'11 32d'2 ALUResult should be 32h'FFFFFFF4
		#100 ALUControl = 4'b0111;
		A = 32'd2;
		B = 32'd5;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

        // Bitwise NAND 32d'11 32d'2 ALUResult should be 32h'FFFFFFFD
		#100 ALUControl = 4'b1000;
		A = 32'd2;
		B = 32'd5;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

		// Shift Right Logical 32d'4 32d'2 ALUResult should be 1
		#100 ALUControl = 4'b1001;
		A = 32'd4;
		B = 32'd2;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

		// Shift Left Logical 32d'4 32d'2 ALUResult should be 16
		#100 ALUControl = 4'b1010;
		A = 32'd4;
		B = 32'd2;
		#20 $display("ALUControl=%h, A=%h, B=%h, ALUResult=%h, Zero=%h", ALUControl, A, B, ALUResult, Zero)

    end

endmodule
