;Linux 32-bit Assembly Source for chastecmp
format ELF executable
entry main

include 'chastelib32.asm'
include 'chasteio32.asm'

main:

;radix will be 16 because this whole program is about hexadecimal
mov [radix],16 ; can choose radix for integer input/output!
mov [int_width],1
mov [int_newline],0 ;disable automatic printing of newlines after putint

pop eax
mov [argc],eax ;save the argument count for later

;first arg is the name of the program. we skip past it
pop eax
dec [argc]
mov eax,[argc]

;call putint
;call putspace

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
call open
cmp eax,0
js main_end ;end program if the file can't be opened
mov [filedesc1],eax ; save the file descriptor number for later use

arg_open_file_2:
pop eax
mov [filename2],eax ; save the name of the file we will open to read
call open
cmp eax,0
js main_end ;end program if the file can't be opened
mov [filedesc2],eax ; save the file descriptor number for later use

files_compare:

file_1_read_one_byte:
mov edx,1          ;number of bytes to read
mov ecx,byte1 ;address to store the bytes
mov ebx,[filedesc1] ;move the opened file descriptor into EBX
mov eax,3          ;invoke SYS_READ (kernel opcode 3)
int 80h            ;call the kernel

;eax will have the number of bytes read after system call
cmp eax,0
jnz file_2_read_one_byte ;unless zero bytes were read, proceed to read from next file

mov eax,[filename1]
call putstring
mov eax,end_of_file_string
call putstring

jmp main_end ;we have reach end of one file and should end program

file_2_read_one_byte:
mov edx,1          ;number of bytes to read
mov ecx,byte2 ;address to store the bytes
mov ebx,[filedesc2] ;move the opened file descriptor into EBX
mov eax,3          ;invoke SYS_READ (kernel opcode 3)
int 80h            ;call the kernel

;eax will have the number of bytes read after system call
cmp eax,0
jnz compare_bytes ;unless zero bytes were read, proceed to compare bytes from both files

mov eax,[filename2]
call putstring
mov eax,end_of_file_string
call putstring

jmp main_end ;we have reach end of one file and should end program


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

main_end:

;this is the end of the program
;we close the open file and then use the exit call

mov eax,[filedesc1] ;file number to close
call close

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

;variables for managing arguments
argc dd 0
filename1 dd 0 ; name of the file to be opened
filename2 dd 0 ; name of the file to be opened
filedesc1 dd 0 ; file descriptor
filedesc2 dd 0 ; file descriptor
byte1 db 0
byte2 db 0
bytes_read dd 0
file_offset dd 0

help_message db 'chastecmp: compares two files in hexadecimal',0Ah
db 9,'chastecmp file1 file2',0Ah,0

end_of_file_string db ' has reached EOF',0Ah,0

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
