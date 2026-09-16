format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

mov rcx,0

mov [array],byte 1

powers_of_two:

;this section prints the digits
mov rbx,[length]
array_print:
dec rbx
mov rax,0
mov al,[array+rbx]
call putint
cmp rbx,0
jnz array_print
call putline

;this section adds the digits
mov dl,0
mov rbx,0
array_add:
mov rax,0
mov al,[array+rbx]
add al,al
add al,dl
mov dl,0
cmp al,10
jb less_than_ten

sub al,10
mov dl,1

less_than_ten:
mov [array+rbx],al
inc rbx
cmp rbx,[length]
jnz array_add

cmp dl,0
jz carry_is_zero

mov [array+rbx],1
inc [length]

carry_is_zero:

;keeps track of how many times the loop has run
add rcx,1
cmp rcx,256
jna powers_of_two

sub rsp,40
mov rcx,0
call [ExitProcess]

length dq 1
array db 0x100 dup 0

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
