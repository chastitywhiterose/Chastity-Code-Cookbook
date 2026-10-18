format PE console
entry main

include 'win32a.inc'
include 'chastelib-w32.asm'

main:

mov [radix],16 ; Choose radix for integer output.
mov [int_width],1

;Open an existing file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 32-bit calling convention

push 0                  ;hTemplateFile = NULL: We are not using a template file
push 0x80               ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
push 3                  ;dwCreationDisposition = OPEN_EXISTING
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
call putline
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file_good:

mov [fd],eax
mov eax,filename
call putstring
call putline


loop0:

;Windows 32-bit ReadFile system call
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile


push 0               ;lpOverlapped = NULL
push count           ;lpNumberOfBytesRead = count
push 16              ;nNumberOfBytesToRead = 16
push buf             ;lpBuffer = address of data to write
push [fd]            ;hFile = [fd] (copied there earlier)
call [ReadFile]

;if zero bytes were read, skip to end
cmp [count],0
jz main_end

;this section prints a row of hex bytes
;each row is 16 bytes in hexadecimal
print_hex_row:
mov eax,[offset]
mov [int_width],8
call putint_and_space

mov ebx,buf
mov ecx,[count]
add [offset],ecx
next_byte:
mov eax,0
mov al,[ebx]
mov [int_width],2
call putint_and_space

inc ebx
dec ecx
cmp ecx,0
jnz next_byte

call putline

jmp loop0 ;jump to loop0 and read next row of bytes

main_end:

mov eax,end_of_file
call putstring
call putline

;close the file

push [fd]
call [CloseHandle]


;Exit the process with code 0
push 0
call [ExitProcess]

;variables for error messages
file_error_message db 'error: ',0
end_of_file db 'EOF',0

;variables for managing file IO.
filename db "byte.bin",0
fd dd 0             ;file descriptor
count dd 0          ;used to store number of bytes read in last ReadFile call
offset dd 0         ;stores the current address in the file
buf db 16 dup '?',0 ;buffer to store bytes read from file

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 GetCommandLineA, 'GetCommandLineA',\
 CreateFileA, 'CreateFileA',\
 GetLastError, 'GetLastError',\
 ReadFile, 'ReadFile',\
 CloseHandle, 'CloseHandle'
