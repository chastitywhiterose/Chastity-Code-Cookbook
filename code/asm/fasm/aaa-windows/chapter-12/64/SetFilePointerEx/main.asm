format PE64 console
entry main

include 'win64a.inc'        ;includes standard Windows 32-bit definitions and macros
include 'chastelib-w64.asm' ;include standard library functions by Chastity

main:

;Create a new file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 64-bit calling convention
sub rsp, 56             ;reserve 32-byte shadow + space for 3 extra args (3*8=24) = 56
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
mov rax,filename
call putstring

mov [offset],0x30
call fseek
mov rax,string0
call fputstring

mov [offset],0x10
call fseek
mov rax,string1
call fputstring

main_end:

;close the file
sub rsp,40
mov rcx,[fd]
call [CloseHandle]
add rsp,40

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

file_error_message db 'error: ',0

filename db "testfile.txt",0
fd dq ?
offset dq ?

string0 db "first string.",0
string1 db "second string.",0

fputstring:         ;print string pointed to by rax register

push rax
push rbx
push rcx
push rdx

mov rbx,rax             ;copy eax to ebx to be used as index to the string

fputstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [rbx],byte 0        ;compare byte at address ebx with 0
jz fputstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc rbx
jmp fputstring_strlen_start

fputstring_strlen_end:
sub rbx,rax ;subtract start pointer from current pointer to get length of string

;Windows 64-bit WriteFile system call
sub rsp,40           ;align stack for Win64 API calls
mov qword [rsp+32],0 ;lpOverlapped = NULL
mov r9,0             ;lpNumberOfBytesWritten = NULL
mov r8,rbx           ;nNumberOfBytesToWrite = rbx
mov rdx,rax          ;lpBuffer = address of string to write
mov rcx,[fd]         ;hFile = [fd] handle of existing file
call [WriteFile]
add rsp,40           ;restore stack now that WinAPI calls are done

pop rdx
pop rcx
pop rbx
pop rax

ret

fseek:

;seek to 64-bit address of file with SetFilePointerEx function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-setfilepointerex

sub rsp,40       ;align stack before Win API functions(required in windows 64-bit)
mov r9, 0        ;dwMoveMethod = FILE_BEGIN -> seek from beginning of file
mov r8, 0        ;lpNewFilePointer = NULL: We are not storing the result anywhere
mov rdx,[offset] ;liDistanceToMove = [offset]
mov rcx,[fd]     ;hFile = [fd] -> a file already opened
call [SetFilePointerEx]
add rsp,40       ;restore stack now that WinAPI calls are done

ret

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 GetCommandLineA, 'GetCommandLineA',\
 CreateFileA, 'CreateFileA',\
 GetLastError, 'GetLastError',\
 SetFilePointerEx, 'SetFilePointerEx',\
 ReadFile, 'ReadFile',\
 CloseHandle, 'CloseHandle'
