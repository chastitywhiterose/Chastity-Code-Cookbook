format PE64 console
entry main

include 'win64a.inc'        ;includes standard Windows 64-bit definitions and macros
include 'chastelib-w64.asm' ;include standard functions by Chastity
include 'chastelib-w64-debug.asm'

main:

mov qword[radix],16       ;I can choose the radix for integer output!
mov qword[int_width],16    ;and the width of each integer for padded zeros

mov rax,0
mov rbx,1
mov rcx,2
mov rdx,3
mov rdi,4
mov rsi,5
mov rbp,6

mov r8,8
mov r9,9
mov r10,10
mov r11,11
mov r12,12
mov r13,13
mov r14,14
mov r15,15

call debug_registers

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

;FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
