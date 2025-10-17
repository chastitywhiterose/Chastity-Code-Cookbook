org 100h     ;DOS programs start at this address

mov word [radix],16 ; can choose radix for integer output!

mov ch,0     ;zero ch (upper half of cx)
mov cl,[80h] ;load length of the command string
cmp cx,0
jz ending

mov dx,81h   ;Point dx to the beginning of string

inc dx       ;go to next char
dec cx       ;but subtract 1 from count

;find the end of the string based on length
mov ax,dx
add ax,cx
;now we know where the string ends.
mov [arg_string_end],ax

call putint

mov bx,dx
filter:
cmp byte [bx],' '
jnz notspace ;jump if this character is not a space

mov byte [bx],0 ;if it was a space, change it to a zero

notspace:
inc bx
cmp bx,[arg_string_end] ;are we at the end of the arg string?
jnz filter ;if not at end, continue the filter

mov ax,dx
call putstring
call putstring

ending:
mov ax,4C00h ; Exit program
int 21h

arg_string_end dw 0

include 'chastelib16.asm'