org 100h

main:

mov word [radix],10 ; choose radix for integer input/output
mov word [int_width],1

mov di,2025
mov si,38

mov ax,di
call putint
mov ax,si
call putint
call putline

fake_sub:
xor di,si
and si,di
shl si,1
jnz fake_sub

mov ax,di
call putint
mov ax,si
call putint

mov ax,4C00h
int 21h

include 'chastelib16.asm'
