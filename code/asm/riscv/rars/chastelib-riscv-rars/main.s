# chastelib test suite for RISC-V Assembly in RARS simulator

# The same library of functions I commonly use in my Intel Assembly code
# have now been translated to RISC-V.

.data

# These variables are used by the intstr function to convert an integer to a string
# and what radix should be used as well as the width (how many leading zeros)

int_string: .space 32 #reserve space for 32 bytes for up to 32 bits if printed in binary
int_end: .byte 0 #the terminating zero of the integer string
radix: .byte 2   #the radix the number will be shown in
int_width: .byte 1 #by default

# These variables are for outputting special strings
# such as a newline, space, or a single character based on s0

space: .byte 0x20, 0
line:  .byte 0x0A, 0
char:  .byte 0, 0 

# These variables are for outputting specific messages
# or to simulate user input as integers in the strint function

string0: .asciz "chastelib test suite for RISC-V Assembly in RARS simulator\n"

input_int_0: .asciz "0"
input_int_1: .asciz "100"

.text

la s0, string0
jal putstr

# at the beginning of a program, it is usually good to get user input
# this program doesn't use real user input but simulates it with global strings we will interpret
# as if they are hexadecimal integers

# change radix to decimal
li t0, 16    #load t0 register with the new radix
la t1, radix #load t1 register with the address the radix will go to
sb t0, 0(t1) #save t0 register (byte) to address t1

# load s0 with address of first integer string, convert it with strint, and save in another register
la s0, input_int_0
jal strint
mv s2, s0

# load s0 with address of second integer string, convert it with strint, and save in another register
la s0, input_int_1
jal strint
mv s3, s0

# this is how we would load the loop controller variables directly
# these are commented out for this example
# li s0, 0
# li s1, 0x100

mv s0, s2
mv s1, s3

loop:

# change radix to binary
li t0, 2     #load t0 register with the new radix
la t1, radix #load t1 register with the address the radix will go to
sb t0, 0(t1) #save t0 register (byte) to address t1

# change width to 8 to represent an 8 bit binary value
li t0, 8     #load t0 register with the new width
la t1, int_width #load t1 register with the address the width will go to
sb t0, 0(t1) #save t0 register (byte) to address t1

jal putint
jal putspace

# change radix to hexadecimal
li t0, 16     #load t0 register with the new radix
la t1, radix #load t1 register with the address the radix will go to
sb t0, 0(t1) #save t0 register (byte) to address t1

# change width to 2 to represent an 8 bit binary value as a two digit hex value
li t0, 2     #load t0 register with the new width
la t1, int_width #load t1 register with the address the width will go to
sb t0, 0(t1) #save t0 register (byte) to address t1

jal putint
jal putspace

# change radix to decimal
li t0, 10     #load t0 register with the new radix
la t1, radix #load t1 register with the address the radix will go to
sb t0, 0(t1) #save t0 register (byte) to address t1

# change width to 3 to represent an 8 bit binary value decimal value of up to 3 digits
li t0, 3       #load t0 register with the new width
la t1, int_width #load t1 register with the address the width will go to
sb t0, 0(t1) #save t0 register (byte) to address t1

jal putint

li t1, 0x20
blt s0, t1, not_char
li t1, 0x7E
blt t1, s0, not_char

jal putspace
jal putchar

not_char:                # jump here if character is outside range to print

jal putline

addi s0, s0, 1
blt s0, s1, loop

la s0, string0
jal putstr

li   a7, 10     # exit syscall
ecall

#################################################################################
# The following functions are independent of a specific RISC-V Operating System #
#                                                                               #
# intstr = convert integer into a string ready for printing                     #
# putint = prints integer using intstr and the OS specific putstr function      #
# strint = convert string into an integer                                       #
#                                                                               #
# The s0 register is used for pass data in or out of these functions            #
# See comments above those specific functions for full details                  #
#################################################################################

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

# RISC-V does not allow constants for branches
# Because of this fact, the RISC-V version of strint
# requires a lot more code than the MIPS version
# Whatever value I wanted to compare in the branch statement
# was placed in the t5 register on the line before the conditional branch
# Even though it is completely stupid, it has proven to work

strint:

la t1, radix     # load address of radix into t1
lb t2, 0(t1)     # load value of radix into t2

mv t1, s0 # copy string address from s0 to t1
li s0, 0

read_strint:
lb t0, 0(t1)
addi t1, t1, 1
beq t0, zero, strint_end

# if char is below '0' or above '9', it is outside the range of these and is not a digit
li t5, 0x30
blt t0, t5, not_digit
li t5, 0x39
blt t5, t0, not_digit

# but if it is a digit, then correct and process the character
is_digit:
andi t0, t0, 0xF
j process_char

not_digit:
# it isn't a digit, but it could be perhaps and alphabet character
# which is a digit in a higher base

# if char is below 'A' or above 'Z', it is outside the range of these and is not capital letter
li t5, 0x41
blt t0, t5, not_upper
li t5, 0x5A
blt t5, t0, not_upper

is_upper:
li t5, 0x41
sub t0, t0, t5
addi t0, t0, 10
j process_char

not_upper:

# if char is below 'a' or above 'z', it is outside the range of these and is not lowercase letter
li t5, 0x61
blt t0, t5, not_lower
li t5, 0x7A
blt t5, t0, not_lower

is_lower:
li t5, 0x61
sub t0, t0, t5
addi t0, t0, 10
j process_char

not_lower:

# if we have reached this point, result invalid and end function
# this is only reached if the byte was not a valid digit or alphabet character
j strint_end

process_char:

blt t2, t0 strint_end #;if this value is above or equal to radix, it is too high despite being a valid digit/alpha


mul s0, s0, t2 # multiply s0 by the radix
add s0, s0, t0 # add the correct value of this digit

j read_strint # jump back and continue the loop if nothing has exited it

strint_end:

ret

###############################################################################
# This putstr function is the most portable function for RISC-V simulators    #
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

#############################################################################
# The next four 3 functions print things to standard output                 #
# All of them use the putstr function above to achieve the output           #
# They use the stack to preserve the values of the s0 and t1 registers used #
# They also use global variables in the data section                        #
#############################################################################

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

# the putspace function prints a space to standard output

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

# the putline function prints a newline to standard output

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
