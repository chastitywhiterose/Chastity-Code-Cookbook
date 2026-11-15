space db ' ',0 ;a string containing only a space

putspace:
push ax
mov ax,space
call putstring
pop ax
ret
