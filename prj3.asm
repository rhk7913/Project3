# Project 3 - CS-2033-01
# Group 5: Ronnie Phillips and Rhea Katari

.data
    noSol: .asciiz "no solution\n"
    newline: .asciiz "\n"
    sol1: .asciiz "x1 = "
    sol2: .asciiz "x2 = "
    sol3: .asciiz "x3 = "
.text
.globl main

main:
jal inputToMem
jal memToReg

# need to check if coefficients == 0
# if an eq has three 0's -> no solution
# if an eq has two 0's -> forward it to the 1 - 1 var equation code
# if an eq has one 0 -> forward it to the 2 - 2 var equations code

# need to check if equations have no solution
# need to make regular checks to see if the elimination process eliminates more than one var
# (more than 1 0 coef is created)

three3x3:
# 3 - 3 var equations, assuming no 0's
# eq1: f1x + f2y + f3z = f10
# eq2: f4x + f5y + f6z = f11
# eq3: f7x + f8y + f9z = f12

li.s $f0, -1.0
# getting 1st equation ready to subtract from 2nd
div.s $f13, $f4, $f1
mul.s $f13, $f13 $f0    # $f13: const to mult with all coefs
mul.s $f1, $f1, $f13    # $f1: a11 (ready to cancel out a21)
mul.s $f2, $f2, $f13    # $f2: a12 (ready to subtract from a22)
mul.s $f3, $f3, $f13    # $f3: a13 (ready to subract from a23)
mul.s $f10, $f10, $f13  # $f10: b1 (ready to subtract from b2)

# $f4 + $f1 == 0
add.s $f14, $f5, $f2   
add.s $f15, $f6, $f3 
add.s $f16, $f11, $f10  # f14y + f15z = f16
# check for 0's in f14 and f15


# getting 3rd equation ready to subtract from 2nd
div.s $f13, $f4, $f7
mul.s $f13, $f13, $f0   # $f13: const to mult with all coefs
mul.s $f7, $f7, $f13    # $f7: a31 (ready to cancel out a21)
mul.s $f8, $f8, $f13    # $f8: a32 (ready to subtract from a22)
mul.s $f9, $f9, $f13    # $f9: a33 (ready to subtract from a23)
mul.s $f12, $f12, $f13  # $f12: b3 (read to subtract from b2)

# $f4 + $f7 == 0
add.s $f17, $f5, $f8
add.s $f18, $f6, $f9
add.s $f19, $f11, $f12  # f17y + f18z = f19
# check for 0's in f17 and f18

two2x2:
# 2 - 2 var equations, assuming no 0's
# eq1: f14y + f15z = f16
# eq2: f17y + f18z = f19

# getting 1st equation ready to subtract from 2nd
div.s $f13, $f17, $f14
mul.s $f13, $f13, $f0   # $f13: const to mult with all coefs
mul.s $f14, $f14, $f13  # $f14: ready to subtract from f17
mul.s $f15, $f15, $f13  # $f15: ready to subtract fom f18
mul.s $f16, $f16, $f13  # $f16: ready to subtract from f19

# $f14 + $f17 == 0
add.s $f20, $f15, $f18
add.s $f21, $f16, $f19  # f20z = f21
# check for 0 in f20

one1x1:
# 1 - 1 var equation, assuming no 0's (solve for z then plug in for y and x)
div.s $f24, $f21, $f20  # $f24: z = f21/f20
mul.s $f23, $f15, $f24                        
sub.s $f23, $f16, $f23
div.s $f23, $f23, $f14  # $f23: y = (f16 - f15*z)/f14
mul.s $f13, $f3, $f24
mul.s $f22, $f2, $f23 
sub.s $f22, $f22, $f13 
sub.s $f22, $f10, $f22
div.s $f22, $f22, $f1   # $f22: x = (f10 - f2*y - f3*z)/f1

printSolutions:
li.s $f0, 0.0
li $v0, 4
la $a0, sol1
syscall
li $v0, 2
add.s $f12, $f22, $f0
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, sol2
syscall
li $v0, 2
add.s $f12, $f23, $f0
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, sol3
syscall
li $v0, 2
add.s $f12, $f23, $f0
syscall
li $v0, 4
la $a0, newline
syscall

