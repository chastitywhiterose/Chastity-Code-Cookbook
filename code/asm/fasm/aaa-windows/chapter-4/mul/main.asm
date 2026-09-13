format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

mov rax,12
call putint
call putline
mov rbx,5
mul rbx
call putint
call putline
mov rbx,8
mov rdx,0
div rbx
call putint
call putline
mov rax,rdx
call putint
call putline

sub rsp,40
mov rcx,0
call [ExitProcess]

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
