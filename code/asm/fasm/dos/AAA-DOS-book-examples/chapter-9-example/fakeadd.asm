org 100h

main:

mov word [radix],10 ; choose radix for integer input/output
mov word [int_width],1

mov di,1987
mov si,38

mov ax,di
call putint
mov ax,si
call putint
call putline

fake_add:
mov ax,di
xor di,si
and si,ax
shl si,1
jnz fake_add

mov ax,di
call putint
mov ax,si
call putint

mov ax,4C00h
int 21h

include 'chastelib16.asm'
