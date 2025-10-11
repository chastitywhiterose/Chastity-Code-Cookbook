format ELF executable
entry main

include 'chastelib32.asm'

main: ; the main function of our assembly function, just as if I were writing C.

; I can load any string address into eax and print it!

mov ebx, 1 ;ebx must be 1 to write to standard output

mov eax,msg
call putstring
mov eax,main_string ; move the address of main_string into eax register
call putstring

mov [radix],2 ; can choose radix for integer output!
mov [int_width],8

mov eax,0
loop1:
call putint
inc eax
cmp eax,10h;
jnz loop1

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

; this is where I keep my string variables

msg db 'Hello World!', 0Ah,0     ; assign msg variable with your message string
main_string db "This is Chastity's 32-bit Assembly Language counting program!",0Ah,0

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main
