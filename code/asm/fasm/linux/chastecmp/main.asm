;Linux 32-bit Assembly Source for chastecmp
format ELF executable
entry main

include 'chastelib32.asm'

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
call putstr_and_line

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
call putstr_and_line

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
jz bytes_are_same

;print the address and the bytes at that address
mov eax,[file_offset]
mov [int_width],8
call putint_and_space
mov [int_width],2
mov eax,0
mov al,[byte1]
call putint_and_space
mov al,[byte2]
call putint_and_line

bytes_are_same:

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

;variables for displaying information

help_message db 'chastecmp by Chastity White Rose',0Ah,0Ah
db 9,'chastecmp file1 file2',0Ah,0Ah
db 'Bytes that differ between files are shown in hexadecimal',0Ah
db 'until the EOF has been reached.',0Ah,0


file_open db ' opened',0
file_error db ' error',0
end_of_file_string db ' EOF',0

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

