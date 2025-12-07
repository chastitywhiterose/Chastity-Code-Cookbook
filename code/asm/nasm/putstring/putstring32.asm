putstring:

push eax
push ebx
push ecx
push edx

mov ebx,eax ; copy eax to ebx as well. Now both registers have the address of the main_string

putstring_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz putstring_strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;ebx will now have correct number of bytes

;write string using Linux Write system call
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

ret ; this is the end of the putstring function return to calling location