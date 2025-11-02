format PE console
include 'win32ax.inc'
.code
db 10h dup 90h
start:
invoke  WriteConsole, <invoke GetStdHandle,STD_OUTPUT_HANDLE>,"Hello World!",12,0
invoke  ExitProcess,0
.end start
db 10h dup 90h
