;chastearg source file for FASM assembler.
;This program prints each command line argument on a separate line
;This does not count the program name as an argument
;This program is smaller than the original but is also harder to read.
;Therefore, I may not use it as the official verion of chastearg

format ELF executable
entry main

main:

pop eax           ;pop the number of arguments from the stack
mov ebp,eax       ;save the argument count for later

pop eax           ;pop argument 0 (name of the program)
dec ebp           ;subtract 1 from argument count


putarg:

and ebp,ebp         ;check for remaining arguments
jz putarg_end        ;if none, end the loop and stop printing
pop eax              ;pop the next argument off the stack
call putstring       ;print the string and a new line
call putline
dec ebp           ;subtract 1 from argument count
jmp putarg           ;jump to the beginning of the loop

putarg_end:

mov eax, 1           ; invoke SYS_EXIT (kernel opcode 1)
xor ebx,ebx          ; return 0 status with ebx register but use xor for less bytes assembled
int 0x80

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
sub ebx,eax ;subtract start pointer from current pointer to get length of string

;Write string using Linux Write system call.
;Reference for 32 bit x86 syscalls is below.
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit

mov edx,ebx      ;number of bytes to write
mov ecx,eax      ;pointer/address of string to write
mov ebx,1        ;write to the STDOUT file
mov eax, 4       ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h          ;system call to write the message

pop edx
pop ecx
pop ebx
pop eax

ret ; this is the end of the putstring function. return to calling location

putline:
push eax
mov eax,line
call putstring
pop eax
ret

line db 0Ah,0 ;where the string containing a new line is
