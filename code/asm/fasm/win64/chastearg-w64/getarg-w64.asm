;The getarg function was something I badly needed in order to make my assembly code for DOS easier to read.
;It will automatically process the command line arguments if they are available.
;
;The first time it is run, it returns the whole command string or zero if no args are given
;Each time after that, it will give you the next argument, which is a substring of the original.
;When no more arguments are available, it will always return zero
;The program calling this is expected to check for this error and then terminate
;or print a message depending on the goals of that program

;A word of warning, though, this function has multiple return statements and is long
;However, it is fully featured in that it can recognize quoted strings as being the same argument
;This brings full compatibility between my DOS and Linux programs which expect consistent behavior
;
;I also wrote a Windows version of this same function in a separate file
;Because DOS does not allow the program name to be part of the arguments,
;I also wrote the Windows edition to exclude it from results.
;However, the DOS getarg function is the most important because DOS systems are freely available.

getarg:

mov rbx,[arguments_start] ;get the address of start of arguments
cmp rbx,0 ;is this address zero? (meaning this function was not called before)
jz get_arg_data ;if it was zero, then get the argument data for the first execution of this function

;if the start was not zero, then clearly arguments exist and addresses have been saved
cmp rbx,[arguments_end]  ;is the address of the start and end the same?
jnz find_next_string  ;if they are not the same, find the next sub string
mov rax,0 ;otherwise, return rax as zero and check this in the main program

ret

find_next_string:

mov rbx,[arguments_start] ;get address of current arg

skip_spaces:

cmp byte[rbx],' ' ;is this byte a space?
jnz skip_spaces_end ;if it is not a space, we can end this loop
inc rbx ;otherwise, go to next byte
jmp skip_spaces ;and keep looping till we find non-space
skip_spaces_end:
mov rax,rbx ;copy this non-space address to rax register

;we have found a non-space which is the start of a printable string
;but we still have to find the next space and terminate it with a zero!

;however, there is a special case where we want a string to contain spaces. In this case, I have another routine!

;check for quoted strings
cmp byte[rbx],0x22 ;is this a double quote -> "
jz scan_quoted_string
cmp byte[rbx],0x27 ;is this a single quote -> '
jz scan_quoted_string

find_space:
cmp byte [rbx],' ' ;is this a space?
jz found_space ;if this was a space, end the loop and terminate with zero

;we must also check to see if we have reached the terminating zero of the arguments string
cmp byte[rbx],0 ;is this byte a zero?
jz no_more_args ;if yes this string is already terminated

inc rbx
jmp find_space ; this char was not space, go to the next char
found_space:
mov byte[rbx],0 ;terminate this string

inc rbx ;but go to the next byte
mov [arguments_start],rbx ;and set the new start address for the next call

ret ;We can return rax safely knowing the string ends in a zero

scan_quoted_string:

mov cl,byte[rbx] ;mov this quote type to cl
inc rbx ;go to next byte
mov rax,rbx ;set rax to this address which is assumed to be the start of a quoted string

find_end_quote:
cmp byte[rbx],cl ;is this the same quote we started with?
jz found_end_quote ;if it is, end this loop

;we must also check to see if we have reached the terminating zero of the arguments string
;this avoids a crash if I forgot to add the second quotation mark in the arguments
cmp byte[rbx],0 ;is this byte a zero?
jz no_more_args ;if yes this string is already terminated

inc rbx
jmp find_end_quote
found_end_quote:
mov byte[rbx],0 ;terminate this string

inc rbx ;but go to the next byte
mov [arguments_start],rbx ;and set the new start address for the next call

ret

no_more_args:

mov [arguments_start],rbx ;mov the start to where the string ended

;now that the start and end addresses are the same
;this function will always return zero
ret

;this will happen first time this function is called to get the argument data
get_arg_data:

;get command line argument string with this Windows API call
;it returns a pointer in the rax register
sub rsp,40  ;align stack before Win API functions(required in windows 64-bit)
call [GetCommandLineA]
add rsp,40  ;restore stack now that WinAPI calls are done
mov [arguments_start],rax ;but copy it to memory too

;the following loop is a modified strlen loop except that we don't
;care about how long the string is. We only need the pointer for where it ends

mov rbx,rax  ;copy rax to rbx to be used in loop to find ending zero
argend_find: ; this loop finds the zero at the end of the argument string
cmp [rbx],byte 0 ; compare byte at address rbx with 0
jz argend_found ; if comparison was zero, jump to loop end because we have found the length
inc rbx
jmp argend_find
argend_found:
mov [arguments_end],rbx ;save rbx address containing the zero byte

mov rbx,rax ;mov the start of the arg string again before the next loop

skip_prog_name:
cmp byte[rbx],0   ;check for zero first (very important)
jz no_args        ;if we found a zero before a space, there are no arguments after program name!
cmp byte[rbx],' ' ;is this byte a space?
jz skip_prog_name_end ;if it is a space, we can end this loop
mov byte[rbx],' ' ;turn this byte into a space and therefore delete it
inc rbx ; go to next byte
jmp skip_prog_name ;and keep looping till we find space
skip_prog_name_end:
mov rax,rbx ;copy this non-space address to rax register
;return rax pointing to an address of string with arguments after program name
ret

no_args:
mov rax,0
;in this case, we return zero because there are no args

ret

;start and end default to address of zero, which means we have not tested the arguments yet
arguments_start dq 0
arguments_end dq 0
