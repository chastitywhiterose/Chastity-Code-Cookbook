format ELF executable
entry main
include 'chastelib32.asm'
include 'hexplore-ansi.asm'

main:

mov [radix],16         ;can choose radix for integer output!
mov [int_width],1
mov [int_newline],0

mov     eax, 2         ; invoke SYS_FORK (kernel opcode 2)
int     80h
cmp     eax, 0         ; if eax is zero we are in the child process
jz      child          ; jump if eax is zero to child label

parent:

;this is the game loop where were get input and process it accordingly
loop_read_keyboard:    ;this loop keeps reading from the keyboard

mov eax,ansi_clear ;move to top left of screen
call putstring

mov eax,ansi_home ;move to top left of screen
call putstring

call RAM_hexdump

;this section provides a visual way of knowing which byte is selected

mov eax,[RAM_y_select] ;which row is it on? Y vertical coordinate
mov [y],eax

mov eax,[RAM_x_select] ;which row is it on? Y vertical coordinate
mov ebx,3 ;we will multiply by 3 on the next line
mul ebx
add eax,8
mov [x],eax

call move_cursor
mov al,'['
call putchar
add [x],3
call move_cursor
mov al,']'
call putchar
;end of brackets section


;where to move cursor in next function call
mov [x],1
mov [y],17

call move_cursor ;move the cursor before displaying debug information


mov eax,0              ;zero eax to receive the key value in al
mov al,[key];          ;move the key pressed last time into al
call putint            ;print the number of this key
call putspace          ;print a space to keep it readable
call putchar           ;print the character in al register
call putline           ;print a line to make it easier to read

;will pause until a key is pressed
call getchar           ;call my function that reads a single byte from the keyboard

cmp al,'q'             ;test for q key. q stands for quit in this context
jz main_end            ;jump to end of program if q was pressed
call hexplore_input    ;call the function to process the input and operate the editor
jmp loop_read_keyboard ;continue the game loop

main_end:
mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

; This is the end of the parent process or main program
; The child process below only uses the stty command before returning to the parent proces

child:

;This child process disables line buffer with stty

;execute a command from the child process
    mov     edx, environment    ; address of environment variables
    mov     ecx, arguments      ; address of the arguments to pass to the commandline
    mov     ebx, command        ; address of the file to execute
    mov     eax, 11             ; invoke SYS_EXECVE (kernel opcode 11)
    int     80h

;this is the end of the child process which became the stty command and then terminated naturally

byte_brackets db '[  ]',0 ;for displaying brackets around selected byte



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
key db 0,0

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
pop edx
pop ecx
pop ebx
ret

RAM db 0x100 dup '?',0
RAM_address dd 0
RAM_x_select dd 0
RAM_y_select dd 0

RAM_hexdump:

mov ebx,RAM
mov ebp,[RAM_address]

mov edx,0 ;the Y value for this loop
RAM_dump_loop:
mov ecx,0 ;the X value for this loop
mov eax,ebp
mov [int_width],8
call putint
call putspace
mov [int_width],2
mov eax,0
dump_byte_row:
mov al,[ebx]

normal_print:
call putint
call putspace
normal_print_skip:

inc ebx
inc ecx
cmp ecx,0x10;
jnz dump_byte_row

;optionally, print chars after hex bytes
call RAM_hexdump_text_row

call putline
add ebp,0x10
inc edx
cmp edx,0x10
jnz RAM_dump_loop

ret



RAM_hexdump_text_row:
push eax
push ebx
push ecx
push edx
sub ebx,0x10
mov ecx,0
mov eax,0
next_char:
mov al,[ebx]

;if char is below '0' or above '9', it is outside the range of these and is not a digit
cmp al,0x20
jb not_printable
cmp al,0x7E
ja not_printable

printable:
;if char is in printable range,leave as is and proceed to next index
jmp next_index

not_printable:
mov al,'.' ;otherwise replace with placeholder value

next_index:
call putchar
inc ebx
inc ecx
cmp ecx,0x10
jnz next_char

pop edx
pop ecx
pop ebx
pop eax

ret
