# This is the source of the MIPS version of chastelib
# The four basic functions have been translated from Intel x86 Assembly
# They are as follows
#
# putstring (prints string pointed to by $s0 register)
# intstr (converts integer in $s0 register to a string)
# putint (prints integer in $s0 register by use of the previous two functions)
# strint (converts a string pointed to by $s0 register into an integer in $s0)
#
# Most importantly, the intstr and strint functions depend on a global variable (radix)
# In fact, these two functions are the foundation of everything.
# They can convert to and from any radix from 2 to 36

.data
title: .asciz "A test of Chastity's integer and string conversion functions.\n"

# test string of integer for input
test_int: .asciz "10011101001110011110011"

#this is the location in memory where digits are written to by the putint function
int_string: .byte '?':32
int_newline: .byte 10,0
radix: .byte 2
int_width: .byte 4

.text
main:

la s0,title
jal putstring

li t0,10    #change radix
la t1,radix
sb t0,0(t1)

li t0,8    #change width
la t1,int_width
sb t0,0(t1)


li s0,5693
jal intstr

jal putstring

li   a7, 10     # exit syscall
ecall


putstring:
li a7,4      # load immediate, v0 = 4 (4 is print string system call)
mv a0,s0  # load address of string to print into a0
ecall
jr ra

#this is the intstr function, the ultimate integer to string conversion function
#just like the Intel Assembly version, it can convert an integer into a string
#radixes 2 to 36 are supported. Digits higher than 9 will be capital letters

intstr:

la t1,int_newline # load target index address of lowest digit
addi t1,t1,-1

lb t2,radix     # load value of radix into $t2
lb t4,int_width # load value of int_width into $t4
li t3,1         # load current number of digits, always 1


digits_start:

remu t0,s0,t2 # $t0=remainder of the previous division
divu s0,s0,t2 # $s0=$s0/$t2 (divide s0 by the radix value in $t2)

li t5,10 # load t5 with 10 because RISC-V does not allow constants for branches
blt t0,t5,decimal_digit
bge t0,t5,hexadecimal_digit

decimal_digit: # we go here if it is only a digit 0 to 9
addi t0,t0,'0'
j save_digit

hexadecimal_digit:
addi t0,t0,-10
addi t0,t0,'A'

save_digit:
sb t0,(t1) # store byte from $t0 at address $t1
beq s0,zero,intstr_end
addi t1,t1,-1
addi t3,t3,1
j digits_start

intstr_end:

li t0,'0'
prefix_zeros:
bge t3,t4,end_zeros
addi t1,t1,-1
sb t0,(t1) # store byte from $t0 at address $t1
addi t3,t3,1
j prefix_zeros
end_zeros:

mv s0,t1

jr ra
