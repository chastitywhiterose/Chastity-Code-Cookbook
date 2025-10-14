org 100h

main:

mov ah,40h ; call function 40h write 
mov bx,1   ; file handle 1=stdout
mov cx,15  ; number of bytes to write
mov dx,msg ; address of bytes to write
int 21h    ; call the DOS kernel

ret        ; return from main function / end program

msg     db      'Hello, World!',0Dh,0Ah,'$'     ; assign msg variable with your message string

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
