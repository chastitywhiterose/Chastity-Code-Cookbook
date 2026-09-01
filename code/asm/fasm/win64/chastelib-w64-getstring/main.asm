format PE64 console
entry main

include 'win64ax.inc'       ;include standard Windows 64-bit definitions and macros
include 'chastelib-w64.asm' ;include standard functions by Chastity
include 'chastdin-w64.asm'  ;include standard input functions by Chastity

main:

mov qword [radix],10
mov qword [int_width],1

loop_input:

mov rax,string0
call putstring

call getstring

mov rsi,rax     ;mov the string address in eax to esi
mov rdi,string3 ;mov the "exit" string address to edi
call strcmp     ;call the function to compare the strings and return eax
cmp rax,0       ;if eax is 0, the strings are the same
jz the_end      ;go to the_end if the user typed "exit"

mov rax,string1
call putstring

mov rax,buf
call putstring
call putline

mov rax,string2
call putstring

mov rax,[count]
call putint
call putline

;special condition for end of line characters
cmp [last_char],0x0D ;was last char carriage return?
jnz not_end_line     ;if not equal, skip this read
call getchar         ;read the 0x0A line feed byte from stdin and discard it
not_end_line:

jmp loop_input

the_end:

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

string0 db 'Enter a string from the keyboard: ',0
string1 db 'string: ',0
string2 db 'length: ',0
string3 db 'exit',0

;A string to test if output works
main_string db 'test suite for 64 bit Windows Assembly version of chastelib.',0x0D,0x0A,0

;FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 ReadFile, 'ReadFile'
