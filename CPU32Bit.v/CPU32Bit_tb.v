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

        wait (outPC == 32'd0);
        @(negedge Clk);

        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);

        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge Clk);

    $finish;
    end

endmodule
