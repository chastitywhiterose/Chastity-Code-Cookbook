# Using Linux System calls for 64-bit
# Tested with GNU Assembler on Debian 12 (bookworm)
# It uses Chastity's putstring function for output

.global _start

.text

_start:

mov $main_string,%rax # move address of string into rax register
call   putstring      # call the putstring function Chastity wrote
mov    $0x3c,%eax     # system call 60 is exit
mov    $0x0,%edi      # we want to return code 0
syscall               # end program with system call

main_string:
.string	"This program runs in Linux!\n"

putstring:            # the start of the putstring function
push   %rax
push   %rbx
push   %rcx
push   %rdx
mov    %rax,%rbx

putstring_strlen_start:
cmpb   $0x0,(%rbx)
je     putstring_strlen_end
inc    %rbx
jmp    putstring_strlen_start

putstring_strlen_end:
sub    %rax,%rbx # subtract rax from rbx for number of bytes to write
mov    %rbx,%rdx # copy number of bytes from rbx to rdx
mov    %rax,%rsi # address of string to output
mov    $0x1,%edi # file handler 1 is stdout
mov    $0x1,%rax # system call 1 is write
syscall
pop    %rdx
pop    %rcx
pop    %rbx
pop    %rax
ret

# This Assembly source file has been formatted for the GNU assembler.
# The following makefile rule has commands to assemble, link, and run the program
#
#main-gas:
#	gcc -nostdlib -nostartfiles -nodefaultlibs -static main.s -o main
#	strip main
#	./main
