`timescale 1ns/1ps

module CPU32Bit_tb();
    wire unDivClk, Rst = 1;
    wire [31:0] outWriteData, outPC;

    always begin
        unDivClk = 0;
        #5;
        unDivClk = 1;
        #5;
    end

    CPU32Bit u1(.unDivClk(unDivClk), .Rst(Rst), .outWriteData(outWriteData), .outPC(outPC));

    initial begin
        #250 Rst = 0;

        wait (outPC == 32'd0);
        @(negedge unDivClk);

        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);


        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);

        $display("Write data: %h, PC: %h", outWriteData, outPC);
        // NOP
        repeat (6) @(negedge unDivClk);

    $finish;
    end

endmodule
