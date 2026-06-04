format ELF executable
main:

mov dword [radix],10
mov dword [int_width],1

mov eax,5
mov ebx,8
cmp eax,ebx
jb less
je same
ja more

less:
mov eax,string_less
jmp the_end
same:
mov eax,string_same
jmp the_end
more:
mov eax,string_more
jmp the_end

the_end:
call putstring

mov eax,1
mov ebx,0
int 80h

string_less db 'eax is less than ebx',0Ah,0
string_same db 'eax is the same as ebx',0Ah,0
string_more db 'eax is more than ebx',0Ah,0

include 'chastelib32.asm'