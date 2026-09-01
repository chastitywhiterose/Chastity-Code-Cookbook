format PE64 console
entry main

include 'win64ax.inc'       ;includes standard Windows 64-bit definitions and macros
include 'chastelib-w64.asm' ;include standard functions by Chastity
include 'chastdin-w64.asm'  

main:

mov rax,main_string
call putstring



sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

;A string to test if output works
main_string db 'test suite for 64 bit Windows Assembly version of chastelib.',0x0D,0x0A,0
;test string of integer for input
input_string_int db '100',0

;FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 ReadFile, 'ReadFile'
