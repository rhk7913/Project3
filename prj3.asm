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
# (a 0 coef is created)

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

# printing solutions
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

inputToMem:
addiu $sp, $sp, -48 # make room for 12 numbers on stack
li $v0, 6           # read float
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
swc1 $f0, 8($sp)    # b1
syscall
swc1 $f0, 4($sp)    # b2
syscall
swc1 $f12, 0($sp)   # b3
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
lwc1 $f11, 4($sp)   # $f11: b2
lwc1 $f12, 0($sp)   # $f12: b3
j $ra
