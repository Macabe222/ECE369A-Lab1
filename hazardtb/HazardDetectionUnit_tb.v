`timescale 1ns/1ps
// Direct combinational checks include false dependencies and $zero writes.
module HazardDetectionUnit_tb;
    reg [31:0] ID_Instruction;
    reg EX_RegWrite, MEM_RegWrite, WB_RegWrite;
    reg [4:0] EX_WriteReg, MEM_WriteReg, WB_WriteReg;
    wire Stall;
    integer stage;
    integer checks = 0;
    HazardDetectionUnit dut(ID_Instruction, EX_RegWrite, EX_WriteReg,
        MEM_RegWrite, MEM_WriteReg, WB_RegWrite, WB_WriteReg, Stall);

    task expect_stall;
        input expected;
        begin
            #1;
            if (Stall !== expected)
                $fatal(1,"stage %0d instruction %h: Stall %b expected %b",
                    stage, ID_Instruction, Stall, expected);
            checks = checks + 1;
        end
    endtask

    task set_writer;
        input integer location;
        input [4:0] destination;
        begin
            EX_RegWrite=0; MEM_RegWrite=0; WB_RegWrite=0;
            EX_WriteReg=0; MEM_WriteReg=0; WB_WriteReg=0;
            case(location)
                0: begin EX_RegWrite=1; EX_WriteReg=destination; end
                1: begin MEM_RegWrite=1; MEM_WriteReg=destination; end
                2: begin WB_RegWrite=1; WB_WriteReg=destination; end
            endcase
        end
    endtask

    task check_sources;
        input [5:0] opcode, funct;
        input uses_rs, uses_rt;
        begin
            // rs=8 and rt=9 are deliberately different.
            ID_Instruction = {opcode,5'd8,5'd9,5'd10,5'd0,funct};
            for(stage=0;stage<3;stage=stage+1) begin
                set_writer(stage,8); expect_stall(uses_rs);
                set_writer(stage,9); expect_stall(uses_rt);
                set_writer(stage,10); expect_stall(0); // unrelated destination
                EX_RegWrite=0; MEM_RegWrite=0; WB_RegWrite=0;
                expect_stall(0);
            end
        end
    endtask

    initial begin
        check_sources(0,32,1,1); // add
        check_sources(0,34,1,1); // sub
        check_sources(0,36,1,1); // and
        check_sources(0,37,1,1); // or
        check_sources(0,38,1,1); // xor
        check_sources(0,39,1,1); // nor
        check_sources(0,42,1,1); // slt
        check_sources(0,0,0,1);  // sll
        check_sources(0,2,0,1);  // srl
        check_sources(0,8,1,0);  // jr
        check_sources(28,2,1,1); // mul
        check_sources(4,0,1,1);  // beq
        check_sources(5,0,1,1);  // bne
        check_sources(1,0,1,0);  // signed branch family
        check_sources(6,0,1,0);  // blez
        check_sources(7,0,1,0);  // bgtz
        check_sources(8,0,1,0);  // addi
        check_sources(10,0,1,0); // slti
        check_sources(12,0,1,0); // andi
        check_sources(13,0,1,0); // ori
        check_sources(14,0,1,0); // xori
        check_sources(32,0,1,0); // lb
        check_sources(33,0,1,0); // lh
        check_sources(35,0,1,0); // lw
        check_sources(40,0,1,1); // sb
        check_sources(41,0,1,1); // sh
        check_sources(43,0,1,1); // sw
        check_sources(2,0,0,0);  // j
        check_sources(3,0,0,0);  // jal
        for(stage=0;stage<3;stage=stage+1) begin
            ID_Instruction={6'd0,5'd0,5'd0,5'd10,5'd0,6'd32};
            set_writer(stage,0); expect_stall(0);
        end
        $display("HAZARD UNIT TEST PASSED: %0d checks",checks);
        $finish;
    end
endmodule
