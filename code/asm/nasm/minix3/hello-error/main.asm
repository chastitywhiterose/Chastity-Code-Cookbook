section .data
    hello_msg db "Hello, World!", 0xA  ; Message to print, ends with newline
    hello_len equ $ - hello_msg       ; Calculate message length

section .text
    global _start                     ; Entry point

_start:
    ; Write system call
    mov eax, 4                        ; syscall: sys_write (4)
    mov ebx, 1                        ; file descriptor: stdout (1)
    mov ecx, hello_msg                ; pointer to message
    mov edx, hello_len                ; length of message
    int 0x80                          ; make syscall

    ; Exit system call
    mov eax, 1                        ; syscall: sys_exit (1)
    xor ebx, ebx                      ; exit code: 0
    int 0x80                          ; make syscall

;the following commands were tested on Minix 3 running under a virtual machine
;the program assembles and links but gives a segmentation fault

;nasm -f elf hello.asm -o hello.o
;ld -m elf_i386_minix hello.o -o hello
