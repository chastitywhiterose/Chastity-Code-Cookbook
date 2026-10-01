format PE64 console
entry main

include 'win64a.inc'        ;include standard Windows 64-bit definitions and macros
include 'chastelib-w64.asm' ;include standard functions by Chastity
include 'chastdin-w64.asm'  ;include standard input functions by Chastity

main:

mov dword[radix],10    ;I can choose the radix for integer output!
mov dword[int_width],1 ;and the width of each integer for padded zeros

;get the first number
mov rax,help4
call putstring
call putline
call getint
mov rbx,rax

;get the second number
mov rax,help5
call putstring
call putline
call getint
mov rcx,rax

;show both entered numbers
mov rax,help7
call putstring
call putline
mov rax,rbx
call putint
call putline
mov rax,rcx
call putint
call putline
call putline

;ask user for math operation
op_choose:
mov rax,help6
call putstring
call putline
call getint

cmp rax,0
jz op_add
cmp rax,1
jz op_sub
cmp rax,2
jz op_mul
cmp rax,3
jz op_div

jmp op_choose ;start over if none of the choices 0 to 3 were chosen

op_add:
mov rax,rbx
add rax,rcx
jmp print_result

op_sub:
mov rax,rbx
sub rax,rcx
jmp print_result

op_mul:
mov rax,rbx
mul rcx
jmp print_result

op_div:
mov rdx,0
mov rax,rbx
div rcx
jmp print_result

print_result:
push rax
mov rax,help8
call putstring
call putline
pop rax
call putint
call putline

command_exit:      ;end the program

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

string_exit db 'exit',0

help0 db 'Please enter a decimal number.',0xD,0xA
      db 'That means digits 0 to 9 are allowed',0xD,0xA,0
      
help1 db 'You entered: ',0
help2 db 'That is not a valid number! Try again!',0xD,0xA,0
help3 db 'Yes, that is a number!',0xD,0xA,0
help4 db 'Enter the first number',0
help5 db 'Enter the second number',0
help6 db 'Enter which math function to use:',0xD,0xA
      db '0=addition',0xD,0xA
      db '1=subtraction',0xD,0xA
      db '2=multiplication',0xD,0xA
      db '3=division',0xD,0xA,0
help7 db 'Your numbers are:',0xD,0xA,0
help8 db 'Your result is:',0xD,0xA,0

getint:

push rbx
push rcx
push rdx

mov rax,help0
call putstring

getint_loop:

call getstring     ;get string and return address in rax

cmp qword[count],0 ;were there zero characters read?
jz getint_loop     ;if yes, this was an empty string, retry input

mov rsi,rax        ;mov string to rsi for backup and comparison

mov rax,help1
call putstring
mov rax,rsi
call putstring
call putline

call strint          ;try to get a number from the string pointed to by rax
cmp [strint_error],0 ;did we have zero errors in the strint function?
jz number_good       ;if there were no errors, jump to number_good label

number_bad:

mov rax,help2
call putstring
call putline

jmp getint_loop

number_good:

push rax
mov rax,help3
call putstring
call putline
pop rax

getint_end:
pop rdx
pop rcx
pop rbx

ret
            
section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 ReadFile, 'ReadFile'
