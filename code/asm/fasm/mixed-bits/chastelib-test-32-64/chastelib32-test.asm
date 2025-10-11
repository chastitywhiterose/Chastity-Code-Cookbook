format ELF executable
entry main

include 'chastelib32.asm'

main: ; the main function of our assembly function, just as if I were writing C.

mov ebx,1 ;ebx must be 1 to write to standard output

mov [radix],2 ; Choose radix 2 for integer input!

mov eax,test_int
call strint

mov [radix],10 ; Choose radix 10 for integer output!
mov [int_width],8
call putint

mov eax,1  ; invoke SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

; test string of integer for input
test_int db '10011101001110011110011',0

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm chastelib32-test.asm
;	chmod +x chastelib32-test
;	./chastelib32-test
