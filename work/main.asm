org 100h

main:


mov ax,msg
call put$tring

mov ax,main_string ;
call putstring

mov ax,15
call putint

mov ah,0   ; call function 0 (terminate program)
int 21h    ; call the DOS kernel


msg     db      'Hello, World!',0Dh,0Ah,'$'     ; assign msg variable with your message string
main_string db "This is Chastity's 16-bit Assembly Language counting program!",0Dh,0Ah,0

include 'chastelib16.asm'

; This 16 bit DOS Assembly source has been formatted for the FASM assembler.
; In order to run it, you will need the DOSBOX emulator or something similar.
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
;
; original source from: https://cable.ayra.ch/md/hello-world-in-dos

