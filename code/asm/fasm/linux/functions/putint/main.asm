format ELF executable
entry main

main: ; the main function of our assembly function, just as if I were writing C.

; I can load any string address into eax and print it!

mov eax,msg
call putstring
mov eax,main_string ; move the address of main_string into eax register
call putstring


mov eax,0
loop1:
call putint
inc eax
cmp eax,16;
jnz loop1

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

; this is where I keep my string variables

msg: db 'Hello World!', 0Ah,0     ; assign msg variable with your message string
main_string db 'This is the assembly counting program!',0Ah,0

; this is where I keep my function definitions

; function to print zero terminated string pointed to by register eax

stdout dd 1 ; variable for standard output so that it can theoretically be redirected

putstring:

push eax
push ebx
push ecx
push edx

mov ebx,eax ; copy eax to ebx. ebx will be used as index to the string

putstring_strlen_start: ; this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz putstring_strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;By subtracting the start of the string with the current address, we have the length of the string.

; Write string using Linux Write system call. Reference for 32 bit x86 syscalls is below.
; https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit

mov edx,ebx      ;number of bytes to write
mov ecx,eax      ;pointer/address of string to write
mov ebx,[stdout] ;write to the STDOUT file
mov eax, 4       ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h          ;system call to write the message

pop edx
pop ecx
pop ebx
pop eax

ret ; this is the end of the putstring function return to calling location

; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 32 dup '?' ;enough bytes to hold maximum size 32-bit binary integer

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

mov ebx,int_newline-1 ;find address of lowest digit(just before the newline 0Ah)
mov ecx,1

digits_start:

mov edx,0;
div dword [radix]
cmp edx,10
jb decimal_digit
jae hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add edx,'0'
jmp save_digit

hexadecimal_digit:
sub edx,10
add edx,'A'

save_digit:

mov [ebx],dl
cmp eax,0
jz intstr_end
dec ebx
inc ecx
jmp digits_start

intstr_end:

prefix_zeros:
cmp ecx,[int_width]
jnb end_zeros
dec ebx
mov [ebx],byte '0'
inc ecx
jmp prefix_zeros
end_zeros:

mov eax,ebx ; now that the digits have been written to the string, display it!

ret

; function to print string form of whatever integer is in eax
; The radix determines which number base the string form takes.
; Anything from 2 to 36 is a valid radix
; in practice though, only bases 2,8,10,and 16 will make sense to other programmers
; this function does not process anything by itself but calls the combination of my other
; functions in the order I intended them to be used.

putint: 

push eax
push ebx
push ecx
push edx

call intstr

call putstring

pop edx
pop ecx
pop ebx
pop eax

ret


; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main
