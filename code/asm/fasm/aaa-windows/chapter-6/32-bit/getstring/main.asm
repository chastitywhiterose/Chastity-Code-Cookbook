format PE console
entry main

include 'win32a.inc'        ;include standard Windows 64-bit definitions and macros
include 'chastelib-w32.asm' ;include standard functions by Chastity
include 'chastdin-w32.asm'  ;include standard input functions by Chastity

main:

mov dword[radix],10    ;I can choose the radix for integer output!
mov dword[int_width],1 ;and the width of each integer for padded zeros

mov eax,help0
call putstring

main_loop:

call getstring     ;get string and return address in eax

cmp dword[count],0 ;were there zero characters read?
jz main_loop       ;if yes, this was an empty string, retry input

mov esi,eax        ;mov string to esi for backup and comparison

mov eax,help1
call putstring
mov eax,esi
call putstring
call putline

mov eax,help2
call putstring
mov eax,[count]
call putint
call putline

mov edi,string_exit
call strcmp
jz command_exit

jmp main_loop

command_exit:      ;end the program

;Exit the process with code 0
push 0
call [ExitProcess]

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
