.globl __start

.data

msg: .asciiz "Hello World!"

.text

__start:

la s0,msg
jal putstring

li a0, 10 # ecall code for exit program
ecall

putstring:
li a0, 4  # ecall code for print zero terminated string
mv a1,s0  # load address of string to print into a0
ecall
jr ra
