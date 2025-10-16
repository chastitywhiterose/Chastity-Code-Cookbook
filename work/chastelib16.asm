; This file is where I keep my function definitions.
; These are usually my string and integer output routines.

stdout dw 1 ; variable for standard output so that it can theoretically be redirected

; this is my best putstring function for DOS because it uses call 40h of interrupt 21h
; this means that it works in a similar way to my Linux Assembly code

putstring:

mov bx,ax ; copy ax to cx as well. Now both registers have the address of the main_string

putstring_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

cmp [bx], byte 0 ; compare this byte byte at address with 0
jz putstring_strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc bx
jmp putstring_strlen_start

putstring_strlen_end:

sub bx,ax ; sub ax from bx to get the difference for number of bytes
mov cx,bx ; mov bx to cs
mov dx,ax  ; dx will have address of string to write

mov ah,40h ; select DOS function 40h write 
mov bx,[stdout]   ; file handle 1=stdout
int 21h    ; call the DOS kernel

ret



; function to print zero terminated string pointed to by register eax
; this is implemented by repeatedly calling function 2 of the DOS interrupt 21h
; this function is very simple to write but it is also slower than one with a better system call

putstring_function_2h: 

mov bx,ax ; copy ax to cx as well. Now both registers have the address of the main_string

putstring_2h_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

mov dl,[bx]
cmp dl,0 ; compare this byte byte at address with 0
jz strlen_2h_end ; if comparison was zero, jump to loop end because we have found the length

; call interrupt for printing a single character in dl register
mov ah,2
int 21h

inc bx
jmp putstring_2h_strlen_start

strlen_2h_end:

ret ; this is the end of the putstring function return to calling location







;print $ terminated string at address ax
;this function only works if there is a $ at the end of what you wish to print

putstring_function_9h:

mov dx,ax ; give dx register address of the string

;do the Hello World with function 9 (the easy way)
mov ah,9h  ; call function 9 (write string terminated by $)
int 21h    ; call the DOS kernel

ret





;this is the location in memory where digits are written to by the putint function
int_string     db 16 dup '?' ;enough bytes to hold maximum size 32-bit binary integer
; this is the end of the integer string optional line feed and terminating zero
; clever use of this label can change the ending to be a different character when needed 
int_string_end db 0Ah,0 ;for some reason, the 0Dh,0Ah does not diplay correctly in DOSBOX
;therefore, the 0Dh has been excluded from this string ending

radix dw 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dw 8

intstr:

mov bp,int_string_end-1 ;find address of lowest digit(just before the newline 0Ah)
mov cx,1

digits_start:

mov dx,0;
mov si,[radix] ;radix is from memory location just before this function
div si
cmp dx,10
jb decimal_digit
jge hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add dx,'0'
jmp save_digit

hexadecimal_digit:
sub dx,10
add dx,'A'

save_digit:

mov [bp],dl
cmp ax,0
jz intstr_end
dec bp
inc cx
jmp digits_start

intstr_end:

prefix_zeros:
cmp cx,[int_width]
jnb end_zeros
dec bp
mov [bp],byte '0'
inc cx
jmp prefix_zeros
end_zeros:

mov ax,bp ; now that the digits have been written to the string, display it!

ret






; function to print string form of whatever integer is in eax
; The radix determines which number base the string form takes.
; Anything from 2 to 36 is a valid radix
; in practice though, only bases 2,8,10,and 16 will make sense to other programmers
; this function does not process anything by itself but calls the combination of my other
; functions in the order I intended them to be used.

putint: 

push ax ;save eax on the stack to restore later

call intstr

call putstring

pop ax  ;load eax from the stack so it will be as it was before this function was called

ret








;this function converts a string pointed to by eax into an integer returned in eax instead
;it is a little complicated because it has to account for whether the character in
;a string is a decimal digit 0 to 9, or an alphabet character for bases higher than ten
;it also checks for both uppercase and lowercase letters for bases 11 to 36
;finally, it checks if that letter makes sense for the base.
;For example, G to Z cannot be used in hexadecimal, only A to F can
;The purpose of writing this function was to be able to accept user input as integers

strint:

mov si,ax ;copy string address from eax to esi because eax will be replaced soon!
mov ax,0

read_strint:
mov cx,0 ; zero ecx so only lower 8 bits are used
mov cl,[si]
inc si
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

cmp cx,[radix] ;compare char with radix
jae strint_end ;if this value is above or equal to radix, it is too high despite being a valid digit/alpha

mov dx,0 ;zero edx because it is used in mul sometimes
mul [radix]    ;mul eax with radix
add ax,cx

jmp read_strint ;jump back and continue the loop if nothing has exited it

strint_end:

ret

;returns in al register a character from the keyboard
getchr:

mov ah,1
int 21h

ret

