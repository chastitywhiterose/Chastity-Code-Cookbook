org 100h

mov ah,2
mov dl,20h
loop_start:
int 21h
inc dl
cmp dl,7Fh
jne loop_start

mov ax,4C00h
int 21h
