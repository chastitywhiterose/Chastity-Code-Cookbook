org 100h
main:

mov word [radix],10
mov word [int_width],1

mov ax,5
mov bx,8
cmp ax,bx
jb less
je same
ja more

less:
mov ax,string_less
jmp end
same:
mov ax,string_same
jmp end
more:
mov ax,string_more
jmp end

end:
call putstring

mov ax,4C00h
int 21h

string_less db 'ax is less than bx',0
string_same db 'ax is the same as bx',0
string_more db 'ax is more than bx',0

%include 'chastelib16.asm'
