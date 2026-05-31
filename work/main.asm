;chastext is a generic find and replace program for text files
;using it is very simple because it only requires 3 arguments
;
;chastext filename "search string" "replacement string"
;
;It does not do regular expressions like sed but it is useful
;I use it when I need to change the name of a variable in a program
;or when I am modifying configuration files.

format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'
include 'getargw32.asm'

main:

mov [radix],10 ; Choose radix for integer output.
mov [int_width],1

call getarg ;this first call will get the command string
cmp eax,0 ;did the getarg function return 0?
jnz args_exist

mov eax,help    ;if no arguments were given, show a help message
call putstring
jmp ending     ;and end the program because there is nothing to do

args_exist:

call getarg
mov [filename],eax
;call putstr_and_line ;print filename before text output (for debugging)

;This is where the main part of the chastext program really begins.;

;now that the argument string is prepared, we will try to use the first argument as a filename to open

;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
;https://learn.microsoft.com/en-us/windows/win32/secauthz/generic-access-rights

;open first file with the CreateFileA function

push 0           ;NULL: We are not using a template file
push 0x80        ;FILE_ATTRIBUTE_NORMAL
push 3           ;OPEN_EXISTING
push 0           ;NULL: No security attributes
push 0           ;NULL: Share mode irrelevant. Only this program reads the file.
push 0x80000000  ;GENERIC_READ access mode
push [filename] ;
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

mov [filedesc],eax

;before we proceed, we also check for more arguments.

call getarg ;this first call will get the command string
cmp eax,0 ;if 0, no search string argument
jz textdump ;jump to textdump section

;otherwise, we save the address at ax to our search string
mov [string_search],eax
;call putstr_and_line

call getarg ;this first call will get the command string
cmp eax,0 ;if 0, no replacement string argument
jz textdump ;jump to textdump section

;otherwise, we save the address at eax to our replacement string
mov [string_replace],eax
;call putstr_and_line

;all other arguments that may exist after this are irrelevant

textdump:

;this is the beginning of the textdump main loop of chastext

;first, check to see if there is a search string
;if there is a search string, skip the normal putchar

cmp dword[string_search],0 ;do we have a search string?
jnz search_mode

;but if there is not a search string
;we will read one character, then display it to stdout
;and then jump to the beginning of the textdump loop to print them until EOF

;This loop is the same as the Linux 'cat' command
;or the DOS 'type' command

;read only 1 byte using Win32 ReadFile system call.
cat:
push 0              ;Optional Overlapped Structure 
push bytes_read     ;Store Number of Bytes Read from this call
push 1              ;Number of bytes to read
push byte_array     ;address to store bytes
push [filedesc]     ;handle of the open file
call [ReadFile]

mov eax,[bytes_read]

cmp eax,1        ;check to see if exactly 1 byte was read
jz file_success ;if true, proceed to display
;mov ax,end_of_file
;call putstring
jmp main_end ;otherwise close the file and end program after failure

; this point is reached if 1 byte was read from the file successfully
file_success:

mov al,[byte_array]
call putchar
jmp cat

;if search string doesn't exist, just jump and repeat the loop
;otherwise we continue into the next section that compares the input with the search string

search_mode:

;this is the beginning of search mode
;it handles the file by seeking and reading to search every position for the search string

;first, seek to the file_address we initialized to zero
;this variable will be added to depending on actions taken

;seek to address of file with SetFilePointer function
;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-setfilepointer
push 0             ;seek from beginning of file (SEEK_SET)
push 0             ;NULL: We are not using a 64 bit address
push [file_address] ;where we are seeking to
push [filedesc] ;seek within this file
call [SetFilePointer]

;obtain the length of the search string using my strlen function
mov eax,[string_search]
call strlen ;get the length of the search string

mov ecx,eax ;store this length in ecx
mov [search_length],ecx

;call putint_and_line ;check length of search string

;use the length of the string we are searching for as the number of bytes to read at this location

;Win32 ReadFile system call.
push 0              ;Optional Overlapped Structure 
push bytes_read     ;Store Number of Bytes Read from this call
push ecx            ;Number of bytes to read
push byte_array     ;address to store bytes
push [filedesc]     ;handle of the open file
call [ReadFile]

mov eax,[bytes_read]  ;get how many bytes were read with that last read operation

mov ebx,byte_array    ;move the address of bytes read into bx
add ebx,eax           ;add number of bytes read (return value of read function in eax)
mov byte[ebx],0       ;terminate the string with zero

cmp eax,[search_length] ;if the number of bytes is not what we expected to read, end this loop
jnz textdump_end

