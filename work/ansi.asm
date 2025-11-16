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