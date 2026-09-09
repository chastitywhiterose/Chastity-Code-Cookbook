format PE console
entry main

include 'win32a.inc' ;include Windows 32-bit macros

main:

mov eax,main_string
call putstring


push 0             ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

main_string db 'Hello World',0x0D,0x0A,0

putstring:         ;print string pointed to by eax register

push eax
push ebx
push ecx
push edx

mov ebx,eax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

;Windows 32-bit WriteFile system call

push 0               ;lpOverlapped = NULL
push 0               ;lpNumberOfBytesWritten = NULL
push ebx             ;nNumberOfBytesToWrite = ebx
push eax             ;lpBuffer = address of string to write
push -11             ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle]  ;Get Standard Handle for -11
push eax             ;hFile = eax (returned from GetStdHandle)
call [WriteFile]


pop edx
pop ecx
pop ebx
pop eax

ret

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'

