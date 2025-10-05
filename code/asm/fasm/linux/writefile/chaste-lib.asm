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
