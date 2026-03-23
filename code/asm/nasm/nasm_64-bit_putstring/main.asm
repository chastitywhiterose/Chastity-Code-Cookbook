global  _start

_start:

mov rax,main_string ; move the address of main_string into rax register
call putstring

mov rax, 60 ; invoke SYS_EXIT (kernel opcode 60 on 64 bit systems)
mov rdi,0   ; return 0 status on exit - 'No Errors'
syscall

;A string to test if output works
main_string db 'This program runs in Linux!',0Ah,0

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
mov rdi,1        ;write to the STDOUT file
mov rax,1        ;invoke SYS_WRITE (kernel opcode 1 on 64 bit systems)
syscall          ;system call to write the message

pop rdx
pop rcx
pop rbx
pop rax

ret ; this is the end of the putstring function return to calling location

; This Assembly source file has been formatted for the NASM assembler.
; The following 3 commands assemble, link, and run the program
;
;	nasm -f elf64 main.asm
;	ld main.o -o main
;	./main
