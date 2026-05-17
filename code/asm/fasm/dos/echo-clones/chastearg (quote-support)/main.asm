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

mov [arg_string_index],bx ; save the location of the first non space char in the arg string

;find the end of the string based on length
mov ax,bx
add ax,cx
mov [arg_string_end],ax ;now we know where the string ends.

;now bx points to the first non space character in the arguments passed to the DOS program
;and we know that [arg_string_end] is where it ends

;the next step is to filter the arguments into separate zero terminated strings
;each space will be changed to a zero (normally)
;but we also need to account for spaces inside quotes that are considered part of the string
;Linux handles this normally but DOS needs me to write the code to mimic this behavior
;because the program needs to function identically for DOS or Linux

mov cl,' ' ;set the default filter character (argument terminator) to a space
mov ch,0   ;are we currently checking spaces 0 or quote characters 1 as terminators?

;this loop is the new and improved argument filter
;it keeps track of whether we are inside or outside a quote
;and also which type of quote started the quote
;the actual quote marks are not part of the string unless they
;are the opposite quote type than what started the string
;The important thing is that spaces can exist inside of quoted strings
;as one argument rather than each new word being a new argument
;could be important for filenames containing spaces, etc.

argument_filter:

cmp bx,[arg_string_end] ;are we at the end of the arg string?
jz argument_filter_end       ;if yes, stop the filter and terminate with zero

cmp ch,1       ;are we inside a quoted string?
jz quote_check ;if yes, don't do anything to the spaces

cmp byte[bx],cl ;compare the byte at address bx to the string terminator
jnz ignore_char ;if it is not the same, we ignore it
mov byte[bx],0  ;but if it matches, change it to a zero
ignore_char:

cmp byte [bx],0x22 ;is this a double quote -> "
jz start_quote
cmp byte [bx],0x27 ;is this a single quote -> '
jz start_quote
jmp quote_no ;it was not a quote

start_quote:

mov ch,1    ;set ch to 1 to set that we are inside a quote now
mov cl,[bx] ;save this quote type as the new terminator
mov byte[bx],0 ;but delete the first quote with zero

;check for single or double quotes
quote_check:

cmp [bx],cl ;is this character the same type of quote that started this sub string?
jnz quote_no ;if it is not, then skip to quote_no section

;but if it was matching, change this byte to zero
;and change cl back to a space
mov cl,' ' ;cl is now a space
mov ch,0   ;ch is 0 because now we have ended the quoted string
mov byte[bx],0 ;delete the end quote with zero

quote_no:

inc bx ;go to the next character
jmp argument_filter   ;jump back to the beginning of argument filter

argument_filter_end:
mov byte [bx],0 ;terminate the ending with a zero for safety

;special case!!!
;If the first argument passed began with a quoted string
;it would have been changed to a 0 instead. This requires us to add one to the
;starting argument string index
mov bx,[arg_string_index]
cmp byte[bx],0
jnz first_argument_was_not_quote
inc word[arg_string_index] ;add 1 so it points to the next byte before we process arguments
first_argument_was_not_quote:

;this loop will get all the command line arguments and print them on a separate line

arg_loop:
mov ax,[arg_string_index] ;get address of current argument
call putstring
call putline
call get_next_arg
cmp ax,[arg_string_end]
jz arg_loop_end
jmp arg_loop
arg_loop_end:

ending:
mov ax,4C00h ; Exit program
int 21h

arg_string_index dw 0
arg_string_end dw 0

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

db 0x33 dup 0 ;add extra bytes to make it 512 bytes exactly
