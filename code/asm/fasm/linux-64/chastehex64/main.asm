;Linux 64-bit Assembly Source for chastehex
;a special tool originally written in C
format ELF64 executable
entry main

include 'chastelib64.asm'

main:

;radix will be 16 because this whole program is about hexadecimal
mov qword [radix],16 ; can choose radix for integer input/output!

pop rax ;get the number of arguments
dec rax ;subtract 1 because we will ignore the name of the program

pop rbx ;pop program name into a register to delete it from stack
mov [argc],rax ;save the argument count for later

;before we try to get the first argument as a filename, we must check if it exists
cmp qword [argc],0
jnz arg_open_file

help:
mov rax,help_message
call putstring
jmp main_end

arg_open_file:

pop rax
dec qword [argc]
mov [filename],rax ; save the name of the file we will open to read
call putstr_and_line

;Linux system call to open a file
mov rsi,2   ;open file in read and write mode 
mov rdi,rax ;filename should be in rax before this function was called
mov rax,2   ;invoke SYS_OPEN (kernel opcode 2 on 64 bit systems)
syscall     ;call the kernel

cmp rax,0
jns file_open_no_errors ;if rax is not negative/signed there was no error

;Otherwise, if it was signed, then this code will display an error message.
neg rax
call putint_and_space
mov rax,open_error_message
call putstr_and_line

jmp main_end ;end the program because we failed at opening the file

file_open_no_errors:

mov [fd],rax ; save the file descriptor number for later use
mov qword [offset],0 ;assume the offset is 0,beginning of file

;check next arg
cmp qword [argc],0 ;if there are no more args after filename, just hexdump it
jnz seek_offset ;but if there are more, jump to the next argument to process it as address

hexdump:

mov rdx,0x10    ;number of bytes to read
mov rsi,buf     ;address to store the bytes
mov rdi,[fd]    ;move the opened file descriptor into rdi
mov rax,0       ;invoke SYS_READ (kernel opcode 0 on 64 bit Intel)
syscall         ;call the kernel

mov [count],rax

cmp rax,0
jnz file_success ;if more than zero bytes read, proceed to display

;display EOF to indicate we have reached the end of file
mov rax,end_of_file_string
call putstr_and_line

jmp main_end

;this point is reached if file was read from successfully
file_success:
call print_bytes_row
jmp hexdump

;convert argument with strint and lseek to that offset
seek_offset:

pop rax ;pop the argument into rax and process it as a hex number
dec qword [argc]
call strint

;use the hex number as an address to seek to in the file
mov rdx,0        ;whence argument (SEEK_SET)
mov rsi,rax      ;move the file cursor to this address
mov rdi,[fd]     ;move the opened file descriptor into rdi
mov rax,8        ;invoke SYS_LSEEK (kernel opcode 8 on 64 bit Intel)
syscall          ;call the kernel

mov [offset],rax ;move the new offset

;check the number of args still remaining
cmp qword [argc],0
jnz next_arg_write ; if there are still arguments, skip this read section and enter writing mode

read_one_byte:
mov rdx,1    ;number of bytes to read
mov rsi,buf  ;address to store the bytes
mov rdi,[fd] ;move the opened file descriptor into rdi
mov rax,0    ;invoke SYS_READ (kernel opcode 0 on 64 bit Intel)
syscall      ;call the kernel

;rax will have the number of bytes read after system call
cmp rax,1
jz print_byte_read ;if exactly 1 byte was read, proceed to print info

call show_eof

jmp main_end ;go to end of program

;print the address and the byte at that address
print_byte_read:
call print_byte_info

;this section interprets the rest of the args as bytes to write
next_arg_write:
cmp qword [argc],0
jz main_end

pop rax
dec qword [argc]
call strint ;try to convert string to a hex number

;write that number as a byte value to the file

mov [buf],al

mov rdx,1    ;write 1 byte
mov rsi,buf  ;pointer/address of byte to write
mov rdi,[fd] ;write to this file descriptor
mov rax,1    ;invoke SYS_WRITE (kernel opcode 1 on 64 bit systems)
syscall      ;system call to write the message

call print_byte_info
inc qword [offset]

jmp next_arg_write

main_end:

;this is the end of the program
;we close the open file and then use the exit call

;Linux system call to close a file

mov rdi,[fd] ;file number to close
mov rax,3    ;invoke SYS_CLOSE (kernel opcode 3 for 64 bit Intel)
syscall      ;call the kernel

mov rax,0x3C ;invoke SYS_EXIT (kernel opcode 0x3C (60 decimal) on 64 bit systems)
mov rdi,0    ;return 0 status on exit - 'No Errors'
syscall

;a function just for printing the address
;this saves space because all 3 modes use this
print_offset:
mov rax,[offset]
mov qword [int_width],8
call putint_and_space
ret

;this function prints a row of hex bytes
;each row is 16 bytes
print_bytes_row:
call print_offset

mov rbx,buf
mov rcx,[count]
add [offset],rcx
next_byte:
mov rax,0
mov al,[rbx]
mov qword [int_width],2
call putint_and_space

inc rbx
dec rcx
cmp rcx,0
jnz next_byte

mov rcx,[count]
pad_spaces:
cmp rcx,0x10
jz pad_spaces_end
mov rax,space_three
call putstring
inc rcx
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
mov rbx,buf
mov rcx,[count]
next_char:
mov rax,0
mov al,[rbx]

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
mov [rbx],al
inc rbx
dec rcx
cmp rcx,0
jnz next_char
mov [rbx],byte 0 ;make sure string is zero terminated

mov rax,buf
call putstring
ret

;function to display EOF with address
show_eof:

call print_offset
mov rax,end_of_file_string
call putstr_and_line

ret

;print the address and the byte at that address
print_byte_info:
call print_offset
mov rax,0
mov al,[buf]
mov qword [int_width],2
call putint_and_line

ret

end_of_file_string db 'EOF',0

help_message db 'chastehex by Chastity White Rose',0Ah
db 'hexdump a file:',0Ah,9,'chastehex file',0Ah
db 'read a byte:',0Ah,9,'chastehex file offset',0Ah
db 'write a byte:',0Ah,9,'chastehex file offset value',0Ah
db 'The file must exist',0Ah,0

;variables for managing arguments and files
argc dq 0
filename dq 0 ; name of the file to be opened
fd dq 0 ; file descriptor
count dq 0
offset dq 0
open_error_message db 'error opening file',0

;where we will store data from the file
;17 bytes because 16 bytes read per row plus the terminating 0
;used for the text printing function
buf db 16 dup '?',0

db 0x25 dup 0 ;fill with extra space to match 1530 executable size
