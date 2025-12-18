# This is the source of the RISC-V version of chastelib
# The four basic functions have been translated from Intel x86 Assembly
# They are as follows
#
# putstring (prints string pointed to by s0 register)
# intstr (converts integer in s0 register to a string)
# putint (prints integer in s0 register by use of the previous two functions)
# strint (converts a string pointed to by s0 register into an integer in s0)
#
# Most importantly, the intstr and strint functions depend on a global variable (radix)
# In fact, these two functions are the foundation of everything.
# They can convert to and from any radix from 2 to 36
#
# There is also a MIPS assembly source of this library.
# The primary differences between the two assembly languages from my experience are:
# RISC-V requires registers for all branch comparisons
# RISC-V uses ecall but MIPS uses syscall
# RISC-V selects system call with a7 but MIPS uses $v0
# RISC-V does not use dollar signs ($) in the name of registers but MIPS does 

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

li s0,0 #we will load the $s0 register with the number we want to convert to string
li s1,16

loop:
jal putint
addi s0,s0,1
blt s0,s1,loop

la s0,test_int # convert string to integer
jal strint

li t0,10    #change radix
la t1,radix
sb t0,0(t1)

li t0,8    #change width
la t1,int_width
sb t0,0(t1)

jal putint

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

lb t2,radix     # load value of radix into t2
lb t4,int_width # load value of int_width into t4
li t3,1         # load current number of digits, always 1

digits_start:

remu t0,s0,t2 # t0=remainder of the previous division
divu s0,s0,t2 # s0=s0/t2 (divide s0 by the radix value in t2)

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
sb t0,(t1) # store byte from t0 at address t1
beq s0,zero,intstr_end
addi t1,t1,-1
addi t3,t3,1
j digits_start

intstr_end:

li t0,'0'
prefix_zeros:
bge t3,t4,end_zeros
addi t1,t1,-1
sb t0,(t1) # store byte from t0 at address t1
addi t3,t3,1
j prefix_zeros
end_zeros:

mv s0,t1

jr ra

#this function calls intstr to convert the s0 register into a string
#then it uses a system call to print the string
#it also uses the stack to save the value of s0 and ra (return address)

putint:
sw ra,0(sp)
sw s0,-4(sp)
jal intstr
#print string
li a7,4      # load immediate, v0 = 4 (4 is print string system call)
mv a0,s0  # load address of string to print into a0
ecall
lw ra,0(sp)
lw s0,-4(sp)
jr ra




# RISC-V does not allow constants for branches
# Because of this fact, the RISC-V version of strint
# requires a lot more code than the MIPS version
# Whatever value I wanted to compare in the branch statement
# was placed in the t5 register on the line before the conditional branch
# Even though it is completely stupid, it has proven to work

strint:

mv t1,s0 # copy string address from s0 to t1
li s0,0

lb t2,radix     # load value of radix into t2

read_strint:
lb t0,(t1)
addi t1,t1,1
beq t0,zero,strint_end

#if char is below '0' or above '9', it is outside the range of these and is not a digit
li t5,'0'
blt t0,t5,not_digit
li t5,'9'
bgt t0,t5,not_digit

#but if it is a digit, then correct and process the character
is_digit:
andi t0,t0,0xF
j process_char

not_digit:
#it isn't a digit, but it could be perhaps and alphabet character
#which is a digit in a higher base

#if char is below 'A' or above 'Z', it is outside the range of these and is not capital letter
li t5,'A'
blt t0,t5,not_upper
li t5,'Z'
bgt t0,t5,not_upper

is_upper:
li t5,'A'
sub t0,t0,t5
addi t0,t0,10
j process_char

not_upper:

#if char is below 'a' or above 'z', it is outside the range of these and is not lowercase letter
li t5,'a'
blt t0,t5,not_lower
li t5,'z'
bgt t0,t5,not_lower

is_lower:
li t5,'a'
sub t0,t0,t5
addi t0,t0,10
j process_char

not_lower:

#if we have reached this point, result invalid and end function
#this is only reached if the byte was not a valid digit or alphabet character
j strint_end

process_char:

bgt t0,t2 strint_end #;if this value is above or equal to radix, it is too high despite being a valid digit/alpha


mul s0,s0,t2 # multiply s0 by the radix
add s0,s0,t0     # add the correct value of this digit

j read_strint # jump back and continue the loop if nothing has exited it

strint_end:

jr ra
