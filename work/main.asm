;org 100h

main:

;mov ax,string0
;call putstring

jmp $

times 510-($-$$) db 0
dw 0xaa55

;include 'putstring-bios.asm' ; use %include if assembling with NASM instead of FASM.

string0 db 'chastelib test suite for Intel 16-bit Assembly on DOS',0xD,0xA,0

; This 16 bit DOS Assembly source has been formatted for the FASM assembler.
; It is assembled for the boot sector of a hard disk

; In order to run it, you will need the QEMU emulator or something similar.
; First, assemble it into a binary file. FASM will automatically add
; the .com extension because of the "org 100h" command.
;
;	fasm main.asm
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
