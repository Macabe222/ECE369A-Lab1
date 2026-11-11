`timescale 1ns/1ps
// Behavioral tests for no-NOP dependencies, discarded stores, and reset.
module CPU32Bit_hazards_tb;
    reg Clk = 0;
    reg Rst = 0;
    reg RunClock = 1;
    wire [31:0] WriteData, PC, Instruction;
    integer i;
    integer checks = 0;
    integer stores = 0;
    integer stalls = 0;
    reg WatchProgram = 0;

    CPU32Bit dut(Clk, Rst, WriteData, PC, Instruction);
    always #5 begin
        if (RunClock == 1'b1) Clk = ~Clk;
    end

    // Observe each actual store edge, rather than just the final memory value.
    always @(posedge Clk) begin
        if (WatchProgram && !Rst) begin
            if (dut.MEM_MemWrite) stores = stores + 1;
            if (dut.Stall) stalls = stalls + 1;
        end
    end

    function [31:0] itype;
        input [5:0] op;
        input [4:0] rs, rt;
        input integer immediate;
        begin itype = {op, rs, rt, immediate[15:0]}; end
    endfunction

    function [31:0] rtype;
        input [4:0] rs, rt, rd;
        input [5:0] funct;
        begin rtype = {6'd0, rs, rt, rd, 5'd0, funct}; end
    endfunction

    task check;
        input [8*80-1:0] label;
        input [31:0] actual, expected;
        begin
            if (actual !== expected)
                $fatal(1, "%0s: got %h expected %h", label, actual, expected);
            checks = checks + 1;
            $display("PASS %0s", label);
        end
    endtask

    task clear_rom;
        begin
            for (i = 0; i < 1024; i = i + 1) dut.u4.Memory[i] = 0;
        end
    endtask

    initial begin
        #1; Rst = 1;
        clear_rom;
        // Consecutive instructions start at PC zero.
        dut.u4.Memory[0] = itype(8,0,8,10);
        dut.u4.Memory[1] = itype(8,0,9,6);
        dut.u4.Memory[2] = rtype(8,9,10,32); // add r10,r8,r9
        dut.u4.Memory[3] = itype(43,0,10,64); // store result
        dut.u4.Memory[4] = itype(35,0,11,64); // load it back
        dut.u4.Memory[5] = rtype(11,11,12,32); // load dependency
        dut.u4.Memory[6] = itype(4,12,12,1); // taken beq -> word 8
        dut.u4.Memory[7] = itype(43,0,0,64); // must be discarded
        dut.u4.Memory[8] = itype(8,0,13,1);
        dut.u4.Memory[9] = {6'd2,26'd11}; // j word 11
        dut.u4.Memory[10] = itype(43,0,0,64); // must be discarded
        dut.u4.Memory[11] = itype(8,0,14,56); // byte target for jr
        dut.u4.Memory[12] = rtype(14,0,0,8); // dependent jr -> word 14
        dut.u4.Memory[13] = itype(43,0,0,64); // must be discarded
        dut.u4.Memory[14] = {6'd3,26'd18}; // jal, link = byte 60
        dut.u4.Memory[15] = {6'd2,26'd22}; // run after return
        dut.u4.Memory[16] = itype(43,0,0,64); // must be discarded
        dut.u4.Memory[18] = itype(8,0,15,77);
        dut.u4.Memory[19] = rtype(31,0,0,8); // return
        dut.u4.Memory[20] = itype(43,0,0,64); // must be discarded
        dut.u4.Memory[22] = itype(8,0,16,99);
        dut.u4.Memory[23] = {6'd2,26'd23}; // park after completion
        #11; Rst = 0; WatchProgram = 1;
        repeat (150) @(posedge Clk);
        @(negedge Clk); #1; WatchProgram = 0;
        check("instruction at PC zero executed",dut.u11.registers[8],10);
        check("two-source dependency",dut.u11.registers[10],16);
        check("store then load",dut.u11.registers[11],16);
        check("load then add",dut.u11.registers[12],32);
        check("taken branch target",dut.u11.registers[13],1);
        check("jal function executed",dut.u11.registers[15],77);
        check("jal uses PC plus four",dut.u11.registers[31],60);
        check("returned and reached final target",dut.u11.registers[16],99);
        check("discarded stores never wrote",stores,1);
        check("memory retains intended store",dut.u20.DataMemory[16],16);
        if (stalls == 0) $fatal(1,"No stalls observed");
        check("program exercised stalls",1,1);

        // Prepare pending register and memory writes, then stop the clock.
        Rst = 1; clear_rom;
        dut.u4.Memory[0] = itype(8,0,20,7);
        dut.u4.Memory[1] = itype(43,0,0,64);
        dut.u4.Memory[2] = itype(8,0,21,8);
        dut.u4.Memory[3] = itype(8,0,22,9);
        #2; Rst = 0;
        wait (dut.WB_RegWrite && dut.MEM_MemWrite && dut.EX_RegWrite);
        #1; RunClock = 0; // freeze high before the WB falling edge
        Rst = 1;
        #1;
        check("asynchronous PC reset",dut.Address,0);
        check("asynchronous IF/ID reset",dut.ID_Instruction,0);
        check("ID/EX reset clears write",dut.EX_RegWrite,0);
        check("EX/MEM reset clears store",dut.MEM_MemWrite,0);
        check("MEM/WB reset clears write",dut.WB_RegWrite,0);
        #20;
        check("pending WB write cancelled",dut.u11.registers[20],0);
        check("pending store cancelled",dut.u20.DataMemory[16],16);
        // Now park low, as a reset clock divider would do.
        Clk = 0;
        clear_rom;
        dut.u4.Memory[0] = itype(8,0,23,123);
        dut.u4.Memory[1] = {6'd2,26'd1};
        #2; Rst = 0; RunClock = 1;
        repeat (20) @(posedge Clk);
        @(negedge Clk); #1;
        check("CPU restarts at PC zero",dut.u11.registers[23],123);
        check("cancelled EX instruction stayed cancelled",dut.u11.registers[21],0);
        $display("HAZARD AND RESET TEST PASSED: %0d checks",checks);
        $finish;
    end

    initial begin
        #20000;
        $fatal(1,"Hazard/reset test timed out");
    end
endmodule
