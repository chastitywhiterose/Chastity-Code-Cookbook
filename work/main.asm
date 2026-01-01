format ELF executable
entry main

include 'chastelib32.asm'
include 'ansi.asm'

main: ; the main function of our assembly function, just as if I were writing C.

mov [radix],16 ; Choose radix for integer output!
mov [int_width],8
mov [int_newline],0 ;disable automatic printing of newlines after putint

keyloop:

;first clear the screen
mov eax, ansi_clear
call putstring

;reset cursor to home AKA top left of screen
mov eax,ansi_home
call putstring

mov eax,prefix_k
call putstring
mov eax,[key]
call putint
call putline

mov eax,prefix_x
call putstring
mov eax,[x]
call putint
call putspace

mov eax,prefix_y
call putstring
mov eax,[y]
call putint
call putline

mov eax,msg
call putstring

cmp [showhelp],0
jz help_skip

print_help:
mov eax,help
call putstring

help_skip:


call read_key

cmp [key],0x68
jz toggle_help

cmp [key],0x41
jz key_up
cmp [key],0x42
jz key_down

cmp [key],0x44
jz key_left
cmp [key],0x43
jz key_right

jmp keyloop_end

;conditional blocks based on input
key_up:
dec [y]
jmp keyloop_end
key_down:
inc [y]
jmp keyloop_end

key_left:
dec [x]
jmp keyloop_end
key_right:
inc [x]
jmp keyloop_end

toggle_help:
xor [showhelp],1
jmp keyloop_end

keyloop_end:
cmp [key],'q' ;loop will go until q is pressed
jnz keyloop


main_end:
mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

; this is where I keep my string variables

msg db "Press q to quit, h for help", 0Ah,0     ; assign msg variable with your message string
help db "This program operates the terminal by using ANSI escape sequences.",0
showhelp dd 0



