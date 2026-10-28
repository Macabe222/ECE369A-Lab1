# All 30 required instructions; five NOPs after each instruction.
# Register numbers use MIPS numeric notation. No pseudoinstructions.
# PC+4 link convention; control-transfer slots are explicit NOPs.
.text
.globl main
    nop
    nop
    nop
    nop
    nop
    nop
main:
    addi $23, $0, 0
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 10
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 6
    nop
    nop
    nop
    nop
    nop
    add $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 16
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    sub $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 4
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    and $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 2
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    or $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 14
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    xor $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 12
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    nor $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, -15
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    slt $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 0
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    mul $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 60
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, -10
    nop
    nop
    nop
    nop
    nop
    add $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, -4
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    mul $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, -60
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    slt $10, $8, $9
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 1
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $10, $8, -2
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, -12
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, -10
    nop
    nop
    nop
    nop
    nop
    andi $10, $8, 65535
    nop
    nop
    nop
    nop
    nop
    ori $22, $0, 65526
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 0
    nop
    nop
    nop
    nop
    nop
    ori $10, $8, 32768
    nop
    nop
    nop
    nop
    nop
    ori $22, $0, 32768
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 0
    nop
    nop
    nop
    nop
    nop
    xori $10, $8, 65535
    nop
    nop
    nop
    nop
    nop
    ori $22, $0, 65535
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, -2
    nop
    nop
    nop
    nop
    nop
    slti $10, $8, -1
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 1
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 4
    nop
    nop
    nop
    nop
    nop
    sll $10, $8, 3
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 32
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    srl $10, $10, 2
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 8
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, -1
    nop
    nop
    nop
    nop
    nop
    srl $10, $8, 31
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 1
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 68
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, -123
    nop
    nop
    nop
    nop
    nop
    sw $9, -4($8)
    nop
    nop
    nop
    nop
    nop
    lw $10, -4($8)
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, -123
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, -1
    nop
    nop
    nop
    nop
    nop
    sw $8, 64($0)
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 128
    nop
    nop
    nop
    nop
    nop
    sb $9, 67($0)
    nop
    nop
    nop
    nop
    nop
    lb $10, 67($0)
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, -128
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    lw $11, 64($0)
    nop
    nop
    nop
    nop
    nop
    ori $22, $0, 33023
    nop
    nop
    nop
    nop
    nop
    sll $22, $22, 16
    nop
    nop
    nop
    nop
    nop
    ori $22, $22, 65535
    nop
    nop
    nop
    nop
    nop
    bne $11, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, -1
    nop
    nop
    nop
    nop
    nop
    sw $8, 64($0)
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, -32768
    nop
    nop
    nop
    nop
    nop
    sh $9, 66($0)
    nop
    nop
    nop
    nop
    nop
    lh $10, 66($0)
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, -32768
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    lw $11, 64($0)
    nop
    nop
    nop
    nop
    nop
    ori $22, $0, 32768
    nop
    nop
    nop
    nop
    nop
    sll $22, $22, 16
    nop
    nop
    nop
    nop
    nop
    ori $22, $22, 65535
    nop
    nop
    nop
    nop
    nop
    bne $11, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 0
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    beq $8, $9, beq_1_ok
    nop
    nop
    nop
    nop
    nop
    j fail
    nop
    nop
    nop
    nop
    nop
beq_1_ok:
    addi $8, $0, 1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    beq $8, $9, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 0
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    bne $8, $9, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    bne $8, $9, bne_2_ok
    nop
    nop
    nop
    nop
    nop
    j fail
    nop
    nop
    nop
    nop
    nop
bne_2_ok:
    addi $8, $0, -1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    bgez $8, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    bgez $8, bgez_2_ok
    nop
    nop
    nop
    nop
    nop
    j fail
    nop
    nop
    nop
    nop
    nop
bgez_2_ok:
    addi $8, $0, -1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    bltz $8, bltz_0_ok
    nop
    nop
    nop
    nop
    nop
    j fail
    nop
    nop
    nop
    nop
    nop
bltz_0_ok:
    addi $8, $0, 1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    bltz $8, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, -1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    bgtz $8, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    bgtz $8, bgtz_2_ok
    nop
    nop
    nop
    nop
    nop
    j fail
    nop
    nop
    nop
    nop
    nop
bgtz_2_ok:
    addi $8, $0, -1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    blez $8, blez_0_ok
    nop
    nop
    nop
    nop
    nop
    j fail
    nop
    nop
    nop
    nop
    nop
blez_0_ok:
    addi $8, $0, 1
    nop
    nop
    nop
    nop
    nop
    addi $9, $0, 0
    nop
    nop
    nop
    nop
    nop
    blez $8, fail
    nop
    nop
    nop
    nop
    nop
    addi $8, $0, 3
    nop
    nop
    nop
    nop
    nop
count_loop:
    addi $8, $8, -1
    nop
    nop
    nop
    nop
    nop
    bgtz $8, count_loop
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 0
    nop
    nop
    nop
    nop
    nop
    bne $8, $22, fail
    nop
    nop
    nop
    nop
    nop
    j j_ok
    nop
    nop
    nop
    nop
    nop
    j fail
    nop
    nop
    nop
    nop
    nop
j_ok:
    addi $8, $0, 3600 # address for jr_ok
    nop
    nop
    nop
    nop
    nop
    jr $8
    nop
    nop
    nop
    nop
    nop
    j fail
    nop
    nop
    nop
    nop
    nop
jr_ok:
    jal subroutine
    nop
    nop
    nop
    nop
    nop
return_pc:
    j after_subroutine
    nop
    nop
    nop
    nop
    nop
subroutine:
    addi $22, $0, 3604 # address for return_pc
    nop
    nop
    nop
    nop
    nop
    bne $31, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $10, $0, 1234
    nop
    nop
    nop
    nop
    nop
    jr $31
    nop
    nop
    nop
    nop
    nop
    j fail
    nop
    nop
    nop
    nop
    nop
after_subroutine:
    addi $22, $0, 1234
    nop
    nop
    nop
    nop
    nop
    bne $10, $22, fail
    nop
    nop
    nop
    nop
    nop
    addi $0, $0, 99
    nop
    nop
    nop
    nop
    nop
    addi $22, $0, 0
    nop
    nop
    nop
    nop
    nop
    bne $0, $22, fail
    nop
    nop
    nop
    nop
    nop
pass:
    addi $23, $0, 24589
    nop
    nop
    nop
    nop
    nop
pass_loop:
    j pass_loop
    nop
    nop
    nop
    nop
    nop
fail:
    addi $23, $0, 2989
    nop
    nop
    nop
    nop
    nop
fail_loop:
    j fail_loop
    nop
    nop
    nop
    nop
    nop
