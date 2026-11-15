`timescale 1ns/1ps
// Use lab6_all_instructions.mem as instruction_memory.mem.
// This bench observes public CPU outputs and the program's pass/fail marker.
module CPU32Bit_program_tb;
    reg Clk = 0;
    reg Rst = 0;
    wire [31:0] WriteData, PC, Instruction;
    reg [29:0] covered = 0;
    integer slot;
    integer executed = 0;
    CPU32Bit dut(Clk, Rst, WriteData, PC, Instruction);
    always #5 Clk = ~Clk;
    initial begin #1; Rst=1; #11; Rst=0; end

    function integer instruction_slot;
        input [31:0] inst;
        begin
            instruction_slot=-1;
            case(inst[31:26])
                0: case(inst[5:0])
                    32:instruction_slot=0; 34:instruction_slot=1;
                    36:instruction_slot=2; 37:instruction_slot=3;
                    38:instruction_slot=4; 39:instruction_slot=5;
                    42:instruction_slot=6; 0:instruction_slot=7;
                    2:instruction_slot=8; 8:instruction_slot=9;
                endcase
                28:instruction_slot=10;
                4:instruction_slot=11; 5:instruction_slot=12;
                1: if(inst[20:16]==0) instruction_slot=13;
                   else if(inst[20:16]==1) instruction_slot=14;
                6:instruction_slot=15; 7:instruction_slot=16;
                8:instruction_slot=17; 10:instruction_slot=18;
                12:instruction_slot=19; 13:instruction_slot=20;
                14:instruction_slot=21; 32:instruction_slot=22;
                33:instruction_slot=23; 35:instruction_slot=24;
                40:instruction_slot=25; 41:instruction_slot=26;
                43:instruction_slot=27; 2:instruction_slot=28;
                3:instruction_slot=29;
            endcase
        end
    endfunction

    always @(negedge Clk) begin
        #1;
        if (!Rst && Instruction !== 0 && (^Instruction !== 1'bx)) begin
            slot=instruction_slot(Instruction);
            if(slot>=0) covered[slot]=1;
            executed=executed+1;
            // The program writes register 23 as its pass/fail marker.
            if(Instruction[31:26]==8 && Instruction[20:16]==23) begin
                if(WriteData==2989) $fatal(1,"ROM program reached fail at PC %0d",PC);
                if(WriteData==24589) begin
                    if(covered !== 30'h3fffffff)
                        $fatal(1,"Program passed but mnemonic coverage incomplete: %h",covered);
                    $display("ALL-INSTRUCTIONS ROM PASSED: 30 mnemonics, %0d executed instructions",executed);
                    $finish;
                end
            end
        end
    end
    initial begin #100000; $fatal(1,"All-instructions ROM timed out"); end
endmodule
