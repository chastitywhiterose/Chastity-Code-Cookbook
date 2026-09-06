format PE64 console
entry main

include 'win64ax.inc'       ;includes standard Windows 64-bit definitions and macros
include 'chastelib-w64.asm' ;include standard functions by Chastity
include 'getarg-w64.asm'

main:

mov [radix],16 ; Choose radix for integer output.
mov [int_width],1

call getarg ;this first call will get the command string
cmp rax,0 ;did the getarg function return 0?
jz help ;if eax was zero, there are no args so we end the program safely after help message

;optionally display the command string
;call putstring
;call putline

call getarg ;get next arg as file name
cmp rax,0 ;did the getarg function return 0?
jz help ;if eax was zero, there are no args so we end the program safely after help message

;print the filename
call putstring
call putline

mov [file_name], rax ;save the filename to a permanent address

jmp open_sesame

help:

mov eax,help_message
call putstring

jmp main_end

open_sesame:

;open a file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

; Prepare first 4 args in registers per Windows x64 calling convention
sub rsp, 56                 ; reserve 32-byte shadow + space for 3 extra args (3*8=24) = 56
mov rcx, [file_name]        ; lpFileName = filename to open
mov rdx, 0x10000000         ; dwDesiredAccess = GENERIC_ALL access mode (Read+Write)
mov r8, 1                   ; dwShareMode = FILE_SHARE_READ
mov r9, 0                   ; lpSecurityAttributes = NULL
mov qword [rsp+32], 3       ; dwCreationDisposition = OPEN_EXISTING (3)
mov qword [rsp+40], 0       ; dwFlagsAndAttributes = 0
mov qword [rsp+48], 0       ; hTemplateFile = NULL
call [CreateFileA]
add rsp, 56

;check eax for file handle or error code
;call putint
cmp rax,-1
jnz file_ok

mov rax,file_error_message
call putstring
call [GetLastError]
call putint
jmp main_end ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file_ok:

mov [file_handle],rax

;before we proceed, we also check for more arguments.

;get next arg (first one after name of program)
call getarg 
cmp rax,0 ;did the getarg function return 0?
jz hexdump ;proceed to normal hex dump if no more args

;otherwise interpret the arg as a hex address to seek to

call strint
mov [file_offset],rax

;seek to 64-bit address of file with SetFilePointerEx function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-setfilepointerex

sub rsp,40  ;align stack before Win API functions(required in windows 64-bit)
mov rcx, [file_handle]      ;seek within this file
mov rdx, [file_offset]      ;where we are seeking to
mov r8, 0                   ;NULL: We are not storing the result anywhere
mov r9, 0                   ;seek from beginning of file (SEEK_SET)
call [SetFilePointerEx]
add rsp,40  ;restore stack now that WinAPI calls are done

;check for more args after the address argument
call getarg ;get next arg as potential bytes to write
cmp rax,0 ;did the getarg function return 0?
jz read_one_byte ;proceed to read one byte mode becaus nothing to write

;otherwise, write the rest of the arguments as bytes to the file!
write_bytes:
call strint
mov [byte_array],al

;write only 1 byte using Win32 WriteFile system call.
push 0              ;Optional Overlapped Structure 
push 0              ;Optionally Store Number of Bytes Written
push 1              ;Number of bytes to write
push byte_array     ;address to store bytes
push [file_handle]  ;handle of the open file
call [WriteFile]

sub rsp,40  ;align stack before Win API functions(required in windows 64-bit)

mov rcx, [file_handle] ;handle of the open file
mov rdx,byte_array     ;address to write from
mov r8,1               ;write 1 byte
mov r9,0               ;NULL: don't store number of bytes written
mov qword [rsp + 32], 0 ; Parameter 5: Must be placed on the stack
call [WriteFile]

add rsp,40  ;restore stack now that WinAPI calls are done

mov rax,[file_offset]
inc [file_offset]
mov [int_width],8
call putint_and_space

mov eax,0
mov al,[byte_array]
mov [int_width],2
call putint_and_line

;check for more args
call getarg ;get next arg as potential bytes to write
cmp rax,0 ;did the getarg function return 0?
jnz write_bytes
;continue write if the args still exist
;otherwise end program
jmp main_end

read_one_byte:

;read only 1 byte using Win32 ReadFile system call.

sub rsp,40  ;align stack before Win API functions(required in windows 64-bit)

mov rcx,[file_handle]  ;handle of the open file
mov rdx,byte_array  ;address to store bytes
mov r8,1            ;Number of bytes to read
mov r9,bytes_read   ;Store Number of Bytes Read from this call
mov qword [rsp + 32], 0 ; Parameter 5: Must be placed on the stack
call [ReadFile]

add rsp,40  ;restore stack now that WinAPI calls are done


cmp [bytes_read],1 
jz print_byte ;if less than one bytes read, there is an error

mov rax,[file_offset]
mov [int_width],8
call putint_and_space
mov eax,end_of_file
call putstr_and_line

jmp main_end

print_byte:
mov rax,[file_offset]
mov [int_width],8
call putint_and_space

mov eax,0
mov al,[byte_array]
mov [int_width],2
call putint_and_line

jmp main_end

hexdump:

;read bytes using Win32 ReadFile system call.

sub rsp,40  ;align stack before Win API functions(required in windows 64-bit)

mov rcx,[file_handle]  ;handle of the open file
mov rdx,byte_array  ;address to store bytes
mov r8,16           ;Number of bytes to read
mov r9,bytes_read   ;Store Number of Bytes Read from this call
mov qword [rsp + 32], 0 ; Parameter 5: Must be placed on the stack
call [ReadFile]

add rsp,40  ;restore stack now that WinAPI calls are done

mov rax,[bytes_read]
;call putint
;mov eax,byte_array
;call putstring

cmp eax,0
jnz read_ok ;if more than zero bytes read, proceed to display

jmp eof_end

read_ok:
call print_bytes_row

jmp hexdump

print_EOF:

mov rax,[file_offset]
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
sub rsp,40
mov rcx,[file_handle]
call [CloseHandle]
add rsp,40

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0


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
mov rax,[file_offset]
mov [int_width],8
call putint_and_space

mov ebx,byte_array
mov rcx,[bytes_read]
add [file_offset],rcx
next_byte:
mov eax,0
mov al,[ebx]
mov [int_width],2
call putint_and_space

inc ebx
dec ecx
cmp ecx,0
jnz next_byte

mov rcx,[bytes_read]
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
mov ebx,byte_array
mov rcx,[bytes_read]
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

mov eax,byte_array
call putstring

ret




;variables for managing arguments
arg_start  dq ? ;start of arg string
arg_end    dq ? ;address of the end of the arg string
arg_length dq ? ;length of arg string
arg_spaces dq ? ;how many spaces exist in the arg command line

;variables for managing file IO.
file_name dq ?
bytes_read dq ? ;how many bytes are read with ReadFile operation
byte_array db 16 dup ?,0
file_handle dq ?
file_offset dq ?

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
 SetFilePointerEx, 'SetFilePointerEx',\
 ReadFile, 'ReadFile',\
 CloseHandle, 'CloseHandle'

