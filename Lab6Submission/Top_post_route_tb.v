`timescale 1ns / 1ps

// Drives the same external ports in RTL and in the implemented Top netlist.
// View ClkOut, Instruction, PC, and WriteData in the implemented waveform.
module Top_post_route_tb;
    reg Clk = 1'b0;
    reg Reset = 1'b0;
    wire [6:0] out7;
    wire [7:0] en_out;

    Top dut(.Clk(Clk), .Reset(Reset), .SW0(1'b0),
            .out7(out7), .en_out(en_out));

    // 100 MHz board clock.
    always #5 Clk = ~Clk;

    initial begin
        // Wait past the simulator's startup reset, then reset the CPU and divider.
        #200 Reset = 1'b1;
        #100 Reset = 1'b0;

        // Build Top with CPU_DIV_VALUE=9 for this simulation window.
        #200000;
        $display("Inspect the PC and WriteData waveform for the 0000600D pass marker.");
        $finish;
    end
endmodule
