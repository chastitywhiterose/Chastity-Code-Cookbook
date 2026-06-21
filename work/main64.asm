format ELF64 executable
entry main

include 'chastelib64.asm'

main:

mov qword[radix],10    ;I can choose the radix for integer output!
mov qword[int_width],1 ;and the width of each integer for padded zeros

mov rbp,chastack       ;mov the address of the beginning of the stack to rbp registers

pop rax                ;pop the number of arguments from the stack
dec rax                ;subtract 1 because the program name will be unused
mov [argc],rax         ;save the argument count for later
pop rbx                ;pop argument 0 (name of the program, we don't use it)
cmp rax,0
jnz usearg             ;if arguments are available, use the main loop

mov rax,string_help
call putstring

usearg:

cmp [argc],0          ;check for remaining arguments
jz usearg_end         ;if none, end the loop and stop printing
pop rsi               ;pop the next argument off the stack to rsi for string comparison
dec [argc]            ;subtract 1 from argument count

;Now we process the string we got from the stack
;First, we will try testing for commands
;If any of the predefined strings match the string in rsi
;We jump to the label for that command

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

;The default command is to turn the argument into a number and push to stack

command_num:

mov rax,rsi          ;mov the string to rax for processing numbers
call strint          ;try to get a number from the string pointed to by rax
cmp [strint_error],0 ;did we have zero errors in the strint function?
jz num_push          ;if there were no errors, push this to stack

mov rax,string_err
call putstring
mov rax,rsi
call putstring
call putline
jmp num_push_end ;skip the push because this can't be used

num_push:        ;push the number to the fake stack
add rbp,8
mov [rbp],rax
num_push_end:

jmp usearg

;These are the labels and code for each of the commands
;When a command is done, we jump back to the beginning of the loop

command_add:
mov rax,[rbp]
sub rbp,8
add [rbp],rax
jmp usearg

command_sub:
mov rax,[rbp]
sub rbp,8
sub [rbp],rax
jmp usearg

command_mul:
mov rbx,[rbp]
sub rbp,8
mov rax,[rbp]
mov rdx,0     ;zero rdx before multiply
mul rbx       ;multiply rax with value in rbx
mov [rbp],rax
jmp usearg

command_div:
mov rbx,[rbp]
sub rbp,8
mov rax,[rbp]
mov rdx,0 ;zero rdx before divide
div rbx   ;divide rax with value in rbx
mov [rbp],rax ;store quotient on stack
jmp usearg

command_rem:
mov rbx,[rbp]
sub rbp,8
mov rax,[rbp]
mov rdx,0 ;zero rdx before divide
div rbx   ;divide rax with value in rbx
mov [rbp],rdx ;store remainder on stack
jmp usearg

usearg_end:

putstack:
cmp rbp,chastack ;is rbp equal to the address of stack start?
jz putstack_end  ;if it is, end the putstack loop

mov rax,[rbp]
sub rbp,8

call putint_and_line

jmp putstack
putstack_end:

mov rax,0x3C     ;exit (kernel opcode 0x3C on 64 bit systems) (60 decimal)
mov rdi,0        ;return 0 status on exit - 'No Errors'
syscall          ;system call for 64-bit Linux kernel

argc dq 0

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

;strcmp compares the string at rsi to the one at rdi
;rax returns 0 if the strings are the same and 1 if different
;the algorithm is simple but I will explain it for those who are confused

;rax is initialized to zero
;a byte from each string is loaded into the al and bl registers
;the bytes are compared. if they are different, then we jump to the end
;However, if they are the same, then we check if one of them is zero
;for this purpose it doesn't matter whether we compare al or bl with zero
;because it is known that they are the same if the jnz did not take place
;if it is zero, this also jumps to the end of the function
;If neither jump took place, then we jump to the start of the loop
;but when the function finally ends bl will be subtracted from al
;this ensures that the function returns zero if the final characters are the same
;rbx,rsi,and rdi are preserved but rax is the return value
;also, the sub instruction at the end of the function also updates the flags
;so you can "jz" or "jnz" to a label after calling this function based on results

strcmp:

push rbx
push rsi
push rdi

mov rax,0

strcmp_start:

;read a byte from each string
mov al,[rdi]
mov bl,[rsi]
cmp al,bl
jnz strcmp_end

cmp al,0
jz strcmp_end

inc rdi
inc rsi

jmp strcmp_start

strcmp_end:
sub al,bl

pop rdi
pop rsi
pop rbx

ret

;because the actual hardware stack is used to process the command line arguments.
;I allocate memory for a virtual stack that we can index as if it was the real stack
;I name it "chastack" for Chastity's stack.

db 6 dup 0 ;extra padding bytes
chastack: rq 0x100
