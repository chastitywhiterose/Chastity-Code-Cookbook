#hexdump for MIPS emulator: mars
.data
title: .asciz "hexdump program in RISC-V assembly language\n\n"

# test string of integer for input
test_int: .asciz "10011101001110011110011"
hex_message: .asciz "Hex Dump of File: "
file_message_yes: "The file is open.\n"
file_message_no: "The file could not be opened.\n"
file_data: .byte '?':16
           .byte 0
space_three: .asciz "   "

#this is the location in memory where digits are written to by the putint function
int_string: .byte '?':32
int_newline: .byte 10,0
radix: .byte 2
int_width: .byte 4

argc: .word 0
argv: .word 0

.text
main:

# at the beginning of the program a0 has the number of arguments
# so we will save it in the argc variable
la t1,argc
sw a0,0(t1)

# at the beginning of the program a1 has a pointer to the argument strings
# so we save it because we may need a1 for system calls
la t1,argv
sw a1,0(t1)

#Now that the argument data is stored away, we can access it even if it is overwritten.
#For example, the putstring function uses a0 for system call number 4, which prints a string

la s0,title
jal putstring

li t0,16    #change radix
la t1,radix
sb t0,0(t1)

li t0,1    #change width
la t1,int_width
sb t0,0(t1)


# next, we load argc from the memory so we can display the number of arguments
la t1,argc
lw s0,0(t1)
#jal putint

beq s0,zero,exit # if the number of arguments is zero, exit the program because nothing else to print

# this section processes the filename and opens the file from the first argument

jal next_argument
#jal putstring
mv s11,s0 #save the filename in register s11 so we can use it any time

li a7,1024 # open file call number
mv a0,s11  # copy filename for the open call
li a1,0    # read only access for the file we will open (rars does not support read+write mode)
ecall

mv s0,a0
#jal putint

blt s0,zero,file_error # branch if argc is not equal to zero

mv s9,s0 # save the find handle in register s9
la s0,file_message_yes
#jal putstring
jal hexdump

j exit

file_error:

la s0,file_message_no
jal putstring


j exit

exit:
li a7, 10     # exit syscall
ecall












putstring:
li $v0,4      # load immediate, v0 = 4 (4 is print string system call)
move $a0,$s0  # load address of string to print into a0
syscall
jr $ra


#this is the intstr function, the ultimate integer to string conversion function
#just like the Intel Assembly version, it can convert an integer into a string
#radixes 2 to 36 are supported. Digits higher than 9 will be capital letters

intstr:

la $t1,int_newline # load target index address of lowest digit
addi $t1,$t1,-1

lb $t2,radix     # load value of radix into $t2
lb $t4,int_width # load value of int_width into $t4
li $t3,1         # load current number of digits, always 1

digits_start:

divu $s0,$s0,$t2 # $s0=$s0/$t2 (divide s0 by the radix value in $t2)
mfhi $t0        # $t0=remainder of the previous division
blt $t0,10,decimal_digit
bge $t0,10,hexadecimal_digit

decimal_digit: # we go here if it is only a digit 0 to 9
addi $t0,$t0,'0'
j save_digit

hexadecimal_digit:
addi $t0,$t0,-10
addi $t0,$t0,'A'

save_digit:
sb $t0,($t1) # store byte from $t0 at address $t1
beq $s0,$0,intstr_end
addi $t1,$t1,-1
addi $t3,$t3,1
j digits_start

intstr_end:

li $t0,'0'
prefix_zeros:
bge $t3,$t4,end_zeros
addi $t1,$t1,-1
sb $t0,($t1) # store byte from $t0 at address $t1
addi $t3,$t3,1
j prefix_zeros
end_zeros:

move $s0,$t1

jr $ra

#this function calls intstr to convert the $s0 register into a string
#then it uses a system call to print the string
#it also uses the stack to save the value of $s0 and $ra (return address)

putint:
addi $sp,$sp,-8
sw $ra,0($sp)
sw $s0,4($sp)
jal intstr
#print string
li $v0,4      # load immediate, v0 = 4 (4 is print string system call)
move $a0,$s0  # load address of string to print into a0
syscall
lw $ra,0($sp)
lw $s0,4($sp)
addi $sp,$sp,8
jr $ra











strint:

move $t1,$s0 # copy string address from $s0 to $t1
li $s0,0

lb $t2,radix     # load value of radix into $t2

read_strint:
lb $t0,($t1)
addi $t1,$t1,1
beq $t0,0,strint_end

#if char is below '0' or above '9', it is outside the range of these and is not a digit
blt $t0,'0',not_digit
bgt $t0,'9',not_digit

#but if it is a digit, then correct and process the character
is_digit:
and $t0,$t0,0xF
j process_char

not_digit:
#it isn't a digit, but it could be perhaps and alphabet character
#which is a digit in a higher base

#if char is below 'A' or above 'Z', it is outside the range of these and is not capital letter
blt $t0,'A',not_upper
bgt $t0,'Z',not_upper

is_upper:

sub $t0,$t0,'A'
addi $t0,$t0,10
j process_char

not_upper:

#if char is below 'a' or above 'z', it is outside the range of these and is not lowercase letter
blt $t0,'a',not_lower
bgt $t0,'z',not_lower

is_lower:

sub $t0,$t0,'a'
addi $t0,$t0,10
j process_char

not_lower:

#if we have reached this point, result invalid and end function
#this is only reached if the byte was not a valid digit or alphabet character
j strint_end

process_char:

bgt $t0,$t2 strint_end #;if this value is above or equal to radix, it is too high despite being a valid digit/alpha

mul $s0,$s0,$t2 # multiply $s0 by the radix
add $s0,$s0,$t0     # add the correct value of this digit

j read_strint # jump back and continue the loop if nothing has exited it

strint_end:

jr $ra

