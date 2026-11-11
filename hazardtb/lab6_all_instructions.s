# All required instructions, no NOP padding. First instruction is at PC zero.
# Register 23 receives 24589 for pass or 2989 for fail.
.text
.globl main
main:
addi $23, $0, 0
addi $8, $0, 10
addi $9, $0, 6
add $10, $8, $9
addi $22, $0, 16
bne $10, $22, fail
sub $10, $8, $9
addi $22, $0, 4
bne $10, $22, fail
and $10, $8, $9
addi $22, $0, 2
bne $10, $22, fail
or $10, $8, $9
addi $22, $0, 14
bne $10, $22, fail
xor $10, $8, $9
addi $22, $0, 12
bne $10, $22, fail
nor $10, $8, $9
addi $22, $0, -15
bne $10, $22, fail
slt $10, $8, $9
addi $22, $0, 0
bne $10, $22, fail
mul $10, $8, $9
addi $22, $0, 60
bne $10, $22, fail
addi $8, $0, -10
add $10, $8, $9
addi $22, $0, -4
bne $10, $22, fail
mul $10, $8, $9
addi $22, $0, -60
bne $10, $22, fail
slt $10, $8, $9
addi $22, $0, 1
bne $10, $22, fail
addi $10, $8, -2
addi $22, $0, -12
bne $10, $22, fail
addi $8, $0, -10
andi $10, $8, 65535
ori $22, $0, 65526
bne $10, $22, fail
addi $8, $0, 0
ori $10, $8, 32768
ori $22, $0, 32768
bne $10, $22, fail
addi $8, $0, 0
xori $10, $8, 65535
ori $22, $0, 65535
bne $10, $22, fail
addi $8, $0, -2
slti $10, $8, -1
addi $22, $0, 1
bne $10, $22, fail
addi $8, $0, 4
sll $10, $8, 3
addi $22, $0, 32
bne $10, $22, fail
srl $10, $10, 2
addi $22, $0, 8
bne $10, $22, fail
addi $8, $0, -1
srl $10, $8, 31
addi $22, $0, 1
bne $10, $22, fail
addi $8, $0, 68
addi $9, $0, -123
sw $9, -4($8)
lw $10, -4($8)
addi $22, $0, -123
bne $10, $22, fail
addi $8, $0, -1
sw $8, 64($0)
addi $9, $0, 128
sb $9, 67($0)
lb $10, 67($0)
addi $22, $0, -128
bne $10, $22, fail
lw $11, 64($0)
ori $22, $0, 33023
sll $22, $22, 16
ori $22, $22, 65535
bne $11, $22, fail
addi $8, $0, -1
sw $8, 64($0)
addi $9, $0, -32768
sh $9, 66($0)
lh $10, 66($0)
addi $22, $0, -32768
bne $10, $22, fail
lw $11, 64($0)
ori $22, $0, 32768
sll $22, $22, 16
ori $22, $22, 65535
bne $11, $22, fail
addi $8, $0, 0
addi $9, $0, 0
beq $8, $9, beq_1_ok
j fail
beq_1_ok:
addi $8, $0, 1
addi $9, $0, 0
beq $8, $9, fail
addi $8, $0, 0
addi $9, $0, 0
bne $8, $9, fail
addi $8, $0, 1
addi $9, $0, 0
bne $8, $9, bne_2_ok
j fail
bne_2_ok:
addi $8, $0, -1
addi $9, $0, 0
bgez $8, fail
addi $8, $0, 1
addi $9, $0, 0
bgez $8, bgez_2_ok
j fail
bgez_2_ok:
addi $8, $0, -1
addi $9, $0, 0
bltz $8, bltz_0_ok
j fail
bltz_0_ok:
addi $8, $0, 1
addi $9, $0, 0
bltz $8, fail
addi $8, $0, -1
addi $9, $0, 0
bgtz $8, fail
addi $8, $0, 1
addi $9, $0, 0
bgtz $8, bgtz_2_ok
j fail
bgtz_2_ok:
addi $8, $0, -1
addi $9, $0, 0
blez $8, blez_0_ok
j fail
blez_0_ok:
addi $8, $0, 1
addi $9, $0, 0
blez $8, fail
addi $8, $0, 3
count_loop:
addi $8, $8, -1
bgtz $8, count_loop
addi $22, $0, 0
bne $8, $22, fail
j j_ok
j fail
j_ok:
addi $8, $0, 596
jr $8
j fail
jr_ok:
jal subroutine
return_pc:
j after_subroutine
subroutine:
addi $22, $0, 600
bne $31, $22, fail
addi $10, $0, 1234
jr $31
j fail
after_subroutine:
addi $22, $0, 1234
bne $10, $22, fail
addi $0, $0, 99
addi $22, $0, 0
bne $0, $22, fail
pass:
addi $23, $0, 24589
pass_loop:
j pass_loop
fail:
addi $23, $0, 2989
fail_loop:
j fail_loop
