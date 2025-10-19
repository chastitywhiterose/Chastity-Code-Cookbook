;Linux 32-bit Assembly source for chastehex
;A special tool originally written in C but translated to Assembly by hand
;See the original at: https://github.com/chastitywhiterose/chastehex

;assemble with:
;	fasm chastehex.asm 
;	chmod +x chastehex

format ELF executable
entry main

;the main function of our assembly function, just as if I were writing C.
main:

mov ebx,1 ;ebx must be 1 to write to standard output



;radix will be 16 because this whole program is about hexadecimal
mov [radix],16 ; can choose radix for integer input/output!
mov [int_newline],0 ;disable automatic printing of newlines after putint
;we will be manually printing spaces or newlines depending on context


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
mov eax,[argc]
;call putint
;call putline
cmp [argc],0
jnz arg_open_file

help_start:
mov eax,help
call putstring
help_end:

jmp zero_args

arg_open_file:

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
jnz next_arg_address ;but if there are more, jump to the next argument to process it as address

hexdump:

first_read_bytes_row:
    mov     edx, 0x10         ;number of bytes to read
    mov     ecx, byte_array   ;address to store the bytes
    mov     ebx, [filedesc]   ;move the opened file descriptor into EBX
    mov     eax, 3            ;invoke SYS_READ (kernel opcode 3)
    int     80h               ;call the kernel

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
call putline
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

jmp zero_args ;end program here

; address argument section
next_arg_address:

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
mov eax,argc_string
;call putstring
mov eax,[argc]
;call putint ;display number of args left
;call putline

cmp eax,0
jnz next_arg_write ; if there are still arguments, skip this read section and enter writing mode

read_one_byte:
    mov     edx, 1         ;number of bytes to read
    mov     ecx, byte_array   ;address to store the bytes
    mov     ebx, [filedesc]   ;move the opened file descriptor into EBX
    mov     eax, 3            ;invoke SYS_READ (kernel opcode 3)
    int     80h               ;call the kernel

;eax will have the number of bytes read after system call
cmp eax,1
jz print_byte_info ;if exactly 1 byte was read, proceed to print info

;otherwise, print an EOF message for this address
mov eax,[file_offset]
mov [int_width],8
call putint
call putspace
mov eax,end_of_file_string
call putstring
call putline

jmp zero_args ;go to end of program

mov eax,end_of_file_string
call putstring

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

;;;;;;;;;;

;this section interprets the rest of the args as bytes to write
next_arg_write:
cmp [argc],0
jz zero_args

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

zero_args:

;this is the end of the program
;we close the open file and then use the exit call

mov eax, 6         ; invoke SYS_CLOSE (kernel opcode 6)
mov ebx,[filedesc] ;file number to close
int 80h            ; call the kernel

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
end_of_file_string db 'EOF',0

help db 'Welcome to chastehex! The tool for reading and writing bytes of a file!',0Ah
db 'To hexdump an entire file:',0Ah,9,'chastehex file',0Ah
db 'To read a single byte at an address:',0Ah,9,'chastehex file address',0Ah
db 'To write a single byte at an address:',0Ah,9,'chastehex file address value',0Ah
db 'The file must exist before you launch the program.',0Ah
db 'This design was to prevent accidentally opening a mistyped filename.',0Ah,0

; this is where I keep my string variables

main_string db "This is Chastity's 32-bit Assembly Hex Dumper/Editor.",0Ah,0
test_input_string db '11000',0

;where we will store data from the file
byte_array db 32 dup '?',0

print_bytes_row:
mov eax,[file_offset]
mov [int_width],8
call putint
call putspace

mov esi,byte_array
next_hex:
push esi
mov ecx,0
mov cl,[esi]
mov eax,ecx
mov [int_width],2
call putint
call putspace

pop esi
inc esi
dec [bytes_read] 
cmp [bytes_read],0
jnz next_hex

call putline

ret



read_bytes_row:
    mov     edx, 0x10             ; number of bytes to read - one for each letter of the file contents
    mov     ecx, byte_array   ; move the memory address of our file contents variable into ecx
    mov     ebx, [filedesc]            ; move the opened file descriptor into EBX
    mov     eax, 3              ; invoke SYS_READ (kernel opcode 3)
    int     80h                 ; call the kernel

mov [bytes_read],eax
ret

; These are my string and integer output routines.

; function to print zero terminated string pointed to by register eax

stdout dd 1 ; variable for standard output so that it can theoretically be redirected

putstring:

push eax
push ebx
push ecx
push edx

