org 100h

mov ah,2
mov dl,20h
start_of_loop:
int 21h
add dl,1
cmp dl,7Fh
jne start_of_loop

mov ah,0
int 21h
