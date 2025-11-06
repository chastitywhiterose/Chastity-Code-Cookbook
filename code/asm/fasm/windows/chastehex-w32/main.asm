format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'

main:

mov [radix],16 ; Choose radix for integer output.
mov [int_width],1

;get command line argument string
call [GetCommandLineA]

mov [arg_start],eax ;store start of arg string

;short routine to find the length of the string
;and whether arguments are present
mov ebx,eax
find_arg_length:
cmp [ebx], byte 0
jz found_arg_length
inc ebx
jmp find_arg_length
found_arg_length:
;at this point, ebx has the address of last byte in string which contains a zero
;we will subtract to get and store the length of the string
mov [arg_end],ebx
sub ebx,eax
mov eax,ebx
mov [arg_length],eax

;display the arg string to make sure it is working correctly
;mov eax,[arg_start]
;call putstring
;call putline

;print the length in bytes of the arg string
;mov eax,[arg_length]
;call putint

;this loop will filter the string, replacing all spaces with zero
mov ebx,[arg_start]
arg_filter:
cmp byte [ebx],' '
ja notspace ; if char is above space, leave it alone
mov byte [ebx],0 ;otherwise it counts as a space, change it to a zero
notspace:
inc ebx
cmp ebx,[arg_end]
jnz arg_filter

arg_filter_end:

;optionally print first arg (name of program)
;mov eax,[arg_start]
;call putstring
;call putline

;get next arg (first one after name of program)
call get_next_arg
cmp eax,[arg_end]
jz help

mov [file_name],eax
mov eax,file_open_message
call putstring
mov eax,[file_name]
call putstring
call putline

jmp open_sesame

help:

mov eax,help_message
call putstring

jmp args_none

open_sesame:

;open a file with the CreateFileA function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea

push 0           ;NULL: We are not using a template file
push 0x80        ;FILE_ATTRIBUTE_NORMAL
push 3           ;OPEN_EXISTING
push 0           ;NULL: No security attributes
push 0           ;NULL: Share mode irrelevant. Only this program reads the file.
push 0x10000000  ;GENERIC_ALL access mode (Read+Write)
push [file_name] ;
call [CreateFileA]

;check eax for file handle or error code
;call putint
cmp eax,-1
jnz file_ok

mov eax,file_error_message
call putstring
call [GetLastError]
call putint
jmp args_none ;end program if the file was not opened

;this label is jumped to when the file is opened correctly
file_ok:

mov [file_handle],eax

mov [int_newline],0 ;disable automatic printing of newlines after putint
;we will be manually printing spaces or newlines depending on context

;before we proceed, we also check for more arguments.

;get next arg (first one after name of program)
call get_next_arg
cmp eax,[arg_end]
jz hexdump ;proceed to normal hex dump if no more args

;otherwise interpret the arg as a hex address to seek to

call strint
mov [file_offset],eax
mov eax,file_seek_message
call putstring
mov eax,[file_offset]
call putint
call putline

;seek to address of file with SetFilePointer function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-setfilepointer
push 0             ;seek from beginning of file (SEEK_SET)
push 0             ;NULL: We are not using a 64 bit address
push [file_offset] ;where we are seeking to
push [file_handle] ;seek within this file
call [SetFilePointer]

;check for more args
call get_next_arg
cmp eax,[arg_end]
jz read_one_byte ;proceed to read one byte mode

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

mov eax,[file_offset]
inc [file_offset]
mov [int_width],8
call putint
call putspace

mov eax,0
mov al,[byte_array]
mov [int_width],2
call putint
call putline

;check for more args
call get_next_arg
cmp eax,[arg_end]
jnz write_bytes
;continue write if the args still exist
;otherwise end program
jmp args_none

read_one_byte:

;read only 1 byte using Win32 ReadFile system call.
push 0              ;Optional Overlapped Structure 
push bytes_read     ;Store Number of Bytes Read from this call
push 1              ;Number of bytes to read
push byte_array     ;address to store bytes
push [file_handle]  ;handle of the open file
call [ReadFile]

