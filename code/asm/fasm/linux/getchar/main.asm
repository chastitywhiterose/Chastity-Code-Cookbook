format ELF executable
entry main

include 'chastelib32.asm'

main:

mov eax,main_string
call putstring

mov [int_newline],0

mov eax,0
loop1:

mov [radix],2            ;set radix to binary
mov [int_width],8        ;width of 8 for maximum 8 bits
call putint
call putspace
mov [radix],16           ;set radix to hexadecimal
mov [int_width],2        ;width of 8 for maximum 8 bits
call putint
call putspace
mov [radix],10           ;set radix to decimal (what humans read)
mov [int_width],3        ;width of 8 for maximum 8 bits
call putint

cmp al,0x20
jb not_char
cmp al,0x7E
ja not_char

call putspace
call putchar

not_char:                ;jump here if character is outside range to print

call putline

call getchar

cmp eax,'q';
jnz loop1

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

;A string to test if output works
main_string db 'This program will read bytes one at a time until you press q',0Ah
db 'This tests keyboard input for creating new programs.',0Ah,0

key db 0,0

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
