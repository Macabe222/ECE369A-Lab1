`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// vbsme_tb
//
// Runs vbsme_instruction_memory.mem / vbsme_data_memory.mem on CPU32Bit
// directly (no clock divider, so it runs fast) and:
//   - prints $v0 and $v1 every time either one is written
//   - prints PASS/FAIL for each test when vbsme returns to main
//   - stops when the program reaches the end_program loop
////////////////////////////////////////////////////////////////////////////////

module vbsme_tb;

    reg Clk, Rst;
    wire [31:0] V0, V1;

    CPU32Bit dut(Clk, Rst, V0, V1);

    // 100 MHz clock
    initial Clk = 0;
    always #5 Clk = ~Clk;

    // Byte addresses from vbsme_instruction_memory.mem
    localparam [31:0] VBSME_RETURN_PC4 = 32'd392;   // jr $ra at word 97 (+4)
    localparam [31:0] END_PROGRAM_PC   = 32'd100;   // end_program: j end_program (word 25)
    localparam [31:0] JR_RA            = 32'h03e00008;
    localparam integer MAX_CYCLES      = 20_000_000;

    // Expected answers (row, col) for tests 1-5
    integer exp_row [1:5];
    integer exp_col [1:5];
    initial begin
        exp_row[1] = 3;  exp_col[1] = 2;
        exp_row[2] = 16; exp_col[2] = 0;
        exp_row[3] = 12; exp_col[3] = 0;
        exp_row[4] = 8;  exp_col[4] = 3;
        exp_row[5] = 5;  exp_col[5] = 16;
    end

    integer cycle = 0;
    integer test_num = 1;
    integer passed = 0;
    integer end_count = 0;
    reg [31:0] prev_v0, prev_v1;

    initial begin
        Rst = 1;
        prev_v0 = 0;
        prev_v1 = 0;
        repeat (3) @(posedge Clk);
        #1 Rst = 0;
        $display("---- vbsme simulation started ----");
    end

    always @(posedge Clk) begin
        if (!Rst) begin
            cycle = cycle + 1;

            // 1) Print every update to $v0 / $v1
            #1;   // let outV0/outV1 settle after this edge
            if (V0 !== prev_v0 || V1 !== prev_v1) begin
                $display("[cycle %0d] update: $v0 = %0d  $v1 = %0d", cycle, V0, V1);
                prev_v0 = V0;
                prev_v1 = V1;
            end

            // 2) vbsme's final jr $ra is in decode and not stalled -> result is final
            if (dut.ID_Instruction == JR_RA && dut.ID_PCPlusFour == VBSME_RETURN_PC4
                && dut.Stall == 1'b0 && test_num <= 5) begin
                if (V0 == exp_row[test_num] && V1 == exp_col[test_num]) begin
                    $display("[cycle %0d] TEST %0d PASS: (%0d, %0d)",
                             cycle, test_num, V0, V1);
                    passed = passed + 1;
                end else begin
                    $display("[cycle %0d] TEST %0d FAIL: got (%0d, %0d), expected (%0d, %0d)",
                             cycle, test_num, V0, V1, exp_row[test_num], exp_col[test_num]);
                end
                test_num = test_num + 1;
            end

            // 3) Stop once the PC has been parked in end_program for a while
            if (dut.Address == END_PROGRAM_PC) end_count = end_count + 1;
            if (end_count > 20) begin
                $display("---- done: %0d/5 tests passed in %0d cycles ----", passed, cycle);
                $finish;
            end

            if (cycle >= MAX_CYCLES) begin
                $display("---- TIMEOUT after %0d cycles (%0d/5 passed) ----", cycle, passed);
                $finish;
            end
        end
    end

endmodule
