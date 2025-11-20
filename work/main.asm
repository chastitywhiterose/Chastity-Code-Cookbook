;Linux 32-bit Assembly Source for chastecmp
format ELF executable
entry main

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
;we close the open files and then use the exit call

mov eax,[filedesc1] ;file number to close
call close
mov eax,[filedesc2] ;file number to close
call close


mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

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

;variables for displaying information

help_message db 'chastecmp: compares two files in hexadecimal',0Ah
db 9,'chastecmp file1 file2',0Ah
db 'The bytes of the files are compared until EOF of either is reached.',0Ah,0

end_of_file_string db ' has reached EOF',0Ah,0

;in this section, only the relevant functions from chastelib32.asm were copied over

stdout dd 1 ; variable for standard output so that it can theoretically be redirected

putstring:

push eax
push ebx
push ecx
push edx

mov ebx,eax ; copy eax to ebx as well. Now both registers have the address of the main_string

putstring_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz putstring_strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;ebx will now have correct number of bytes

;write string using Linux Write system call
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit


mov edx,ebx      ;number of bytes to write
mov ecx,eax      ;pointer/address of string to write
mov ebx,[stdout] ;write to the STDOUT file
mov eax, 4       ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h          ;system call to write the message


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

mov ebx,int_newline-1 ;find address of lowest digit(just before the newline 0Ah)
mov ecx,1

digits_start:

mov edx,0
div dword [radix]
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

mov [ebx],dl
cmp eax,0
jz intstr_end
dec ebx
inc ecx
jmp digits_start

intstr_end:

prefix_zeros:
cmp ecx,[int_width]
jnb end_zeros
dec ebx
mov [ebx],byte '0'
inc ecx
jmp prefix_zeros
end_zeros:

mov eax,ebx ; now that the digits have been written to the string, display it!

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

;the strint function from chastelib32.asm has been excluded for this program because unlike in chastehex, we are not reading strings to get numbers. We are only outputting byte numbers by converting them to strings with intstr

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

;variables for managing arguments and files
argc dd ?
filename1 dd ? ; name of the file to be opened
filename2 dd ? ; name of the file to be opened
filedesc1 dd ? ; file descriptor
filedesc2 dd ? ; file descriptor
byte1 db ?
byte2 db ?
bytes_read dd ?
file_offset dd ?

