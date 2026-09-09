format PE64 console
entry main

include 'win64a.inc' ;include Windows 64-bit macros

main:

mov rax,main_string
call putstring

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

main_string db 'Hello World',0x0D,0x0A,0

putstring:         ;print string pointed to by rax register

push rax
push rbx
push rcx
push rdx

mov rbx,rax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [rbx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc rbx
jmp putstring_strlen_start

putstring_strlen_end:
sub rbx,rax ;subtract start pointer from current pointer to get length of string

;Windows 64-bit WriteFile system call
sub rsp,40           ;align stack for Win64 API calls
mov qword [rsp+32],0 ;lpOverlapped = NULL
mov r9,0             ;lpNumberOfBytesWritten = NULL
mov r8,rbx           ;nNumberOfBytesToWrite = rbx
mov rdx,rax          ;lpBuffer = address of string to write
mov rcx, -11         ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle]  ;Get Standard Handle for -11
mov rcx,rax          ;hFile = rax (returned from GetStdHandle)
call [WriteFile]
add rsp,40           ;restore stack now that WinAPI calls are done

pop rdx
pop rcx
pop rbx
pop rax

ret

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'


