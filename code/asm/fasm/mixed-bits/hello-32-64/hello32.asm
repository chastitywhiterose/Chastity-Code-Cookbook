format ELF executable
entry main

main:

mov eax,4   ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,1   ; write to the STDOUT file
mov ecx,msg ; pointer/address of string to write
mov edx,13  ; number of bytes to write
int 80h

mov eax,1   ; invoke SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0   ; return 0 status on exit - 'No Errors'
int 80h

msg db 'Hello World!', 0Ah ; assign msg variable with your message string

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main
