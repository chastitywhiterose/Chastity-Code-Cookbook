format PE console
include 'win32ax.inc'
;
main:
db 10h dup 90h
push 0              ;this must be zero. I have no idea why!  
push 13             ;number of bytes to write
push main_string    ;address of string to print
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle]
push eax
call [WriteConsole]
db 10h dup 90h


;Exit the process with code 0
 push 0
 call [ExitProcess]


.end main

main_string db 'Hello World!',0Ah,0

;invoke  WriteConsole, <invoke GetStdHandle,STD_OUTPUT_HANDLE>,"Hello World!",12,0
