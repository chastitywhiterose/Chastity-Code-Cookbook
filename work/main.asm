format ELF executable
entry main
include 'chastelib32.asm'
main:

mov [radix],16         ;can choose radix for integer output!
mov [int_width],1
mov [int_newline],0

mov eax,main_string
call putstring
mov     eax, 2         ; invoke SYS_FORK (kernel opcode 2)
int     80h
cmp     eax, 0         ; if eax is zero we are in the child process
jz      child          ; jump if eax is zero to child label
parent:
mov     eax, program0_msg ; inside our parent process move parentMsg into eax
call putstring
jmp loop_read_keyboard

child:

mov eax,program1_msg       ; inside our child process move childMsg into eax
call putstring


;execute a command from the child process
    mov     edx, environment    ; address of environment variables
    mov     ecx, arguments      ; address of the arguments to pass to the commandline
    mov     ebx, command        ; address of the file to execute
    mov     eax, 11             ; invoke SYS_EXECVE (kernel opcode 11)
    int     80h

;this is the game loop where were get input and process it accordingly
loop_read_keyboard:    ;this loop keeps reading from the keyboard

mov eax,ansi_clear ;move to top left of screen
call putstring

mov eax,ansi_home ;move to top left of screen
call putstring

;mov eax,RAM
;call putstring

call RAM_hexdump


call getchar           ;call my function that reads a single byte from the keyboard
call putspace
call putint            ;print the number of this key
call putline           ;print a line to make it easier to read

cmp al,'q'             ;test for q key. q stands for quit in this context
jnz loop_read_keyboard

main_end:
mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

main_string db 'Linux Unbuffered Input Template Program',0Ah,0

program0_msg db 'Parent processed forked',0Ah,0
program1_msg db 'Disabling line buffer with stty',0Ah,0


;The execve call requires the path to a program, arguments passed to that program, and environment variables if relevant
;these strings are the execve call data
command         db      '/bin/stty', 0h     ; command to execute
arg1            db      'cbreak', 0h
arguments       dd      command
                dd      arg1                ; arguments to pass to commandline (in this case just one)
                dd      0h                  ; end the struct
environment     dd      0h                  ; arguments to pass as environment variables (inthis case none) end the struct



;key is defined as dword even though only a byte is used
;this way, it loads into eax without trouble
key db 0

prefix_k db "k=",0

getchar:
push ebx
push ecx
push edx
mov edx,1     ;number of bytes to read
mov ecx,key   ;address to store the bytes
mov ebx,0     ;read from stdin
mov eax,3     ;invoke SYS_READ (kernel opcode 3)
int 80h       ;call the kernel
xor eax,eax   ;set eax to 0
mov al,[key]  ;set lowest part of eax to key read
push edx
push ecx
push ebx
ret

;this part is important!
;for maximum speed I embedded the ANSI sequence strings directly into the program
;Writing dynamic functions by hand was extremely error prone and still required loading the right
;registers with the arguments to the function. Therefore, unlike with the C programming language, the strings
;should be included directly. Every location is meant to be hard coded anyway

ansi_clear: db 0x1b,'[2J',0 ;erase entire screen
ansi_home: db 0x1b,'[H',0 ;move cursor to top left (Home)

RAM db 0x100 dup '?',0
RAM_address dd 0
RAM_x_select dd 0
RAM_y_select dd 0


RAM_hexdump:

mov ebx,RAM
mov ebp,[RAM_address]

mov ecx,0
mov edx,0

RAM_dump_loop:
mov eax,ebp
mov [int_width],8
call putint
call putspace
mov [int_width],2
dump_byte_row:
mov eax,0
mov al,[ebx]
call putint
call putspace
inc ebx
inc ecx
cmp ecx,16;
jnz dump_byte_row
call putline
;add ebp,0x10
inc edx
cmp edx,2
jnz RAM_dump_loop

ret
