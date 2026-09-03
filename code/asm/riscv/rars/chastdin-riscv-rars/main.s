# chastelib test suite for RISC-V Assembly in RARS simulator

# this program tests the stdin extension of chastelib

# The same library of functions I commonly use in my Intel Assembly code
# have now been translated to RISC-V.
# All assembly code seen here is for the RARS simulator written in Java.

.data

##################################################################
# chastelib core specific variables                              #
#                                                                #
# These variables are used by the intstr function to convert an  #
# integer to a string and what radix and widthshould be used     #
# width means how many minimum digits including leading zeros    #
##################################################################

int_string: .space 32 #reserve space for 32 bytes for up to 32 bits if printed in binary
int_end: .byte 0 #the terminating zero of the integer string
radix: .byte 2   #the radix the number will be shown in
int_width: .byte 1 #by default

# These variables are for outputting special strings
# such as a newline, space, or a single character based on s0

space: .byte 0x20, 0
line:  .byte 0x0A, 0
char:  .byte 0, 0 

##################################################################
# chastdin specific variables                                    #
#                                                                #
# these variables are used as the default controllers            #
# for the getstring and getline functions                        #
# buf stores keyboard input during those functions               #
# count stores how many bytes were read during system read calls #
# last_char stores the last character read                       #
# usually this will be a space, tab, or newline                  #
##################################################################

buf: .space 0x100
count: .word 0
last_char: .byte 0

# program specific variables
# These variables are for outputting specific messages
# or to simulate user input as integers in the strint function

string0: .ascii "chastelib test suite for RISC-V Assembly\n"
string1: .asciz "stdin (STanDard INput) extension\n"

string_exit: .asciz "exit"

.text

la s0, string0
jal putstr

# change radix for this program
li t0, 16    #load t0 register with the new radix
la t1, radix #load t1 register with the address the radix will go to
sb t0, 0(t1) #save t0 register (byte) to address t1

main_loop:

jal getstr  # read the string from standard input
jal putline # print extra line for readability

jal putstr # echo it to standard output
jal putline

#s0 already contains string that was input and printed
#s1 will be loaded with address of exit string
la s1, string_exit
jal strcmp

# end program if the string entered is equal to string_exit
beq t0, zero, exit

#method 0: loading the length of string just entered from (count)
#la t1, count       #load address of count into t2
#lw s0, 0(t1)       #store number of chars read at (count) address

#method 1: calculate the length with strlen function
jal strlen

# regardless of method used, display the length of last string
jal putint
jal putline

j main_loop # keep restarting until exit string is entered

exit:
li a0, 0  #status
li a7, 93 #exit
ecall     #environment call

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

la t1, radix     #load address of radix into t1
lb t2, 0(t1)     #load value of radix into t2
la t1, int_width #load address of width into t1
lb t4, 0(t1)     #load value of int_width into t4
li t3, 1         #load current number of digits, always 1

la t1, int_end   #t1=address of terminating zero in string
addi t1, t1, -1  #t1-- to go to lowest digit

digits_start:

remu t0, s0, t2  #t0=remainder of the previous division
divu s0, s0, t2  #s0=s0/t2 (divide s0 by the radix value in t2)

li t5, 10        #load t5 with 10 because RISC-V does not allow constants for branches

blt t0, t5, decimal_digit
bge t0, t5, hexadecimal_digit

decimal_digit:   #we go here if it is only a digit 0 to 9

addi t0, t0, 0x30

j save_digit

hexadecimal_digit:
addi t0, t0, -10
addi t0, t0, 0x41

save_digit:
sb t0, 0(t1)     #store byte from t0 at address t1
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

la t1, radix     #load address of radix into t1
lb t2, 0(t1)     #load value of radix into t2

mv t1, s0        #copy string address from s0 to t1
li s0, 0

read_strint:
lb t0, 0(t1)
addi t1, t1, 1
beq t0, zero, strint_end

#if char is below '0' or above '9', it is outside the range of these and is not a digit
li t5, 0x30
blt t0, t5, not_digit
li t5, 0x39
blt t5, t0, not_digit

#but if it is a digit, then correct and process the character
is_digit:
andi t0, t0, 0xF
j process_char

