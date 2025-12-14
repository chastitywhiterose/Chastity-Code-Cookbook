.data
title: .asciiz "Modifying a string in memory!\n"

#this is the location in memory where digits are written to by the putint function
int_string: .byte '?':32
int_newline: .byte 10,0
radix: .byte 2
int_width: .byte 4

.text
main:

li $s0,0 #we will load the $s0 register with the number we want to convert to string

loop:
jal putint
addi $s0,$s0,1
blt $s0,16,loop

li   $v0, 10     # exit syscall
syscall

#this is the intstr function, the ultimate integer to string conversion function
#just like the Intel Assembly version, it can convert an integer into a string
#radixes 2 to 36 are supported. Digits higher than 9 will be capital letters

intstr:

la $t1,int_newline # load target index address of lowest digit
addi $t1,$t1,-1

lb $t2,radix     # load value of radix into $t2
lb $t4,int_width # load value of int_width into $t4
li $t3,1         # load current number of digits, always 1

digits_start:

divu $s0,$s0,$t2 # $s0=$s0/$t2 (divide s0 by the radix value in $t2)
mfhi $t0        # $t0=remainder of the previous division
blt $t0,10,decimal_digit
bge $t0,10,hexadecimal_digit

decimal_digit: # we go here if it is only a digit 0 to 9
addi $t0,$t0,'0'
j save_digit

hexadecimal_digit:
addi $t0,$t0,-10
addi $t0,$t0,'A'

save_digit:
sb $t0,($t1) # store byte from $t0 at address $t1
beq $s0,$0,intstr_end
addi $t1,$t1,-1
addi $t3,$t3,1
j digits_start

intstr_end:

li $t0,'0'
prefix_zeros:
bge $t3,$t4,end_zeros
addi $t1,$t1,-1
sb $t0,($t1) # store byte from $t0 at address $t1
addi $t3,$t3,1
j prefix_zeros
end_zeros:

move $s0,$t1

jr $ra

#this function calls intstr to convert the $s0 register into a string
#then it uses a system call to print the string
#it also uses the stack to save the value of $s0 and $ra (return address)

putint:
sw $ra,0($sp)
sw $s0,4($sp)
jal intstr
#print string
li $v0,4      # load immediate, v0 = 4 (4 is print string system call)
move $a0,$s0  # load address of string to print into a0
syscall
lw $ra,0($sp)
lw $s0,4($sp)
jr $ra
