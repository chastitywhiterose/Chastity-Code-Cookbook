.globl __start

.data

msg: .asciiz "Hello World!\n"

#These variables are used by the intstr function to convert an integer to a string
#and what radix should be used as well as the width (how many leading zeros)

int_string: .space 32 #reserve space for 32 bytes for up to 32 bits if printed in binary
int_end: .byte 0 #the terminating zero of the integer string
radix: .byte 2   #the radix the number will be shown in
int_width: .byte 1 #by default

.text

__start:

#The first thing to do is to disable automatic printing of the newline.
#My library is built to print integers ending in a newline but it doesn't make sense for this program.

la s0,msg
jal putstring

li s0,0 #we will load the $s0 register with the number we want to convert to string
li s1,0x100

loop:

#change radix to binary
li t0,2     #load t0 register with the new radix
la t1,radix #load t1 register with the address the radix will go to
sb t0,0(t1) #save t0 register (byte) to address t1

#change width to 8 to represent an 8 bit binary value
li t0,8     #load t0 register with the new width
la t1,int_width #load t1 register with the address the width will go to
sb t0,0(t1) #save t0 register (byte) to address t1

jal putint
jal putspace

#change radix to hexadecimal
li t0,16     #load t0 register with the new radix
la t1,radix #load t1 register with the address the radix will go to
sb t0,0(t1) #save t0 register (byte) to address t1

#change width to 2 to represent an 8 bit binary value as a two digit hex value
li t0,2     #load t0 register with the new width
la t1,int_width #load t1 register with the address the width will go to
sb t0,0(t1) #save t0 register (byte) to address t1

jal putint
jal putspace

#change radix to decimal
li t0,10     #load t0 register with the new radix
la t1,radix #load t1 register with the address the radix will go to
sb t0,0(t1) #save t0 register (byte) to address t1

#change width to 3 to represent an 8 bit binary value decimal value of up to 3 digits
li t0,3       #load t0 register with the new width
la t1,int_width #load t1 register with the address the width will go to
sb t0,0(t1) #save t0 register (byte) to address t1

jal putint

li t1,0x20
blt s0,t1,not_char
li t1,0x7E
bgt s0,t1,not_char

jal putspace
jal putchar

not_char:                ;jump here if character is outside range to print

jal putline


addi s0,s0,1
blt s0,s1,loop

li a0, 10 # ecall code for exit program
ecall

# putstring is arguably both the simplest but the most important because it is how I print all my strings.
# The s0 register must be loaded with the address of a string to print.
# Obviously the string will be terminated with a zero byte and stored in memory somewhere.

putstring:
li a0, 4  # ecall code for print zero terminated string
mv a1,s0  # load address of string to print into a0
ecall
jr ra

# The intstr function does several things at once and is the foundation for all integer output.
# It uses the global radix variable to know which radix or number base to use when turning the integer to a string
# It also uses the global int_width variable to determine how many leading zeros should be used for the string
# The purpose of this is to make numbers look good when lined up when they are printed in a list.
# radices 2 to 36 are supported. Digits higher than 9 will be capital letters

intstr:

la t1,int_end # load target index address of lowest digit
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
sb t0,0(t1) # store byte from t0 at address t1
beq s0,zero,intstr_end
addi t1,t1,-1
addi t3,t3,1
j digits_start

intstr_end:

li t0,'0'
prefix_zeros:
bge t3,t4,end_zeros
addi t1,t1,-1
sb t0,0(t1) # store byte from t0 at address t1
addi t3,t3,1
j prefix_zeros
end_zeros:

mv s0,t1

jr ra



#this function calls intstr to convert the s0 register into a string
#then it uses a system call to print the string
#it also uses the stack to save the value of s0 and ra (return address)

putint:
addi sp,sp,-8
sw ra,0(sp)
sw s0,4(sp)

jal intstr
jal putstring

lw ra,0(sp)
lw s0,4(sp)
addi sp,sp,8
jr ra


putspace:
li a0, 11  # ecall code for print character
li a1, 0x20 # character to print (in this case, 0x20 for a space)
ecall
jr ra

putline:
li a0, 11  # ecall code for print character
li a1, 0x0A # character to print (in this case, 0x0A for newline)
ecall
jr ra

#the putchar function, which is named after the C language function of the same name
#prints the lowest byte of the s0 register as a byte or character to standard output

putchar:
li a0, 11  # ecall code for print character
mv a1, s0  # character to print (in this case, 0x0A for newline)
ecall
jr ra
