format ELF64 executable

main:                     ;the main function of the assembly program

mov rax,string0
call putstring

mov qword[radix],16       ;I can choose the radix for integer output!
mov qword[int_width],1    ;and the width of each integer for padded zeros

mov rax,input_string_int  ;address of input string to convert to integer
call strint               ;call strint to return the string in rax register
mov rbx,rax               ;rbx=rax (copy the converted value returned in rax to rbx)

mov rax,0
loop0:

mov qword[radix],2        ;set radix to binary
mov qword[int_width],8    ;width of 8 bits
call putint
call putspace
mov qword[radix],16       ;set radix to hexadecimal
mov qword[int_width],2    ;width of 2 hex digits
call putint
call putspace
mov qword[radix],10       ;set radix to decimal (what humans read)
mov qword[int_width],3    ;width of 3 decimal digits
call putint

cmp al,0x20               ;check if al is in printable range
jb not_char               ;if not then jump to not_char label
cmp al,0x7E
ja not_char

call putspace
call putchar              ;print the character if it is in the range 0x20 to 0x7E

not_char:                 ;jump here if character is outside range to print

call putline              ;print newline before the next loop

inc rax
cmp rax,rbx;
jnz loop0

mov rax,string0
call putstring

mov rax,0x3C              ;exit (kernel opcode 0x3C on 64 bit systems) (60 decimal)
mov rdi,0                 ;return 0 status on exit - 'No Errors'
syscall                   ;system call for 64-bit Linux kernel

include 'chastelib64.asm'

string0 db 'chastelib test suite for Intel 64-bit Assembly on Linux',0Ah,0
input_string_int db '100',0

;This Assembly source file has been formatted for the FASM assembler.
;The following script will assemble, give executable permissions, and run the program.
;
;#!/bin/sh
;fasm main.asm
;chmod +x main
;./main