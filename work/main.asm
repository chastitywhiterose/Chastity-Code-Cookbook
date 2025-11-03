format PE console
include 'win32ax.inc'

main:

;Write 13 bytes from a string to standard output
push 0              ;this must be zero. I have no idea why!  
push 13             ;number of bytes to write
push main_string    ;address of string to print
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [WriteConsole] ;all the data is in place, do the write thing!

call [WriteConsole]

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

main_string db 'Hello World!',0Ah
