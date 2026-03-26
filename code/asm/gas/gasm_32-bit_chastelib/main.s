# Using Linux System calls for 32-bit
# Tested with GNU Assembler on Debian 12 (bookworm)
# It uses Chastity's putstring function for output

.global _start

.text

_start:

mov $main_string,%eax # move address of string into eax register
call   putstring      # call the putstring function Chastity wrote
mov    $0x1,%eax      # system call 60 is exit
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

int_string:
.skip 32,'?'
.byte 0


# This Assembly source file has been formatted for the GNU assembler.
# The following makefile rule has commands to assemble, link, and run the program
#
#main-gas:
#	gcc -nostdlib -nostartfiles -nodefaultlibs -static main.s -o main -m32
#	strip main
#	./main
