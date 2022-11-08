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
jal handleInput

# need to check if coefficients == 0
# if an eq has three 0's -> 
# if an eq has two 0's -> forward it to the 1 - 1 var equation code
# if an eq has one 0 -> forward it to the 2 - 2 var equations code

# li $t5, 1
# li $t6, 2
# li $t7, 3

# lw $t1, 88($sp)
# lw $t2, 80($sp)
# lw $t3, 72($sp)
# add $t4, $t1, $t2
# add $t4, $t4, $t3
# blt $t4, $t5, prepEq1forThree3x3  # if # of 0's == 0
# blt $t4, $t6, prepEq1forTwo2x2    # if # of 0's == 1
# blt $t4, $t7, prepEq1forOne1x1    # if # of 0's == 2


# need to check if equations have no solution
# need to make regular checks to see if the elimination process eliminates more than one var
# (more than 1 0 coef is created)

# prepEq1forThree3x3:


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

# prepEq1forTwo2x2:


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

# prepEq1forOne1x1:


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

li $v0, 4   # print string
la $a0, sol1
syscall
li $v0, 2   # print float
add.s $f12, $f22, $f0   # load argument $f12 with $f22: x
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, sol2
syscall
li $v0, 2
add.s $f12, $f23, $f0   # load argument $f12 with $f23: y
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, sol3
syscall
li $v0, 2
add.s $f12, $f23, $f0   # load argument $f12 with $f24: z
syscall
li $v0, 4
la $a0, newline
syscall
j exit

printNoSolution:
li $v0, 4
la $a0, noSol
syscall
la $a0, newline
syscall
j exit

handleInput:
# storing FP inputs in every other address of stack
# checking for 0's while loading
# setting the word following the address of each FP num to 0 if $fx == 0.0, 1 otherwise
addiu $sp, $sp, -96         # make room for 24 numbers on stack
li $v0, 6                   # read float
li $t1, 1                   # $t1: 1
li.s $f25, 0.0              # $f25: 0.0
la $t2, 96                  # $t2: offset
add $t0, $sp, $t2           # $t0: offset($sp-96)
syscallLoop:
ble $t2, $zero, loadVals    # if offset < 0, exit loop
addi $t2, $t2, -4           # $t2: offset - 4
add $t0, $sp, $t2           # $t0: addr of FP num ($fx)
syscall
swc1 $f0, 0($t0)            # store FP num in offset($sp-96)
c.eq.s $f0, $f25            # c = 1 if $fx == 0.0
addi $t2, $t2, -4           # $t2: offset - 4 
add $t0, $sp, $t2           # $t0: addr of corresponding int
bc1t store0                 # store 0 in following addr if $fx == 0
bc1f store1                 # store 1 in following addr if $fx != 0

store0:
sw $zero, 0($t0)
j syscallLoop

store1:
sw $t1, 0($t0)
j syscallLoop

loadVals:
lwc1 $f1, 92($sp)   # $f1: a11; 88($sp): 0/1 for a11 == 0 or != 0
lwc1 $f2, 84($sp)   # $f2: a12; 80($sp): 0/1
lwc1 $f3, 76($sp)   # $f3: a13; 72($sp): 0/1
lwc1 $f4, 68($sp)   # $f4: a21; 64($sp): 0/1
lwc1 $f5, 60($sp)   # $f5: a22; 56($sp): 0/1
lwc1 $f6, 52($sp)   # $f6: a23; 48($sp): 0/1
lwc1 $f7, 44($sp)   # $f7: a31; 40($sp): 0/1
lwc1 $f8, 36($sp)   # $f8: a32; 32($sp): 0/1
lwc1 $f9, 28($sp)   # $f9: a33; 24($sp): 0/1
lwc1 $f10, 20($sp)  # $f10: b1; 16($sp): 0/1
lwc1 $f11, 12($sp)  # $f11: b2;  8($sp): 0/1
lwc1 $f12, 4($sp)   # $f12: b3;  0($sp): 0/1

j $ra

exit: