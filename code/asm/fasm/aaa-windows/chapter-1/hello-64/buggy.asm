format PE64 console
entry main

include 'win64ax.inc' ; Includes standard Windows 64-bit definitions and macros

main:

sub rsp, 40 ;alignment
; 1. Set up the stack frame (FASM win64ax convention handles alignment)
mov rax,main_string
call putstring

sub rsp, 40 ;alignment

call putstring

mov rcx,0
call [ExitProcess]

main_string db 'Hello World!',0x0D,0x0A,0

write_count dq 0

putstring:              ;print string pointed to by rax register



push rax
push rbx
push rcx
push rdx

mov rbx,rax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [rbx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc rbx
jmp putstring_strlen_start

putstring_strlen_end:
sub rbx,rax ;subtract start pointer from current pointer to get length of string

mov rdx,rax ;pointer to message

mov rcx, -11        ; STD_OUTPUT_HANDLE
call [GetStdHandle] ; Get Standard Output Handle
mov rcx,rax         ; copy handle to ecx

mov r8,rbx  ;message length
mov r9,write_count ;store how many bytes are written



mov qword [rsp + 32], 0 ; Parameter 5: Must be placed on the stack
call [WriteFile]

pop rdx
pop rcx
pop rbx
pop rax

ret ;this is the end of the putstring function return to calling location



; FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable
    library kernel32, 'KERNEL32.DLL'

    import kernel32,\
           GetStdHandle, 'GetStdHandle',\
           WriteFile, 'WriteFile',\
           ExitProcess, 'ExitProcess'
