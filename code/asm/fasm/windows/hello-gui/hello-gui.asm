; example of simplified Windows programming using complex macro features
format PE console
;format PE GUI 4.0
include 'win32ax.inc' ; you can simply switch between win32ax, win32wx, win64ax and win64wx here
.code
start:
invoke  WriteConsole, <invoke GetStdHandle,STD_OUTPUT_HANDLE>,"Hello World!",12,0
invoke  MessageBox,HWND_DESKTOP,"Hi! I'm the example program!","Hello!",MB_OK
invoke  ExitProcess,0
.end start
