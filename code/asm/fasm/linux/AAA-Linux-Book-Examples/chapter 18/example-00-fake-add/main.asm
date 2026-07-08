format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov edi,1987
mov esi,39

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

fake_add:
mov eax,edi
xor edi,esi
and esi,eax
shl esi,1
jnz fake_add

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'
