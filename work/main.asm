;Linux 32-bit Assembly Source for chastecmp
format ELF executable
entry main

main:

;radix will be 16 because this whole program is about hexadecimal
mov [radix],16 ; can choose radix for integer input/output!
mov [int_width],1

pop eax
mov [argc],eax ;save the argument count for later

;first arg is the name of the program. we skip past it
pop eax
dec [argc]
mov eax,[argc]

cmp eax,2
jb help
mov [file_offset],0 ;assume the offset is 0,beginning of file
jmp arg_open_file_1

help:
mov eax,help_message
call putstring
jmp main_end

arg_open_file_1:
pop eax
mov [filename1],eax ; save the name of the file we will open to read

call putstring ;print the name of the file we will try opening

mov ecx,0   ;open file in read mode 
mov ebx,eax ;filename should be in eax before this function was called
mov eax,5   ;invoke SYS_OPEN (kernel opcode 5)
int 80h     ;call the kernel

cmp eax,0
js file_error_display ;end program if the file can't be opened
mov [filedesc1],eax ; save the file descriptor number for later use
mov eax,file_open
call putstr_and_line

arg_open_file_2:
pop eax
mov [filename2],eax ; save the name of the file we will open to read

call putstring ;print the name of the file we will try opening

mov ecx,0   ;open file in read mode 
mov ebx,eax ;filename should be in eax before this function was called
mov eax,5   ;invoke SYS_OPEN (kernel opcode 5)
int 80h     ;call the kernel

cmp eax,0
js file_error_display ;end program if the file can't be opened
mov [filedesc2],eax ; save the file descriptor number for later use
mov eax,file_open
call putstr_and_line

files_compare:

file_1_read_one_byte:
mov edx,1          ;number of bytes to read
mov ecx,byte1 ;address to store the bytes
mov ebx,[filedesc1] ;move the opened file descriptor into EBX
mov eax,3          ;invoke SYS_READ (kernel opcode 3)
int 80h            ;call the kernel

;eax will have the number of bytes read after system call
mov [file_1_bytes_read],eax ;we save the number of bytes read for later
cmp eax,0
jnz file_2_read_one_byte ;unless zero bytes were read, proceed to read from next file

mov eax,[filename1]
call putstring
mov eax,end_of_file_string
call putstring

;jmp main_end ;we have reach end of one file and should end program

;Even if we have reached the end of the first file,
;we still proceed to read a byte from the second file
;to see if it also ends at the same address

file_2_read_one_byte:
mov edx,1          ;number of bytes to read
mov ecx,byte2 ;address to store the bytes
mov ebx,[filedesc2] ;move the opened file descriptor into EBX
mov eax,3          ;invoke SYS_READ (kernel opcode 3)
int 80h            ;call the kernel

;eax will have the number of bytes read after system call
mov [file_2_bytes_read],eax ;we save the number of bytes read for later
cmp eax,0
jnz check_both_bytes ;unless zero bytes were read, proceed to compare bytes from both files

mov eax,[filename2]
call putstring
mov eax,end_of_file_string
call putstring

jmp main_end ;we have reach end of one file and should end program

check_both_bytes:

;we add the number of bytes read from both files
mov eax,[file_1_bytes_read]
add eax,[file_2_bytes_read]
cmp eax,2
jnz main_end

compare_bytes:

mov al,[byte1]
mov bl,[byte2]

;compare the two bytes and skip printing them if they are the same
cmp al,bl
jz same
call print_bytes_info
same:

inc [file_offset]

jmp files_compare

file_error_display:

mov eax,file_error
call putstr_and_line

main_end:

;this is the end of the program
;we close the open files and then use the exit call

mov ebx,[filedesc1] ;file number to close
mov eax,6   ;invoke SYS_CLOSE (kernel opcode 6)
int 80h     ;call the kernel

mov ebx,[filedesc2] ;file number to close
mov eax,6   ;invoke SYS_CLOSE (kernel opcode 6)
int 80h     ;call the kernel

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

;print the address and the bytes at that address
print_bytes_info:
mov eax,[file_offset]
mov [int_width],8
call putint_and_space
mov [int_width],2
mov eax,0
mov al,[byte1]
call putint_and_space
mov al,[byte2]
call putint_and_line
ret

