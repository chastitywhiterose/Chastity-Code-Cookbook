format ELF executable
entry main

include 'chastelib32.asm'
include 'ansi.asm'

main: ; the main function of our assembly function, just as if I were writing C.

mov [radix],16 ; Choose radix for integer output!
mov [int_width],8
mov [int_newline],0 ;disable automatic printing of newlines after putint

mov [memory_address],main

keyloop:

;first clear the screen
mov eax, ansi_clear
call putstring

;reset cursor to home AKA top left of screen
mov eax,ansi_home
call putstring

mov eax,[key]
call putint
call putline

;print the memory at current address
call print_memory_bytes_row

mov eax,msg
call putstring

call read_key

cmp [key],0x41
jz memory_prev_row
cmp [key],0x42
jz memory_next_row
jmp keyloop_end

;conditional blocks based on input
memory_prev_row:
sub [memory_address],0x10
jmp keyloop_end
memory_next_row:
add [memory_address],0x10
jmp keyloop_end

keyloop_end:
cmp [key],'q' ;loop will go until q is pressed
jnz keyloop



mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

; this is where I keep my string variables

msg db 'Press q to quit, h for help', 0Ah,0     ; assign msg variable with your message string

;read one byte from stdin
;named read_key do signal that is is for keyboard input rather than a file

;BUT, and this is very important, this will not do what I desire of reading a single character
;unless I first run the command "stty cbreak" to set the terminal to break on a character rather than a line
;by default, it waits until enter is pressed to process any input

;key is defined as dword even though only a byte is used
;this way, it loads into eax without trouble
key dd 0

read_key:

mov edx,1     ;number of bytes to read
mov ecx,key   ;address to store the bytes
mov ebx,0     ;read from stdin
mov eax,3     ;invoke SYS_READ (kernel opcode 3)
int 80h       ;call the kernel

ret


memory_address dd 0

;this function prints a row of hex bytes
;each row is 16 bytes
print_memory_bytes_row:
mov eax,[memory_address]
mov [int_width],8
call putint
call putspace

mov ebx,[memory_address]
mov ecx,0x10
next_byte:
mov eax,0
mov al,[ebx]
mov [int_width],2
call putint
call putspace

inc ebx
dec ecx
cmp ecx,0
jnz next_byte

call putline

ret


