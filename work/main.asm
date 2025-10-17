;Linux 32-bit Assembly Source for chastehex
;a special tool originally written in C
format ELF executable
entry main

include 'chastelib32.asm'
include 'chastehex.inc'

;the main function of our assembly function, just as if I were writing C.
main:

mov ebx,1 ;ebx must be 1 to write to standard output



;radix will be 16 because this whole program is about hexadecimal
mov [radix],16 ; can choose radix for integer input/output!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;print all the command line arguments for debugging purposes



;mov eax,argc_string
;call putstring
pop eax
;call putint
mov [argc],eax ;save the argument count for later

pop eax
mov [progname],eax ; save the name of the program
;call putstring
dec [argc]

;before we try to get the first argument as a file, we must check if it exists
cmp [argc],0
jz zero_args

pop eax
mov [filename],eax ; save the name of the file we will open to read
;call putstring
dec [argc]

    mov     ecx, 2              ; open file in read and write mode 
    mov     ebx, [filename]       ; filename we created above
    mov     eax, 5              ; invoke SYS_OPEN (kernel opcode 5)
    int     80h                 ; call the kernel

mov [filedesc],eax ; save the file descriptor number for later use
mov [file_offset],0 ;assume the offset is 0,beginning of file

mov ebx,1
;call putint ;show the return of the open call
cmp eax,0
jb zero_args ;if eax less than zero error occurred

;check next arg
;mov eax,argc_string
;call putstring
mov eax,[argc]
;call putint
cmp eax,0 ;if there are no more args after filename, just hexdump it
jz hexdump

;if there is at least one more arg
pop eax ;pop the argument into eax and process it as a hex number
dec [argc]
call strint
;call putint

; use the hex number as an address to seek to in the file
    mov     edx, 0              ; whence argument (SEEK_SET)
    mov     ecx, eax            ; move the file cursor to this address
    mov     ebx, [filedesc]     ; move the opened file descriptor into EBX
    mov     eax, 19             ; invoke SYS_LSEEK (kernel opcode 19)
    int     80h                 ; call the kernel

mov [file_offset],ecx ; move the new offset

;check the number of args still remaining
;mov eax,argc_string
;call putstring
mov eax,[argc]
cmp eax,0
jnz next_arg ; if there are still arguments, skip the normal hex dump and enter writing mode
;call putint

hexdump:

first_read_bytes_row:
    mov     edx, 0x10             ; number of bytes to read - one for each letter of the file contents
    mov     ecx, byte_array   ; move the memory address of our file contents variable into ecx
    mov     ebx, [filedesc]            ; move the opened file descriptor into EBX
    mov     eax, 3              ; invoke SYS_READ (kernel opcode 3)
    int     80h                 ; call the kernel

mov [bytes_read],eax

 mov ebx,1 ;switch back ebx to 1 for stdout
; call putint

cmp [bytes_read],1 
jl file_error ;if less than one bytes read, there is an error
jmp file_success

file_error:
mov eax,[filename]
;call putstring
mov eax,[file_offset]
mov [int_newline],' '
mov [int_width],8
call putint
mov eax,end_of_file_string
call putstring
jmp zero_args

; this point is reached if file was read from successfully

file_success:
;mov eax,[filename]
;call putstring
;mov eax,file_opened_string
;call putstring

mov eax,byte_array
;call putstring



next_row_of_bytes:
mov ebx,1
call print_bytes_row

call read_bytes_row
add [file_offset],0x10

cmp [bytes_read],1 
jl zero_args ;if less than one bytes read, there is an error
jmp next_row_of_bytes



;jmp zero_args ;end program here


;mov [argx],0

;this section interprets the rest of the args as bytes to write
next_arg:
cmp [argc],0
jz zero_args
;inc [argx]
pop eax
dec [argc]
call strint ;try to convert string to a hex number

;write that number as a byte value to the file

mov [temp_byte],al

mov eax,4  ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,[filedesc] ; write to the file (not STDOUT)
mov ecx,temp_byte ; pointer to temporary byte address
mov edx,1   ;write 1 byte
int 80h     ; system call to write the message

mov eax,[file_offset]
inc [file_offset]
mov [int_newline],' '
mov [int_width],8
call putint
mov eax,0
mov al,[temp_byte]
mov [int_width],2
mov [int_newline],0Ah
call putint



;don't use these except for debugging
;call putstring
;mov eax,int_newline
;call putstring

jmp next_arg

zero_args:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

;variables for managing arguments
argc dd 0
argx dd 0
progname dd 0 ; name of the program
filename dd 0 ; name of the file to be opened
filedesc dd 0 ; file descriptor
bytes_read dd 0
file_offset dd 0
temp_byte db 0

argc_string db 'argc=',0
argx_string db 'argx=',0
file_opened_string db ' was successfully opened!',0Ah,0
file_failed_string db ' could not be opened!',0Ah,0
end_of_file_string db 'EOF'

newline db 0Ah,0
space db ' ',0

; this is where I keep my string variables

main_string db "This is Chastity's 32-bit Assembly Hex Dumper/Editor.",0Ah,0
test_input_string db '11000',0

;where we will store data from the file
byte_array db 32 dup '?',0

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main
