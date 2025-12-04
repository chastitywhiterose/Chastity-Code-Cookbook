; This file is where I keep my function definitions.
; These are usually my string and integer output routines.

; function to print zero terminated string pointed to by register rax

stdout dq 1 ; variable for standard output so that it can theoretically be redirected

putstring:

push rax
push rbx
push rcx
push rdx

mov rbx,rax ; copy rax to rbx as well. Now both registers have the address of the main_string

putstring_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

cmp [rbx],byte 0 ; compare byte at address rdx with 0
jz putstring_strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc rbx
jmp putstring_strlen_start

putstring_strlen_end:
sub rbx,rax ;rbx will now have correct number of bytes

;write string using Linux Write system call
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86_64-64-bit


mov rdx,rbx      ;number of bytes to write
mov rsi,rax      ;pointer/address of string to write
mov rdi,[stdout] ;write to the STDOUT file
mov rax,1        ;invoke SYS_WRITE (kernel opcode 1 on 64 bit systems)
syscall          ;system call to write the message


pop rdx
pop rcx
pop rbx
pop rax

ret ; this is the end of the putstring function return to calling location

;this is the location in memory where digits are written to by the putint function
int_string     db 64 dup '?' ;enough bytes to hold maximum size 64-bit binary integer
; this is the end of the integer string optional line feed and terminating zero
; clever use of this label can change the ending to be a different character when needed 
int_newline db 0Ah,0

radix dq 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dq 8

;this function creates a string of the integer in rax
;it uses the above radix variable to determine base from 2 to 36
;it then loads rax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov rbx,int_newline-1 ;find address of lowest digit(just before the newline 0Ah)
mov rcx,1

digits_start:

mov rdx,0;
div qword [radix]
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

mov [rbx],dl
cmp rax,0
jz intstr_end
dec rbx
inc rcx
jmp digits_start

intstr_end:

prefix_zeros:
cmp rcx,[int_width]
jnb end_zeros
dec rbx
mov [rbx],byte '0'
inc rcx
jmp prefix_zeros
end_zeros:

mov rax,rbx ; now that the digits have been written to the string, display it!

ret


; function to print string form of whatever integer is in rax
; The radix determines which number base the string form takes.
; Anything from 2 to 36 is a valid radix
; in practice though, only bases 2,8,10,and 16 will make sense to other programmers
; this function does not process anything by itself but calls the combination of my other
; functions in the order I intended them to be used.

putint: 

push rax
push rbx
push rcx
push rdx

call intstr

call putstring

pop rdx
pop rcx
pop rbx
pop rax

ret

;this function converts a string pointed to by rax into an integer returned in rax instead
;it is a little complicated because it has to account for whether the character in
;a string is a decimal digit 0 to 9, or an alphabet character for bases higher than ten
;it also checks for both uppercase and lowercase letters for bases 11 to 36
;finally, it checks if that letter makes sense for the base.
;For example, G to Z cannot be used in hexadecimal, only A to F can
;The purpose of writing this function was to be able to accept user input as integers

strint:

mov rbx,rax ;copy string address from rax to esi because rax will be replaced soon!
mov rax,0

read_strint:
mov rcx,0 ; zero rcx so only lower 8 bits are used
mov cl,[rbx]
inc rbx
cmp cl,0 ; compare byte at address rdx with 0
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

cmp rcx,[radix] ;compare char with radix
jae strint_end ;if this value is above or equal to radix, it is too high despite being a valid digit/alpha

mov rdx,0 ;zero rdx because it is used in mul sometimes
mul [radix]    ;mul rax with radix
add rax,rcx

jmp read_strint ;jump back and continue the loop if nothing has exited it

strint_end:

ret
;the next utility functions simply print a space or a newline
;these help me save code when printing lots of things for debugging

space db ' ',0
line db 0Dh,0Ah,0

putspace:
push rax
mov rax,space
call putstring
pop rax
ret

putline:
push rax
mov rax,line
call putstring
pop rax
ret
