;Linux 64-bit Assembly Source for chastecmp
format ELF64 executable
entry main

include 'chastelib64.asm'

main:

;radix will be 16 because this whole program is about hexadecimal
mov [radix],16 ; can choose radix for integer input/output!
mov [int_width],1

pop rax
mov [argc],rax ;save the argument count for later

;first arg is the name of the program. we skip past it
pop rax
dec [argc]
mov rax,[argc]

cmp rax,2
jb help
mov [file_offset],0 ;assume the offset is 0,beginning of file
jmp arg_open_file_1

help:
mov rax,help_message
call putstring
jmp main_end

arg_open_file_1:
pop rax
mov [filename1],rax ; save the name of the file we will open to read

call putstring ;print the name of the file we will try opening

mov rsi,0   ;open file in read mode 
mov rdi,rax ;filename should be in rax before this function was called
mov rax,2   ;invoke SYS_OPEN (kernel opcode 2 on 64 bit systems)
syscall     ;call the kernel

cmp rax,0
js file_error_display ;end program if the file can't be opened
mov [filedesc1],rax ; save the file descriptor number for later use
mov rax,file_open
call putstr_and_line

arg_open_file_2:
pop rax
mov [filename2],rax ; save the name of the file we will open to read

call putstring ;print the name of the file we will try opening

mov rsi,0   ;open file in read mode 
mov rdi,rax ;filename should be in rax before this function was called
mov rax,2   ;invoke SYS_OPEN (kernel opcode 2 on 64 bit systems)
syscall     ;call the kernel

cmp rax,0
js file_error_display ;end program if the file can't be opened
mov [filedesc2],rax ; save the file descriptor number for later use
mov rax,file_open
call putstr_and_line

files_compare:

file_1_read_one_byte:
mov rdx,1            ;number of bytes to read
mov rsi,byte1        ;address to store the bytes
mov rdi,[filedesc1]  ;move the opened file descriptor into rdi
mov rax,0            ;invoke SYS_READ (kernel opcode 0 on 64 bit Intel)
syscall              ;call the kernel

;rax will have the number of bytes read after system call
mov [file_1_bytes_read],rax ;we save the number of bytes read for later
cmp rax,0
jnz file_2_read_one_byte ;unless zero bytes were read, proceed to read from next file

mov rax,[filename1]
call putstring
mov rax,end_of_file_string
call putstr_and_line

;Even if we have reached the end of the first file,
;we still proceed to read a byte from the second file
;to see if it also ends at the same address

file_2_read_one_byte:
mov rdx,1            ;number of bytes to read
mov rsi,byte2        ;address to store the bytes
mov rdi,[filedesc2]  ;move the opened file descriptor into rdi
mov rax,0            ;invoke SYS_READ (kernel opcode 0 on 64 bit Intel)
syscall              ;call the kernel

;rax will have the number of bytes read after system call
mov [file_2_bytes_read],rax ;we save the number of bytes read for later
cmp rax,0
jnz check_both_bytes ;unless zero bytes were read, proceed to compare bytes from both files

mov rax,[filename2]
call putstring
mov rax,end_of_file_string
call putstr_and_line

jmp main_end ;we have reach end of one file and should end program

check_both_bytes:

;we add the number of bytes read from both files
mov rax,[file_1_bytes_read]
add rax,[file_2_bytes_read]
cmp rax,2
jnz main_end

compare_bytes:

mov al,[byte1]
mov bl,[byte2]

;compare the two bytes and skip printing them if they are the same
cmp al,bl
jz bytes_are_same

;print the address and the bytes at that address
mov rax,[file_offset]
mov [int_width],8
call putint_and_space
mov [int_width],2
mov rax,0
mov al,[byte1]
call putint_and_space
mov al,[byte2]
call putint_and_line

bytes_are_same:

inc [file_offset]

jmp files_compare

file_error_display:

mov rax,file_error
call putstr_and_line

main_end:

;this is the end of the program
;we close the open files and then use the exit call

mov rdi,[filedesc1] ;file number to close
mov rax,3           ;invoke SYS_CLOSE (kernel opcode 3 for 64 bit Intel)
syscall             ;call the kernel

mov rdi,[filedesc2] ;file number to close
mov rax,3           ;invoke SYS_CLOSE (kernel opcode 3 for 64 bit Intel)
syscall             ;call the kernel

mov rax, 0x3C ; invoke SYS_EXIT (kernel opcode 0x3C (60 decimal) on 64 bit systems)
mov rdi,0   ; return 0 status on exit - 'No Errors'
syscall

;variables for displaying information

help_message db 'chastecmp by Chastity White Rose',0Ah,0Ah
db 9,'chastecmp file1 file2',0Ah,0Ah
db 'Differing bytes are shown in hexadecimal',0Ah
db 'until the EOF has been reached.',0Ah,0

file_open db ' opened',0
file_error db ' error',0
end_of_file_string db ' EOF',0

db 48 dup 0 ;fill with extra space to match 1280 executable size

;variables for managing arguments and files
argc dq ?
filename1 dq ? ; name of the file to be opened
filename2 dq ? ; name of the file to be opened
filedesc1 dq ? ; file descriptor
filedesc2 dq ? ; file descriptor
byte1 db ?
byte2 db ?
file_1_bytes_read dq ?
file_2_bytes_read dq ?
file_offset dq ?