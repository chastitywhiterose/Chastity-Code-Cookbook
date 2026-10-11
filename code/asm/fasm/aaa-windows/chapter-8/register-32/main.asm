format PE console
entry main

include 'win32a.inc'        ;includes standard Windows 32-bit definitions and macros
include 'chastelib-w32.asm' ;include standard functions by Chastity'
include 'chastelib-w32-debug.asm'

main:

mov dword[radix],16       ;I can choose the radix for integer output!
mov dword[int_width],8    ;and the width of each integer for padded zeros

mov eax,0
mov ebx,1
mov ecx,2
mov edx,3
mov edi,4
mov esi,5
mov ebp,6

call debug_registers

push 0             ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

;FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
