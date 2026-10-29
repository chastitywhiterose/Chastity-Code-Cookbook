;chastearg Assembly source code for FASM
;This program prints all the arguments on a separate line
;Quoted strings count as one argument and will be on the same line.
format PE64 console
entry main

include 'win64ax.inc'
include 'chastelib-w64.asm'
include 'getarg-w64.asm'

main:

call getarg ;this first call will get the command string
cmp rax,0   ;did the getarg function return 0?
jz main_end ;if rax was zero, there are no args so we end program

;uncomment these lines to see the whole command string
;call putstring
;call putline

arg_loop:
call getarg     ;get the next argument
cmp rax,0       ;did the getarg function return 0?
jz arg_loop_end ;if rax was zero, there are no args
call putstring
call putline
jmp arg_loop
arg_loop_end:

main_end:

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

section '.idata' import data readable writeable
library kernel32, 'KERNEL32.DLL'
import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 GetCommandLineA, 'GetCommandLineA'
