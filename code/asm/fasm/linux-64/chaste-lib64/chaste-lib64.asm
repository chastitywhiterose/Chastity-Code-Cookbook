; This file is where I keep my function definitions.
; These are usually my string and integer output routines.

; function to print zero terminated string pointed to by register rax

putstring: 

mov rdx,rax ; copy rax to rdx as well. Now both registers have the address of the main_string

putstring_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

cmp [rdx],byte 0 ; compare byte at address rdx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc rdx
jmp putstring_strlen_start

strlen_end:
sub rdx,rax ; rdx will now have correct number of bytes when we use it for the system write call

mov rsi,rax ; pointer/address of string to write
mov rax,1   ; invoke SYS_WRITE (kernel opcode 1 on 64 bit systems)
;mov rdi,1   ; write to the STDOUT file
syscall

ret ; this is the end of the putstring function return to calling location

;this is the location in memory where digits are written to by the putint function
int_string     db 64 dup '?'
; this is the end of the integer string optional line feed and terminating zero
; clever use of this label can change the ending to be a different character when needed 
int_string_end db 0Ah,0

radix dq 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dq 8

intstr:

mov rbp,int_string_end-1 ;find address of lowest digit(just before the newline 0Ah)
mov rcx,1

digits_start:

mov rdx,0;
mov rsi,[radix] ;radix is from memory location just before this function
div rsi
cmp rdx,10
jb decimal_digit
jge hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add rdx,'0'
jmp save_digit

hexadecimal_digit:
sub rdx,10
add rdx,'A'

save_digit:

mov [ebp],dl
cmp rax,0
jz intstr_end
dec rbp
inc rcx
jmp digits_start

intstr_end:

prefix_zeros:
cmp rcx,[int_width]
jnb end_zeros
dec rbp
mov [rbp],byte '0'
inc rcx
jmp prefix_zeros
end_zeros:

mov rax,rbp ; now that the digits have been written to the string, display it!

ret







putint: ; function to output decimal form of whatever integer is in rax

push rax ;save rax on the stack to restore later

call intstr

call putstring

pop rax  ;load rax from the stack so it will be as it was before this function was called
ret
