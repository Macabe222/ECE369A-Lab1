`timescale 1ns/1ps
// ECE369A Labs 4-5: self-checking BEHAVIORAL CPU testbench.
// Team members / percentage effort: fill in your actual contributions.
//
// Vivado: add this file as a Simulation Source, set simulation top to
// CPU32Bit_all_operations_tb, and Run All. Do not synthesize this file.
// Include all DESIGN .v sources and your existing instruction_memory.mem.
// Icarus: iverilog -g2012 -s CPU32Bit_all_operations_tb -o verify <design .v files> CPU32Bit_all_operations_tb.v
//         vvp verify
//
// Matches the reviewed CPU hierarchy: dut.u4.Memory, dut.u11.registers,
// dut.u20.DataMemory. Update these paths if you rename those instances.
// Programs are injected into instruction RAM for simulation only. Register
// operands are initialized by actual ADDI instructions; memory by actual stores.
// Five NOPs follow each emitted instruction. No forwarding is assumed.
// JAL is checked against PC+4, matching this CPU's no architectural delay-slot
// convention. Jump/branch fall-through slots contain NOPs.
//
// This covers all 29 REQUIRED mnemonics and selected edge cases, not exhaustive
// proof, post-routing verification, board clock startup, or .mem loading.
// Validated on reviewed commit a43d9e9: 60 scenarios, 106 checks pass.
// Set IMEM_WORDS=1024 after enlarging InstructionMemory to the required size.
// No repository files or memory initialization files are modified by this test.
module CPU32Bit_all_operations_tb;
    parameter IMEM_WORDS = 128;
    reg Clk = 0;
    reg Rst = 1;
    wire [31:0] outWriteData, outPC, outInstruction;
    integer passed = 0, failed = 0, cases_run = 0;
    integer cursor, i;
    reg [8*100-1:0] case_name;
    CPU32Bit dut(.Clk(Clk), .Rst(Rst), .outWriteData(outWriteData),
                 .outPC(outPC), .outInstruction(outInstruction));
    always #5 Clk = ~Clk;

    function [31:0] enc_i;
        input [5:0] op;
        input [4:0] rs, rt;
        input integer imm;
        begin enc_i = {op, rs, rt, imm[15:0]}; end
    endfunction
    function [31:0] enc_r;
        input [5:0] op;
        input [4:0] rs, rt, rd, shamt;
        input [5:0] funct;
        begin enc_r = {op, rs, rt, rd, shamt, funct}; end
    endfunction

    task check;
        input [8*100-1:0] label;
        input [31:0] actual, expected;
        begin
            if (actual === expected) begin
                passed = passed + 1;
                $display("PASS [%0s] %0s = %08h", case_name, label, actual);
            end else begin
                failed = failed + 1;
                $display("FAIL [%0s] %0s: got %08h expected %08h", case_name, label, actual, expected);
            end
        end
    endtask

    task begin_case;
        input [8*100-1:0] label;
        begin
            @(negedge Clk); #1;
            Rst = 1;
            // Empty ROM before draining the pipeline; reset only resets the PC
            // in the reviewed implementation. A NOP at PC 0 avoids reset replay.
            for (i=0; i<IMEM_WORDS; i=i+1) dut.u4.Memory[i] = 0;
            repeat (8) @(posedge Clk);
            @(negedge Clk); #1;
            case_name = label;
            cases_run = cases_run + 1;
            cursor = 6;
        end
    endtask

    task emit;
        input [31:0] instruction;
        begin
            if (cursor+5 >= IMEM_WORDS) $fatal(1, "Test program exceeds IMEM_WORDS");
            dut.u4.Memory[cursor] = instruction;
            cursor = cursor + 6;
        end
    endtask

    task start_case;
        begin @(negedge Clk); #1; Rst = 0; end
    endtask
    task finish_case;
        begin
            // All supplied scenarios complete well before 120 cycles; stop
            // before the reviewed 128-word instruction RAM can wrap around.
            start_case;
            repeat (120) @(posedge Clk);
            @(negedge Clk); #1;
        end
    endtask

    task binary_case;
        input [8*100-1:0] label;
        input [5:0] op, funct;
        input integer a, b;
        input [31:0] expected;
        begin
            begin_case(label);
            emit(enc_i(8,0,8,a)); emit(enc_i(8,0,9,b));
            emit(enc_i(8,0,10,123));
            emit(enc_r(op,8,9,10,0,funct));
            finish_case;
            check("destination $t2", dut.u11.registers[10], expected);
            check("$zero preserved", dut.u11.registers[0], 0);
        end
    endtask

    task immediate_case;
        input [8*100-1:0] label;
        input [5:0] op;
        input integer a, imm;
        input [31:0] expected;
        begin
            begin_case(label);
            emit(enc_i(8,0,8,a)); emit(enc_i(8,0,10,123));
            emit(enc_i(op,8,10,imm)); finish_case;
            check("destination $t2", dut.u11.registers[10], expected);
        end
    endtask

    task shift_case;
        input [8*100-1:0] label;
        input [5:0] funct;
        input integer a;
        input [4:0] shamt;
        input [31:0] expected;
        begin
            begin_case(label);
            emit(enc_i(8,0,8,a)); emit(enc_i(8,0,10,123));
            emit(enc_r(0,0,8,10,shamt,funct)); finish_case;
            check("shift result", dut.u11.registers[10], expected);
        end
    endtask

    task branch_case;
        input [8*100-1:0] label;
        input [5:0] opcode;
        input [4:0] rt;
        input integer a, b;
        input taken;
        integer branch_word;
        begin
            begin_case(label);
            emit(enc_i(8,0,8,a)); emit(enc_i(8,0,9,b));
            emit(enc_i(8,0,10,0));
            branch_word = cursor;
            // Target skips one padded ADDI (12 words after branch).
            emit(enc_i(opcode,8,rt,11));
            emit(enc_i(8,0,10,99));
            emit(enc_i(8,0,11,77));
            finish_case;
            check("branch path marker", dut.u11.registers[10], taken ? 0 : 99);
            check("target executed", dut.u11.registers[11], 77);
        end
    endtask

    // Catch hung simulations independently of program checks.
    initial begin #1000000; $fatal(1, "Global simulation timeout"); end

    initial begin
        #1;
        binary_case("ADD positive",0,32,10,6,16);
        binary_case("ADD signed",0,32,-10,6,32'hfffffffc);
        binary_case("SUB negative",0,34,6,10,32'hfffffffc);
        binary_case("SUB zero",0,34,10,10,0);
        binary_case("AND",0,36,10,6,2);
        binary_case("OR",0,37,10,6,14);
        binary_case("XOR",0,38,10,6,12);
        binary_case("NOR",0,39,10,6,32'hfffffff1);
        binary_case("SLT signed true",0,42,-1,1,1);
        binary_case("SLT signed false",0,42,1,-1,0);
        binary_case("SLT equal",0,42,-1,-1,0);
        binary_case("MUL positive",28,2,10,6,60);
        binary_case("MUL signed",28,2,-10,6,32'hffffffc4);
        immediate_case("ADDI negative",8,10,-12,32'hfffffffe);
        immediate_case("ADDI sign bit",8,0,-32768,32'hffff8000);
        immediate_case("ANDI zero extension",12,-1,32768,32'h00008000);
        immediate_case("ORI zero extension",13,0,65535,32'h0000ffff);
        immediate_case("XORI zero extension",14,-1,65535,32'hffff0000);
        immediate_case("SLTI negative true",10,-2,-1,1);
        immediate_case("SLTI negative false",10,1,-1,0);
        immediate_case("SLTI equal",10,-1,-1,0);
        shift_case("SLL",0,10,3,80);
        shift_case("SLL shamt 31",0,1,31,32'h80000000);
        shift_case("SLL shamt 0",0,-1,0,32'hffffffff);
        shift_case("SRL",2,10,1,5);
        shift_case("SRL logical sign bit",2,-1,1,32'h7fffffff);
        shift_case("SRL shamt 31",2,-1,31,1);
        begin_case("SW LW and negative address offset");
        emit(enc_i(8,0,8,16));
        emit(enc_i(8,0,9,-123));
        emit(enc_i(43,8,9,-4));
        emit(enc_i(8,0,10,123));
        emit(enc_i(35,8,10,-4));
        finish_case;
        check("stored word",dut.u20.DataMemory[3],32'hffffff85);
        check("loaded word",dut.u11.registers[10],32'hffffff85);
        begin_case("SB LB byte lane 0");
        emit(enc_i(8,0,8,-1));
        emit(enc_i(43,0,8,64));
        emit(enc_i(8,0,9,128));
        emit(enc_i(40,0,9,64));
        emit(enc_i(32,0,10,64));
        emit(enc_i(35,0,11,64));
        finish_case;
        check("LB sign extension",dut.u11.registers[10],32'hffffff80);
        check("SB preserves other lanes",dut.u11.registers[11],32'hffffff80);
        begin_case("SB LB byte lane 1");
        emit(enc_i(8,0,8,-1));
        emit(enc_i(43,0,8,64));
        emit(enc_i(8,0,9,128));
        emit(enc_i(40,0,9,65));
        emit(enc_i(32,0,10,65));
        emit(enc_i(35,0,11,64));
        finish_case;
        check("LB sign extension",dut.u11.registers[10],32'hffffff80);
        check("SB preserves other lanes",dut.u11.registers[11],32'hffff80ff);
        begin_case("SB LB byte lane 2");
        emit(enc_i(8,0,8,-1));
        emit(enc_i(43,0,8,64));
        emit(enc_i(8,0,9,128));
        emit(enc_i(40,0,9,66));
        emit(enc_i(32,0,10,66));
        emit(enc_i(35,0,11,64));
        finish_case;
        check("LB sign extension",dut.u11.registers[10],32'hffffff80);
        check("SB preserves other lanes",dut.u11.registers[11],32'hff80ffff);
        begin_case("SB LB byte lane 3");
        emit(enc_i(8,0,8,-1));
        emit(enc_i(43,0,8,64));
        emit(enc_i(8,0,9,128));
        emit(enc_i(40,0,9,67));
        emit(enc_i(32,0,10,67));
        emit(enc_i(35,0,11,64));
        finish_case;
        check("LB sign extension",dut.u11.registers[10],32'hffffff80);
        check("SB preserves other lanes",dut.u11.registers[11],32'h80ffffff);
        begin_case("SH LH halfword lane 0");
        emit(enc_i(8,0,8,-1));
        emit(enc_i(43,0,8,64));
        emit(enc_i(8,0,9,-32768));
        emit(enc_i(41,0,9,64));
        emit(enc_i(33,0,10,64));
        emit(enc_i(35,0,11,64));
        finish_case;
        check("LH sign extension",dut.u11.registers[10],32'hffff8000);
        check("SH preserves other half",dut.u11.registers[11],32'hffff8000);
        begin_case("SH LH halfword lane 1");
        emit(enc_i(8,0,8,-1));
        emit(enc_i(43,0,8,64));
        emit(enc_i(8,0,9,-32768));
        emit(enc_i(41,0,9,66));
        emit(enc_i(33,0,10,66));
        emit(enc_i(35,0,11,64));
        finish_case;
        check("LH sign extension",dut.u11.registers[10],32'hffff8000);
        check("SH preserves other half",dut.u11.registers[11],32'h8000ffff);
        begin_case("LB positive");
        emit(enc_i(8,0,8,127)); emit(enc_i(40,0,8,64)); emit(enc_i(32,0,10,64));
        finish_case; check("positive load",dut.u11.registers[10],127);
        begin_case("LH positive");
        emit(enc_i(8,0,8,32767)); emit(enc_i(41,0,8,64)); emit(enc_i(33,0,10,64));
        finish_case; check("positive load",dut.u11.registers[10],32767);
        branch_case("BEQ rs=-1",4,9,-1,0,0);
        branch_case("BEQ rs=0",4,9,0,0,1);
        branch_case("BEQ rs=1",4,9,1,0,0);
        branch_case("BNE rs=-1",5,9,-1,0,1);
        branch_case("BNE rs=0",5,9,0,0,0);
        branch_case("BNE rs=1",5,9,1,0,1);
        branch_case("BGEZ rs=-1",1,1,-1,0,0);
        branch_case("BGEZ rs=0",1,1,0,0,1);
        branch_case("BGEZ rs=1",1,1,1,0,1);
        branch_case("BLTZ rs=-1",1,0,-1,0,1);
        branch_case("BLTZ rs=0",1,0,0,0,0);
        branch_case("BLTZ rs=1",1,0,1,0,0);
        branch_case("BGTZ rs=-1",7,0,-1,0,0);
        branch_case("BGTZ rs=0",7,0,0,0,0);
        branch_case("BGTZ rs=1",7,0,1,0,1);
        branch_case("BLEZ rs=-1",6,0,-1,0,1);
        branch_case("BLEZ rs=0",6,0,0,0,1);
        branch_case("BLEZ rs=1",6,0,1,0,0);
        begin_case("backward branch / signed negative displacement");
        emit(enc_i(8,0,8,3));
        // Loop at word 12: decrement, then BGTZ from word 18 to word 12.
        emit(enc_i(8,8,8,-1));
        emit(enc_i(7,8,0,-7));
        emit(enc_i(8,0,10,77));
        finish_case;
        check("loop count",dut.u11.registers[8],0);
        check("loop exit",dut.u11.registers[10],77);
        begin_case("J target and fall-through");
        emit(enc_i(8,0,10,0));
        emit(enc_i(8,0,31,123));
        emit((2 << 26) | (cursor + 12));
        emit(enc_i(8,0,10,99));
        emit(enc_i(8,0,11,77));
        finish_case;
        check("jump skips marker",dut.u11.registers[10],0);
        check("jump target",dut.u11.registers[11],77);
        check("link register",dut.u11.registers[31],123);
        begin_case("JAL target and fall-through");
        emit(enc_i(8,0,10,0));
        emit(enc_i(8,0,31,123));
        emit((3 << 26) | (cursor + 12));
        emit(enc_i(8,0,10,99));
        emit(enc_i(8,0,11,77));
        finish_case;
        check("jump skips marker",dut.u11.registers[10],0);
        check("jump target",dut.u11.registers[11],77);
        check("link register",dut.u11.registers[31],76);
        begin_case("JR register target");
        emit(enc_i(8,0,8,120));
        emit(enc_i(8,0,10,0));
        emit(enc_r(0,8,0,0,0,8));
        emit(enc_i(8,0,10,99));
        emit(enc_i(8,0,11,77));
        finish_case;
        check("JR skips marker",dut.u11.registers[10],0);
        check("JR target",dut.u11.registers[11],77);
        begin_case("writes to register zero / NOP");
        emit(enc_i(8,0,0,42));
        emit(enc_r(0,0,0,0,0,0));
        emit(enc_i(8,0,10,7));
        finish_case;
        check("$zero immutable",dut.u11.registers[0],0);
        check("NOP has no side effect",dut.u11.registers[10],7);
        begin_case("required SW demo PC / zero output");
        emit(enc_i(8,0,8,42));
        emit(enc_i(43,0,8,4));
        start_case;
        begin : wait_for_store
            integer cycles; reg seen; seen = 0;
            for(cycles=0; cycles<60; cycles=cycles+1) begin
                @(negedge Clk); #1;
                if(outPC === 32'd48 && outInstruction === enc_i(43,0,8,4)) begin
                    check("SW displayed data must be zero",outWriteData,0);
                    seen = 1;
                    disable wait_for_store;
                end
            end
            if(!seen) check("SW retirement timeout",0,1);
        end
        check("SW still stores correct data",dut.u20.DataMemory[1],42);

        $display("============================================================");
        $display("%0d scenarios; %0d checks passed; %0d checks failed",cases_run,passed,failed);
        if(failed != 0) $fatal(1,"CPU VERIFICATION FAILED -- inspect FAIL lines above");
        $display("ALL CHECKS PASSED (behavioral tests only)");
        $finish;
    end
endmodule
