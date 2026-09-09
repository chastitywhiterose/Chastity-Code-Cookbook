format PE console

include 'win32ax.inc'
include 'chastelibw32.asm'

main:

mov eax,string0
call putstring

;get command line argument string
call [GetCommandLineA]
call putstr_and_line

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

string0 db 'Hello World!',0x0D,0x0A,0
