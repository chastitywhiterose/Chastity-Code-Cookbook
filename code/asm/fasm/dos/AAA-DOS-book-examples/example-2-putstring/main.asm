org 100h

main:

mov ax,text
call putstring

mov ax,4C00h
int 21h

text db 'Hello World!',0Dh,0Ah,0

; This section is for the putstring function I wrote.
; It will print any zero terminated string that register ax points to

stdout dw 1 ; value of standard output

putstring:

mov bx,ax ; copy ax to bx as well. Now both registers have the address of the main_string

putstring_strlen_start: ; this loop finds the length of the string as part of the putstring function

cmp [bx], byte 0 ; compare this byte byte at address with 0
jz putstring_strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc bx
jmp putstring_strlen_start

putstring_strlen_end:

sub bx,ax ; sub ax from bx to get the difference for number of bytes
mov cx,bx ; mov bx to cx
mov dx,ax  ; dx will have address of string to write

mov ah,40h ; select DOS function 40h write 
mov bx,[stdout]   ; file handle 1=stdout
int 21h    ; call the DOS kernel

ret ; return to calling location
