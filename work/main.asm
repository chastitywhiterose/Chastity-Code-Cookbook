format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'

main:

mov eax,main_string
call putstring

fix_stdin:
push 0 ; mode zero, no console mode selected
push -10            ;STD_INPUT_HANDLE = Negative Ten
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [SetConsoleMode]


getchar:
;read only 1 byte using Win32 ReadFile system call.
push 0           ;Optional Overlapped Structure 
push keys_read  ;Store Number of Bytes Read from this call
push 1           ;Number of bytes to read
push key       ;address to store bytes

;push [filedesc1] ;handle of the open file

push -10            ;STD_INPUT_HANDLE = Negative Ten
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function

call [ReadFile]

mov [radix],16 ; can choose radix for integer output!
mov [int_width],1
mov [int_newline],0

mov eax,input_string_int ;address of input string to convert to integer
call strint              ;call strint to return the string in eax register

mov ebx,eax              ;ebx=eax

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

inc eax
cmp eax,ebx;
jnz loop1

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

;A string to test if output works
main_string db 'This program is the official test suite for the Windows Assembly version of chastelib.',0Ah,0
;test string of integer for input
input_string_int db '10',0

keys_read dd 0
key db 0

