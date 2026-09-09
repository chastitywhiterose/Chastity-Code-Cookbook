format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'

main:

mov eax,main_string
call putstring

mov [radix],2 ; can choose radix for integer output!
mov [int_width],4

mov eax,0
loop1:
call putint
inc eax
cmp eax,10h;
jnz loop1

mov eax,test_int
call strint

mov [radix],10 ; Choose radix 10 for integer output!
mov [int_width],8
call putint

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

;A string to test if output works
main_string db 'Hello World!',0Ah,0
;test string of integer for input
test_int db '10011101001110011110011',0
