format PE64 console
entry start

include 'win64ax.inc' ; Includes standard Windows 64-bit definitions and macros

section '.data' data readable writeable
    msg      db "Hello, World!", 13, 10
    msg_len  = $ - msg

section '.bss' readable writeable
    bytes_written dq ?

section '.text' code readable executable
start:
    ; 1. Set up the stack frame (FASM win64ax convention handles alignment)
    sub rsp, 40

    ; 2. Get Standard Output Handle
    mov rcx, -11            ; STD_OUTPUT_HANDLE
    call [GetStdHandle]     ; Note the brackets: we are calling via the import pointer

    ; 3. Write "Hello, World!" to Console
    ; WriteFile(handle, buffer, length, &bytesWritten, lpOverlapped)
    mov rcx, rax            ; Parameter 1: Handle returned by GetStdHandle
    lea rdx, [msg]          ; Parameter 2: Pointer to message
    mov r8, msg_len         ; Parameter 3: Message length
    lea r9, [bytes_written] ; Parameter 4: Pointer to memory for result
    mov qword [rsp + 32], 0 ; Parameter 5: Must be placed on the stack
    call [WriteFile]

    ; 4. Exit Program
    xor rcx, rcx            ; Exit code 0
    call [ExitProcess]

; 5. Import Table Data
; FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable
    library kernel32, 'KERNEL32.DLL'

    import kernel32,\
           GetStdHandle, 'GetStdHandle',\
           WriteFile, 'WriteFile',\
           ExitProcess, 'ExitProcess'
