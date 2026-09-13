format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

mov rax,5
mov rbx,8
cmp rax,rbx
jb less
je same
ja more

less:
mov rax,string_less
jmp the_end
same:
mov rax,string_same
jmp the_end
more:
mov rax,string_more
jmp the_end

the_end:
call putstring

sub rsp,40
mov rcx,0
call [ExitProcess]

string_less db 'rax is less than rbx',0Dh,0Ah,0
string_same db 'rax is the same as rbx',0Dh,0Ah,0
string_more db 'rax is more than rbx',0Dh,0Ah,0

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
