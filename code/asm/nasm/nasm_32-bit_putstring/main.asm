global  _start

section .data ; Data read or written by the program goes in the data section

;A string to test if output works

main_string db 'This program runs in Linux!',0Ah,0

section .text

_start:

mov byte[main_string], '?' ;optionally modify a byte of the string

mov eax,main_string
call putstring

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

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
mov ebx,1        ;write to the STDOUT file
mov eax,4        ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h          ;system call to write the message

pop edx
pop ecx
pop ebx
pop eax

ret ; this is the end of the putstring function return to calling location

; This Assembly source file has been formatted for the NASM assembler.
; The following 3 commands assemble, link, and run the program
;
;main-nasm:
;	nasm -f elf main.asm
;	ld -m elf_i386 main.o -o main
;	./main