printNoSolution:
li $v0, 4
la $a0, noSol
syscall
la $a0, newline
syscall

inputToMem:
addiu $sp, $sp, -96 # make room for 24 numbers on stack
li $v0, 6           # read float
syscall
swc1 $f0, 92($sp)   # a11
syscall
swc1 $f0, 84($sp)   # a12
syscall
swc1 $f0, 76($sp)   # a13
syscall
swc1 $f0, 68($sp)   # a21
syscall
swc1 $f0, 60($sp)   # a22
syscall
swc1 $f0, 52($sp)   # a23
syscall
swc1 $f0, 44($sp)   # a31
syscall
swc1 $f0, 36($sp)   # a32
syscall
swc1 $f0, 28($sp)   # a33
syscall
swc1 $f0, 20($sp)   # b1
syscall
swc1 $f0, 12($sp)   # b2
syscall
swc1 $f0, 4($sp)    # b3
j $ra

memToReg:
# checking for 0's while loading
# setting corresponding temp registers with 0 if $fx == 0, 1 otherwise
li $t15, 1
li.s $f25, 0.0

addi $t0, $t0, $sp          # $t0: 0($sp)
addi $t0, $sp, 96           # $t0: 96($sp)
loop:
subi $t0, $t0, 4            # access addr of FP num ($fx)
lwc1 $f26, 0($t0)
c.eq.s $f26, $f25
subi $t0, $t0, 4            # access addr of corresponding temp int ($tx)
subi $t14, $t0, $sp         # $t14: $t0 - $sp = offset + $sp - $sp = offset
slti $t14, $t14, 0          # $t14: 1 if offset < 0
beq $t14, $t15, storeVals   # if x < 0 for $t0 == x($sp), exit loop
bc1t store0                 # store 0 in $tx if $fx == 0
bc1f store1                 # store 1 in $tx if $fx != 0

store0:
sw $zero, 0($t0)
j loop

store1:
ori $t13, $zero, 0x0001
sw $t13, 0($t0)
j loop

storeVals:
lwc1 $f1, 92($sp)   # $f1: a11
lw $t1, 88($sp)     # $t1: 0/1 for a11 == 0 or != 0
lwc1 $f2, 84($sp)   # $f2: a12
lw $t2, 80($sp)     # $t2: 0/1 for a12 == 0 or != 0
lwc1 $f3, 76($sp)   # $f3: a13
lw $t3, 72($sp)     # $t3: 0/1 for a13 == 0 or != 0
lwc1 $f4, 68($sp)   # $f4: a21
lw $t4, 64($sp)     # $t4: 0/1 for a21 == 0 or != 0
lwc1 $f5, 60($sp)   # $f5: a22
lw $t5, 56($sp)     # $t5: 0/1 for a22 == 0 or != 0
lwc1 $f6, 52($sp)   # $f6: a23
lw $t6, 48($sp)     # $t6: 0/1 for a23 == 0 or != 0
lwc1 $f7, 44($sp)   # $f7: a31
lw $t7, 40($sp)     # $t7: 0/1 for a31 == 0 or != 0
lwc1 $f8, 36($sp)   # $f8: a32
lw $t8, 32($sp)     # $t8: 0/1 for a32 == 0 or != 0
lwc1 $f9, 28($sp)   # $f9: a33
lw $t9, 24($sp)     # $t9: 0/1 for a33 == 0 or != 0
lwc1 $f10, 20($sp)  # $f10: b1
lw $t10, 16($sp)    # $t10: 0/1 for b1 == 0 or != 0
lwc1 $f11, 12($sp)  # $f11: b2
lw $t11, 8($sp)     # $t11: 0/1 for b2 == 0 or != 0
lwc1 $f12, 4($sp)   # $f12: b3
lw $t12, 0($sp)     # $t12: 0/1 for b3 == 0 or != 0
j $ra



