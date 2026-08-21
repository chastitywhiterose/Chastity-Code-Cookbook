format PE64 console
entry main

include 'win64ax.inc' ; Includes standard Windows 64-bit definitions and macros
include 'chastelib-win64.asm'

main:

mov [radix],16

; 1. Set up the stack frame (FASM win64ax convention handles alignment)

sub rsp,40

mov rax,main_string

;mov r15,rsp ;backup rsp to r15

call putstring

;mov rsp,r15 ;restore backup from r15 to rsp


mov rcx,0
call [ExitProcess]

main_string db 'Hello World!',0x0D,0x0A,0

; FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable
    library kernel32, 'KERNEL32.DLL'

    import kernel32,\
           GetStdHandle, 'GetStdHandle',\
           WriteFile, 'WriteFile',\
           ExitProcess, 'ExitProcess'
