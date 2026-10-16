format PE console
entry main

include 'win32ax.inc'
include 'chastelib-w32.asm'

main:

;Create a new file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

push 0           ;hTemplateFile = NULL: We are not using a template file
push 0x80        ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
push 2           ;dwCreationDisposition = CREATE_ALWAYS
push 0           ;lpSecurityAttributes = NULL: No security attributes
push 1           ;dwShareMode = FILE_SHARE_READ (other programs can read this file)
push 0x10000000  ;dwDesiredAccess = GENERIC_ALL access mode (Read+Write+Execute)
push filename    ;lpFileName
call [CreateFileA]

;check eax for file handle or error code
cmp eax,-1
jnz file_good

file_bad:
mov eax,file_error_message
call putstring
call [GetLastError]
call putint
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file_good:

mov [fd],eax
mov eax,filename
call putstring

;use a loop to write every possible byte to the file
mov eax,0
loop0:
mov [buf],al

push eax
;write only 1 byte using Win32 WriteFile system call.
push 0              ;Optional Overlapped Structure 
push 0              ;Optionally Store Number of Bytes Written
push 1              ;Number of bytes to write
push buf            ;address to store bytes
push [fd]  ;handle of the open file
call [WriteFile]
pop eax

inc eax
cmp eax,0x100
jnz loop0

main_end:

;close the file
push [fd]
call [CloseHandle]

;Exit the process with code 0
push 0
call [ExitProcess]

;variables for error messages
file_error_message db 'error: ',0

;variables for managing file IO.
filename db "byte.bin",0
fd dd 0  ;file descriptor
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
