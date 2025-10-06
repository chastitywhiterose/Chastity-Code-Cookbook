format ELF64 executable
entry main

main:

mov rax,1   ; invoke SYS_WRITE (kernel opcode 1 on 64 bit systems)
mov rdi,1   ; write to the STDOUT file
mov rsi,msg ; pointer/address of string to write
mov rdx,13  ; number of bytes to write
syscall

mov rax, 60 ; invoke SYS_EXIT (kernel opcode 60 on 64 bit systems)
mov rdi,0   ; return 0 status on exit - 'No Errors'
syscall

msg db 'Hello World!', 0Ah ; assign msg variable with your message string

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main

