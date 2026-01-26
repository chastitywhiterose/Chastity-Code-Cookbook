format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'

main:

mov eax,main_string
call putstring

mov [radix],16 ; can choose radix for integer output!
mov [int_width],1
mov [int_newline],0

mov eax,input_string_int ;address of input string to convert to integer
call strint              ;call strint to return the string in eax register

mov ebx,eax              ;ebx=eax

mov eax,0
loop1:

mov [radix],2            ;set radix to binary
mov [int_width],8        ;width of 8 for maximum 8 bits
call putint
call putspace
mov [radix],16           ;set radix to hexadecimal
mov [int_width],2        ;width of 8 for maximum 8 bits
call putint
call putspace
mov [radix],10           ;set radix to decimal (what humans read)
mov [int_width],3        ;width of 8 for maximum 8 bits
call putint
call putspace
call putline
inc eax
cmp eax,ebx;
jnz loop1

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

;A string to test if output works
main_string db 'This program is the official test suite for the Windows Assembly version of chastelib.',0Ah,0
;test string of integer for input
input_string_int db '80',0
