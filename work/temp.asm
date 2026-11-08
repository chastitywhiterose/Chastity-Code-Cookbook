org 0x7C00

main:

mov ax,string0
call putstring

jmp $

string0 db 'Hello World',0xD,0xA,0

%include 'putstring-bios.asm' ; use %%include if assembling with NASM instead of FASM.

;make this output into a valid boot 512 byte boot sector
db 510-($-$$) dup 0          ;same as -> times 510-($-$$) db 0
dw 0xAA55

;This 16 bit BIOS Assembly source has been formatted for the FASM assembler.
;It is assembled for the boot sector of a hard disk

;First, assemble it into a binary file. FASM will automatically add
;the .bin extension as the default
;
;	fasm main.asm

;In order to run it, you will need the QEMU emulator or something similar.
;Either of these commands works fine for QEMU:
;
;	qemu-system-i386 -drive file=main.bin,format=raw
;	qemu-system-x86_64 -drive file=main.bin,format=raw
;
;If everything was done correctly, you will see something like:
;
;	Booting from Hard Disk...
;	Hello World
;
;If you see this, it means that the putstring function I wrote for the BIOS is working correctly.
