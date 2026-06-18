format ELF64 executable
entry main

include 'chastelib64.asm'

main:

mov qword[radix],10    ;I can choose the radix for integer output!
mov qword[int_width],1 ;and the width of each integer for padded zeros

mov rbp,chastack      ;mov the address of the beginning of the stack to rbp registers

pop rax                ;pop the number of arguments from the stack
mov [argc],rax         ;save the argument count for later

pop rax                ;pop argument 0 (name of the program)
dec [argc]             ;subtract 1 from argument count

mov rax,[argc]
;call putint_and_line
cmp rax,0
jnz usearg ;if arguments are available, use the main loop

mov rax, string_help
call putstring

usearg:

cmp [argc],0          ;check for remaining arguments
jz usearg_end         ;if none, end the loop and stop printing
pop rax               ;pop the next argument off the stack
;call putstr_and_line ;print the string and a new line

mov rsi,rax ;save this string address in rsi for string comparisons later

;Now we process the string we got from the stack
;first, we will try testing for commands
command:

try_add:
mov rdi,string_add
call strcmp
jnz try_sub
mov rax,[rbp]
sub rbp,8
add [rbp],rax
jmp num_push_end ;skip number push because command happened

try_sub:
mov rdi,string_sub
call strcmp
jnz try_mul
mov rax,[rbp]
sub rbp,8
sub [rbp],rax
jmp num_push_end ;skip number push because command happened

try_mul:
mov rdi,string_mul
call strcmp
jnz try_div
mov rbx,[rbp]
sub rbp,8
mov rax,[rbp]
mov rdx,0 ;zero rdx before multiply
mul rbx   ;multiply rax with value in rbx
mov [rbp],rax
jmp num_push_end ;skip number push because command happened

try_div:
mov rdi,string_div
call strcmp
jnz try_rem
mov rbx,[rbp]
sub rbp,8
mov rax,[rbp]
mov rdx,0 ;zero rdx before divide
div rbx   ;divide rax with value in rbx
mov [rbp],rax ;store quotient on stack
jmp num_push_end ;skip number push because command happened

try_rem:
mov rdi,string_rem
call strcmp
jnz command_end
mov rbx,[rbp]
sub rbp,8
mov rax,[rbp]
mov rdx,0 ;zero rdx before divide
div rbx   ;divide rax with value in rbx
mov [rbp],rdx ;store remainder on stack
jmp num_push_end ;skip number push because command happened

command_end:

mov rax,rsi ;mov the string back to rax for processing numbers
call strint ;try to get a number from the string pointed to by rax
cmp [strint_error],0 ;did we have zero errors in the strint function?
jz num_push         ;if there were no errors, push this to stack

mov rax,string_err
call putstring
mov rax,rsi
call putstring
call putline
jmp num_push_end ;skip the push because this can't be used

num_push:

;push the number to the fake stack
add rbp,8
mov [rbp],rax

num_push_end:

;end of command processing

dec [argc]           ;subtract 1 from argument count
jmp usearg           ;jump to the beginning of the loop

usearg_end:

putstack:
cmp rbp,chastack ;is rbp equal to the address of stack start?
jz putstack_end  ;if it is, end the putstack loop

mov rax,[rbp]
sub rbp,8

call putint_and_line

jmp putstack
putstack_end:

mov rax,0x3C           ; invoke SYS_EXIT (kernel opcode 1)
mov rdi,0           ; return 0 status on exit - 'No Errors'
syscall

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

chastack: rq 0x100
