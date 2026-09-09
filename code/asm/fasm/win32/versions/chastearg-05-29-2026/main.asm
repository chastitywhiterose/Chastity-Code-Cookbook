;chastearg Assembly source code for FASM
;This program prints all the arguments on a separate line
;Quoted strings count as one argument and will be on the same line.
format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'

main:

mov [radix],10 ; Choose radix for integer output.
mov [int_width],1

;get command line argument string
call [GetCommandLineA]

mov [arg_string_index],eax ;back up eax to restore later

call strlen ;get the length of the string

mov ebx,[arg_string_index] ;mov the address of the string start into ebx
add ebx,eax                ;add eax which contains the length
mov [arg_string_end],ebx   ;move end of string address to permanent location

;optionally display the arg string to make sure it is working correctly
;mov eax,[arg_string_index]
;call putstring
;call putline

;set ebx back to the start of the arg string for the filter loop
mov ebx,[arg_string_index]

;now ebx points to the first non space character in the arguments passed to the DOS program
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

cmp ebx,[arg_string_end] ;are we at the end of the arg string?
jz argument_filter_end       ;if yes, stop the filter and terminate with zero

cmp ch,1       ;are we inside a quoted string?
jz quote_check ;if yes, don't do anything to the spaces

cmp byte[ebx],cl ;compare the byte at address bx to the string terminator
jnz ignore_char ;if it is not the same, we ignore it
mov byte[ebx],0  ;but if it matches, change it to a zero
ignore_char:

cmp byte [ebx],0x22 ;is this a double quote -> "
jz start_quote
cmp byte [ebx],0x27 ;is this a single quote -> '
jz start_quote
jmp quote_no ;it was not a quote

start_quote:

mov ch,1    ;set ch to 1 to set that we are inside a quote now
mov cl,[ebx] ;save this quote type as the new terminator
mov byte[ebx],0 ;but delete the first quote with zero

;check for single or double quotes
quote_check:

cmp [ebx],cl ;is this character the same type of quote that started this sub string?
jnz quote_no ;if it is not, then skip to quote_no section

;but if it was matching, change this byte to zero
;and change cl back to a space
mov cl,' ' ;cl is now a space
mov ch,0   ;ch is 0 because now we have ended the quoted string
mov byte[ebx],0 ;delete the end quote with zero

quote_no:

inc ebx ;go to the next character
jmp argument_filter   ;jump back to the beginning of argument filter

argument_filter_end:
mov byte [ebx],0 ;terminate the ending with a zero for safety

;this loop is very safe because it only prints arguments if they are valid
;if the end of the args are reached by comparison of eax with [arg_end]
;then it will jump to args_none and proceed from there
args_list:
call get_next_arg
cmp eax,[arg_string_end]
jz args_none
call putstring
call putline
jmp args_list
args_none:

main_end: ;jump here to end the program

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

arg_string_index  dd 0 ;start of arg string
arg_string_end    dd 0 ;address of the end of the arg string

;function to move ahead to the next art
;only works after the filter has been applied to turn all spaces into zeroes
get_next_arg:
mov ebx,[arg_string_index]
find_zero:
cmp byte [ebx],0
jz found_zero
inc ebx
jmp find_zero ; this char is not zero, go to the next char
found_zero:

find_non_zero:
cmp ebx,[arg_string_end]
jz arg_finish ;if ebx is already at end, nothing left to find
cmp byte [ebx],0
jnz arg_finish ;if this char is not zero we have found the next string!
inc ebx
jmp find_non_zero ;otherwise, keep looking

arg_finish:
mov [arg_string_index],ebx ; save this index to variable
mov eax,ebx ;but also save it to ax register for use
ret
;we can know that there are no more arguments when
;the either [arg_start] or eax are equal to [arg_end]


;a function to get the length of string in eax and return the integer in eax

strlen:

mov ebx,eax ; copy eax to ebx. ebx will be used as index to the string

strlen_start: ; this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp strlen_start

strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

mov eax,ebx ;copy the string length back to eax

ret
