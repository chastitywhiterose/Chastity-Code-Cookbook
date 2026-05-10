org 100h     ;DOS programs start at this address

mov word [radix],16 ; can choose radix for integer output!

mov ch,0     ;zero ch (upper half of cx)
mov cl,[80h] ;load length of the command string
cmp cx,0
jz ending

;Point bx to the beginning of arg string
;however, this always contains a space
mov bx,81h

skip_start_spaces:
cmp byte [bx],' ' ;is this byte a space?
jnz skip_start_spaces_end ;if not, we are done skipping spaces
inc bx ;otherwise, go to next char
dec cx ;but subtract 1 from character count
jmp skip_start_spaces
skip_start_spaces_end:

mov [arg_string_start],bx ; save the location of the first non space in the arg string
mov [arg_string_index],bx ; save the location of the first non space in the arg string

;find the end of the string based on length
mov ax,bx
add ax,cx
mov [arg_string_end],ax ;now we know where the string ends.

;now bx points to the first non space character in the arguments passed to the DOS program
;cx contains the length
;and we know that [arg_string_end] is where it ends

arg_filter:
cmp byte [bx],' '
ja notspace ; if char is above space, leave it alone
mov byte [bx],0 ;otherwise it counts as a space, change it to a zero
notspace:
inc bx
cmp bx,[arg_string_end] ;are we at the end of the arg string?
jnz arg_filter ;if not at end, continue the filter

arg_filter_end:
mov byte [bx],0 ;terminate the ending with a zero for safety

;this loop will get all the command line arguments and print them on a separate line

arg_loop:
mov ax,[arg_string_index] ;get address of current argument
call putstring
call putline
call get_next_arg
cmp bx,[arg_string_end]
jz arg_loop_end
jmp arg_loop
arg_loop_end:

ending:
mov ax,4C00h ; Exit program
int 21h

arg_string_start dw 0
arg_string_end dw 0
arg_string_index dw 0

;function to move ahead to the next argument
;only works after the filter has been applied to turn all spaces into zeroes

get_next_arg:
mov bx,[arg_string_index] ;get address of current arg
find_zero:
cmp byte [bx],0
jz found_zero
inc bx
jmp find_zero ; this char is not zero, go to the next char
found_zero:

;once we have found a zero, check to make sure we are not at the end

find_non_zero:
cmp bx,[arg_string_end]
jz arg_finish ;if bx is already at end, nothing left to find
cmp byte [bx],0
jnz arg_finish ;if this char is not zero we have found the next string!
inc bx
jmp find_non_zero ;otherwise, keep looking

arg_finish:
mov [arg_string_index],bx ; save this index to the variable
mov ax,bx ;but also save it to ax register for use in printing or something else
ret

include 'chastelib16.asm'