format PE64 console
entry main

include 'win64a.inc'        ;includes standard Windows 32-bit definitions and macros
include 'chastelib-w64.asm' ;include standard library functions by Chastity
include 'getarg-w64.asm'    ;include Chastity's getarg function for command line arguments

main:

mov [radix],16 ; Choose radix for integer output.
mov [int_width],1

call getarg ;this first call will get the command string
cmp rax,0   ;did the getarg function return 0?
jz help     ;if rax was zero, there are no args so we end the program safely after help message

call getarg ;get next arg as file name
cmp rax,0   ;did the getarg function return 0?
jz help     ;if rax was zero, there are no args so we end the program safely after help message

mov [filename1],rax ; save the name of the first file we will open to read

call getarg ;get next arg as file name
cmp rax,0   ;did the getarg function return 0?
jz help     ;if rax was zero, there are no args so we end the program safely after help message

mov [filename2],rax ; save the name of the second file we will open to read

jmp open_sesame1 ;if no errors at this point, we will skip the help message because we have obtained both filenames

help:

mov rax,help_message
call putstring

jmp main_end ;end program after displaying help message explaining that two files must be given

open_sesame1:

mov rax,[filename1]
call putstring
call putline

;open a file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 64-bit calling convention
sub rsp, 56             ;reserve 32-byte shadow + space for 3 extra args (3*8=24) = 56
mov qword [rsp+48],0    ;hTemplateFile = NULL: We are not using a template file
mov qword [rsp+40],0x80 ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
mov qword [rsp+32],3    ;dwCreationDisposition = OPEN_EXISTING
mov r9,0                ;lpSecurityAttributes = NULL: No security attributes
mov r8,1                ;dwShareMode = FILE_SHARE_READ (other programs can read this file)
mov rdx,0x80000000      ;dwDesiredAccess = GENERIC_READ access mode
mov rcx,[filename1]     ;lpFileName
call [CreateFileA]
add rsp, 56             ;restore stack pointer now that API call is done

;check rax for file handle or error code
;call putint
cmp rax,-1
jnz file1_ok

mov rax,file_error_message
call putstring
call [GetLastError]
call putint
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file1_ok:

mov [filedesc1],rax

open_sesame2:

mov rax,[filename2]
call putstring
call putline

;open a file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 64-bit calling convention
sub rsp, 56             ;reserve 32-byte shadow + space for 3 extra args (3*8=24) = 56
mov qword [rsp+48],0    ;hTemplateFile = NULL: We are not using a template file
mov qword [rsp+40],0x80 ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
mov qword [rsp+32],3    ;dwCreationDisposition = OPEN_EXISTING
mov r9,0                ;lpSecurityAttributes = NULL: No security attributes
mov r8,1                ;dwShareMode = FILE_SHARE_READ (other programs can read this file)
mov rdx,0x80000000      ;dwDesiredAccess = GENERIC_READ access mode
mov rcx,[filename2]     ;lpFileName
call [CreateFileA]
add rsp, 56             ;restore stack pointer now that API call is done

;check rax for file handle or error code
;call putint
cmp rax,-1
jnz file2_ok

mov rax,file_error_message
call putstring
call [GetLastError]
call putint
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file2_ok:

mov [filedesc2],rax ;first file is opened, save its handle

;if this place of the code is reached, it means both files are open for reading
;we read 1 byte at a time from each file and compare them
;if either of the bytes can't be read, we have reached end of file

files_compare:

file_1_read_one_byte:

sub rsp,40  ;align stack before Win API functions(required in windows 64-bit)

mov rcx,[filedesc1] ;handle of the open file
mov rdx,buf1        ;address to store bytes
mov r8,1            ;Number of bytes to read
mov r9,count1       ;Store Number of Bytes Read from this call
mov qword[rsp+32],0 ;Parameter 5: Must be placed on the stack
call [ReadFile]

add rsp,40  ;restore stack now that WinAPI calls are done

cmp [count1],0
jnz file_2_read_one_byte ;unless zero bytes were read, proceed to read from next file

mov rax,[filename1]
call putstring
mov rax,end_of_file_string
call putstr_and_line

file_2_read_one_byte:

sub rsp,40  ;align stack before Win API functions(required in windows 64-bit)

mov rcx,[filedesc2] ;handle of the open file
mov rdx,buf2        ;address to store bytes
mov r8,1            ;Number of bytes to read
mov r9,count2       ;Store Number of Bytes Read from this call
mov qword[rsp+32],0 ;Parameter 5: Must be placed on the stack
call [ReadFile]

add rsp,40  ;restore stack now that WinAPI calls are done

cmp [count2],0
jnz check_both_bytes ;unless zero bytes were read, proceed to compare bytes from both files

mov rax,[filename2]
call putstring
mov rax,end_of_file_string
call putstr_and_line

jmp main_end ;we have reach end of one file and should end program

check_both_bytes:

;we add the number of bytes read from both files
;if this number is not 2, end program
mov rax,[count1]
add rax,[count2]
cmp rax,2
jnz main_end

compare_bytes:

mov al,[buf1]
mov bl,[buf2]

;compare the two bytes and skip printing them if they are the same
cmp al,bl
jz bytes_are_same

;print the address and the bytes at that address
mov rax,[offset]
mov dword[int_width],8
call putint_and_space
mov dword[int_width],2
mov rax,0
mov al,[buf1]
call putint_and_space
mov al,[buf2]
call putint_and_line

bytes_are_same:

inc dword[offset]

jmp files_compare

main_end:

;close the file
sub rsp,40
mov rcx,[filedesc1]
call [CloseHandle]
mov rcx,[filedesc2]
call [CloseHandle]
add rsp,40

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

;variables for displaying messages

help_message db 'chastecmp by Chastity White Rose',0xD,0xA
db 9,'chastecmp file1 file2',0xD,0xA
db 'Differing bytes are shown in hexadecimal',0xD,0xA
db 'until the EOF has been reached.',0xD,0xA,0

end_of_file_string db ' EOF',0
file_error_message db 'error: ',0

;variables for managing files and their bytes
filename1 dq ? ;name of the file 1 to be opened
filename2 dq ? ;name of the file 2 to be opened
filedesc1 dq ? ;file descriptor 1
filedesc2 dq ? ;file descriptor 2
buf1 db ?      ;store byte from file 1
buf2 db ?      ;store byte from file 2
count1 dq ?    ;how many bytes read from file 1
count2 dq ?    ;how many bytes read from file 1
offset dq ?    ;offset or address being read

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
