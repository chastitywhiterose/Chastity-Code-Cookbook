format PE64 console
entry main

include 'win64a.inc'        ;include standard Windows 64-bit definitions and macros
include 'chastelib-w64.asm' ;include standard functions by Chastity
include 'chastdin-w64.asm'  ;include standard input functions by Chastity

main:

mov dword[radix],10    ;I can choose the radix for integer output!
mov dword[int_width],1 ;and the width of each integer for padded zeros

mov rax,help0
call putstring

main_loop:

call getstring     ;get string and return address in rax

cmp qword[count],0 ;were there zero characters read?
jz main_loop       ;if yes, this was an empty string, retry input

mov rsi,rax        ;mov string to rsi for backup and comparison

mov rax,help1
call putstring
mov rax,rsi
call putstring
call putline

mov rax,help2
call putstring
mov rax,[count]
call putint
call putline

mov rdi,string_exit
call strcmp
jz command_exit

jmp main_loop

command_exit:      ;end the program

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

string_exit db 'exit',0

help0 db 'Enter a string of text from the keyboard.',0xA
      db 'Then I will tell you about the string you entered.',0xA,0
      
help1 db 'The string was: ',0
help2 db 'The length was: ',0
            
section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 ReadFile, 'ReadFile'
