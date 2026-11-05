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

;optionally display the command string
;call putstring
;call putline

call getarg ;get next arg as file name
cmp eax,0   ;did the getarg function return 0?
jz help     ;if eax was zero, there are no args so we end the program safely after help message

;print the filename
call putstring
call putline

mov [filename], eax ;save the filename to a permanent address

jmp open_sesame

help:

mov eax,help_message
call putstring

jmp main_end

open_sesame:

;open a file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

;call CreateFileA with Windows 32-bit calling convention

push 0                  ;hTemplateFile = NULL: We are not using a template file
push 0x80               ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
push 3                  ;dwCreationDisposition = OPEN_EXISTING
push 0                  ;lpSecurityAttributes = NULL: No security attributes
push 1                  ;dwShareMode = FILE_SHARE_READ (other programs can read this file)
push 0x10000000         ;dwDesiredAccess = GENERIC_ALL access mode (Read+Write+Execute)
push [filename]         ;lpFileName
call [CreateFileA]


;check eax for file handle or error code
;call putint
cmp eax,-1
jnz file_ok

mov eax,file_error_message
call putstring
call [GetLastError]
call putint
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file_ok:

mov [fd],eax

;before we proceed, we also check for more arguments.

;get next arg (first one after name of program)
call getarg
cmp eax,0  ;did the getarg function return 0?
jz hexdump ;proceed to normal hex dump if no more args

;otherwise interpret the arg as a hex address to seek to

call strint
mov [offset],eax

;seek to 32-bit address of file with SetFilePointer function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-setfilepointer


push 0           ;seek from beginning of file (SEEK_SET)
push 0           ;NULL: We are not using a 64 bit address
push [offset]    ;where we are seeking to
push [fd]        ;seek within this file
call [SetFilePointer]


;check for more args after the address argument
call getarg
cmp eax,0
jz read_one_byte ;proceed to read one byte mode

;otherwise, write the rest of the arguments as bytes to the file!
write_bytes:
call strint
mov [buf],al

;Windows 32-bit WriteFile system call
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile


push 0               ;lpOverlapped = NULL
push 0               ;lpNumberOfBytesWritten = NULL
push 1               ;nNumberOfBytesToWrite = 1
push buf             ;lpBuffer = address of data to write
push [fd]            ;hFile = [fd] (copied there earlier)
call [WriteFile]


mov eax,[offset]
inc [offset]
mov [int_width],8
call putint_and_space

mov eax,0
mov al,[buf]
mov [int_width],2
call putint_and_line

;check for more args
call getarg ;get next arg as potential bytes to write
cmp eax,0   ;did the getarg function return 0?
jnz write_bytes
;continue write if the args still exist
;otherwise end program
jmp main_end

read_one_byte:

;read only 1 byte using Win32 ReadFile system call.


push 0              ;Optional Overlapped Structure 
push count     ;Store Number of Bytes Read from this call
push 1              ;Number of bytes to read
push buf     ;address to store bytes
push [fd]  ;handle of the open file
call [ReadFile]

cmp [count],1 
jz print_byte ;if less than one bytes read, there is an error

mov eax,[offset]
mov [int_width],8
call putint_and_space
mov eax,end_of_file
call putstr_and_line

jmp main_end

print_byte:
mov eax,[offset]
mov [int_width],8
call putint_and_space

mov eax,0
mov al,[buf]
mov [int_width],2
call putint_and_line

jmp main_end

hexdump:

;read bytes using Win32 ReadFile system call.
push 0              ;Optional Overlapped Structure 
push count     ;Store Number of Bytes Read from this call
push 16             ;Number of bytes to read
push buf     ;address to store bytes
push [fd]  ;handle of the open file
call [ReadFile]     ;all the data is in place, do the write thing!

mov eax,[count]
;call putint
;mov eax,buf
;call putstring

cmp eax,0
jnz read_ok ;if more than zero bytes read, proceed to display

jmp eof_end

read_ok:
call print_bytes_row

jmp hexdump

print_EOF:

mov eax,[offset]
mov [int_width],8
call putint_and_space

mov eax,end_of_file
call putstr_and_line

jmp main_end


eof_end:
;before we end the program, let the user know End Of File was reached
mov eax,end_of_file
call putstr_and_line

main_end:

;close the file
push [fd]
call [CloseHandle]

;Exit the process with code 0
push 0
call [ExitProcess]



;variables for displaying messages
file_error_message db 'error: ',0
end_of_file db 'EOF',0
read_error_message db 'Failure during reading of file. Error number: ',0

help_message db 'chastehex by Chastity White Rose',0Ah,0Ah
db 'hexdump a file:',0Ah,0Ah,9,'chastehex file',0Ah,0Ah
db 'read a byte:',0Ah,0Ah,9,'chastehex file address',0Ah,0Ah
db 'write a byte:',0Ah,0Ah,9,'chastehex file address value',0Ah,0Ah
db 'The file must exist',0Ah,0

;this function prints a row of hex bytes
;each row is 16 bytes
print_bytes_row:
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

mov ecx,[count]
pad_spaces:
cmp ecx,0x10
jz pad_spaces_end
mov eax,space_three
call putstring
inc ecx
jmp pad_spaces
pad_spaces_end:

;optionally, print chars after hex bytes
call print_bytes_row_text
call putline

ret

space_three db '   ',0

print_bytes_row_text:
mov ebx,buf
mov ecx,[count]
next_char:
mov eax,0
mov al,[ebx]

;if char is below '0' or above '9', it is outside the range of these and is not a digit
cmp al,0x20
jb not_printable
cmp al,0x7E
ja not_printable

printable:
;if char is in printable range,copy as is and proceed to next index
jmp next_index

not_printable:
mov al,'.' ;otherwise replace with placeholder value

next_index:
mov [ebx],al
inc ebx
dec ecx
cmp ecx,0
jnz next_char
mov [ebx],byte 0 ;make sure string is zero terminated

mov eax,buf
call putstring

ret

;variables for managing file IO.
filename dd ?
count dd ? ;how many bytes are read with ReadFile operation
buf db 16 dup ?,0
fd dd ?
offset dd ?

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
