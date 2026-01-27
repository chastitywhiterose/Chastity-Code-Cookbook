format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'

main:

mov [radix],16         ;can choose radix for integer output!
mov [int_width],1
mov [int_newline],0

mov eax,main_string
call putstring

call fix_stdin         ;call function to disable line buffering in console(see the source below in this file) 

loop_read_keyboard:    ;this loop keeps reading from the keyboard

call getchar           ;call my function that reads a single byte from the keyboard
call putint            ;print the number of this key
call putline           ;print a line to make it easier to read

cmp al,'q'             ;test for q key. q stands for quit in this context
jnz loop_read_keyboard

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

;A string to test if output works
main_string db 'This program reads from the keyboard until you press q.',0Ah,0

;this function disables line buffering in the terminal on windows
fix_stdin:
push 0x200          ; mode: ENABLE_VIRTUAL_TERMINAL_INPUT
push -10            ;STD_INPUT_HANDLE = Negative Ten
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [SetConsoleMode]
ret

keys_read dd 0
key db 0

;read only 1 byte using Win32 ReadFile system call.
getchar:
push 0              ;Optional Overlapped Structure 
push keys_read      ;Store Number of Bytes Read from this call
push 1              ;Number of bytes to read
push key            ;address to store bytes
push -10            ;STD_INPUT_HANDLE = Negative Ten
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [ReadFile]
xor eax,eax         ;set eax to 0
mov al,[key]        ;set lowest part of eax to key read
ret



