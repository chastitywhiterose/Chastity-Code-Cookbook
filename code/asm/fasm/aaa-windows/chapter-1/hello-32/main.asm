format PE console
include 'win32ax.inc'

main:

mov eax,main_string
call putstring

push 0
call [ExitProcess]

.end main

main_string db 'Hello World!',0x0D,0x0A,0

putstring:              ;print string pointed to by eax register

push eax
push ebx

mov ebx,eax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

;Write string using Win32 WriteFile system call.
push 0              ;Optional Overlapped Structure 
push 0              ;Optionally Store Number of Bytes Written
push ebx            ;Number of bytes to write
push eax            ;address of string to print
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [WriteFile]    ;all the data is in place, do the write thing!

pop ebx
pop eax

ret ;this is the end of the putstring function return to calling location
