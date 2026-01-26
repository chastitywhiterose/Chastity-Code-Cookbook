;syscall fork example for Linux
format ELF executable
entry main

include 'chastelib32.asm'

main:

mov eax,main_string
call putstring



mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

main_string db 'This program will fork into two separate processes!',0Ah,0
