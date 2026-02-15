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

li   a7, 10     # exit syscall
ecall


putstring:
li a7,4      # load immediate, v0 = 4 (4 is print string system call)
mv a0,s0  # load address of string to print into a0
ecall
jr ra
