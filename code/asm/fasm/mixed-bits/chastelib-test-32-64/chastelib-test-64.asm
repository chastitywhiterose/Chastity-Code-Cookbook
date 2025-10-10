format ELF64 executable
entry main

include 'chaste-lib64.asm'

main: ; the main function of our assembly function, just as if I were writing C.

mov rdi,1 ;rdi must be 1 to write to standard output

mov [radix],2 ; Choose radix 2 for integer input!

mov rax,test_int
call strint

mov [radix],10 ; Choose radix 10 for integer output!
mov [int_width],8
call putint

mov rax,60 ; invoke SYS_EXIT (kernel opcode 60 on 64 bit systems)
mov rdi,0   ; return 0 status on exit - 'No Errors'
syscall

; test string of integer for input
test_int db '10011101001110011110011',0

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm chastelib-test-64.asm
;	chmod +x chastelib-test-64
;	./chastelib-test-64
