format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov edi,6
mov esi,7

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

fake_mul:
mov eax,0
fake_mul_add_loop:
cmp esi,0
jz fake_mul_add_loop_end
test esi,1
jz skip_add
add eax,edi
skip_add:
shl edi,1
shr esi,1
jmp fake_mul_add_loop
fake_mul_add_loop_end:
mov edi,eax

mov eax,edi
call putint
call putline

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'