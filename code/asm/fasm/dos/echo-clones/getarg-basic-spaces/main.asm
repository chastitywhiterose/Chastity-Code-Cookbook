org 100h     ;DOS programs start at this address

;this loop will get all the command line arguments and print them on a separate line

arg_loop:
call getarg
cmp ax,0 ;did the getarg function return 0?
jz arg_loop_end
call putstring
call putline
jmp arg_loop
arg_loop_end:

ending:
mov ax,4C00h ; Exit program
int 21h

include 'getarg.asm'
include 'chastelib16.asm'


;db 0x36 dup 0 ;add extra bytes to make it 512 bytes exactly
