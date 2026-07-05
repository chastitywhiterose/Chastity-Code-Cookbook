format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov eax,0
mov ebx,1

Fibonacci:
call putint
call putline
add eax,ebx
push eax
mov eax,ebx
pop ebx
cmp eax,1000
jb Fibonacci

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'
