org 0x7C00

main:
mov ax,string0
call putstring
mov word[radix],16    ;choose radix for integer output!
mov word[int_width],4 ;minimum width of digits

loop0:
mov ah,0 ;function 0 of next interrupt
int 0x16 ;interrupt for keyboard input
call putint

cmp al,0x20 ;check if al is in printable range
jb not_char ;if not then jump to not_char label
cmp al,0x7E 
ja not_char

call putspace
call putchar ;print the character if it is in the range 0x20 to 0x7E

not_char:    ;jump here if character is outside range to print

call putline
jmp loop0

string0 db 'BIOS Keyboard Input Program',0xD,0xA,0

include 'putstring-bios.asm'
include 'intstr.asm'
include 'putint.asm'
include 'putline.asm'
include 'putchar.asm'
include 'putspace.asm'

db 510-($-$$) dup 0 ;same as -> times 510-($-$$) db 0
dw 0xAA55 ;mark disk as boot sector
