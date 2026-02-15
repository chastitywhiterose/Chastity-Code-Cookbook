.data

msg: .asciiz "Hello World!\n"

.text

li a0, 1   # ecall code for print integer in decimal
li a1, 0x100 # integer to print
ecall

li a0, 11  # ecall code for print character
li a1, 0xA # character to print (in this case, ten for newline)
ecall

li a0, 4   # ecall code for print zero terminated string
la a1, msg # string to print
ecall

li a0, 10 # ecall code for exit program
ecall
