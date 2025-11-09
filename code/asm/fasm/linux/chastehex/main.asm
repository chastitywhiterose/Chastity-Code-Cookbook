;Linux 32-bit Assembly Source for chastehex
;a special tool originally written in C
format ELF executable
entry main

include 'chastelib32.asm'
include "chasteio32.asm"

main:

;radix will be 16 because this whole program is about hexadecimal
mov [radix],16 ; can choose radix for integer input/output!
mov [int_newline],0 ;disable automatic printing of newlines after putint
;we will be manually printing spaces or newlines depending on context

pop eax
mov [argc],eax ;save the argument count for later

;first arg is the name of the program. we skip past it
pop eax
dec [argc]

;before we try to get the first argument as a filename, we must check if it exists
cmp [argc],0
jnz arg_open_file

help:
mov eax,help_message
call putstring
jmp main_end

arg_open_file:

pop eax
dec [argc]
mov [filename],eax ; save the name of the file we will open to read
call putstring
call putline

call open

cmp eax,0
js main_end

mov [filedesc],eax ; save the file descriptor number for later use
mov [file_offset],0 ;assume the offset is 0,beginning of file

;check next arg
cmp [argc],0 ;if there are no more args after filename, just hexdump it
jnz next_arg_address ;but if there are more, jump to the next argument to process it as address

hexdump:

mov     edx, 0x10         ;number of bytes to read
mov     ecx, byte_array   ;address to store the bytes
mov     ebx, [filedesc]   ;move the opened file descriptor into EBX
mov     eax, 3            ;invoke SYS_READ (kernel opcode 3)
int     80h               ;call the kernel

mov [bytes_read],eax

; call putint

cmp eax,0
jnz file_success ;if more than zero bytes read, proceed to display

;if the offset is zero, display EOF to indicate empty file
;otherwise, end without displaying this because there should already be bytes printed to the display
cmp [file_offset],0
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

cmp [bytes_read],1 
jl main_end ;if less than one bytes read, there is an error
jmp hexdump

;address argument section
next_arg_address:

;if there is at least one more arg
pop eax ;pop the argument into eax and process it as a hex number
dec [argc]
call strint

;use the hex number as an address to seek to in the file
mov edx,0          ;whence argument (SEEK_SET)
mov ecx,eax        ;move the file cursor to this address
mov ebx,[filedesc] ;move the opened file descriptor into EBX
mov eax,19         ;invoke SYS_LSEEK (kernel opcode 19)
int 80h            ;call the kernel

mov [file_offset],eax ;move the new offset

;check the number of args still remaining
cmp [argc],0
jnz next_arg_write ; if there are still arguments, skip this read section and enter writing mode

read_one_byte:
mov edx,1          ;number of bytes to read
mov ecx,byte_array ;address to store the bytes
mov ebx,[filedesc] ;move the opened file descriptor into EBX
mov eax,3          ;invoke SYS_READ (kernel opcode 3)
int 80h            ;call the kernel

;eax will have the number of bytes read after system call
cmp eax,1
jz print_byte_info ;if exactly 1 byte was read, proceed to print info

call show_eof

jmp main_end ;go to end of program

;print the address and the byte at that address
print_byte_info:
mov eax,[file_offset]
mov [int_width],8
call putint
call putspace
mov eax,0
mov al,[byte_array]
mov [int_width],2
call putint
call putline

;this section interprets the rest of the args as bytes to write
next_arg_write:
cmp [argc],0
jz main_end

pop eax
dec [argc]
call strint ;try to convert string to a hex number

;write that number as a byte value to the file

mov [temp_byte],al

mov eax,4          ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,[filedesc] ;write to the file (not STDOUT)
mov ecx,temp_byte  ;pointer to temporary byte address
mov edx,1          ;write 1 byte
int 80h            ;system call to write the message

mov eax,[file_offset]
inc [file_offset]
mov [int_width],8
call putint
call putspace
mov eax,0
mov al,[temp_byte]
mov [int_width],2
call putint
call putline

;don't use these except for debugging
;call putstring
;mov eax,int_newline
;call putstring

jmp next_arg_write

main_end:

;this is the end of the program
;we close the open file and then use the exit call

mov eax,[filedesc] ;file number to close
call close

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

;variables for managing arguments
argc dd 0
filename dd 0 ; name of the file to be opened
filedesc dd 0 ; file descriptor
bytes_read dd 0
file_offset dd 0
temp_byte db 0

file_opened_string db ' was successfully opened!',0Ah,0
file_failed_string db ' could not be opened!',0Ah,0
end_of_file_string db 'EOF',0

help_message db 'Welcome to chastehex! The tool for reading and writing bytes of a file!',0Ah,0Ah
db 'To hexdump an entire file:',0Ah,0Ah,9,'chastehex file',0Ah,0Ah
db 'To read a single byte at an address:',0Ah,0Ah,9,'chastehex file address',0Ah,0Ah
db 'To write a single byte at an address:',0Ah,0Ah,9,'chastehex file address value',0Ah,0Ah,0

;where we will store data from the file
byte_array db 16 dup '?',0

;this function prints a row of hex bytes
;each row is 16 bytes
print_bytes_row:
mov eax,[file_offset]
mov [int_width],8
call putint
call putspace

mov ebx,byte_array
mov ecx,[bytes_read]
add [file_offset],ecx
next_byte:
mov eax,0
mov al,[ebx]
mov [int_width],2
call putint
call putspace

inc ebx
dec ecx
cmp ecx,0
jnz next_byte

call putline

ret

;function to display EOF with address
;this function saves space because it occurs in two places in the program
show_eof:

;otherwise, print an EOF message for this address
mov eax,[file_offset]
mov [int_width],8
call putint
call putspace
mov eax,end_of_file_string
call putstring
call putline

ret