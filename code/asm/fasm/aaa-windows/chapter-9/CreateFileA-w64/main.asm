format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

;Create a new file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 64-bit calling convention
sub rsp, 56             ; reserve 32-byte shadow + space for 3 extra args (3*8=24) = 56
mov qword [rsp+48],0    ;hTemplateFile = NULL: We are not using a template file
mov qword [rsp+40],0x80 ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
mov qword [rsp+32],2    ;dwCreationDisposition = CREATE_ALWAYS
mov r9,0                ;lpSecurityAttributes = NULL: No security attributes
mov r8,1                ;dwShareMode = FILE_SHARE_READ (other programs can read this file)
mov rdx,0x10000000      ;dwDesiredAccess = GENERIC_ALL access mode (Read+Write+Execute)
mov rcx,filename        ;lpFileName
call [CreateFileA]
add rsp, 56

;check eax for file handle or error code
cmp rax,-1
jnz file_good

file_bad:
mov rax,file_error_message
call putstring
call [GetLastError]
call putint
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file_good:

mov [fd],rax
mov eax,filename
call putstring

;use a loop to write every possible byte to the file
mov rax,0
loop0:
mov [buf],al

push rax

;Windows 64-bit WriteFile system call
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile

sub rsp,40           ;align stack for Win64 API calls
mov qword [rsp+32],0 ;lpOverlapped = NULL
mov r9,0             ;lpNumberOfBytesWritten = NULL
mov r8,1             ;nNumberOfBytesToWrite = 1
mov rdx,buf          ;lpBuffer = address of data to write
mov rcx,[fd]         ;hFile = [fd] (copied there earlier)
call [WriteFile]
add rsp,40           ;restore stack now that WinAPI calls are done

pop rax

inc rax
cmp rax,0x100
jnz loop0

main_end:

;close the file
sub rsp,40
mov rcx,[fd]
call [CloseHandle]
add rsp,40

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

;variables for error messages
file_error_message db 'error: ',0

;variables for managing file IO.
filename db "byte.bin",0
fd dq 0  ;file descriptor
buf db 0 ;buffer to write to file

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 CreateFileA, 'CreateFileA',\
 GetLastError, 'GetLastError',\
 CloseHandle, 'CloseHandle'
