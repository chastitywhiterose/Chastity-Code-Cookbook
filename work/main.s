.data
title: .asciiz "Modifying a string in memory!\n"

#this is the location in memory where digits are written to by the putint function
int_string: .byte '?':32
int_newline: .byte 10,0
radix: .byte 16
int_width: .byte 8

.text
main:

li $s0,1987 #we will load the $s0 register with the number we want to convert to string

jal intstr

#print string
li $v0,4      # load immediate, v0 = 4 (4 is print string system call)
la $a0,int_string  # load address of string to print into a0
syscall

li   $v0, 10     # exit syscall
syscall


intstr:

la $t1,int_newline # load target index address of lowest digit
addi $t1,$t1,-1

la $t0,radix # load address of radix
lb $t2,($t0) # load value of radix into $t2

la $t0,int_width # get the int_width (minimum digits)
lb $t4,($t0) # load value of int_width into $t4
li $t3,1

digits_start:

div $s0,$s0,$t2 # $s0=$s0/$t2 (divide s0 by the radix value in $t2)
mfhi $t0        # $t0=remainder of the previous division
blt $t0,10,decimal_digit
bge $t0,10,hexadecimal_digit


decimal_digit: # we go here if it is only a digit 0 to 9
addi $t0,'0'
j save_digit

hexadecimal_digit:
addi $t0,-10
addi $t0,'A'

save_digit:
sb $t0,($t1) # store byte from $t0 at address $t1
beq $s0,$0,intstr_end
addi $t1,-1
addi $t3,1
j digits_start

intstr_end:

jr $ra


