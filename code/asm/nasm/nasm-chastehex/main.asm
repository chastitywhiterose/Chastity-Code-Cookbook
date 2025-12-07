section	.data
%include 'chastelib32.asm'
%include 'chasteio32.asm'
global  _start

_start:

;radix will be 16 because this whole program is about hexadecimal
mov dword [radix],16 ; can choose radix for integer input/output!
mov byte [int_newline],0 ;disable automatic printing of newlines after putint
;we will be manually printing spaces or newlines depending on context

pop eax
mov [argc],eax ;save the argument count for later

;first arg is the name of the program. we skip past it
pop eax
dec dword [argc]

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
call putstring
call putline

call open

cmp eax,0
js main_end

mov [filedesc],eax ; save the file descriptor number for later use
mov dword [file_offset],0 ;assume the offset is 0,beginning of file

;check next arg
cmp dword [argc],0 ;if there are no more args after filename, just hexdump it
jnz next_arg_address ;but if there are more, jump to the next argument to process it as address

hexdump:

mov edx,0x10         ;number of bytes to read
mov ecx,byte_array   ;address to store the bytes
mov ebx,[filedesc]   ;move the opened file descriptor into EBX
mov eax,3            ;invoke SYS_READ (kernel opcode 3)
int 80h               ;call the kernel

mov [bytes_read],eax

; call putint

cmp eax,0
jnz file_success ;if more than zero bytes read, proceed to display

;if the offset is zero, display EOF to indicate empty file
;otherwise, end without displaying this because there should already be bytes printed to the display
cmp dword [file_offset],0
jnz main_end

call show_eof

jmp main_end

; this point is reached if file was read from successfully

file_success:
;mov eax,[filename]
;call putstring
;mov eax,file_opened_string
;call putstring

mov eax,byte_array
;call putstring

call print_bytes_row

cmp dword [bytes_read],1 
jl main_end ;if less than one bytes read, there is an error
jmp hexdump

;address argument section
next_arg_address:

;if there is at least one more arg
pop eax ;pop the argument into eax and process it as a hex number
dec dword [argc]
call strint

;use the hex number as an address to seek to in the file
mov edx,0          ;whence argument (SEEK_SET)
mov ecx,eax        ;move the file cursor to this address
mov ebx,[filedesc] ;move the opened file descriptor into EBX
mov eax,19         ;invoke SYS_LSEEK (kernel opcode 19)
int 80h            ;call the kernel

mov [file_offset],eax ;move the new offset

;check the number of args still remaining
cmp dword [argc],0
jnz next_arg_write ; if there are still arguments, skip this read section and enter writing mode

read_one_byte:
mov edx,1          ;number of bytes to read
mov ecx,byte_array ;address to store the bytes
mov ebx,[filedesc] ;move the opened file descriptor into EBX
mov eax,3          ;invoke SYS_READ (kernel opcode 3)
int 80h            ;call the kernel

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

mov [byte_array],al

mov eax,4          ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,[filedesc] ;write to the file (not STDOUT)
mov ecx,byte_array  ;pointer to temporary byte address
mov edx,1          ;write 1 byte
int 80h            ;system call to write the message

call print_byte_info
inc dword [file_offset]

jmp next_arg_write

main_end:

;this is the end of the program
;we close the open file and then use the exit call

mov eax,[filedesc] ;file number to close
call close

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h


;this function prints a row of hex bytes
;each row is 16 bytes
print_bytes_row:
mov eax,[file_offset]
mov dword [int_width],8
call putint
call putspace

mov ebx,byte_array
mov ecx,[bytes_read]
add [file_offset],ecx
next_byte:
mov eax,0
mov al,[ebx]
mov dword [int_width],2
call putint
call putspace

inc ebx
dec ecx
cmp ecx,0
jnz next_byte

mov ecx,[bytes_read]
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

space_three db '   ',0

print_bytes_row_text:
mov ebx,byte_array
mov ecx,[bytes_read]
next_char:
mov eax,0
mov al,[ebx]

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
mov [ebx],al
inc ebx
dec ecx
cmp ecx,0
jnz next_char
mov [ebx],byte 0 ;make sure string is zero terminated

mov eax,byte_array
call putstring

ret


;function to display EOF with address
show_eof:

mov eax,[file_offset]
mov dword [int_width],8
call putint
call putspace
mov eax,end_of_file_string
call putstring
call putline

ret

;print the address and the byte at that address
print_byte_info:
mov eax,[file_offset]
mov dword [int_width],8
call putint
call putspace
mov eax,0
mov al,[byte_array]
mov dword [int_width],2
call putint
call putline

ret

end_of_file_string db 'EOF',0

help_message db 'Welcome to chastehex! The tool for reading and writing bytes of a file!',0Ah,0Ah
db 'To hexdump an entire file:',0Ah,0Ah,9,'chastehex file',0Ah,0Ah
db 'To read a single byte at an address:',0Ah,0Ah,9,'chastehex file address',0Ah,0Ah
db 'To write a single byte at an address:',0Ah,0Ah,9,'chastehex file address value',0Ah,0Ah,0

;variables for managing arguments
argc dd 0
filename dd 0 ; name of the file to be opened
filedesc dd 0 ; file descriptor
bytes_read dd 0
file_offset dd 0

;where we will store data from the file
byte_array db 17 dup '?'
