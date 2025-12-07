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

mov edx,ebx ;number of bytes to write
mov ecx,eax ;pointer/address of string to write
mov ebx,1   ;write to the STDOUT file
mov eax,4   ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)

;BSD calling method: The arguments for the Unix Kernel are read from the stack. Therefore, since the registers are loaded with the correct data, we simply push them in the correct order before calling int 80h. Afterwards, we must add 16 to the stack pointer because the interrupt does not pop the elements from the stack for us automatically. 4 arguments times 4 bytes (each dword/register) is 16 total bytes.

push edx
push ecx
push ebx
push eax
int 80h          ;system call to write the message
add esp,16 ;restore stack to before the 4 dwords were pushed

;As weird as it looks, this allows for converting Linux programs into Unix programs, assuming they are on the same architecture and use the same call numbers.

pop edx
pop ecx
pop ebx
pop eax

ret ; this is the end of the putstring function return to calling location
