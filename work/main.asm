format ELF executable
entry main

include 'chastelib32.asm'
include 'chastdin32.asm'

main:

mov dword[radix],10    ;I can choose the radix for integer output!
mov dword[int_width],1 ;and the width of each integer for padded zeros

mov ebp,chastack       ;mov the address of the beginning of the stack to ebp registers

;this program does not read command line arguments
;it always displays a message to tell user what the program does
mov eax,string_help
call putstring

mov [last_char],0xA ;set newline as last_char so prompt will display

main_loop:

;show the arrow indicating we wait for the user to enter something
;but only show it when the last character is a newline
;otherwise it will print too many if multiple commands were entered on the same line
cmp [last_char],0xA
jnz skip_prompt
mov eax,string_prompt
call putstring
skip_prompt:

call getstring ;get string and return address in eax

;we must restart the loop in case of an empty string
;if we didn't, strint would read the empty string and return 0
;then zero would be pushed to the stack, which is not what we want

cmp dword[count],0 ;were there zero characters read?
jz main_loop ;if yes, this was an empty string, retry input

mov esi,eax    ;mov string to esi for string comparison

;Now we process the string the user entered
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

mov edi,string_query
call strcmp
jz command_query

mov edi,string_clear
call strcmp
jz command_clear

mov edi,string_exit
call strcmp
jz command_exit

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
jmp main_loop

;These are the labels and code for each of the commands
;When a command is done, we jump back to the beginning of the loop

command_add:
mov eax,[ebp]
mov dword[ebp],0
sub ebp,4
add [ebp],eax
jmp main_loop

command_sub:
mov eax,[ebp]
mov dword[ebp],0
sub ebp,4
sub [ebp],eax
jmp main_loop

command_mul:
mov ebx,[ebp]
mov dword[ebp],0
sub ebp,4
mov eax,[ebp]
mov edx,0     ;zero edx before multiply
mul ebx       ;multiply eax with value in ebx
mov [ebp],eax
jmp main_loop

command_div:
mov ebx,[ebp]
mov dword[ebp],0
sub ebp,4
mov eax,[ebp]
mov edx,0 ;zero edx before divide
div ebx   ;divide eax with value in ebx
mov [ebp],eax ;store quotient on stack
jmp main_loop

command_rem:
mov ebx,[ebp]
mov dword[ebp],0
sub ebp,4
mov eax,[ebp]
mov edx,0 ;zero edx before divide
div ebx   ;divide eax with value in ebx
mov [ebp],edx ;store remainder on stack
jmp main_loop

command_query: ;print all numbers on the stack
push ebp ;save value of ebp
command_query_loop:
cmp ebp,chastack ;is ebp equal to the address of stack start?
jz command_query_end  ;if it is, end the putstack loop
mov eax,[ebp]
sub ebp,4
call putint_and_line
jmp command_query_loop
command_query_end:
pop ebp ;restore ebp to what it was before this command
jmp main_loop

command_clear: ;erase all numbers on the stack
command_clear_loop:
cmp ebp,chastack ;is ebp equal to the address of stack start?
jz command_clear_end  ;if it is, end the putstack loop
mov dword[ebp],0
sub ebp,4
jmp command_clear_loop
command_clear_end:
jmp main_loop

command_exit: ;end the program

main_loop_end:

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
string_exit db 'exit',0
string_query db '?',0
string_clear db 'clear',0

string_prompt db '-> ',0

string_help db 'chastdin is a stack based interactive calculator',0xA
            db 'Numbers are pushed on the stack and commands can do math.',0xA
            db 'It is a fork of chastack that reads from stdin instead of arguments.',0xA
            db 'Each line can contain multiple numbers or commands.',0xA
            db 'Math commands are add,sub,mul,div,rem',0xA
            db 'The exit command ends the program',0xA
            db 'The ? command prints the entire stack',0xA,0xA,0

;This program uses a virtual stack for convenience and portability
;I allocate memory for a virtual stack that we can index as if it was the real stack
;I name it "chastack" for Chastity's stack.

db 6 dup 0 ;extra padding bytes
chastack: rd 0x100
