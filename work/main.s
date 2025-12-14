.data
title: .asciiz "Modifying a string in memory!\n"

#this is the location in memory where digits are written to by the putint function
int_string: .byte '?':32
int_newline: .byte 10,0

.text
main:

li $t0,'0'
la $t1,int_newline
addi $t1,$t1,-1

#sb $t0,($t1)

;lb $t0,1($t1)

loop1:
sb $t0,12($t1)
addi $t1,$t1,1 # $t0=$t0+1
blt $t1,$t2,loop1


#print string
li $v0,4      # load immediate, v0 = 4 (4 is print string system call)
la $a0,int_string  # load address of string to print into a0
syscall

li   $v0, 10     # exit syscall
syscall

