# Using Linux System calls for 32-bit
# Tested with GNU Assembler on Debian 12 (bookworm)
# It uses Chastity's putstring function for output

.global _start

.text

_start:

mov $main_string,%eax # move address of string into eax register
call   putstring      # call the putstring function Chastity wrote

movl $10,radix # set the radix to decimal AKA base ten so humans can understand this code

mov $666,%eax   # load the number in eax that we want to print
call putint

mov    $0x1,%eax      # system call 1 is exit
mov    $0x0,%ebx      # we want to return code 0
int    $0x80          # end program with system call

main_string:
.string	"This program runs in Linux!\n"

putstring:            # the start of the putstring function
push   %eax
push   %ebx
push   %ecx
push   %edx
mov    %eax,%ebx

putstring_strlen_start:
cmpb   $0x0,(%ebx)
je     putstring_strlen_end
inc    %ebx
jmp    putstring_strlen_start

putstring_strlen_end:
sub    %eax,%ebx # subtract eax from ebx for number of bytes to write
mov    %ebx,%edx # copy number of bytes from ebx to edx
mov    %eax,%ecx # address of string to output
mov    $0x1,%ebx # file handler 1 is stdout
mov    $0x4,%eax # system call 4 is write
int    $0x80

pop    %edx
pop    %ecx
pop    %ebx
pop    %eax
ret

.data

int_string:  # storage for the bytes of an integer
.skip 32,'?' # unknown bytes represented with question marks
.byte 0      # terminating zero of this string

int_newline: # optional newline to print after a number
.byte 0xA,0

radix: .long 2
int_width: .long 8

.text

intstr: # start of the intstr function
mov    $int_string+31,%ebx
mov    $0x1,%ecx

digits_start:
mov    $0x0,%edx
divl   radix            # divide by number at address radix
cmp    $0xa,%edx
jb     decimal_digit
jae    hexadecimal_digit

decimal_digit:
add    $0x30,%edx
jmp    save_digit

hexadecimal_digit:
sub    $0xa,%edx
add    $0x41,%edx

save_digit:
mov    %dl,(%ebx)
cmp    $0x0,%eax
je     intstr_end
dec    %ebx
inc    %ecx
jmp    digits_start

intstr_end:
cmp    int_width,%ecx # see if ecx is above or equal to the integer width we want
jae    end_zeros
dec    %ebx
movb   $0x30,(%ebx)
inc    %ecx
jmp    intstr_end

end_zeros:
mov    %ebx,%eax
ret

putint: # the putint function calls intstr and then putstring to display any number

push   %eax
push   %ebx
push   %ecx
push   %edx
call   intstr
call   putstring
pop    %edx
pop    %ecx
pop    %ebx
pop    %eax
ret

# This Assembly source file has been formatted for the GNU assembler.
# The following makefile rule has commands to assemble, link, and run the program
#
#main-gas:
#	gcc -nostdlib -nostartfiles -nodefaultlibs -static main.s -o main -m32
#	strip main
#	./main
