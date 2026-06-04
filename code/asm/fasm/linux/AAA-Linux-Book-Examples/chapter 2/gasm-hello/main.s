# Using Linux System calls for 32-bit
# Tested with GNU Assembler on Debian 12 (bookworm)
# Writes a message to standard output with Linux system calls

.global _start

.text

_start:

mov    $0xD,%edx # copy number of bytes from ebx to edx
mov    $msg,%ecx # address of string to output
mov    $0x1,%ebx # file handler 1 is stdout
mov    $0x4,%eax # system call 4 is write
int    $0x80

mov    $0x1,%eax      # system call 1 is exit
mov    $0x0,%ebx      # we want to return code 0
int    $0x80          # end program with system call

.data        # must declare data section for mutable memory

msg:
.ascii "Hello World!\n"
