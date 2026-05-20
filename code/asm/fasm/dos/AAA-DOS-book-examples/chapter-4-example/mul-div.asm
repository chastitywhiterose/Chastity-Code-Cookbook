org 100h
main:

mov word [radix],10
mov word [int_width],1

mov ax,12
call putint
mov bx,5
mul bx
call putint
mov bx,8
mov dx,0
div bx
call putint
mov ax,dx
call putint

mov ax,4C00h
int 21h

%include 'chastelib16.asm'
