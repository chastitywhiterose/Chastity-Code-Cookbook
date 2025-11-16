format ELF executable
entry main

include 'chastelib32.asm'
include 'ansi.asm'

main: ; the main function of our assembly function, just as if I were writing C.

mov [radix],16 ; Choose radix 10 for integer output!
mov [int_width],8

mov eax, ansi_new
call putstring

call read_key

mov eax,msg
call putstring

mov eax, [key]
call putint

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

; this is where I keep my string variables

msg db 'Hello World!', 0Ah,0     ; assign msg variable with your message string

;read one byte from stdin
;named read_key do signal that is is for keyboard input rather than a file
read_key:

mov edx,1     ;number of bytes to read
mov ecx,key   ;address to store the bytes
mov ebx,0     ;move the opened file descriptor into EBX
mov eax,3     ;invoke SYS_READ (kernel opcode 3)
int 80h       ;call the kernel

ret

key dd 0
