format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'
include 'chasteiow32.asm'

main:

mov [radix],16 ; Choose radix for integer output.
mov [int_width],1
mov [int_newline],0 ;disable automatic printing of newlines after putint

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

;this section tries to obtain two arguments for filenames and same them for later

;get next arg (first one after name of program)
call get_next_arg
cmp eax,[arg_end]
jz help ;jump to help if we have no more args

mov [filename1],eax ; save the name of the first file we will open to read

call get_next_arg
cmp eax,[arg_end]
jz help ;jump to help if we have no more args

mov [filename2],eax ; save the name of the second file we will open to read

jmp arg_open_file_1 ;if no errors at this point, we will skip the help message because we have obtained both filenames

help:

mov eax,help_message
call putstring

jmp main_end ;end program after displaying help message explaining that two files must be given

arg_open_file_1:

mov eax,[filename1]
call putstring
call putline

;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
;https://learn.microsoft.com/en-us/windows/win32/secauthz/generic-access-rights

;open first file with the CreateFileA function

push 0           ;NULL: We are not using a template file
push 0x80        ;FILE_ATTRIBUTE_NORMAL
push 3           ;OPEN_EXISTING
push 0           ;NULL: No security attributes
push 0           ;NULL: Share mode irrelevant. Only this program reads the file.
push 0x80000000  ;GENERIC_READ access mode
push [filename1] ;
call [CreateFileA]

;check eax for file handle or error code
call open_check_error
cmp eax,-1
jz main_end

mov [filedesc1],eax ;first file is opened, save its handle

arg_open_file_2:

mov eax,[filename2]
call putstring
call putline

;open second file with the CreateFileA function

push 0           ;NULL: We are not using a template file
push 0x80        ;FILE_ATTRIBUTE_NORMAL
push 3           ;OPEN_EXISTING
push 0           ;NULL: No security attributes
push 0           ;NULL: Share mode irrelevant. Only this program reads the file.
push 0x80000000  ;GENERIC_READ access mode
push [filename2] ;
call [CreateFileA]

;check eax for file handle or error code
call open_check_error
cmp eax,-1
jz main_end

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

.end main

end_of_file_string db ' has reached EOF',0Ah,0

help_message db 'chastecmp: compares two files in hexadecimal',0Ah
db 9,'chastecmp file1 file2',0Ah,0

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


;these variables keep track of the argument string
arg_start  dd ? ;start of arg string
arg_end    dd ? ;address of the end of the arg string
arg_length dd ? ;length of arg string

;variables for managing arguments
argc dd ?
filename1 dd ? ; name of the file to be opened
filename2 dd ? ; name of the file to be opened
filedesc1 dd ? ; file descriptor
filedesc2 dd ? ; file descriptor
byte1 db ?
byte2 db ?
file_offset dd ?
bytes_read dd ? ;how many bytes are read with ReadFile operation
