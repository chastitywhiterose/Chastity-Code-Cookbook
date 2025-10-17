; This file is where I keep my function definitions.
; These are usually my string and integer output routines.

; function to print zero terminated string pointed to by register eax

stdout dd 1 ; variable for standard output so that it can theoretically be redirected

putstring: 

mov edx,eax ; copy eax to edx as well. Now both registers have the address of the main_string

putstring_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

cmp [edx],byte 0 ; compare byte at address edx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc edx
jmp putstring_strlen_start

strlen_end:
sub edx,eax ; edx will now have correct number of bytes when we use it for the system write call

mov ecx,eax ; pointer/address of string to write
mov eax, 4  ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,[stdout] ; write to the STDOUT file
int 80h     ; system call to write the message

ret ; this is the end of the putstring function return to calling location

;this is the location in memory where digits are written to by the putint function
int_string     db 32 dup '?' ;enough bytes to hold maximum size 32-bit binary integer
; this is the end of the integer string optional line feed and terminating zero
; clever use of this label can change the ending to be a different character when needed 
int_newline db 0Ah,0

radix dd 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dd 8

;this function creates a string of the integer in eax
;it uses the above radix variable to determine base from 2 to 36
;it then loads eax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov ebp,int_newline-1 ;find address of lowest digit(just before the newline 0Ah)
mov ecx,1

digits_start:

mov edx,0;
mov esi,[radix] ;radix is from memory location just before this function
div esi
cmp edx,10
jb decimal_digit
jge hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add edx,'0'
jmp save_digit

hexadecimal_digit:
sub edx,10
add edx,'A'

save_digit:

mov [ebp],dl
cmp eax,0
jz intstr_end
dec ebp
inc ecx
jmp digits_start

intstr_end:

prefix_zeros:
cmp ecx,[int_width]
jnb end_zeros
dec ebp
mov [ebp],byte '0'
inc ecx
jmp prefix_zeros
end_zeros:

mov eax,ebp ; now that the digits have been written to the string, display it!

ret


; function to print string form of whatever integer is in eax
; The radix determines which number base the string form takes.
; Anything from 2 to 36 is a valid radix
; in practice though, only bases 2,8,10,and 16 will make sense to other programmers
; this function does not process anything by itself but calls the combination of my other
; functions in the order I intended them to be used.

putint: 

push eax ;save eax on the stack to restore later

call intstr

call putstring

pop eax  ;load eax from the stack so it will be as it was before this function was called

ret

;this function converts a string pointed to by eax into an integer returned in eax instead
;it is a little complicated because it has to account for whether the character in
;a string is a decimal digit 0 to 9, or an alphabet character for bases higher than ten
;it also checks for both uppercase and lowercase letters for bases 11 to 36
;finally, it checks if that letter makes sense for the base.
;For example, G to Z cannot be used in hexadecimal, only A to F can
;The purpose of writing this function was to be able to accept user input as integers

strint:

mov esi,eax ;copy string address from eax to esi because eax will be replaced soon!
mov eax,0

read_strint:
mov ecx,0 ; zero ecx so only lower 8 bits are used
mov cl,[esi]
inc esi
cmp cl,0 ; compare byte at address edx with 0
jz strint_end ; if comparison was zero, this is the end of string

;if char is below '0' or above '9', it is outside the range of these and is not a digit
cmp cl,'0'
jb not_digit
cmp cl,'9'
ja not_digit

;but if it is a digit, then correct and process the character
is_digit:
sub cl,'0'
jmp process_char

not_digit:
;it isn't a digit, but it could be perhaps and alphabet character
;which is a digit in a higher base

;if char is below 'A' or above 'Z', it is outside the range of these and is not capital letter
cmp cl,'A'
jb not_upper
cmp cl,'Z'
ja not_upper

is_upper:
sub cl,'A'
add cl,10
jmp process_char

not_upper:

;if char is below 'a' or above 'z', it is outside the range of these and is not lowercase letter
cmp cl,'a'
jb not_lower
cmp cl,'z'
ja not_lower

is_lower:
sub cl,'a'
add cl,10
jmp process_char

not_lower:

;if we have reached this point, result invalid and end function
jmp strint_end

process_char:

cmp ecx,[radix] ;compare char with radix
jae strint_end ;if this value is above or equal to radix, it is too high despite being a valid digit/alpha

mov edx,0 ;zero edx because it is used in mul sometimes
mul [radix]    ;mul eax with radix
add eax,ecx

jmp read_strint ;jump back and continue the loop if nothing has exited it

strint_end:

ret


