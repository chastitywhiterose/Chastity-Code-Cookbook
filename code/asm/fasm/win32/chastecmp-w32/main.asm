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
push [filename1]         ;lpFileName
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
push [filename2]         ;lpFileName
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
;this means any program involving reading these files can take place in this section
;for this reason, I also saved this as a template for future programs that need two files opened for reading
;the original purpose of this was designed for chastecmp, my hexadecimal file comparison tool

files_compare:

file_1_read_one_byte:
;read only 1 byte using Win32 ReadFile system call.
push 0           ;Optional Overlapped Structure 
push bytes_read  ;Store Number of Bytes Read from this call
push 1           ;Number of bytes to read
push byte1       ;address to store bytes
push [filedesc1] ;handle of the open file
call [ReadFile]

cmp [bytes_read],0
jnz file_2_read_one_byte ;unless zero bytes were read, proceed to read from next file

mov eax,[filename1]
call putstring
mov eax,end_of_file_string
call putstring

jmp main_end ;we have reach end of one file and should end program

file_2_read_one_byte:
;read only 1 byte using Win32 ReadFile system call.
push 0           ;Optional Overlapped Structure 
push bytes_read  ;Store Number of Bytes Read from this call
push 1           ;Number of bytes to read
push byte2       ;address to store bytes
push [filedesc2] ;handle of the open file
call [ReadFile]

cmp [bytes_read],0
jnz compare_bytes ;unless zero bytes were read, proceed to compare bytes from both files

mov eax,[filename2]
call putstring
mov eax,end_of_file_string
call putstring

jmp main_end ;we have reach end of one file and should end program

compare_bytes:

;store the two bytes into the 8 bit lower parts of eax and ebx for a byte comparison.
mov al,[byte1]
mov bl,[byte2]

;compare the two bytes and skip printing them if they are the same
cmp al,bl
jz same
call print_bytes_info
same:

inc [file_offset]

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

end_of_file_string db ' has reached EOF',0xD,0xA,0

help_message db 'chastecmp: compares two files in hexadecimal',0Ah
db 9,'chastecmp file1 file2',0Ah,0

;print the address and the bytes at that address
print_bytes_info:
mov eax,[file_offset]
mov [int_width],8
call putint
call putspace
mov [int_width],2
mov eax,0
mov al,[byte1]
call putint
call putspace
mov al,[byte2]
call putint
call putspace
call putline
ret

;variables for displaying messages
file_error_message db 'error: ',0

;variables for managing arguments
filename1 dd ? ; name of the file to be opened
filename2 dd ? ; name of the file to be opened
filedesc1 dd ? ; file descriptor
filedesc2 dd ? ; file descriptor
byte1 db ?
byte2 db ?
file_offset dd ?
bytes_read dd ? ;how many bytes are read with ReadFile operation

;FASM builds the Import Address Table (IAT) directly in the source file
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