;move our two strings into the esi and edi registers for comparison
;with my custom written strcmp function

mov esi,[string_search]
mov edi,byte_array
call strcmp ;compare these two strings

cmp eax,0 ;test if they are the same (if eax returned zero)
jnz not_match ;if they are not a match go to that section for printing a character

;but if they are a match, then we either quote them
;or replace them if a replacement string is available

;but regardless of which action we do, since a match was found, let us add this count to the file address
;so that we read from beyond this point next time the textdump loop starts
mov eax,[bytes_read]
add [file_address],eax

cmp dword[string_replace],0 ;check to see if a replacement string is available
jz print_quotes ;if not, skip to the part where we just quote the strings that match

;otherwise, we will print the replacement string instead of the original!

mov eax,[string_replace]
call putstring ;print the string

jmp textdump ;restart the main loop

print_quotes:
;print quotes around matched string
mov al,'"'
call putchar

mov eax,byte_array
call putstring ;print the string

mov al,'"'
call putchar

jmp textdump ;restart the main loop

not_match: 

;Instead of calling the putchar function in the case of no match,
;I do a system call to print 1 byte to standard output
;This is simple and also compatible with binary files we want to replace text in.
;But it only works if the search and replace strings are of the same length

;Write 1 byte using Win32 WriteFile system call.
push 0              ;Optional Overlapped Structure 
push 0              ;Optionally Store Number of Bytes Written
push 1              ;Number of bytes to write
push byte_array     ;address of string to print
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [WriteFile]    ;all the data is in place, do the write thing!

add [file_address],1 ;add 1 to the file address so we don't read this same position again

jmp textdump

textdump_end:

;print the remaining bytes, if any, left after the main loop ended
;however many were read in the last read call will be written

push 0              ;Optional Overlapped Structure 
push 0              ;Optionally Store Number of Bytes Written
push [bytes_read]   ;Number of bytes to write
push byte_array     ;address of string to print
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [WriteFile]    ;all the data is in place, do the write thing!

main_end:

;this is the end of the program
;we close the open file and then use the exit call

;close the file
push [filedesc]
call [CloseHandle]


ending:
;Exit the process with code 0
push 0
call [ExitProcess]

.end main

arg_string_index  dd 0 ;start of arg string
arg_string_end    dd 0 ;address of the end of the arg string


;the strlen and strcmp are named after the equivalent C functions
;but are written from scratch by me based on their expected behavior

;a function to get the length of string in eax and return the integer in eax

strlen:

mov ebx,eax ; copy eax to ebx. ebx will be used as index to the string

strlen_start: ; this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp strlen_start

strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

mov eax,ebx ;copy the string length back to eax

ret

;strcmp compares the string at esi to the one at edi
;ax returns 0 if the strings are the same and 1 if different
;the algorithm is simple but I will explain it for those who are confused

;eax is initialized to zero
;a byte from each string is loaded into the al and bl registers
;the bytes are compared. if they are different, then we jump to the end
;However, if they are the same, then we check if one of them is zero
;for this purpose it doesn't matter whether we compare al or bl with zero
;because it is known that they are the same if the jnz did not take place
;if it is zero, this also jumps to the end of the function
;If neither jump took place, then we jump to the start of the loop
;but when the function finally ends bl will be subtracted from al
;this ensures that the function returns zero if the final characters are the same

strcmp:

mov eax,0

strcmp_start:

;read a byte from each string
mov al,[edi]
mov bl,[esi]
cmp al,bl
jnz strcmp_end

cmp al,0
jz strcmp_end

inc edi
inc esi

jmp strcmp_start

strcmp_end:
sub al,bl

ret

help db 'chastext by Chastity White Rose',0Dh,0Ah
db '"cat" or "type" a file without changing it:',0Dh,0Ah,9,'chastext file',0Dh,0Ah
db 'search for a string and quote it:',0Dh,0Ah,9,'chastext file search',0Dh,0Ah
db 'replace string:',0Dh,0Ah,9,'chastext file search replace',0Dh,0Ah
db 'Find or replace any string!',0Dh,0Ah,0

file_error_message db 'Could not open the file! Error number: ',0
filename dd 0
filedesc dd 0
file_address dd 0 ;file address defaults to zero AKA beginning of file
end_of_file db 'EOF',0

;where we will store data from the file
bytes_read dd 0

search_length dd 0
string_search dd 0 ; place to hold the search string pointer
string_replace dd 0 ; place to hold the replacement string pointer

byte_array db 0x73 dup 0
