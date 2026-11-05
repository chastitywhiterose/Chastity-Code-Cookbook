format PE console
entry main

include 'win32a.inc'        ;includes standard Windows 32-bit definitions and macros
include 'chastelib-w32.asm' ;include standard library functions by Chastity

main:

;Create a new file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 32-bit calling convention

push 0                  ;hTemplateFile = NULL: We are not using a template file
push 0x80               ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
push 2                  ;dwCreationDisposition = CREATE_ALWAYS
push 0                  ;lpSecurityAttributes = NULL: No security attributes
push 1                  ;dwShareMode = FILE_SHARE_READ (other programs can read this file)
push 0x10000000         ;dwDesiredAccess = GENERIC_ALL access mode (Read+Write+Execute)
push filename           ;lpFileName
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

mov [offset],0x30
call fseek
mov eax,string0
call fputstring

mov [offset],0x10
call fseek
mov eax,string1
call fputstring

main_end:

;close the file

push [fd]
call [CloseHandle]


;Exit the process with code 0
push 0
call [ExitProcess]

file_error_message db 'error: ',0

filename db "testfile.txt",0
fd dd ?
offset dd ?

string0 db "first string.",0
string1 db "second string.",0

fputstring:         ;print string pointed to by eax register

push eax
push ebx
push ecx
push edx

mov ebx,eax             ;copy eax to ebx to be used as index to the string

fputstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0        ;compare byte at address ebx with 0
jz fputstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp fputstring_strlen_start

fputstring_strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

;Windows 32-bit WriteFile system call

push 0               ;lpOverlapped = NULL
push 0               ;lpNumberOfBytesWritten = NULL
push ebx             ;nNumberOfBytesToWrite = ebx
push eax             ;lpBuffer = address of string to write
push [fd]            ;hFile = [fd] handle of existing file
call [WriteFile]


pop edx
pop ecx
pop ebx
pop eax

ret

fseek:

;seek to 32-bit address of file with SetFilePointer function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-setfilepointer


push 0           ;dwMoveMethod = FILE_BEGIN -> seek from beginning of file
push 0           ;lpDistanceToMoveHigh = NULL: We are not using a 64 bit address
push [offset]    ;lDistanceToMove = [offset]
push [fd]        ;hFile = [fd] -> a file already opened
call [SetFilePointer]


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
 SetFilePointer, 'SetFilePointer',\
 ReadFile, 'ReadFile',\
 CloseHandle, 'CloseHandle'
