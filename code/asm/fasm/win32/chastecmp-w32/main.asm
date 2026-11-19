format PE console
entry main

include 'win32a.inc'        ;includes standard Windows 32-bit definitions and macros
include 'chastelib-w32.asm' ;include standard library functions by Chastity
include 'getarg-w32.asm'    ;include Chastity's getarg function for command line arguments

main:

mov [radix],16 ; Choose radix for integer output.
mov [int_width],1

call getarg ;this first call will get the command string
cmp eax,0   ;did the getarg function return 0?
jz help     ;if eax was zero, there are no args so we end the program safely after help message

call getarg ;get next arg as file name
cmp eax,0   ;did the getarg function return 0?
jz help     ;if eax was zero, there are no args so we end the program safely after help message

mov [filename1],eax ; save the name of the first file we will open to read

call getarg ;get next arg as file name
cmp eax,0   ;did the getarg function return 0?
jz help     ;if eax was zero, there are no args so we end the program safely after help message

mov [filename2],eax ; save the name of the second file we will open to read

jmp open_sesame1 ;if no errors at this point, we will skip the help message because we have obtained both filenames

help:

mov eax,help_message
call putstring

jmp main_end ;end program after displaying help message explaining that two files must be given

open_sesame1:

mov eax,[filename1]
call putstring
call putline

;open a file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 32-bit calling convention

push 0                  ;hTemplateFile = NULL: We are not using a template file
push 0x80               ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
push 3                  ;dwCreationDisposition = OPEN_EXISTING
push 0                  ;lpSecurityAttributes = NULL: No security attributes
push 1                  ;dwShareMode = FILE_SHARE_READ (other programs can read this file)
push 0x80000000         ;dwDesiredAccess = GENERIC_READ access mode
push [filename1]        ;lpFileName
call [CreateFileA]

;check eax for file handle or error code
;call putint
cmp eax,-1
jnz file1_ok

mov eax,file_error_message
call putstring
call [GetLastError]
call putint
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file1_ok:

mov [filedesc1],eax

open_sesame2:

mov eax,[filename2]
call putstring
call putline

;open a file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 32-bit calling convention

push 0                  ;hTemplateFile = NULL: We are not using a template file
push 0x80               ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
push 3                  ;dwCreationDisposition = OPEN_EXISTING
push 0                  ;lpSecurityAttributes = NULL: No security attributes
push 1                  ;dwShareMode = FILE_SHARE_READ (other programs can read this file)
push 0x80000000         ;dwDesiredAccess = GENERIC_READ access mode
push [filename2]        ;lpFileName
call [CreateFileA]

;check eax for file handle or error code
;call putint
cmp eax,-1
jnz file2_ok

mov eax,file_error_message
call putstring
call [GetLastError]
call putint
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file2_ok:

mov [filedesc2],eax ;first file is opened, save its handle

;if this place of the code is reached, it means both files are open for reading
;we read 1 byte at a time from each file and compare them
;if either of the bytes can't be read, we have reached end of file

files_compare:

file_1_read_one_byte:
;read only 1 byte using Win32 ReadFile system call.
push 0           ;Optional Overlapped Structure 
push count1      ;Store Number of Bytes Read from this call
push 1           ;Number of bytes to read
push buf1        ;address to store bytes
push [filedesc1] ;handle of the open file
call [ReadFile]

cmp [count1],0
jnz file_2_read_one_byte ;unless zero bytes were read, proceed to read from next file

mov eax,[filename1]
call putstring
mov eax,end_of_file_string
call putstr_and_line

file_2_read_one_byte:
;read only 1 byte using Win32 ReadFile system call.
push 0           ;Optional Overlapped Structure 
push count2      ;Store Number of Bytes Read from this call
push 1           ;Number of bytes to read
push buf2        ;address to store bytes
push [filedesc2] ;handle of the open file
call [ReadFile]

cmp [count2],0
jnz check_both_bytes ;unless zero bytes were read, proceed to compare bytes from both files

mov eax,[filename2]
call putstring
mov eax,end_of_file_string
call putstr_and_line

jmp main_end ;we have reach end of one file and should end program

check_both_bytes:

;we add the number of bytes read from both files
;if this number is not 2, end program
mov eax,[count1]
add eax,[count2]
cmp eax,2
jnz main_end

compare_bytes:

mov al,[buf1]
mov bl,[buf2]

;compare the two bytes and skip printing them if they are the same
cmp al,bl
jz bytes_are_same

;print the address and the bytes at that address
mov eax,[offset]
mov dword[int_width],8
call putint_and_space
mov dword[int_width],2
mov eax,0
mov al,[buf1]
call putint_and_space
mov al,[buf2]
call putint_and_line

bytes_are_same:

inc dword[offset]

jmp files_compare

main_end:

;close the file
push [filedesc1]
call [CloseHandle]

push [filedesc2]
call [CloseHandle]

;Exit the process with code 0
push 0
call [ExitProcess]

;variables for displaying messages

help_message db 'chastecmp by Chastity White Rose',0xD,0xA
db 9,'chastecmp file1 file2',0xD,0xA
db 'Differing bytes are shown in hexadecimal',0xD,0xA
db 'until the EOF has been reached.',0xD,0xA,0

end_of_file_string db ' EOF',0
file_error_message db 'error: ',0

;variables for managing files and their bytes
filename1 dd ? ;name of the file 1 to be opened
filename2 dd ? ;name of the file 2 to be opened
filedesc1 dd ? ;file descriptor 1
filedesc2 dd ? ;file descriptor 2
buf1 db ?      ;store byte from file 1
buf2 db ?      ;store byte from file 2
count1 dd ?    ;how many bytes read from file 1
count2 dd ?    ;how many bytes read from file 1
offset dd ?    ;offset or address being read

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
