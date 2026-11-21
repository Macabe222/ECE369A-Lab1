`timescale 1ns / 1ps

module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, MemSize, ReadData);

    input [31:0] Address; 	// Input Address
    input [31:0] WriteData; // Data that needs to be written into the address
    input [1:0] MemSize;    // Control signal for selecting between byte, half word, and full word
    input Clk;
    input MemWrite; 		// Control signal for memory write
    input MemRead; 			// Control signal for memory read

    output reg[31:0] ReadData; // Contents of memory location at Address

    reg [31:0] DataMemory [0:4095];

    // Initialize data memory to 0
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            DataMemory[i] = 32'd0;
        end
        $readmemh("public_data_memory_lab6.mem", DataMemory);
    end

    // Store path
    always @(posedge Clk) begin
        if (MemWrite) begin
            case (MemSize)
                2'b00: begin // SB
                    case (Address[1:0])
                        2'b00: DataMemory[Address[13:2]][7:0] <= WriteData[7:0]; // First byte
                        2'b01: DataMemory[Address[13:2]][15:8] <= WriteData[7:0]; // Second byte
                        2'b10: DataMemory[Address[13:2]][23:16] <= WriteData[7:0]; // Third byte
                        2'b11: DataMemory[Address[13:2]][31:24] <= WriteData[7:0]; // Fourth byte
                    endcase
                end
                2'b01: begin // SH
                    case (Address[1])
                        1'b0: DataMemory[Address[13:2]][15:0] <= WriteData[15:0]; // First half word
                        1'b1: DataMemory[Address[13:2]][31:16] <= WriteData[15:0]; // Second half word
                    endcase
                end
                2'b10: DataMemory[Address[13:2]] <= WriteData; // SW
            endcase
        end
    end

    // Temporary storage
    reg [7:0] b;
    reg [15:0] h;
    reg [31:0] word;

    // Load path
    always @(*) begin
        word = DataMemory[Address[13:2]];
        b = 8'h00;
        h = 16'h0000;
        ReadData = 32'h00000000;

        if (MemRead) begin
            case(MemSize)
                2'b00: begin // LB
                    case (Address[1:0])
                        2'b00: b = word[7:0]; // First byte
                        2'b01: b = word[15:8]; // Second byte
                        2'b10: b = word[23:16]; // Third byte
                        2'b11: b = word[31:24]; // Fourth byte
                    endcase
                    ReadData = {{24{b[7]}}, b}; // Sign extend byte to full word
                end
                2'b01: begin// LH
                    case (Address[1])
                        1'b0: h = word[15:0];
                        1'b1: h = word[31:16];
                    endcase
                    ReadData = {{16{h[15]}}, h};
                end
                2'b10: ReadData = word; // LW
            endcase
        end
    end


endmodule
