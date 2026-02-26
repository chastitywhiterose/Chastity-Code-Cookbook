org 100h

main:

mov ax,main_string
call putstring

mov word [radix],2 ; can choose radix for integer output!
mov word [int_width],8

mov ax,test_int
call strint

mov word [radix],16 ; can choose radix for integer output!

call putint

mov ax,0
loop1:
mov word [stdout],1
call putint
inc ax

cmp ax,10h;
jnz loop1

;call chaste_debug

mov ax,4C00h
int 21h

main_string db "This is Chastity's 16-bit Assembly Language counting program!",0Dh,0Ah,0

; test string of integer for input
test_int db '11111000011',0

include 'chastelib16.asm'
;include 'chastelib16debug.asm'

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

