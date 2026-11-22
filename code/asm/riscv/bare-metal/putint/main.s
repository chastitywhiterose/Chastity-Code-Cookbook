.section .data #readable and writable data

stack_space: .space 0x100
stack_top:  .quad 0

# These variables are used by the intstr function to convert an integer to a string
# and what radix should be used as well as the width (how many leading zeros)


int_string: .space 64 #reserve space for up to 64 bits if printed in binary
int_end: .byte 0 #the terminating zero of the integer string
radix: .byte 2   #the radix the number will be shown in
int_width: .byte 1 #by default


char:  .byte 0, 0 #used for the putchar function to temporarily store a character

.section .rodata #read only data

string0: .asciz "chastelib putint for bare metal RISC-V Assembly.\n"
string1: .asciz "The program runs as bootloader for QEMU.\n"

# These variables are for outputting special strings
# such as a newline, space, or a single character based on s0

space: .byte 0x20, 0
line:  .byte 0x0A, 0

.section .text
.global _start

_start:

#set the global pointer
.option push
.option norelax
la gp, __global_pointer$
.option pop

#Initialize stack pointer next
la sp, stack_top

la s0, string0
jal putstr
la s0, string1
jal putstr

# this is how we would load the loop controller variables directly
 li s0, 0
 li s1, 0x100

loop:

# change radix to binary
li t0, 16         #load t0 register with the new radix
la t1, radix     #load t1 register with the address the radix will go to
sb t0, 0(t1)     #save t0 register (byte) to address t1

# change width to 8 to represent an 8 bit binary value
li t0, 8         #load t0 register with the new width
la t1, int_width #load t1 register with the address the width will go to
sb t0, 0(t1)     #save t0 register (byte) to address t1

jal putint
jal putspace

# change radix to hexadecimal
li t0, 16        #load t0 register with the new radix
la t1, radix     #load t1 register with the address the radix will go to
sb t0, 0(t1)     #save t0 register (byte) to address t1

# change width to 2 to represent an 8 bit binary value as a two digit hex value
li t0, 2         #load t0 register with the new width
la t1, int_width #load t1 register with the address the width will go to
sb t0, 0(t1)     #save t0 register (byte) to address t1

jal putint
jal putspace

# change radix to decimal
li t0, 10        #load t0 register with the new radix
la t1, radix     #load t1 register with the address the radix will go to
sb t0, 0(t1)     #save t0 register (byte) to address t1

# change width to 3 to represent an 8 bit binary value decimal value of up to 3 digits
li t0, 3         #load t0 register with the new width
la t1, int_width #load t1 register with the address the width will go to
sb t0, 0(t1)     #save t0 register (byte) to address t1

jal putint

li t1, 0x20
blt s0, t1, not_char
li t1, 0x7E
blt t1, s0, not_char

jal putspace
jal putchar

not_char:        #jump here if character is outside range to print

jal putline

addi s0, s0, 1
blt s0, s1, loop

la s0, string0
jal putstr
la s0, string1
jal putstr

#Trigger QEMU poweroff via SiFive Test Finisher
li t0, 0x100000        # Base address of SiFive test device on QEMU virt
li t1, 0x5555          # FINISHER_PASS value (triggers poweroff with exit code 0)
sw t1, 0(t0)           # Write 0x5555 to 0x100000

halt:
wfi                    # Wait for interrupt (low-power idle)
j halt                 # Infinite loop

###############################################################################
# This putstr function is for a RISC-V bootloader while running from QEMU     #
# It uses memory mapped output that is specific to the "-machine virt" option #
# It prints characters from the string address pointed to by the s0 register  #
# It uses the temporary registers t0, t1 and t2 to index all character arrays #
###############################################################################

putstr:

mv t1, s0                     #t1 will be used as an index register
li t2, 0x10000000             #Load the memory-mapped UART address (0x10000000)

putstr_loop_beg:
lb t0, 0(t1)                  #load byte into t0 from address of t1
beq t0, zero, putstr_loop_end #if t0==0, then we jump to the end of the loop.
sb t0, 0(t2)                  #save byte from t0 into address of t1
addi t1, t1, 1                #go to next byte
j putstr_loop_beg             #jump to start of the loop
putstr_loop_end:              

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

addi sp, sp, -24
sd ra, 0(sp)
sd s0, 8(sp)
sd t1, 16(sp)

la t1, char
sb s0, 0(t1)
la s0, char
jal putstr

ld ra, 0(sp)
ld s0, 8(sp)
ld t1, 16(sp)
addi sp, sp, 24

ret

# the putspace function prints a space to standard output

putspace:

addi sp, sp, -16
sd ra, 0(sp)
sd s0, 8(sp)

la s0, space
jal putstr

ld ra, 0(sp)
ld s0, 8(sp)
addi sp, sp, 16

ret

# the putline function prints a newline to standard output

putline:

addi sp, sp, -16
sd ra, 0(sp)
sd s0, 8(sp)

la s0, line
jal putstr

ld ra, 0(sp)
ld s0, 8(sp)
addi sp, sp, 16

ret

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

#64-bit note: stack is saved to multiples of 8 bytes because register size is 64-bits
#this is also true for other functions converted from the 32-bit RARS version

putint:

addi sp, sp, -16
sd ra, 0(sp)
sd s0, 8(sp)

jal intstr
jal putstr

ld ra, 0(sp)
ld s0, 8(sp)
addi sp, sp, 16

ret
