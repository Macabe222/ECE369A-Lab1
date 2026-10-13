`timescale 1ns/1ps

module CPU32Bit_tb();
    reg Clk, Rst = 1;
    wire [31:0] outWriteData, outPC;

    always begin
        Clk = 0;
        #5;
        Clk = 1;
        #5;
    end

    CPU32Bit u1(.Clk(Clk), .Rst(Rst), .outWriteData(outWriteData), .outPC(outPC));

    initial begin
        #250 Rst = 0;
        #1000 $finish;
    end

    always @(negedge Clk) begin
        if (!Rst && u1.WB_RegWrite && u1.WB_WriteReg != 0) begin
            $display("PC: %d, WriteData: %d", outPC, outWriteData);
        end
    end

endmodule
