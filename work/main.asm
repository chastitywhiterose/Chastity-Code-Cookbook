# Chastity's putstr function for RISC-V Assembly in riscemu

.data

# These variables are used by the intstr function to convert an integer to a string
# and what radix should be used as well as the width (how many leading zeros)

int_string: .space 32 #reserve space for 32 bytes for up to 32 bits if printed in binary
int_end: .byte 0 #the terminating zero of the integer string
radix: .byte 2   #the radix the number will be shown in
int_width: .byte 1 #by default

string0: .asciiz "I am Chastity White Rose\n"

.text

addi s0, zero, string0

#li t0, '0x30'
#sb t0, 0(s0)

jal putstr



jal intstr

li s0, int_string
jal putstr

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

la t1, int_end # load target index address of lowest digit
addi t1, t1, -1

digits_start:

remu t0, s0, t2 # t0=remainder of the previous division
divu s0, s0, t2 # s0=s0/t2 (divide s0 by the radix value in t2)

li t5, 10 # load t5 with 10 because RISC-V does not allow constants for branches
blt t0, t5,decimal_digit
bge t0, t5,hexadecimal_digit

decimal_digit: # we go here if it is only a digit 0 to 9
addi t0, t0, '0'
j save_digit

hexadecimal_digit:
addi t0, t0, -10
addi t0, t0, 'A'

save_digit:
sb t0,0(t1) # store byte from t0 at address t1
beq s0, zero, intstr_end
addi t1, t1, -1
addi t3, t3, 1
j digits_start

intstr_end:

li t0, '0'
prefix_zeros:
bge t3, t4, end_zeros
addi t1, t1, -1
sb t0, 0(t1) # store byte from t0 at address t1
addi t3, t3, 1
j prefix_zeros
end_zeros:

mv s0, t1

ret

