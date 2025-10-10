;Linux 32-bit Assembly Source for chastehex
;a special tool originally written in C
format ELF executable
entry main

include 'chaste-lib.asm'

;the main function of our assembly function, just as if I were writing C.
main: 

; I can load any string address into eax and print it!

mov ebx,1  ;ebx must be 1 to write to standard output

mov [radix],2 ; can choose radix for integer input/output!

mov eax,test_input_string
call strint

call putint

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

; this is where I keep my string variables

main_string db "This is Chastity's 32-bit Assembly integer conversion program!",0Ah,0
test_input_string db '11000',0

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main
