section .data
    hello_msg db "Hello, World!", 0xA  ; Message to print, ends with newline
    hello_len equ $ - hello_msg       ; Calculate message length

section .text
    global _start                     ; Entry point

_start:
    ; Write system call (Minix style - parameters on stack)
    push dword hello_len              ; push length (3rd parameter)
    push dword hello_msg              ; push message pointer (2nd parameter)
    push dword 1                      ; push file descriptor (1st parameter)
    mov eax, 4                        ; syscall: sys_write (4)
    int 0x80                          ; make syscall
    add esp, 12                       ; clean up stack (3 parameters * 4 bytes)

    ; Exit system call
    push dword 0                      ; exit code: 0
    mov eax, 1                        ; syscall: sys_exit (1)
    int 0x80                          ; make syscall
