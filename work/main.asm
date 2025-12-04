org 100h

main:

mov word [radix],10 ; choose radix for integer input/output
mov word [int_width],1

mov di,14
mov si,3

mov ax,di
call putint
mov ax,si
call putint
call putline

;add si,di

fake_add:
mov ax,di
xor di,si
and ax,si
cmp ax,0


mov ax,di
call putint
mov ax,si
call putint


mov ax,4C00h
int 21h

include 'chastelib16.asm'
