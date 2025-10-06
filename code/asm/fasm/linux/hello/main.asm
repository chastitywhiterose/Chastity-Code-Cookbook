format ELF executable
entry main

main:

mov eax,4      ; invoke SYS_WRITE (kernel opcode 4)
mov ebx,1      ; write to the STDOUT file
mov ecx,msg    ; move the memory address of our message string into ecx
mov edx,13     ; number of bytes to write - one for each letter plus 0Ah (line feed character)
int 80h

mov eax,1      ; invoke SYS_EXIT (kernel opcode 1)
mov ebx,0      ; return 0 status on exit - 'No Errors'
int 80h

msg db 'Hello World!', 0Ah ; assign msg variable with your message string

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main
