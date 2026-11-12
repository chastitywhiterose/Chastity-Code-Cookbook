; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 16 dup '?' ;reserve bytes for characters string for 16-bit binary integer

int_string_end db 0 ;zero byte terminator for the integer string

radix dw 2     ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dw 8 ;default width of integers. Extra zeros prefixed if more than 1

;this function creates a string of the integer in ax
;it uses the above radix variable to determine base from 2 to 36
;it then loads ax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov bx,int_string_end-1 ;find address of lowest digit(just before the newline 0Ah)
mov cx,1

digits_start:

mov dx,0;
div word [radix]
cmp dx,10
jb decimal_digit
jnb hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add dx,'0'
jmp save_digit

hexadecimal_digit:
sub dx,10
add dx,'A'

save_digit:

mov [bx],dl
cmp ax,0
jz intstr_end
dec bx
inc cx
jmp digits_start

intstr_end:

prefix_zeros:
cmp cx,[int_width]
jnb end_zeros
dec bx
mov byte[bx], '0'
inc cx
jmp prefix_zeros
end_zeros:

mov ax,bx ; store string in ax for display later

ret
