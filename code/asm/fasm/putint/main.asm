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
int_string db 32 dup '?',0Ah,0

; this is where I keep my function definitions

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
mov ebx, 1  ; write to the STDOUT file
int 80h     ; system call to write the message

ret ; this is the end of the putstring function return to calling location

putint: ; function to output decimal form of whatever integer is in eax

push eax ;save eax on the stack to restore later

mov ebx,int_string+31 ;address of start digits

digits_start:

mov edx,0;
mov esi,10
div esi
add edx,'0'
mov [ebx],dl
cmp eax,0
jz digits_end
dec ebx
jmp digits_start

digits_end:

mov eax,ebx ; now that the digits have been written to the string, display it!
call putstring

pop eax  ;load eax from the stack so it will be as it was before this function was called
ret

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main
