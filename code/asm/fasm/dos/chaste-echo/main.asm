org 100h

mov cx,0     ;zero cx
mov cl,[80h] ;load length of the command string

mov dx,81h   ;Point dx to the beginning of string

inc dx       ;go to next char
dec cx       ;but subtract 1 from count

mov ah,40h   ; call 40h (write)
mov bx,1     ; handle stdout
int 21h      ; call DOS to write the arg string

mov ax,4C00h ; Exit program
int 21h
