format ELF executable
entry main

include 'chastelib32.asm'

main:

pop eax              ;pop the number of arguments from the stack
mov [argc],eax       ;save the argument count for later

pop eax              ;pop argument 0 (name of the program)
dec [argc]           ;subtract 1 from argument count

putarg:

cmp [argc],0         ;check for remaining arguments
jz putarg_end        ;if none, end the loop and stop printing
pop eax              ;pop the next argument off the stack
call putstr_and_line ;print the string and a new line
dec [argc]           ;subtract 1 from argument count
jmp putarg           ;jump to the beginning of the loop

putarg_end:

mov eax, 1           ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0           ; return 0 status on exit - 'No Errors'
int 0x80

argc dd 0

