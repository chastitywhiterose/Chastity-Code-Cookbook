format ELF executable
entry main

include 'chastelib32.asm'

main:

mov dword[radix],10    ;I can choose the radix for integer output!
mov dword[int_width],1 ;and the width of each integer for padded zeros

mov ebp,chastack      ;mov the address of the beginning of the stack to ebp registers

pop eax                ;pop the number of arguments from the stack
mov [argc],eax         ;save the argument count for later

pop eax                ;pop argument 0 (name of the program)
dec [argc]             ;subtract 1 from argument count

mov eax,[argc]
;call putint_and_line
cmp eax,0
jnz usearg ;if arguments are available, use the main loop

mov eax, string_help
call putstring

usearg:

cmp [argc],0          ;check for remaining arguments
jz usearg_end         ;if none, end the loop and stop printing
pop eax               ;pop the next argument off the stack
;call putstr_and_line ;print the string and a new line

mov esi,eax ;save this string address in esi for string comparisons later

;Now we process the string we got from the stack
;first, we will try testing for commands
command:

try_add:
mov edi,string_add
call strcmp
jnz try_sub
mov eax,[ebp]
sub ebp,4 ;subtract 4 bytes for 32 bit value
add [ebp],eax
jmp num_push_end ;skip number push because command happened

try_sub:
mov edi,string_sub
call strcmp
jnz try_mul
mov eax,[ebp]
sub ebp,4 ;subtract 4 bytes for 32 bit value
sub [ebp],eax
jmp num_push_end ;skip number push because command happened

try_mul:
mov edi,string_mul
call strcmp
jnz try_div
mov ebx,[ebp]
sub ebp,4 ;subtract 4 bytes for 32 bit value
mov eax,[ebp]
mov edx,0 ;zero edx before multiply
mul ebx   ;multiply eax with value in ebx
mov [ebp],eax
jmp num_push_end ;skip number push because command happened

try_div:
mov edi,string_div
call strcmp
jnz try_rem
mov ebx,[ebp]
sub ebp,4 ;subtract 4 bytes for 32 bit value
mov eax,[ebp]
mov edx,0 ;zero edx before divide
div ebx   ;divide eax with value in ebx
mov [ebp],eax ;store quotient on stack
jmp num_push_end ;skip number push because command happened

try_rem:
mov edi,string_rem
call strcmp
jnz command_end
mov ebx,[ebp]
sub ebp,4 ;subtract 4 bytes for 32 bit value
mov eax,[ebp]
mov edx,0 ;zero edx before divide
div ebx   ;divide eax with value in ebx
mov [ebp],edx ;store remainder on stack
jmp num_push_end ;skip number push because command happened

command_end:

mov eax,esi ;mov the string back to eax for processing numbers
call strint ;try to get a number from the string pointed to by eax
cmp [strint_error],0 ;did we have zero errors in the strint function?
jz num_push         ;if there were no errors, push this to stack

mov eax,string_err
call putstring
mov eax,esi
call putstring
call putline
jmp num_push_end ;skip the push because this can't be used

num_push:

;push the number to the fake stack
add ebp,4     ;add 4 bytes for 32 bit value
mov [ebp],eax

num_push_end:

;end of command processing

dec [argc]           ;subtract 1 from argument count
jmp usearg           ;jump to the beginning of the loop

usearg_end:

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

string_err db 'Error: invalid number or command: ',0 ;Generic error message
string_add db 'add',0
string_sub db 'sub',0
string_mul db 'mul',0
string_div db 'div',0
string_rem db 'rem',0

string_help db 'chastack is a stack based command line calculator',0xA
            db 'Numbers are pushed on the stack and commands can do math.',0xA
            db 'Commands are add,sub,mul,div,rem',0xA
            db 'Example: "chastack 3 4 5 add mul"',0xA,0,0

;strcmp compares the string at esi to the one at edi
;eax returns 0 if the strings are the same and 1 if different
;the algorithm is simple but I will explain it for those who are confused

;eax is initialized to zero
;a byte from each string is loaded into the al and bl registers
;the bytes are compared. if they are different, then we jump to the end
;However, if they are the same, then we check if one of them is zero
;for this purpose it doesn't matter whether we compare al or bl with zero
;because it is known that they are the same if the jnz did not take place
;if it is zero, this also jumps to the end of the function
;If neither jump took place, then we jump to the start of the loop
;but when the function finally ends bl will be subtracted from al
;this ensures that the function returns zero if the final characters are the same
;ebx,esi,and edi are preserved but eax is the return value
;also, the sub instruction at the end of the function also updates the flags
;so you can "jz" or "jnz" to a label after calling this function based on results

strcmp:

push ebx
push esi
push edi

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

pop edi
pop esi
pop ebx

ret

;because the actual hardware stack is used to process the command line arguments.
;I allocate memory for a virtual stack that we can index as if it was the real stack
;I name it "chastack" for Chastity's stack.

chastack: rd 0x100
