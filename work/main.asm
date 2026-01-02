format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'
include 'ansi-w32.asm'

main:

keyloop:

mov [radix],16 ; Choose radix for integer output!
mov [int_width],8
mov [int_newline],0 ;disable automatic printing of newlines after putint

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
call putline

help_skip:

;move the cursor with the function I wrote in ansi.asm
call move_cursor


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

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

;A string to test if output works
main_string db 'Hello World!',0Ah,0
;test string of integer for input
test_int db '10011101001110011110011',0

; string variables to display useful information

msg db "Press q to quit, h for help", 0Ah,0     ; assign msg variable with your message string
help db "This program operates the terminal by using ANSI escape sequences. "
     db "The arrow keys move the cursor around the terminal. "
     db "That is all there is for now, but it is possible that with more code, this could make a small game."
     db "But don't forget, this program only works if the Linux command `stty cbreak` is run first."
     db 0xA,"This turns off line buffering so that each key operates immediately."
     db 0xA,"You can turn this help message on or off with the h key again.",0
showhelp dd 0
