;Linux 32-bit Assembly Source for chastehex
;a special tool originally written in C
format ELF executable

main:

;radix will be 16 because this whole program is about hexadecimal
mov dword [radix],16 ; can choose radix for integer input/output!

pop eax ;get the number of arguments
dec eax ;subtract 1 because we will ignore the name of the program
pop ebx ;pop program name into a register to delete it from stack
mov [argc],eax ;save the argument count for later

;before we try to get the first argument as a filename, we must check if it exists
cmp dword [argc],0
jnz arg_open_file

help:
mov eax,help_message
call putstring
jmp main_end

arg_open_file:

pop eax
dec dword [argc]
mov [filename],eax ; save the name of the file we will open to read
call putstr_and_line

;Linux system call to open a file
mov ecx,2   ;open file in read and write mode 
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

mov [fd],eax ; save the file descriptor number for later use
mov dword [offset],0 ;assume the offset is 0,beginning of file

;check next arg
cmp dword [argc],0 ;if there are no more args after filename, just hexdump it
jnz seek_offset    ;otherwise use next argument as an offset for lseek

hexdump:

mov edx,0x10    ;number of bytes to read
mov ecx,buf     ;address to store the bytes
mov ebx,[fd]    ;move the opened file descriptor into EBX
mov eax,3       ;invoke SYS_READ (kernel opcode 3)
int 80h         ;call the kernel

mov [count],eax

cmp eax,0
jnz file_success ;if more than zero bytes read, proceed to display

;otherwise, display EOF to indicate we have reached the end of file
mov eax,end_of_file_string
call putstr_and_line

jmp main_end

;this point is reached if file was read from successfully
file_success:
call print_bytes_row
jmp hexdump

;convert argument with strint and lseek to that offset
seek_offset:

pop eax ;pop the argument into eax and process it as a hex number
dec dword [argc]
call strint

;use the hex number as an address to seek to in the file
mov edx,0        ;whence argument (SEEK_SET)
mov ecx,eax      ;move the file cursor to this address
mov ebx,[fd]     ;move the opened file descriptor into EBX
mov eax,19       ;invoke SYS_LSEEK (kernel opcode 19)
int 80h          ;call the kernel

mov [offset],eax ;move the new offset

;check the number of args still remaining
cmp dword [argc],0
jnz next_arg_write ; if there are still arguments, skip this read section and enter writing mode

read_one_byte:
mov edx,1    ;number of bytes to read
mov ecx,buf  ;address to store the bytes
mov ebx,[fd] ;move the opened file descriptor into EBX
mov eax,3    ;invoke SYS_READ (kernel opcode 3)
int 80h      ;call the kernel

;eax will have the number of bytes read after system call
cmp eax,1
jz print_byte_read ;if exactly 1 byte was read, proceed to print info

call show_eof

jmp main_end ;go to end of program

;print the address and the byte at that address
print_byte_read:
call print_byte_info

;this section interprets the rest of the args as bytes to write
next_arg_write:
cmp dword [argc],0
jz main_end

pop eax
dec dword [argc]
call strint ;try to convert string to a hex number

;write that number as a byte value to the file

mov [buf],al

mov edx,1    ;write 1 byte
mov ecx,buf  ;pointer/address of byte to write
mov ebx,[fd] ;write to this file descriptor
mov eax,4    ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h      ;system call to write the message

call print_byte_info
inc dword [offset]

jmp next_arg_write

main_end:

;this is the end of the program
;we close the open file and then use the exit call

;Linux system call to close a file

mov ebx,[fd] ;file number to close
mov eax,6    ;invoke SYS_CLOSE (kernel opcode 6)
int 80h      ;call the kernel

mov eax, 1   ;invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0   ;return 0 status on exit - 'No Errors'
int 80h

include 'chastelib32.asm'

;a function just for printing the address
;this saves space because all 3 modes use this
print_offset:
mov eax,[offset]
mov dword [int_width],8
call putint_and_space
ret

;this function prints a row of hex bytes
;each row is 16 bytes
print_bytes_row:
call print_offset

mov ebx,buf
mov ecx,[count]
add [offset],ecx
next_byte:
mov eax,0
mov al,[ebx]
mov dword [int_width],2
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

;I define a string of 3 spaces as filler when less than 16 bytes are read
;This makes the text section on the right properly lined up.
space_three db '   ',0

;This function prints the text equivalent of the bytes on the last row printed.
;It reads how many bytes were read in the last read operation.
;If less than 16 bytes were read, it prints spaces as filler so that
;text can still be printed lined up with all the other rows
;even if less than 16 bytes exist in the current row.
;This situation sometimes happens when we get near the end of the file.
;It also replaces characters that can't be printed with periods -> .

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
;if char is in printable range,keep as is and proceed to next index
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

;function to display EOF with address
show_eof:

call print_offset
mov eax,end_of_file_string
call putstr_and_line

ret

;print the address and the byte at that address
print_byte_info:
call print_offset
mov eax,0
mov al,[buf]
mov dword [int_width],2
call putint_and_line

ret

end_of_file_string db 'EOF',0

help_message db 'chastehex by Chastity White Rose',0Ah
db 'hexdump a file:',0Ah,9,'chastehex file',0Ah
db 'read a byte:',0Ah,9,'chastehex file offset',0Ah
db 'write a byte:',0Ah,9,'chastehex file offset value',0Ah
db 'The file must exist',0Ah,0

;variables for managing arguments and files
argc dd 0
filename dd 0 ; name of the file to be opened
fd dd 0 ; file descriptor
count dd 0
offset dd 0
open_error_message db 'error opening file',0

;where we will store data from the file
;17 bytes because 16 bytes read per row plus the terminating 0
;used for the text printing function
buf db 17 dup '?'

db 0x31 dup 0 ;fill with extra space to match 1280 executable size
