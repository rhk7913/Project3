# Project 3 - CS-2033-01
# Group 5: Ronnie Phillips and Rhea

.data
    noSol: .asciiz "no solution\n"
.text
.globl main

main:
jal inputToMem
jal memToReg
jal systemSolve

inputToMem:
addiu $sp, $sp, -48 # make room for 12 numbers on stack
li $v0, 6   # read float
syscall
swc1 $f0, 44($sp)   # a11 
syscall
swc1 $f0, 40($sp)   # a12
syscall
swc1 $f0, 36($sp)   # a13
syscall
swc1 $f0, 32($sp)   # a21
syscall
swc1 $f0, 28($sp)   # a22
syscall
swc1 $f0, 24($sp)   # a23
syscall
swc1 $f0, 20($sp)   # a31
syscall
swc1 $f0, 16($sp)   # a32
syscall
swc1 $f0, 12($sp)   # a33
syscall
swc1 $f0, 8($sp)   # b1
syscall
swc1 $f0, 4($sp)   # b2
syscall
swc1 $f12, 0($sp)  # b3
j $ra

memToReg:
lwc1 $f1, 44($sp)   # $f1: a11
lwc1 $f2, 40($sp)   # $f2: a12
lwc1 $f3, 36($sp)   # $f3: a13
lwc1 $f4, 32($sp)   # $f4: a21
lwc1 $f5, 28($sp)   # $f5: a22
lwc1 $f6, 24($sp)   # $f6: a23
lwc1 $f7, 20($sp)   # $f7: a31
lwc1 $f8, 16($sp)   # $f8: a32
lwc1 $f9, 12($sp)   # $f9: a33
lwc1 $f10, 8($sp)   # $f10: b1
lwc1 $f11, 4($sp)    # $f11: b2
lwc1 $f12, 0($sp)   # $f12: b3
j $ra

systemSolve: