org 0x7C00

main:

mov ax,string0
call putstring

jmp $

%include 'putstring-bios.asm' ; use %%include if assembling with NASM instead of FASM.

string0 db 'chastelib test suite for Intel 16-bit Assembly on BIOS',0xD,0xA,0

;make this output into a valid boot 512 byte boot sector
times 510-($-$$) db 0
dw 0xAA55

;This 16 bit DOS Assembly source has been formatted for the FASM assembler.
;It is assembled for the boot sector of a hard disk


;First, assemble it into a binary file. FASM will automatically add
;the .bin extension as the default
;
;	fasm main.asm

;In order to run it, you will need the QEMU emulator or something similar.
;This command works fine for QEMU:
;
;	qemu-system-i386 -drive file=main.bin,format=raw
;
; Then you will need to open DOSBOX and mount the folder that it is in.
; For example:
;
;	mount c ~/.dos
;	c:
;
;	Then, you will be able to just run the main.com.
;
;	main
