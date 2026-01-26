format ELF executable
entry main
include 'chastelib32.asm'
main: 
mov eax,main_string
call putstring
mov     eax, 2         ; invoke SYS_FORK (kernel opcode 2)
int     80h
cmp     eax, 0         ; if eax is zero we are in the child process
jz      child          ; jump if eax is zero to child label
parent:
mov     eax, parentMsg ; inside our parent process move parentMsg into eax
call putstring
jmp main_end 
child:
mov eax,childMsg       ; inside our child process move childMsg into eax
call putstring
main_end:
mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h
main_string db 'This program will fork into two separate processes!',0Ah,0
childMsg    db 'This is the child process',0Ah,0
parentMsg   db 'This is the parent process',0Ah,0
