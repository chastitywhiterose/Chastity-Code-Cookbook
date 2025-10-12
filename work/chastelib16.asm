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
