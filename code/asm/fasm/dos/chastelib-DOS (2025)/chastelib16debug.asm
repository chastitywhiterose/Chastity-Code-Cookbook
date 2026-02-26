;chastelib16debug.asm

registers db 'ax ',0,'bx ',0,'cx ',0,'dx ',0,'si ',0,'di ',0,'bp ',0,'sp ',0

chaste_debug:

pusha

push ax

mov ax,registers
call putstring
pop ax
call putint

mov ax,registers+4
call putstring
mov ax,bx
call putint

mov ax,registers+8
call putstring
mov ax,cx
call putint

mov ax,registers+12
call putstring
mov ax,dx
call putint

mov ax,registers+16
call putstring
mov ax,si
call putint

mov ax,registers+20
call putstring
mov ax,di
call putint

mov ax,registers+24
call putstring
mov ax,bp
call putint

mov ax,registers+28
call putstring
mov ax,sp
call putint

popa

ret