cmp [bytes_read],1 
jb print_EOF ;if less than one bytes read, there is an error

mov eax,[file_offset]
mov [int_width],8
call putint
call putspace

mov eax,0
mov al,[byte_array]
mov [int_width],2
call putint
call putline

jmp args_none

hexdump:

;read bytes using Win32 ReadFile system call.
push 0              ;Optional Overlapped Structure 
push bytes_read     ;Store Number of Bytes Read from this call
push 16             ;Number of bytes to read
push byte_array     ;address to store bytes
push [file_handle]  ;handle of the open file
call [ReadFile]     ;all the data is in place, do the write thing!

mov eax,[bytes_read]
;call putint
;mov eax,byte_array
;call putstring

cmp [bytes_read],1 
jb print_EOF ;if less than one bytes read, there is an error

call print_bytes_row

jmp hexdump

print_EOF:

mov eax,[file_offset]
mov [int_width],8
call putint
call putspace

mov eax,end_of_file
call putstring
call putline

jmp args_none




;this loop is very safe because it only prints arguments if they are valid
;if the end of the args are reached by comparison of eax with [arg_end]
;then it will jump to args_none and proceed from there
args_list:
call get_next_arg
cmp eax,[arg_end]
jz args_none
call putstring
call putline
jmp args_list
args_none:

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

arg_start  dd 0 ;start of arg string
arg_end    dd 0 ;address of the end of the arg string
arg_length dd 0 ;length of arg string
arg_spaces dd 0 ;how many spaces exist in the arg command line

;variables for managing file IO.
file_name dd 0
bytes_read dd 0 ;how many bytes are read with ReadFile operation
byte_array db 16 dup '?',0
file_handle dd 0
file_offset dd 0

;variables for displaying messages
file_open_message db 'opening: ',0
file_seek_message db 'seek: ',0
file_error_message db 'error: ',0
end_of_file db 'EOF',0
read_error_message db 'Failure during reading of file. Error number: ',0

help_message db 'Welcome to chastehex! The tool for reading and writing bytes of a file!',0Ah,0Ah
db 'To hexdump an entire file:',0Ah,0Ah,9,'chastehex file',0Ah,0Ah
db 'To read a single byte at an address:',0Ah,0Ah,9,'chastehex file address',0Ah,0Ah
db 'To write a single byte at an address:',0Ah,0Ah,9,'chastehex file address value',0Ah,0Ah
db 'The file must exist before you launch the program.',0Ah
db 'This design was to prevent accidentally opening a mistyped filename.',0Ah,0

;function to move ahead to the next art
;only works after the filter has been applied to turn all spaces into zeroes
get_next_arg:
mov ebx,[arg_start]
find_zero:
cmp byte [ebx],0
jz found_zero
inc ebx
jmp find_zero ; this char is not zero, go to the next char
found_zero:

find_non_zero:
cmp ebx,[arg_end]
jz arg_finish ;if ebx is already at end, nothing left to find
cmp byte [ebx],0
jnz arg_finish ;if this char is not zero we have found the next string!
inc ebx
jmp find_non_zero ;otherwise, keep looking

arg_finish:
mov [arg_start],ebx ; save this index to variable
mov eax,ebx ;but also save it to ax register for use
ret
;we can know that there are no more arguments when
;the either [arg_start] or eax are equal to [arg_end]



;this function prints a row of bytes
;each row is 16 bytes
print_bytes_row:
mov eax,[file_offset]
mov [int_width],8
call putint
call putspace

mov ebx,byte_array
mov ecx,[bytes_read]
add [file_offset],ecx
next_byte:
mov eax,0
mov al,[ebx]
mov [int_width],2
call putint
call putspace

inc ebx
dec ecx
cmp ecx,0
jnz next_byte

call putline

ret
