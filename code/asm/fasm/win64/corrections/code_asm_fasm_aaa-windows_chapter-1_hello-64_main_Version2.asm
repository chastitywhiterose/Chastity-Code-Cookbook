format PE64 console
entry main

include 'win64ax.inc' ; Includes standard Windows 64-bit definitions and macros

main:
    ; Reserve 32-byte shadow space + 8 bytes to keep 16-byte alignment (total 40)
    sub rsp, 40

    ; Pass pointer to string in RCX (Windows x64 first argument)
    lea rcx, [rel main_string]
    call putstring

    ; ExitProcess(0)
    xor ecx, ecx
    call [ExitProcess]

; Data
main_string db 'Hello World!',0x0D,0x0A,0
write_count dq 0

; putstring: prints the NUL-terminated string whose address is in RCX
putstring:
    ; Preserve callee-saved registers used (RBX)
    push rbx

    ; RCX = pointer to string (argument)
    mov rdx, rcx        ; rdx := pointer to buffer (we'll keep this)
    mov rbx, rdx        ; rbx will be used to scan to end

putstring_strlen_loop:
    cmp byte [rbx], 0
    je putstring_strlen_done
    inc rbx
    jmp putstring_strlen_loop

putstring_strlen_done:
    sub rbx, rdx        ; rbx = length (rbx - original pointer)

    ; Allocate local stack space (40) so we have room to place the 5th parameter
    ; and keep stack aligned for the calls we make.
    sub rsp, 40

    ; GetStdHandle(STD_OUTPUT_HANDLE)
    mov rcx, -11        ; STD_OUTPUT_HANDLE
    call [GetStdHandle] ; returns HANDLE in RAX

    ; Prepare WriteFile arguments:
    ; RCX = handle, RDX = buffer pointer, R8 = length, R9 = pointer to DWORD bytesWritten
    mov rcx, rax                ; hFile (from GetStdHandle)
    mov rdx, rdx                ; lpBuffer (still in rdx)
    mov r8, rbx                 ; nNumberOfBytesToWrite (length)
    lea r9, [rel write_count]   ; address of write_count (LPDWORD)
    mov qword [rsp + 32], 0     ; lpOverlapped (parameter 5 on stack) = NULL

    call [WriteFile]

    ; Restore stack and registers
    add rsp, 40
    pop rbx

    ret

; FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable
    library kernel32, 'KERNEL32.DLL'

    import kernel32,\
           GetStdHandle, 'GetStdHandle',\
           WriteFile, 'WriteFile',\
           ExitProcess, 'ExitProcess'