format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov [radix],16 ; Choose radix for integer output.
mov [int_width],1

;Open an existing file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 64-bit calling convention
sub rsp, 56             ;reserve 32-byte shadow + space for 3 extra args (3*8=24) = 56
mov qword [rsp+48],0    ;hTemplateFile = NULL: We are not using a template file
mov qword [rsp+40],0x80 ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
mov qword [rsp+32],3    ;dwCreationDisposition = OPEN_EXISTING
mov r9,0                ;lpSecurityAttributes = NULL: No security attributes
mov r8,1                ;dwShareMode = FILE_SHARE_READ (other programs can read this file)
mov rdx,0x10000000      ;dwDesiredAccess = GENERIC_ALL access mode (Read+Write+Execute)
mov rcx,filename        ;lpFileName
call [CreateFileA]
add rsp, 56             ;restore stack pointer now that API call is done

;check eax for file handle or error code
cmp rax,-1
jnz file_good

file_bad:
mov rax,file_error_message
call putstring
call [GetLastError]
call putint
call putline
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file_good:

mov [fd],rax
mov eax,filename
call putstring
call putline


loop0:

;Windows 64-bit ReadFile system call
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile

sub rsp,40           ;align stack for Win64 API calls
mov qword [rsp+32],0 ;lpOverlapped = NULL
mov r9,count         ;lpNumberOfBytesRead = count
mov r8,16            ;nNumberOfBytesToRead = 16
mov rdx,buf          ;lpBuffer = address of data to write
mov rcx,[fd]         ;hFile = [fd] (copied there earlier)
call [ReadFile]
add rsp,40           ;restore stack now that WinAPI calls are done

;if zero bytes were read, skip to end
cmp [count],0
jz main_end

;this section prints a row of hex bytes
;each row is 16 bytes in hexadecimal
print_hex_row:
mov rax,[offset]
mov [int_width],8
call putint_and_space

mov rbx,buf
mov rcx,[count]
add [offset],rcx
next_byte:
mov rax,0
mov al,[ebx]
mov [int_width],2
call putint_and_space

inc rbx
dec rcx
cmp rcx,0
jnz next_byte

call putline

jmp loop0 ;jump to loop0 and read next row of bytes

main_end:

mov eax,end_of_file
call putstring
call putline

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
end_of_file db 'EOF',0

;variables for managing file IO.
filename db "byte.bin",0
fd dq 0             ;file descriptor
count dq 0          ;used to store number of bytes read in last ReadFile call
offset dq 0         ;stores the current address in the file
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
