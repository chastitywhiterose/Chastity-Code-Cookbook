.data
title: .asciiz "Counting program for MIPS CPU\n"

.text
main:

#print string
li $v0,4      # load immediate, v0 = 4 (4 is print string system call)
la $a0,title  # load address of string to print into a0
syscall

#print integer
li $t0,0      # $t0=0
loop:
li $v0,1      # $v0=1 for print integer system call
move $a0,$t0  # $a0=$t0
syscall

# print newline
li $v0,11 # print char
li $a0,10 # ascii value of '\n'
syscall

addi $t0,$t0,1 # $t0=$t0+1

blt $t0,16,loop # if $t0 is less than 16, branch/jump to loop label

li   $v0, 10     # exit syscall
syscall

