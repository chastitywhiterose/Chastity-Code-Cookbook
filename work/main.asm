org 100h     ;DOS programs start at this address

mov word [radix],16 ; can choose radix for integer output!

mov ch,0     ;zero ch (upper half of cx)
mov cl,[80h] ;load length of the command string
cmp cx,0
jz ending

mov dx,81h   ;Point dx to the beginning of string
inc dx       ;go to next char
dec cx       ;but subtract 1 from count
mov [arg_index],dx ;save index to variable so dx is free to change as needed

;find the end of the string based on length
mov ax,dx
add ax,cx
;now we know where the string ends.
mov [arg_string_end],ax ;this is the end of the arg string. important for later
;call putint ; print address where entire arg string ends

;this routine replaces all non printable characters with zero in the arg string
mov bx,dx
filter:
cmp byte [bx],' '
ja notspace ; if char is above space, leave it alone
mov byte [bx],0 ;otherwise it counts as a space, change it to a zero
notspace:
inc bx
cmp bx,[arg_string_end] ;are we at the end of the arg string?
jnz filter ;if not at end, continue the filter

filter_end:
mov byte [bx],0 ;terminate the ending with a zero for safety

arg_loop:
mov ax,dx ;get address of current arg
call putstring
call putline
call get_next_arg
;mov ax,dx ;load address of string
;call putint ;and print it for debugging
cmp dx,[arg_string_end]
jz arg_loop_end
jmp arg_loop
arg_loop_end:

ending:
mov ax,4C00h ; Exit program
int 21h

arg_string_end dw 0
arg_index dw 0

;function to move ahead to the next art
;only works after the filter has been applied to turn all spaces into zeroes

get_next_arg:
mov bx,dx ;dx has address of current arg
find_zero:
cmp byte [bx],0
jz found_zero
inc bx
jmp find_zero ; this char is not zero, go to the next char
found_zero:

find_non_zero:
cmp bx,[arg_string_end]
jz arg_finish ;if bx is already at end, nothing left to find
cmp byte [bx],0
jnz arg_finish ;if this char is not zero we have found the next string!
inc bx
jmp find_non_zero ;otherwise, keep looking

arg_finish:
mov dx,bx ; mov dx to new string
ret



include 'chastelib16.asm'