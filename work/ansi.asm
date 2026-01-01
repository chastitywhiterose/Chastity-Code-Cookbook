;this file is dedicated to using ANSI escape codes in Assembly programs.
;Using special strings of text, it is possible to reposition the cursor in Linux terminal programs
;Below are some links where I learned about ANSI escape sequences;

;https://notes.burke.libbey.me/ansi-escape-codes/
;https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

;There will be mostly example strings defined in here. The idea is for reminding myself how these things work.

;changing colors
ansi_red: db 0x1b,'[1;31m',0
ansi_green: db 0x1b,'[1;32m',0
ansi_yellow: db 0x1b,'[1;33m',0
ansi_blue: db 0x1b,'[1;34m',0
ansi_magenta: db 0x1b,'[1;35m',0
ansi_cyan: db 0x1b,'[1;36m',0
ansi_white: db 0x1b,'[1;37m',0

ansi_home: db 0x1b,'[H',0 ;move cursor to top left (Home)


;ansi_move8x8: db 0x1b,'[8;8H',0 ;move cursor to absolute position 8,8


ansi_clear: db 0x1b,'[2J',0 ;erase entire screen

ansi_new: db 0x1b,'[1;33m',0 ;erase entire screen

;Global variables for x and y geometric positions on the screen
;These may be used in special escape sequences to reposition the cursor.

x dd 0
y dd 0

prefix_x db "x=",0
prefix_y db "y=",0



















;This function reads one byte from stdin
;It is named read_key to signal that is is for keyboard input rather than a file

;BUT, and this is very important, this will not do what I desire of reading a single character
;unless I first run the command "stty cbreak" to set the terminal to break on a character rather than a line
;by default, it waits until enter is pressed to process any input. For this reason, the command is part of the makefile I use when assembling this program.

;key is defined as dword even though only a byte is used
;this way, it loads into eax without trouble
key dd 0

prefix_k db "k=",0

read_key:

mov edx,1     ;number of bytes to read
mov ecx,key   ;address to store the bytes
mov ebx,0     ;read from stdin
mov eax,3     ;invoke SYS_READ (kernel opcode 3)
int 80h       ;call the kernel

ret
