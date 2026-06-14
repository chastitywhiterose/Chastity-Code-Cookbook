format ELF executable
entry main

include 'chastelib32.asm'

main:

mov dword[radix],10       ;I can choose the radix for integer output!
mov dword[int_width],1    ;and the width of each integer for padded zeros

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

strcmp:

mov eax,0

strcmp_start:

;read a byte from each string
mov al,[edi]
mov bl,[esi]
cmp al,bl
jnz strcmp_end

cmp al,0
jz strcmp_end

inc edi
inc esi

jmp strcmp_start

strcmp_end:
sub al,bl

ret

;because the actual hardware stack is used to process the command line arguments.
;I allocate memory for a virtual stack that we can index as if it was the real stack
;I name it "chastack" for Chastity's stack.

chastack: rd 0x100

