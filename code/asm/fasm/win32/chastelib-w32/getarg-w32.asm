;The getarg function was something I badly needed in order to make my assembly code for DOS easier to read.
;It will automatically process the command line arguments if they are available.
;
;The first time it is run, it returns the whole command string or zero if no args are given
;DOS does not allow the program name to be part of the arguments
;
;Each time after that, it will give you the next argument which is a subtring of the original.
;When no more arguments are available, it will always return zero
;The program calling this is expected to check for this error and then terminate
;or print a message depending on the goals of that program

;A word of warning though, this function has multiple return statements and is long
;However, it is fully featured in that it can recognize quoted strings as being the same argument
;This brings full compatibility between my DOS and Linux programs which expect consistent behavior

getarg:

mov ebx,[arguments_start] ;get the address of start of arguments
cmp ebx,0 ;is this address zero? (meaning this function was not called before)
jz get_arg_data ;if it was zero, then get the argument data for the first execution of this function

;if the start was not zero, then clearly arguments exist and addresses have been saved
cmp ebx,[arguments_end]  ;is the address of the start and end the same?
jnz find_next_string  ;if they are not the same, find the next sub string
mov eax,0 ;otherwise, return eax as zero and check this in the main program

ret

find_next_string:

mov ebx,[arguments_start] ;get address of current arg

skip_spaces:

cmp byte[ebx],' ' ;is this byte a space?
jnz skip_spaces_end ;if it is not a space, we can end this loop
inc ebx ;otherwise, go to next byte
jmp skip_spaces ;and keep looping till we find non-space
skip_spaces_end:
mov eax,ebx ;copy this non-space address to eax register

;we have found a non-space which is the start of a printable string
;but we still have to find the next space and terminate it with a zero!

;however, there is a special case where we want a string to contain spaces. In this case, I have another routine!

;check for quoted strings
cmp byte[ebx],0x22 ;is this a double quote -> "
jz scan_quoted_string
cmp byte[ebx],0x27 ;is this a single quote -> '
jz scan_quoted_string

find_space:
cmp byte [ebx],' ' ;is this a space?
jz found_space ;if this was a space, end the loop and terminate with zero

;we must also check to see if we have reached the terminating zero of the arguments string
cmp byte[ebx],0 ;is this byte a zero?
jz no_more_args ;if yes this string is already terminated

inc ebx
jmp find_space ; this char was not space, go to the next char
found_space:
mov byte[ebx],0 ;terminate this string

inc ebx ;but go to the next byte
mov [arguments_start],ebx ;and set the new start address for the next call

ret ;We can return eax safely knowing the string ends in a zero

scan_quoted_string:

mov cl,byte[ebx] ;mov this quote type to cl
inc ebx ;go to next byte
mov eax,ebx ;set eax to this address which is assumed to be the start of a quoted string

find_end_quote:
cmp byte[ebx],cl ;is this the same quote we started with?
jz found_end_quote ;if it is, end this loop

;we must also check to see if we have reached the terminating zero of the arguments string
;this avoids a crash if I forgot to add the second quotation mark in the arguments
cmp byte[ebx],0 ;is this byte a zero?
jz no_more_args ;if yes this string is already terminated

inc ebx
jmp find_end_quote
found_end_quote:
mov byte[ebx],0 ;terminate this string

inc ebx ;but go to the next byte
mov [arguments_start],ebx ;and set the new start address for the next call

ret

no_more_args:

mov [arguments_start],ebx ;mov the start to where the string ended

;now that the start and end addresses are the same
;this function will always return zero
ret

;this will happen first time this function is called to get the argument data
get_arg_data:

;get command line argument string with this Windows API call
;it returns a pointer in the eax register
call [GetCommandLineA]

mov [arguments_start],eax ;copy it to memory address
call strlen ;get the length of string with my strlen function
mov ebx,[arguments_start] ;and copy address to the ebx register
add ebx,eax ;add the length to ebx which has the address of the start
mov [arguments_end],ebx ;save ebx address containing the zero byte
mov ebx,[arguments_start] ;copy the address of the arguments start to ebx

skip_prog_name:
cmp byte[ebx],0   ;check for zero first (very important)
jz no_args        ;if we found a zero before a space, there are no arguments after program name!
cmp byte[ebx],' ' ;is this byte a space?
jz skip_prog_name_end ;if it is a space, we can end this loop
mov byte[ebx],' ' ;turn this byte into a space and therefore delete it
inc ebx ; go to next byte
jmp skip_prog_name ;and keep looping till we find space
skip_prog_name_end:
mov eax,ebx ;copy this non-space address to eax register
;return eax pointing to an address of string with arguments after program name
ret

no_args:
mov eax,0
;in this case, we return zero because there are no args

ret

;start and end default to address of zero, which means we have not tested the arguments yet
arguments_start dd 0
arguments_end dd 0

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
