;chastearg Assembly source code for FASM
;This program prints all the arguments on a separate line
;Quoted strings count as one argument and will be on the same line.
format PE console

include 'win32ax.inc'
include 'chastelibw32.asm'
include 'getargw32.asm'

main:

mov [radix],16 ; Choose radix for integer output.
mov [int_width],1

;this loop will get all the command line arguments and print them on separate lines

;call getarg ;this first call will get the command string
;call putstring


;jmp main_end

arg_loop:
call getarg
call putint
call putline
cmp eax,0 ;did the getarg function return 0?
jz arg_loop_end ;if eax was zero, there are no args
call putstring
call putline
jmp arg_loop
arg_loop_end:

main_end: ;jump here to end the program

;Exit the process with code 0
push 0
call [ExitProcess]

.end main
