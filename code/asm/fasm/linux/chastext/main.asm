;Linux 32-bit Assembly Source for chastehex
;a special tool originally written in C
format ELF executable
entry main

include 'chastelib32.asm'

main:

;radix will be 16 because this whole program is about hexadecimal
mov dword [radix],16 ; can choose radix for integer input/output!

pop eax
mov [argc],eax ;save the argument count for later
call putint_and_line

cmp [argc],1
ja help_skip ;if more than 1 argument is given, skip the help message and process the other arguments

help:
mov eax,help_message
call putstring
jmp main_end
help_skip:

pop eax ;pop the next arg which is the name of the program we are running
call putstr_and_line

get_filename:
pop eax ;pop the next arg which is the name of the file we will open
call putstr_and_line
mov [filename],eax ; save the name of the file we will open to read

arg_open_file:

;Linux system call to open a file

mov ecx,0   ;open file in read only mode
mov ebx,eax ;filename should be in eax before this function was called
mov eax,5   ;invoke SYS_OPEN (kernel opcode 5)
int 80h     ;call the kernel

cmp eax,0
jns file_open_no_errors ;if eax is not negative/signed there was no error

;Otherwise, if it was signed, then this code will display an error message.

neg eax
call putint_and_space
mov eax,open_error_message
call putstr_and_line

jmp main_end ;end the program because we failed at opening the file

file_open_no_errors:

mov [filedesc],eax ; save the file descriptor number for later use
mov dword [file_offset],0 ;assume the offset is 0,beginning of file

hexdump:

mov edx,1         ;number of bytes to read
mov ecx,byte_array   ;address to store the bytes
mov ebx,[filedesc]   ;move the opened file descriptor into EBX
mov eax,3            ;invoke SYS_READ (kernel opcode 3)
int 80h              ;call the kernel

mov [bytes_read],eax

cmp eax,0
jnz file_success ;if more than zero bytes read, proceed to display

jmp main_end

; this point is reached if file was read from successfully

file_success:

mov al,[byte_array]
call putchar

cmp dword [bytes_read],1 
jl main_end ;if less than one bytes read, there is an error
jmp hexdump

main_end:

;this is the end of the program
;we close the open file and then use the exit call

;Linux system call to close a file

mov ebx,[filedesc] ;file number to close
mov eax,6          ;invoke SYS_CLOSE (kernel opcode 6)
int 80h            ;call the kernel

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h





;print the address and the byte at that address
print_byte_info:
mov eax,[file_offset]
mov dword [int_width],8
call putint_and_space
mov eax,0
mov al,[byte_array]
mov dword [int_width],2
call putint_and_line

ret

help_message db 'chastext by Chastity White Rose',0Ah,0Ah
db 'textdump a file:',0Ah,0Ah,9,'chastext file',0Ah,0Ah
db 'quote search string:',0Ah,0Ah,9,'chastext file search',0Ah,0Ah
db 'replace string:',0Ah,0Ah,9,'chastext file search replace',0Ah,0Ah
db 'The file must exist',0Ah,0

;variables for managing arguments and files
argc dd 0
filename dd 0 ; name of the file to be opened
filedesc dd 0 ; file descriptor
bytes_read dd 0
file_offset dd 0
open_error_message db 'error while opening file',0

;where we will store data from the file
byte_array db 17 dup '?'