not_digit:
#it isn't a digit, but it could be an alphabet character
#which counts as a digit in a higher base

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
# This putstr function is my most portable function for RISC-V simulators     #
# It calculates the length of a zero terminated string before printing it     #
# This is the same way used in my Intel Assembly programs for DOS and Linux   #
# This function was written to operate the same in both RARS and riscemu      #
###############################################################################

putstr:

mv t1, s0                       # t1 will be used as an index register

putstr_strlen_start:
lb t0, 0(t1)                    # load byte into t0 from address of t1
beq t0, zero, putstr_strlen_end # if t0==0, then we jump to the end of the loop.
addi t1, t1, 1                  # go to next byte
j putstr_strlen_start           # jump to start of the loop
putstr_strlen_end:              

li a0, 1                        # STDOUT file number
mv a1, s0                       # address of string 
sub a2, t1, s0                  # length of string
li a7, 64                       # write call number
ecall                           # environment call

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

##########################################################################
# chastdin extension functions                                           #
#                                                                        #
# all functions that deal with getting strings and characters from stdin #
##########################################################################

# the getstr function will read a string into a buffer and return it
# in the s0 register for printing with the putstr function
# the (count) variable will also return the number of characters

getstr:

li t0, 0                        # use t0 register to track chars read
la a1, buf                      # load address of buffer for read string
li a2, 1                        # read only 1 byte for each env call

getstring_chars:

li a0, 0                        # STDIN file number
li a7, 63                       # read call number
ecall                           # environment call

# Branch to label getstring_end if a0 is less than a2
# a0 is the return value of this environment read call
# as will be -1 on error or 1 if successful
# because we read 1 character at a time

blt a0, a2, getstring_end

# if no error, test range of the last byte

lb t1, 0(a1)      #load byte at address (a1) into t1 register

# if t1 is less than 0x21
# of t1 is more than 0x7E
# branch to function end because it is outside of print range

li t2, 0x21
blt t1, t2, getstring_end
li t2, 0x7E
blt t2, t1, getstring_end

# otherwise, proceed to read more characters
add t0, t0, a0    # add to read counter
addi a1, a1, 1    # add 1 to buffer pointer register a1
j getstring_chars # unconditional jump to getstring_chars

getstring_end:

la t2, count       #load address of count into t2
sw t0, 0(t2)       #store number of chars read at (count) address
la t2, last_char   #load address of last_char into t2
sb t1, 0(t2)       #store last byte at (last_char) address
sb zero, 0(a1)     #store byte zero to terminate string
la s0, buf         #return address of buf in s0 register

ret


# Short Description of strlen:
# The strlen function gets the length of string in s0 and returns it in s0
# This is the same algorithm used in my putstr function but is independent of an operating system.

strlen:

mv t1, s0                       # t1 will be used as an index register

strlen_start:
lb t0, 0(t1)                    # load byte into t0 from address of t1
beq t0, zero, strlen_end        # if t0==0, then we jump to the end of the loop.
addi t1, t1, 1                  # go to next byte
j strlen_start                  # jump to start of the loop
strlen_end:              

sub s0, t1, s0                  # return length of string in s0

ret


# Short Description of strcmp:
# strcmp compares the string at s0 to the one at s1
# t0 returns 0 if the strings are the same and non zero if different
# the algorithm is simple but I will explain it for those who are confused

# Long Description of strcmp:
# each byte from each string is loaded into the t0 and t1 registers
# the bytes are compared. if they are different, then we jump to the end
# However, if they are the same, then we check if one of them is zero
# if it is zero, this also jumps to the end of the function
# If neither jump took place, then we jump to the start of the loop
# but when the function finally ends t1 will be subtracted from t0
# this ensures that the t0 register returns zero if the final characters are the same
# a zero result in t0 also guarantees that both strings are equal

strcmp:

mv a0,s0 # move pointer s0 to t0
mv a1,s1 # move pointer s0 to t0

strcmp_start:

#read a byte from each string
lb t0, 0(a0) 
lb t1, 0(a1) 
#if the two bytes are not equal end comparison
bne t0, t1, strcmp_end

#but if they are equal, test for zero
#if one of them is zero, also end the loop
beq t0, zero, strcmp_end

addi a0, a0, 1                  # go to next byte
addi a1, a1, 1                  # go to next byte

j strcmp_start

strcmp_end:

#subtract t1 from t0
#if t0 is still zero after the function returns
#it means that the strings are equal
sub t0, t0, t1

ret
