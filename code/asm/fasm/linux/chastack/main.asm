format ELF executable
entry main

include 'chastelib32.asm'

main:

mov dword[radix],10    ;I can choose the radix for integer output!
mov dword[int_width],1 ;and the width of each integer for padded zeros

mov ebp,chastack       ;mov the address of the beginning of the stack to ebp registers

pop eax                ;pop the number of arguments from the stack
dec eax                ;subtract 1 because the program name will be unused
mov [argc],eax         ;save the argument count for later
pop ebx                ;pop argument 0 (name of the program, we don't use it)
cmp eax,0
jnz usearg             ;if arguments are available, use the main loop

mov eax,string_help
call putstring

usearg:

cmp [argc],0          ;check for remaining arguments
jz usearg_end         ;if none, end the loop and stop printing
pop esi               ;pop the next argument off the stack to esi for string comparison
dec [argc]            ;subtract 1 from argument count

;Now we process the string we got from the stack
;First, we will try testing for commands
;If any of the predefined strings match the string in esi
;We jump to the label for that command

mov edi,string_add
call strcmp
jz command_add

mov edi,string_sub
call strcmp
jz command_sub

mov edi,string_mul
call strcmp
jz command_mul

mov edi,string_div
call strcmp
jz command_div

mov edi,string_rem
call strcmp
jz command_rem

;The default command is to turn the argument into a number and push to stack

command_num:

mov eax,esi          ;mov the string to eax for processing numbers
call strint          ;try to get a number from the string pointed to by eax
cmp [strint_error],0 ;did we have zero errors in the strint function?
jz num_push          ;if there were no errors, push this to stack

mov eax,string_err
call putstring
mov eax,esi
call putstring
call putline
jmp num_push_end ;skip the push because this can't be used

num_push:        ;push the number to the fake stack
add ebp,4
mov [ebp],eax
num_push_end:

jmp usearg

;These are the labels and code for each of the commands
;When a command is done, we jump back to the beginning of the loop

command_add:
mov eax,[ebp]
sub ebp,4
add [ebp],eax
jmp usearg

command_sub:
mov eax,[ebp]
sub ebp,4
sub [ebp],eax
jmp usearg

command_mul:
mov ebx,[ebp]
sub ebp,4
mov eax,[ebp]
mov edx,0     ;zero edx before multiply
mul ebx       ;multiply eax with value in ebx
mov [ebp],eax
jmp usearg

command_div:
mov ebx,[ebp]
sub ebp,4
mov eax,[ebp]
mov edx,0 ;zero edx before divide
div ebx   ;divide eax with value in ebx
mov [ebp],eax ;store quotient on stack
jmp usearg

command_rem:
mov ebx,[ebp]
sub ebp,4
mov eax,[ebp]
mov edx,0 ;zero edx before divide
div ebx   ;divide eax with value in ebx
mov [ebp],edx ;store remainder on stack
jmp usearg

usearg_end:

putstack:
cmp ebp,chastack ;is ebp equal to the address of stack start?
jz putstack_end  ;if it is, end the putstack loop

mov eax,[ebp]
sub ebp,4

call putint_and_line

jmp putstack
putstack_end:

mov eax,1        ;exit (kernel opcode 1 on 32 bit systems)
mov ebx,0        ;return 0 status on exit - 'No Errors'
int 80h          ;system call for 32-bit Linux kernel

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

db 6 dup 0 ;extra padding bytes
chastack: rd 0x100
