# Chastity's putstr function for RISC-V Assembly in riscemu

.data

# These variables are used by the intstr function to convert an integer to a string
# and what radix should be used as well as the width (how many leading zeros)

int_string: .space 32 #reserve space for 32 bytes for up to 32 bits if printed in binary
int_end: .byte 0 #the terminating zero of the integer string
radix: .byte 2   #the radix the number will be shown in
int_width: .byte 1 #by default

# These variables are for outputting special strings
# such as a newline, space, or a single character based on s0

# These variables are for outputting special strings
# such as a newline, space, or a single character based on s0

space: .byte 0x20, 0
line:  .byte 0x0A, 0
char:  .byte 0, 0 

string0: .asciiz "I am Chastity White Rose\n"

.text

addi s0, zero, string0
jal putstr

li s0, 16
jal putint
jal putline

addi s0, zero, string0
jal putstr

jal putspace
li s0, 0x38
jal putchar


addi    a0, zero, 0     # a0=0  (exit code for OS)
addi    a7, zero, 93    # a7=93 (exit system call)
ecall                   #       (environment call)

###############################################################################
# This putstr function is the most portable function for RISC-V simulators #
# It calculates the length of a zero terminated string before printing it     #
# This is the same way used in my Intel Assembly programs for DOS and Linux   #
# This function was written to operate the same in both RARS and riscemu      #
###############################################################################

putstr:

mv t1, s0 # t1 will be used as an index register

putstr_strlen_start:
lb t0, 0(t1)                       # load byte into t0 from address of t1
beq t0, zero, putstr_strlen_end # if t0==0, then we jump to the end of the loop.
addi t1, t1, 1                     # go to next byte
j putstr_strlen_start           # jump to start of the loop
putstr_strlen_end:              


addi a0, zero, 1  # a0=1     (STDOUT file number)
addi a1, s0, 0    # a1=s0    (address of string )
sub  a2, t1, s0   # a2=t1-s0 (length of string  )
addi a7, zero, 64 # a7=64    (write system call )
ecall             #          (environment call  )

ret


# The intstr function does several things at once and is the foundation for all integer output.
# It uses the global radix variable to know which radix or number base to use when turning the integer to a string
# It also uses the global int_width variable to determine how many leading zeros should be used for the string
# The purpose of this is to make numbers look good when lined up when they are printed in a list.
# radices 2 to 36 are supported. Digits higher than 9 will be capital letters

intstr:

la t1, radix     # load address of radix into t1
lb t2, 0(t1)     # load value of radix into t2
la t1, int_width # load address of width into t1
lb t4, 0(t1)     # load value of int_width into t4
li t3, 1         # load current number of digits, always 1

la t1, int_end # t1=address of terminating zero in string
addi t1, t1, -1        # t1-- to go to lowest digit

digits_start:

remu t0, s0, t2 # t0=remainder of the previous division
divu s0, s0, t2 # s0=s0/t2 (divide s0 by the radix value in t2)

li t5, 10 # load t5 with 10 because RISC-V does not allow constants for branches

blt t0, t5, decimal_digit
bge t0, t5, hexadecimal_digit

decimal_digit: # we go here if it is only a digit 0 to 9

addi t0, t0, 0x30

j save_digit

hexadecimal_digit:
addi t0, t0, -10
addi t0, t0, 0x41

save_digit:
sb t0, 0(t1) # store byte from t0 at address t1
beq s0, zero, intstr_end
addi t1, t1, -1
addi t3, t3, 1
j digits_start

intstr_end:

li t0, 0x30
prefix_zeros:
bge t3, t4, end_zeros
addi t1, t1, -1
sb t0, 0(t1) # store byte from t0 at address t1
addi t3, t3, 1
j prefix_zeros
end_zeros:

mv s0, t1

ret

# this function calls intstr to convert the s0 register into a string
# then it uses the system specific putstr call to print the string
# it also uses the stack to save the value of s0 and ra (return address)
# this way, s0 is restored to the value it had before this function
# restoring ra is required because it is modified during calls to other functions

putint:

addi sp, sp, -8
sw ra, 0(sp)
sw s0, 4(sp)

jal intstr
jal putstr

lw ra, 0(sp)
lw s0, 4(sp)
addi sp, sp, 8

ret




#the putchar function, which is named after the C language function of the same name
#prints the lowest byte of the s0 register as a byte or character to standard output

putchar:

addi sp, sp, -12
sw ra, 0(sp)
sw s0, 4(sp)
sw t1, 8(sp)

la t1, char
sb s0, 0(t1)
la s0, char
jal putstr

lw ra, 0(sp)
lw s0, 4(sp)
lw t1, 8(sp)
addi sp, sp, 12

ret

#the putspace function prints a space to standard output

putspace:

addi sp, sp, -8
sw ra, 0(sp)
sw s0, 4(sp)

la s0, space
jal putstr

lw ra, 0(sp)
lw s0, 4(sp)
addi sp, sp, 8

ret

#the putline function prints a newline to standard output

putline:

addi sp, sp, -8
sw ra, 0(sp)
sw s0, 4(sp)

la s0, line
jal putstr

lw ra, 0(sp)
lw s0, 4(sp)
addi sp, sp, 8

ret