;variables for displaying information

help_message db 'chastecmp: compares two files in hexadecimal',0Ah
db 9,'chastecmp file1 file2',0Ah
db 'The bytes of the files are compared until EOF of either is reached.',0Ah,0

file_open db ' opened',0
file_error db ' error',0
end_of_file_string db ' EOF',0Ah,0


;in this section, only the relevant functions from chastelib32.asm were copied over

;the strint function from chastelib32.asm has been excluded for this program
;unlike in chastehex, we are not reading strings to get numbers.
;We are only outputting byte numbers by converting them to strings with intstr

;the next utility functions simply print a space or a newline
;these help me save code when printing lots of things for debugging

stdout dd 1 ; variable for standard output so that it can theoretically be redirected

putstring:

push eax
push ebx
push ecx
push edx

mov ebx,eax ; copy eax to ebx. ebx will be used as index to the string

putstring_strlen_start: ; this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz putstring_strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

;Write string using Linux Write system call.
;Reference for 32 bit x86 syscalls is below.
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit

mov edx,ebx      ;number of bytes to write
mov ecx,eax      ;pointer/address of string to write
mov ebx,[stdout] ;write to the STDOUT file
mov eax, 4       ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h          ;system call to write the message

pop edx
pop ecx
pop ebx
pop eax

ret ; this is the end of the putstring function return to calling location

; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 32 dup '?' ;enough bytes to hold maximum size 32-bit binary integer

int_string_end db 0 ;zero byte terminator for the integer string

radix dd 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dd 8

;this function creates a string of the integer in eax
;it uses the above radix variable to determine base from 2 to 36
;it then loads eax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov ebx,int_string_end-1 ;find address of lowest digit(just before the newline 0Ah)
mov ecx,1

digits_start:

mov edx,0;
div dword [radix]
cmp edx,10
jb decimal_digit
jae hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add edx,'0'
jmp save_digit

hexadecimal_digit:
sub edx,10
add edx,'A'

save_digit:

mov [ebx],dl
cmp eax,0
jz intstr_end
dec ebx
inc ecx
jmp digits_start

intstr_end:

prefix_zeros:
cmp ecx,[int_width]
jnb end_zeros
dec ebx
mov [ebx],byte '0'
inc ecx
jmp prefix_zeros
end_zeros:

mov eax,ebx ; now that the digits have been written to the string, display it!

ret

; function to print string form of whatever integer is in eax
; The radix determines which number base the string form takes.
; Anything from 2 to 36 is a valid radix
; in practice though, only bases 2,8,10,and 16 will make sense to other programmers
; this function does not process anything by itself but calls the combination of my other
; functions in the order I intended them to be used.

putint: 

push eax
push ebx
push ecx
push edx

call intstr

call putstring

pop edx
pop ecx
pop ebx
pop eax

ret

;The utility functions below simply print a space or a newline.
;these help me save code when printing lots of strings and integers.

space db ' ',0
line db 0Dh,0Ah,0

putspace:
push eax
mov eax,space
call putstring
pop eax
ret

putline:
push eax
mov eax,line
call putstring
pop eax
ret

;a function for printing a single character that is the value of al

char: db 0,0

putchar:
push eax
mov [char],al
mov eax,char
call putstring
pop eax
ret

;a small function just for the common operation
;printing an integer followed by a space
;this saves a few bytes in the assembled code
;by reducing the number of function calls in the main program

putint_and_space:
call putint
call putspace
ret

;a small function just for the common operation
;printing an integer followed by a line feed
;this saves a few bytes in the assembled code
;by reducing the number of function calls in the main program

putint_and_line:
call putint
call putline
ret

;a small function just for the common operation
;printing a string followed by a line feed
;this saves a few bytes in the assembled code
;by reducing the number of function calls in the main program
;it also means we don't need to include a newline in every string!

putstr_and_line:
call putstring
call putline
ret

;variables for managing arguments and files
argc dd ?
filename1 dd ? ; name of the file to be opened
filename2 dd ? ; name of the file to be opened
filedesc1 dd ? ; file descriptor
filedesc2 dd ? ; file descriptor
byte1 db ?
byte2 db ?
file_1_bytes_read dd ?
file_2_bytes_read dd ?
file_offset dd ?

