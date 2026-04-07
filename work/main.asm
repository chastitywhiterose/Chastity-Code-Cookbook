section	.data
%include 'chastelib64.asm'
global  _start

_start:

;radix will be 16 because this whole program is about hexadecimal
mov [radix],16 ; can choose radix for integer input/output!

pop rax
mov [argc],rax ;save the argument count for later

;first arg is the name of the program. we skip past it
pop rax
dec [argc]

;before we try to get the first argument as a filename, we must check if it exists
cmp [argc],0
jnz arg_open_file

help:
mov rax,help_message
call putstring
jmp main_end

arg_open_file:

pop rax
dec [argc]
mov [filename],rax ; save the name of the file we will open to read
call putstr_and_line

;Linux system call to open a file

mov rsi,2   ;open file in read and write mode 
mov rdi,rax ;filename should be in rax before this function was called
mov rax,2   ;invoke SYS_OPEN (kernel opcode 2 on 64 bit systems)
syscall     ;call the kernel

cmp rax,0
jns file_open_no_errors ;if eax is not negative/signed there was no error

;Otherwise, if it was signed, then this code will display an error message.

neg rax
call putint_and_space
mov rax,open_error_message
call putstr_and_line

jmp main_end ;end the program because we failed at opening the file

file_open_no_errors:

mov [filedesc],rax ; save the file descriptor number for later use
mov [file_offset],0 ;assume the offset is 0,beginning of file

;check next arg
cmp [argc],0 ;if there are no more args after filename, just hexdump it
jnz next_arg_address ;but if there are more, jump to the next argument to process it as address

hexdump:

mov rdx,0x10         ;number of bytes to read
mov rsi,byte_array   ;address to store the bytes
mov rdi,[filedesc]   ;move the opened file descriptor into rdi
mov rax,0            ;invoke SYS_READ (kernel opcode 0 on 64 bit Intel)
syscall              ;call the kernel

mov [bytes_read],rax

cmp rax,0
jnz file_success ;if more than zero bytes read, proceed to display

;display EOF to indicate we have reached the end of file

mov eax,end_of_file_string
call putstr_and_line

jmp main_end

; this point is reached if file was read from successfully

file_success:

call print_bytes_row

cmp [bytes_read],1 
jl main_end ;if less than one bytes read, there is an error
jmp hexdump

;address argument section
next_arg_address:

;if there is at least one more arg
pop rax ;pop the argument into rax and process it as a hex number
dec [argc]
call strint

;use the hex number as an address to seek to in the file

mov rdx,0          ;whence argument (SEEK_SET)
mov rsi,rax        ;move the file cursor to this address
mov rdi,[filedesc] ;move the opened file descriptor into rdi
mov rax,8          ;invoke SYS_LSEEK (kernel opcode 8 on 64 bit Intel)
syscall            ;call the kernel

mov [file_offset],rax ;move the new offset

;check the number of args still remaining
cmp [argc],0
jnz next_arg_write ; if there are still arguments, skip this read section and enter writing mode

read_one_byte:
mov rdx,1            ;number of bytes to read
mov rsi,byte_array   ;address to store the bytes
mov rdi,[filedesc]   ;move the opened file descriptor into rdi
mov rax,0            ;invoke SYS_READ (kernel opcode 0 on 64 bit Intel)
syscall              ;call the kernel

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
cmp [argc],0
jz main_end

pop rax
dec [argc]
call strint ;try to convert string to a hex number

;write that number as a byte value to the file

mov [byte_array],al

mov rdx,1          ;write 1 byte
mov rsi,byte_array ;pointer/address of byte to write
mov rdi,[filedesc] ;write to this file descriptor
mov rax,1          ;invoke SYS_WRITE (kernel opcode 1 on 64 bit systems)
syscall            ;system call to write the message

call print_byte_info
inc [file_offset]

jmp next_arg_write

main_end:

;this is the end of the program
;we close the open file and then use the exit call

;Linux system call to close a file

mov rdi,[filedesc] ;file number to close
mov rax,3          ;invoke SYS_CLOSE (kernel opcode 3 for 64 bit Intel)
syscall            ;call the kernel

mov rax, 0x3C ; invoke SYS_EXIT (kernel opcode 0x3C (60 decimal) on 64 bit systems)
mov rdi,0   ; return 0 status on exit - 'No Errors'
syscall

;this function prints a row of hex bytes
;each row is 16 bytes
print_bytes_row:
mov rax,[file_offset]
mov [int_width],8
call putint_and_space

mov rbx,byte_array
mov rcx,[bytes_read]
add [file_offset],rcx
next_byte:
mov rax,0
mov al,[rbx]
mov [int_width],2
call putint_and_space

inc rbx
dec rcx
cmp rcx,0
jnz next_byte

mov rcx,[bytes_read]
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

space_three db '   ',0

print_bytes_row_text:
mov rbx,byte_array
mov rcx,[bytes_read]
next_char:
mov rax,0
mov al,[rbx]

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
mov [rbx],al
inc rbx
dec rcx
cmp rcx,0
jnz next_char
mov [rbx],byte 0 ;make sure string is zero terminated

mov rax,byte_array
call putstring

ret

;function to display EOF with address
show_eof:

mov rax,[file_offset]
mov [int_width],8
call putint_and_space
mov rax,end_of_file_string
call putstr_and_line

ret

;print the address and the byte at that address
print_byte_info:
mov rax,[file_offset]
mov [int_width],8
call putint_and_space
mov rax,0
mov al,[byte_array]
mov [int_width],2
call putint_and_line

ret

end_of_file_string db 'EOF',0

help_message db 'chastehex by Chastity White Rose',0Ah,0Ah
db 'hexdump a file:',0Ah,0Ah,9,'chastehex file',0Ah,0Ah
db 'read a byte:',0Ah,0Ah,9,'chastehex file address',0Ah,0Ah
db 'write a byte:',0Ah,0Ah,9,'chastehex file address value',0Ah,0Ah
db 'The file must exist',0Ah,0

;variables for managing arguments
argc dq 0
filename dq 0 ; name of the file to be opened
filedesc dq 0 ; file descriptor
bytes_read dq 0
file_offset dq 0
open_error_message db 'error while opening file',0

;where we will store data from the file
byte_array db 17 dup ?
