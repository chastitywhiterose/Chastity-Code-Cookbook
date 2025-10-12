; This file is where I keep my function definitions.
; These are usually my string and integer output routines.

; function to print zero terminated string pointed to by register eax

putstring: 

mov bx,ax ; copy ax to cx as well. Now both registers have the address of the main_string

putstring_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

mov dl,[bx]
cmp dl,0 ; compare this byte byte at address with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length

; call interrupt for printing a single character in dl register
mov ah,2
int 21h

inc bx
jmp putstring_strlen_start

strlen_end:
;sub edx,eax ; edx will now have correct number of bytes when we use it for the system write call

ret ; this is the end of the putstring function return to calling location







;print $ terminated string at address ax
put$tring:

mov dx,ax ; give dx register address of the string

;do the Hello World with function 9 (the easy way)
mov ah,9h  ; call function 9 (write string terminated by $)
int 21h    ; call the DOS kernel

ret





;this is the location in memory where digits are written to by the putint function
int_string     db 16 dup '?' ;enough bytes to hold maximum size 32-bit binary integer
; this is the end of the integer string optional line feed and terminating zero
; clever use of this label can change the ending to be a different character when needed 
int_string_end db 0D,0Ah,0

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




