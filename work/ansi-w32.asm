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

ansi_string db 32 dup 0 ;string storage for buildable ansi sequence.

move_cursor:

mov [radix],10
mov [int_width],1

mov edi,ansi_string
mov [edi],byte 0x1B ;all escape sequences start with the escape character.
inc edi

mov [edi],byte '['
inc edi

mov eax,[y]
inc eax
call intstr ; get the string for y

mov esi,eax ; set source index to the new integer string
call strcpy

mov [edi],byte ';'
inc edi

mov eax,[x]
inc eax
call intstr ; get the string for x

mov esi,eax ; set source index to the new integer string
call strcpy


mov [edi],byte 'H' ;finish the escape code for setting cursor position
inc edi
mov [edi],byte 0 ;terminate the string with zero

mov eax,ansi_string+1
call putstring

mov eax,ansi_string
call putstring

ret

;copies bytes from address edi to esi until a zero is found
;This is not optimized for speed because it doesn't use the special x86 instructions for that purpose.
;However, it is easily portable to any CPU I might write assembly for, if I choose which registers to use for that purpose.
;However, since this is an x86 function, I use edi(destination index) and esi(source index) in their traditional contexts

strcpy:

;jmp strcpy_end

mov al,[esi]
cmp al,0
jz strcpy_end
mov [edi],al
inc edi
inc esi
jmp strcpy

strcpy_end:
ret









;This function reads one byte from stdin
;It is named read_key to signal that is is for keyboard input rather than a file

;BUT, and this is very important, this will not do what I desire of reading a single character
;unless I first run the command "stty cbreak" to set the terminal to break on a character rather than a line
;by default, it waits until enter is pressed to process any input. For this reason, the command is part of the makefile I use when assembling this program.

;key is defined as dword even though only a byte is used
;this way, it loads into eax without trouble
key dd 0
keys_read dd ? ;how many bytes are read with ReadFile operation

prefix_k db "k=",0

read_key:

;read only 1 byte using Win32 ReadFile system call.
push 0           ;Optional Overlapped Structure 
push keys_read  ;Store Number of Bytes Read from this call
push 1           ;Number of bytes to read
push key     ;address to store bytes
push -10            ;STD_INPUT_HANDLE = Negative Ten
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [ReadFile]

ret
