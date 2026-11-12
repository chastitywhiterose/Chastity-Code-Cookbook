org 0x7C00

main:
mov ax,string0
call putstring
mov word[radix],16    ;choose radix for integer output!
mov word[int_width],4 ;minimum width of digits
mov ax,0
mov bx,0x18
loop0:
call putline
call putint
inc ax
cmp ax,bx
jnz loop0
jmp $

string0 db 'BIOS Assembly Counting Program',0
%include 'putstring-bios.asm'
%include 'intstr.asm'
%include 'putint.asm'
%include 'putline.asm'

db 510-($-$$) dup 0 ;same as -> times 510-($-$$) db 0
dw 0xAA55 ;mark disk as boot sector
