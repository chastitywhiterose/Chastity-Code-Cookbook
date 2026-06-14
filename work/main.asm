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

mov ebp,chastack     ;mov the address of the beginning of the stack to ebp registers

putarg:

cmp [argc],0         ;check for remaining arguments
jz putarg_end        ;if none, end the loop and stop printing
pop eax              ;pop the next argument off the stack
;call putstr_and_line ;print the string and a new line

;Now we process the string we got from the stack

;first, we will try testing for commands
command:

mov esi,eax ;save this string address in esi for string comparisons later



num_push:

call strint ;try to get a number from the string pointed to by eax
cmp [strint_error],0 ;did we have zero errors in the strint function?
jnz num_push_end     ;if there were errors, do not push this to stack

;push the number to the fake stack
add ebp,4     ;add 4 bytes for 32 bit value
mov [ebp],eax

num_push_end:

;end of command processing

dec [argc]           ;subtract 1 from argument count
jmp putarg           ;jump to the beginning of the loop

putarg_end:

putstack:
cmp ebp,chastack ;is ebp equal to the address of stack start?
jz putstack_end  ;if it is, end the putstack loop

mov eax,[ebp]
sub ebp,4 ;subtract 4 bytes for 32 bit value

call putint_and_line

jmp putstack
putstack_end:

mov eax, 1           ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0           ; return 0 status on exit - 'No Errors'
int 0x80

argc dd 0

string_nul db 'add',0 ;for checking if the string was meant to represent zero
string_add db 'add',0
string_sub db 'sub',0

string_nan db 'Last argument was not a number. Is it a command?',0 ;


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

