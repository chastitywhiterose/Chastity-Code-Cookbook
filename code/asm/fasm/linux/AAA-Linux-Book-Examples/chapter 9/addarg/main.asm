format ELF executable
entry main

include 'chastelib32.asm'

main:

mov dword[radix],10    ;I can choose the radix for integer output!
mov dword[int_width],1 ;and the width of each integer for padded zeros

pop eax                ;pop the number of arguments from the stack
mov [argc],eax         ;save the argument count for later

pop eax                ;pop argument 0 (name of the program)
dec [argc]             ;subtract 1 from argument count

mov ebp,0              ;use the ebp register as our sum

addarg:

cmp [argc],0           ;check for remaining arguments
jz addarg_end          ;if none, end the loop and stop printing
pop eax                ;pop the next argument off the stack
call strint
add ebp,eax            ;add the converted number to our sum in ebp
dec [argc]             ;subtract 1 from argument count
jmp addarg             ;jump to the beginning of the loop

addarg_end:

mov eax,ebp
call putint_and_line   ;print the string and a new line

mov eax, 1             ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0             ; return 0 status on exit - 'No Errors'
int 0x80

argc dd 0
