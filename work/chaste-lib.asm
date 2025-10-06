; This file is where I keep my function definitions.
; These are usually my string and integer output routines.

putstring: ; function to print zero terminated string pointed to by register eax

mov edx,eax ; copy eax to edx as well. Now both registers have the address of the main_string

strlen_start: ; this loop finds the lenge of the string as part of the putstring function

cmp [edx],byte 0 ; compare byte at address edx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc edx
jmp strlen_start

strlen_end:
sub edx,eax ; edx will now have correct number of bytes when we use it for the system write call

mov ecx,eax ; copy eax to ecx which must contain address of string to write
mov eax, 4  ; invoke SYS_WRITE (kernel opcode 4)
;mov ebx, 1  ; ebx=1 means write to the STDOUT file
int 80h     ; system call to write the message

ret ; this is the end of the putstring function return to calling location

;this is the location in memory where digits are written to by the putint function
int_string db 32 dup '?',0Ah,0
int_string_end:

radix dd 2 ;radix or base for integer output. 2=binary, 16=hexadecimal, 10=decimal

putint: ; function to output decimal form of whatever integer is in eax

push eax ;save eax on the stack to restore later

mov ebp,int_string_end-3 ;find address of lowest digit(just before the newline 0Ah)

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
jz digits_end
dec ebp
jmp digits_start

digits_end:

mov eax,ebp ; now that the digits have been written to the string, display it!
call putstring

pop eax  ;load eax from the stack so it will be as it was before this function was called
ret