mov edx,eax ; copy eax to edx as well. Now both registers have the address of the main_string

putstring_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

cmp [edx],byte 0 ; compare byte at address edx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc edx
jmp putstring_strlen_start

strlen_end:
sub edx,eax ; edx will now have correct number of bytes when we use it for the system write call

mov ecx,eax ; pointer/address of string to write
mov eax, 4  ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,[stdout] ; write to the STDOUT file
int 80h     ; system call to write the message

pop edx
pop ecx
pop ebx
pop eax

ret ; this is the end of the putstring function return to calling location

;this is the location in memory where digits are written to by the putint function
int_string     db 32 dup '?' ;enough bytes to hold maximum size 32-bit binary integer
; this is the end of the integer string optional line feed and terminating zero
; clever use of this label can change the ending to be a different character when needed 
int_newline db 0Ah,0

radix dd 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dd 8

;this function creates a string of the integer in eax
;it uses the above radix variable to determine base from 2 to 36
;it then loads eax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov ebp,int_newline-1 ;find address of lowest digit(just before the newline 0Ah)
mov ecx,1

digits_start:

mov edx,0;
mov esi,[radix] ;radix is from memory location just before this function
div esi
cmp edx,10
jb decimal_digit
jge hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add edx,'0'
jmp save_digit

hexadecimal_digit:
sub edx,10
add edx,'A'

save_digit:

mov [ebp],dl
cmp eax,0
jz intstr_end
dec ebp
inc ecx
jmp digits_start

intstr_end:

prefix_zeros:
cmp ecx,[int_width]
jnb end_zeros
dec ebp
mov [ebp],byte '0'
inc ecx
jmp prefix_zeros
end_zeros:

mov eax,ebp ; now that the digits have been written to the string, display it!

ret


; function to print string form of whatever integer is in eax
; The radix determines which number base the string form takes.
; Anything from 2 to 36 is a valid radix
; in practice though, only bases 2,8,10,and 16 will make sense to other programmers
; this function does not process anything by itself but calls the combination of my other
; functions in the order I intended them to be used.

putint: 

push eax
push ebx
push ecx
push edx

call intstr

call putstring

pop edx
pop ecx
pop ebx
pop eax

ret

;this function converts a string pointed to by eax into an integer returned in eax instead
;it is a little complicated because it has to account for whether the character in
;a string is a decimal digit 0 to 9, or an alphabet character for bases higher than ten
;it also checks for both uppercase and lowercase letters for bases 11 to 36
;finally, it checks if that letter makes sense for the base.
;For example, G to Z cannot be used in hexadecimal, only A to F can
;The purpose of writing this function was to be able to accept user input as integers

strint:

mov esi,eax ;copy string address from eax to esi because eax will be replaced soon!
mov eax,0

read_strint:
mov ecx,0 ; zero ecx so only lower 8 bits are used
mov cl,[esi]
inc esi
cmp cl,0 ; compare byte at address edx with 0
jz strint_end ; if comparison was zero, this is the end of string

;if char is below '0' or above '9', it is outside the range of these and is not a digit
cmp cl,'0'
jb not_digit
cmp cl,'9'
ja not_digit

;but if it is a digit, then correct and process the character
is_digit:
sub cl,'0'
jmp process_char

not_digit:
;it isn't a digit, but it could be perhaps and alphabet character
;which is a digit in a higher base

;if char is below 'A' or above 'Z', it is outside the range of these and is not capital letter
cmp cl,'A'
jb not_upper
cmp cl,'Z'
ja not_upper

is_upper:
sub cl,'A'
add cl,10
jmp process_char

not_upper:

;if char is below 'a' or above 'z', it is outside the range of these and is not lowercase letter
cmp cl,'a'
jb not_lower
cmp cl,'z'
ja not_lower

is_lower:
sub cl,'a'
add cl,10
jmp process_char

not_lower:

;if we have reached this point, result invalid and end function
jmp strint_end

process_char:

cmp ecx,[radix] ;compare char with radix
jae strint_end ;if this value is above or equal to radix, it is too high despite being a valid digit/alpha

mov edx,0 ;zero edx because it is used in mul sometimes
mul [radix]    ;mul eax with radix
add eax,ecx

jmp read_strint ;jump back and continue the loop if nothing has exited it

strint_end:

ret



;the next utility functions simply print a space or a newline
;these help me save code when printing lots of things for debugging

space db ' ',0
line db 0Dh,0Ah,0

putspace:
push eax
mov eax,space
call putstring
pop eax
ret

putline:
push eax
mov eax,line
call putstring
pop eax
ret

