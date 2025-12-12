.data
title: .asciiz "Modifying a string in memory!\n"

.text
main:

li $t0,'?'
la $t1,title
addi $t2,$t1,6 # $t0=$t0+1


loop1:
sb $t0,12($t1)
addi $t1,$t1,1 # $t0=$t0+1
blt $t1,$t2,loop1


#print string
li $v0,4      # load immediate, v0 = 4 (4 is print string system call)
la $a0,title  # load address of string to print into a0
syscall

li   $v0, 10     # exit syscall
syscall

