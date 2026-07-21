format ELF64 executable
entry main

include 'chastelib64.asm'
include 'chastdin64.asm'

main:

mov qword[radix],10    ;I can choose the radix for integer output!
mov qword[int_width],1 ;and the width of each integer for padded zeros

mov rbp,chastack       ;mov the address of the beginning of the stack to rbp registers

;this program does not read command line arguments
;it always displays a message to tell user what the program does
mov rax,string_help
call putstring

mov [last_char],0xA ;set newline as last_char so prompt will display

main_loop:

;show the arrow indicating we wait for the user to enter something
;but only show it when the last character is a newline
;otherwise it will print too many if multiple commands were entered on the same line
cmp [last_char],0xA
jnz skip_prompt
mov rax,string_prompt
call putstring
skip_prompt:

call getstring ;get string and return address in rax

;we must restart the loop in case of an empty string
;if we didn't, strint would read the empty string and return 0
;then zero would be pushed to the stack, which is not what we want

cmp qword[count],0 ;were there zero characters read?
jz main_loop ;if yes, this was an empty string, retry input

mov rsi,rax    ;mov string to rsi for string comparison

;Now we process the string the user entered
;First, we will try testing for commands
;If any of the predefined strings match the string in rsi
;We jump to the label for that command

mov rdi,string_setradix
call strcmp
jz command_setradix

mov rdi,string_add
call strcmp
jz command_add

mov rdi,string_sub
call strcmp
jz command_sub

mov rdi,string_mul
call strcmp
jz command_mul

mov rdi,string_div
call strcmp
jz command_div

mov rdi,string_rem
call strcmp
jz command_rem

mov rdi,string_query
call strcmp
jz command_query

mov rdi,string_clear
call strcmp
jz command_clear

mov rdi,string_exit
call strcmp
jz command_exit

;The default command is to turn the argument into a number and push to stack
command_num:

mov rax,rsi          ;mov the string to rax for processing numbers
call strint          ;try to get a number from the string pointed to by rax
cmp [strint_error],0 ;did we have zero errors in the strint function?
jz num_push          ;if there were no errors, push this to stack

mov rax,string_err
call putstring       ;print error message
mov rax,rsi
call putstring       ;print which command failed
call putline
jmp num_push_end     ;skip the push because this can't be used

num_push:            ;push the number to the fake stack
add rbp,8            ;increment the pointer by the size of the native int for this mode
mov [rbp],rax        ;mov the value we converted from the string with strint
num_push_end:
jmp main_loop        ;once value is pushed, continue the program

;These are the labels and code for each of the commands
;When a command is done, we jump back to the beginning of the loop
;the add,sub,mul,div,rem commands are pretty self explanatory
;but I will provide comments for these and other commands

;pop top of stack and set the current radix to it
;it has error checking and leaves the radix as is
;unless at least one number is on the stack
command_setradix:
cmp rbp,chastack      ;is rbp above the address of stack start?
jna change_radix_no   ;if not above, we cannot use it to set the radix
change_radix_yes:
mov rax,[rbp]         ;get the top of stack
mov [radix],rax       ;change the radix
mov qword[rbp],0      ;erase the top of stack
sub rbp,8             ;subtract pointer
jmp main_loop         ;and continue main_loop as normal
change_radix_no:
mov rax,string_err1   ;get error message for less than 1 numbers on stack
call putstring        ;print error message
mov rax,rsi           ;get name of the command used
call putstring        ;print which command failed
call putline
jmp main_loop

;add number on top of stack to the one below it
command_add:
mov rax,[rbp]
sub rbp,8
add [rbp],rax
jmp memory_check ;check stack for errors after this command

;subtract number on top of stack from the one below it
command_sub:
mov rax,[rbp]
sub rbp,8
sub [rbp],rax
jmp memory_check ;check stack for errors after this command

;multiply number on top of stack by the one below it
command_mul:
mov rbx,[rbp]
sub rbp,8
mov rax,[rbp]
mov rdx,0     ;zero rdx before multiply
mul rbx       ;multiply rax with value in rbx
mov [rbp],rax
jmp memory_check ;check stack for errors after this command

;divide number on top of stack into the one below it
command_div:
mov rbx,[rbp]
sub rbp,8
mov rax,[rbp]
mov rdx,0 ;zero rdx before divide
div rbx   ;divide rax with value in rbx
mov [rbp],rax ;store quotient on stack
jmp memory_check ;check stack for errors after this command

;divide number on top of stack into the one below it
;but leave remainder instead of quotient
command_rem:
mov rbx,[rbp]
sub rbp,8
mov rax,[rbp]
mov rdx,0 ;zero rdx before divide
div rbx   ;divide rax with value in rbx
mov [rbp],rdx ;store remainder on stack
jmp memory_check ;check stack for errors after this command

;check if the stack has enough space for the last command
;this will print an error if less than two numbers were on the stack
;when using one of the math commands above
memory_check:
cmp rbp,chastack      ;is rbp above the address of stack start?
jna print_stack_error ;if not above, explain error to user
mov qword[rbp+8],0    ;if no error, erase the old top of stack
jmp main_loop         ;and continue main_loop as normal
print_stack_error:
mov rax,string_err2  ;get error message for less than 2 numbers on stack
call putstring       ;print error message
mov rax,rsi          ;get name of the command used
call putstring       ;print which command failed
call putline
add rbp,8            ;increment the pointer to what it was before the failed command
jmp main_loop

command_query: ;print all numbers on the stack
push rbp ;save value of rbp
command_query_loop:
cmp rbp,chastack ;is rbp equal to the address of stack start?
jz command_query_end  ;if it is, end the putstack loop
mov rax,[rbp]
sub rbp,8
call putint_and_line
jmp command_query_loop
command_query_end:
pop rbp ;restore rbp to what it was before this command
jmp main_loop

command_clear: ;erase all numbers on the stack
command_clear_loop:
cmp rbp,chastack ;is rbp equal to the address of stack start?
jz command_clear_end  ;if it is, end the putstack loop
mov qword[rbp],0
sub rbp,8
jmp command_clear_loop
command_clear_end:
jmp main_loop

command_exit: ;end the program

main_loop_end:

mov rax,0x3C              ;exit (kernel opcode 0x3C on 64 bit systems) (60 decimal)
mov rdi,0                 ;return 0 status on exit - 'No Errors'
syscall                   ;system call for 64-bit Linux kernel

argc dd 0

string_setradix db 'setradix',0
string_add db 'add',0
string_sub db 'sub',0
string_mul db 'mul',0
string_div db 'div',0
string_rem db 'rem',0

string_exit db 'exit',0
string_query db '?',0
string_clear db 'clear',0

string_prompt db '-> ',0

string_err db 'Error: invalid number or command: ',0 ;Generic error message
string_err1 db 'Error: need one number on stack for command: ',0 ;math fail error when less than one number on the stack
string_err2 db 'Error: need two numbers on stack for command: ',0 ;math fail error when less than two numbers on the stack

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

chastack: rq 0x100
