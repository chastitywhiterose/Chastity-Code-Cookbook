# Using Linux System calls for 32-bit
# Tested with GNU Assembler on Debian 12 (bookworm)
# It uses Chastity's putstring function for output

.global _start

_start:

mov $main_string,%eax # move address of string into eax register
call   putstring      # call the putstring function Chastity wrote

movl $10,radix # set the radix to decimal AKA base ten so humans can understand this code
movl $1,int_width # set the minimum integer width

mov $string_putint,%eax
call putstring

mov $666,%eax   # load the number in eax that we want to print
call putint
call putline

mov $string_strint,%eax
call putstring

mov $input_string,%eax
call strint
call putint
call putline

mov $end_string,%eax
call putstring

mov    $0x1,%eax      # system call 1 is exit
mov    $0x0,%ebx      # we want to return code 0
int    $0x80          # end program with system call

main_string:
.string	"The putstring function performs all text output\n"
string_putint:
.string "The putint function prints whatever number is in eax register!\n"
string_strint:
.string "The strint function converts a strint into a number for the eax register\n"
end_string:
.string "The reason the year I was born was printed was because it was defined as a string and then converted to a number\n"

input_string:
.string	"1987"

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

.data        # must declare data section for mutable memory

int_string:  # storage for the bytes of an integer
.skip 32,'?' # unknown bytes represented with question marks
.byte 0      # terminating zero of this string

int_newline: # optional newline to print after a number
.byte 0xA,0

radix: .long 2
int_width: .long 8

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

# the strint function is arguably the most complicated assembly function I have ever written
# it can convert any string into a number based on the current radix
# as soon as it finds a zero byte or a charact that is not a valid digit in that radix
# it will return the value in the eax register so it can be printed or used elsewhere

strint:
mov    %eax,%ebx # copy string address from eax to ebx because eax will be replaced soon!
mov    $0x0,%eax # eax set to zero before digits multiplied in


read_strint:
mov    $0x0,%ecx
mov    (%ebx),%cl
inc    %ebx
cmp    $0x0,%cl
je     strint_end
cmp    $0x30,%cl
jb     not_digit
cmp    $0x39,%cl
ja     not_digit

is_digit:
sub    $0x30,%cl
jmp    process_char

not_digit:
cmp    $0x41,%cl
jb     not_upper
cmp    $0x5a,%cl
ja     not_upper

is_upper:
sub    $0x41,%cl
add    $0xa,%cl
jmp    process_char

not_upper:
cmp    $0x61,%cl
jb     not_lower
cmp    $0x7a,%cl
ja     not_lower

is_lower:
sub    $0x61,%cl
add    $0xa,%cl
jmp    process_char

not_lower:
jmp    strint_end

process_char:
cmp    radix,%ecx
jae    strint_end
mov    $0x0,%edx
mull   radix
add    %ecx,%eax
jmp    read_strint

strint_end:
ret

space: .byte ' ',0
line: .byte 0x0A,0

putspace:
push   %eax
mov    $space,%eax
call   putstring
pop    %eax
ret

putline:
push   %eax
mov    $line,%eax
call   putstring
pop    %eax
ret

char: .byte 0,0 # where char data is temporarily stored by the putchar function

putchar:
push   %eax
mov    %al,0x12b
mov    $char,%eax
call   putstring
pop    %eax
ret

# This Assembly source file has been formatted for the GNU assembler.
# The following makefile rule has commands to assemble, link, and run the program
#
#main-gas:
#	gcc -nostdlib -nostartfiles -nodefaultlibs -static main.s -o main -m32
#	strip main
#	./main
