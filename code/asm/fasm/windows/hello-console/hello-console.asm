format PE console
include 'win32ax.inc'
.code
start:
invoke  WriteConsole, <invoke GetStdHandle,STD_OUTPUT_HANDLE>,"Hello World!",12,0
invoke  ExitProcess,0
.end start
