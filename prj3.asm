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

# eq1: f1x + f2y + f3z = f10
# eq2: f4x + f5y + f6z = f11
# eq3: f7x + f8y + f9z = f12

#     f1 f2 f3      x       b1
# A = f4 f5 f6  X = y   B = b2
#     f7 f8 f9      z       b3

# AX = B
# A^-1 A X = A^-1 B
# X = A^-1 B
# A^-1 = adj(A)/detA 

# detA = f1*det[f5,f6,f8,f9] - f2*det[f4,f6,f7,f9] + f3*det[f4,f5,f7,f8]
# det[f5,f6,f8,f9] = f5*f9 - f6*f8
mul.s $f13, $f5, $f9
mul.s $f14, $f6, $f8
sub.s $f13, $f13, $f14  # $f13: det[a]
mul.s $f14, $f1, $f13   # $f14: f1*det[a]
# det[f4,f6,f7,f9] = f4*f9 - f6*f7
mul.s $f13, $f4, $f9
mul.s $f15, $f6, $f7
sub.s $f13, $f13, $f15  # $f13: det[a]
mul.s $f13, $f2, $f13   # $f13: f2*det[a]
sub.s $f14, $f14, $f13  # $f14: f1*dt[a] - f2*det[a]
# det[f4,f5,f7,f8] = f4*f8 - f5*f7
mul.s $f13, $f4, $f8
mul.s $f15, $f5, $f7
sub.s $f13, $f13, $f15  # $f13: det[a]
mul.s $f13, $f3, $f13   # $f13: f3*det[a]
add.s $f14, $f14, $f13  # $f14: detA = f1*det[a] - f2*det[a] + f3*det[a]
li.s $f0, 0.0
c.eq.s $f14, $f0        # if detA == 0
bc1t printNoSolution    # no solution

# find inverse of A
# transpose A -> A^T
# f1 f2 f3     f1 f4 f7
# f4 f5 f6 --> f2 f5 f8
# f7 f8 f9     f3 f6 f9

# find det of each 2x2 minor matrix
# $f21: det[f5,f8,f6,f9] = f5*f9 - f8*f6
mul.s $f21, $f5, $f9
mul.s $f13, $f8, $f6
sub.s $f21, $f21, $f13
# $f22: det[f2,f8,f3,f9] = f2*f9 - f8*f3
mul.s $f22, $f2, $f9
mul.s $f13, $f8, $f3
sub.s $f22, $f22, $f13
# $f23: det[f2,f5,f3,f6] = f2*f6 - f5*f3
mul.s $f23, $f2, $f6
mul.s $f13, $f5, $f3
sub.s $f23, $f23, $f13
# $f24: det[f4,f7,f6,f9] = f4*f9 - f7*f6
mul.s $f24, $f4, $f9
mul.s $f13, $f7, $f6
sub.s $f24, $f24, $f13
# $f25: det[f1,f7,f3,f9] = f1*f9 - f7*f3
mul.s $f25, $f1, $f9
mul.s $f13, $f7, $f3
sub.s $f25, $f25, $f13
# $f26: det[f1,f4,f3,f6] = f1*f6 - f4*f3
mul.s $f26, $f1, $f6
mul.s $f13, $f4, $f3
sub.s $f26, $f26, $f13
# $f27: det[f4,f7,f5,f8] = f4*f8 - f7*f5
mul.s $f27, $f4, $f8
mul.s $f13, $f7, $f5
sub.s $f27, $f27, $f13
# $f28: det[f1,f7,f2,f8] = f1*f8 - f7*f2
mul.s $f28, $f1, $f8
mul.s $f13, $f7, $f2
sub.s $f28, $f28, $f13
# $f29: det[f1,f4,f2,f5] = f1*f5 - f4*f2
mul.s $f29, $f1, $f5
mul.s $f13, $f4, $f2
sub.s $f29, $f29, $f13

# create matrix of cofactors A^T -> adj(A)
# f21 f22 f23   +1 -1 +1
# f24 f25 f26 * -1 +1 -1
# f27 f28 f29   +1 -1 +1
li.s $f0, -1.0
mul.s $f22, $f22, $f0
mul.s $f24, $f24, $f0
mul.s $f26, $f26, $f0
mul.s $f28, $f28, $f0

# divide each term in by det adj(A)/detA = A^-1
# $f14: detA
div.s $f21, $f21, $f14
div.s $f22, $f22, $f14
div.s $f23, $f23, $f14
div.s $f24, $f24, $f14
div.s $f25, $f25, $f14
div.s $f26, $f26, $f14
div.s $f27, $f27, $f14
div.s $f28, $f28, $f14
div.s $f29, $f29, $f14

# multiply A^-1 with vectorB to find vectorX
# f21 f22 f23   b1=f10
# f24 f25 f26 * b2=f11
# f27 f28 f29   b3=f12
# $f15: x = f21*f10 + f22*f11 + f23*f12
mul.s $f15, $f21, $f10
mul.s $f18, $f22, $f11
add.s $f15, $f15, $f18
mul.s $f18, $f23, $f12
add.s $f15, $f15, $f18
# $f16: y = f24*f10 + f25*f11 + f26*f12
mul.s $f16, $f24, $f10
mul.s $f18, $f25, $f11
add.s $f16, $f16, $f18
mul.s $f18, $f26, $f12
add.s $f16, $f16, $f18
# $f17: z = f27*f10 + f28*f11 + f29*f12
mul.s $f17, $f27, $f10
mul.s $f18, $f28, $f11
add.s $f17, $f17, $f18
mul.s $f18, $f29, $f12
add.s $f17, $f17, $f18

# print solutions
li.s $f0, 0.0

li $v0, 4   # print string
la $a0, sol1
syscall
li $v0, 2   # print float
add.s $f12, $f15, $f0   # load argument $f12 with $f15: x
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, sol2
syscall
li $v0, 2
add.s $f12, $f16, $f0   # load argument $f12 with $f16: y
syscall
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, sol3
syscall
li $v0, 2
add.s $f12, $f17, $f0   # load argument $f12 with $f17: z
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
addiu $sp, $sp, -48         # make room for 12 numbers on stack
li $v0, 6                   # read float
la $t2, 44                  # $t2: offset
add $t0, $sp, $t2           # $t0: offset($sp-96)
syscallLoop:
blt $t2, $zero, loadVals    # if offset < 0, exit loop
add $t0, $sp, $t2           # $t0: addr of FP num ($fx)
syscall
swc1 $f0, 0($t0)            # store FP num in offset($sp-96)
addi $t2, $t2, -4           # $t2: offset - 4
j syscallLoop

loadVals:
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

exit:
li $v0, 10  
syscall