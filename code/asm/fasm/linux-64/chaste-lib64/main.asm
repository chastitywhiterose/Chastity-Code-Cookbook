format ELF64 executable
entry main

include 'chaste-lib64.asm'

main: ; the main function of our assembly function, just as if I were writing C.

; I can load any string address into rax and print it!

mov rdi,1 ;rdi must be 1 to write to standard output

mov rax,msg
call putstring
mov rax,main_string ; move the address of main_string into rax register
call putstring

mov [radix],2 ; can choose radix for integer output!
mov [int_width],8

mov rax,0

mov rax,num

loop1:
call putint
inc rax
cmp rax,10h;
jnz loop1

mov rax, 60 ; invoke SYS_EXIT (kernel opcode 60 on 64 bit systems)
mov rdi,0   ; return 0 status on exit - 'No Errors'
syscall

; this is where I keep my string variables

msg db 'Hello World!', 0Ah,0     ; assign msg variable with your message string
main_string db "This is Chastity's 64-bit Assembly Language counting program!",0Ah,0
num db '101',0

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main

