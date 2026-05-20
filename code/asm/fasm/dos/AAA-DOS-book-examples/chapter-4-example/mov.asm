org 100h
main:

mov word [radix],10
mov word [int_width],1

mov ax,3
mov bx,5
add ax,bx

call putint

mov ax,4C00h
int 21h

%include 'chastelib16.asm'
