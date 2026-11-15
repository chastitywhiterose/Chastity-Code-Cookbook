;hybrid putstring example
;using one function with BIOS interrupt 0x10
;and another with Video RAM

org 0x7C00

main:

mov ax,string0
call putstring
call putstring

call putstring_vram
call putstring_vram

jmp $

string0 db 'Hello World',0xD,0xA,0

include 'putstring-bios.asm'
include 'putstring-vram.asm'

;make this output into a valid boot 512 byte boot sector
db 510-($-$$) dup 0          ;same as -> times 510-($-$$) db 0
dw 0xAA55
