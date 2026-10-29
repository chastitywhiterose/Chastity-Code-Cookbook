;chastearg Assembly source code for FASM
;This program prints all the arguments on a separate line
;Quoted strings count as one argument and will be on the same line.
format PE console
entry main

include 'win32a.inc'
include 'chastelib-w32.asm'
include 'getarg-w32.asm'

main:

call getarg ;this first call will get the command string
cmp eax,0   ;did the getarg function return 0?
jz main_end ;if eax was zero, there are no args so we end program

;uncomment these lines to see the whole command string
;call putstring
;call putline

arg_loop:
call getarg     ;get the next argument
cmp eax,0       ;did the getarg function return 0?
jz arg_loop_end ;if eax was zero, there are no args
call putstring
call putline
jmp arg_loop
arg_loop_end:

main_end:

;Exit the process with code 0
push 0
call [ExitProcess]

section '.idata' import data readable writeable
library kernel32, 'KERNEL32.DLL'
import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 GetCommandLineA, 'GetCommandLineA'
