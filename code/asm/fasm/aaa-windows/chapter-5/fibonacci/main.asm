format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

mov rax,0
mov rbx,1

Fibonacci:
call putint
call putline
add rax,rbx
push rax
mov rax,rbx
pop rbx
cmp rax,1000
jb Fibonacci

sub rsp,40
mov rcx,0
call [ExitProcess]

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
