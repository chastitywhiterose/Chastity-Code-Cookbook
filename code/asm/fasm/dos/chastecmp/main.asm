org 100h     ;DOS programs start at this address

mov word [radix],16 ; can choose radix for integer output!
mov [int_width],1
mov [int_newline],0

mov ch,0     ;zero ch (upper half of cx)
mov cl,[80h] ;load length of the command string
cmp cx,0
jnz args_exist

print_help:
mov ax,help
call putstring
jmp main_end

args_exist:
mov dx,81h   ;Point dx to the beginning of string
inc dx       ;go to next char
dec cx       ;but subtract 1 from count
mov [arg_index],dx ;save index to variable so dx is free to change as needed

;find the end of the string based on length
mov ax,dx
add ax,cx
;now we know where the string ends.
mov [arg_string_end],ax ;this is the end of the arg string. important for later
;call putint ; print address where entire arg string ends

;this routine replaces all non printable characters with zero in the arg string
mov bx,dx
filter:
cmp byte [bx],' '
ja notspace ; if char is above space, leave it alone
mov byte [bx],0 ;otherwise it counts as a space, change it to a zero
notspace:
inc bx
cmp bx,[arg_string_end] ;are we at the end of the arg string?
jnz filter ;if not at end, continue the filter

filter_end:
mov byte [bx],0 ;terminate the ending with a zero for safety

;now that the filter is done, we test to see if two filenames are available

;get the first filename
mov ax,[arg_index]
mov [filename1],ax

;check for next argument and if exists, use as second filename
call get_next_arg
cmp ax,[arg_string_end]
jz print_help ;show help if you forgot to include both filenames
mov [filename2],ax

;At this point, both filenames exist, we will attempt to open both of them.

mov [file_offset],0
mov [extra_word],0

open_file_1:

mov ax,[filename1]
call putstring
call putline

mov ah,3Dh ;call number for DOS open existing file
mov al,0   ;file access: 0=read,1=write,2=read+write
mov dx,[filename1] ;string address to interpret as filename
int 21h ;DOS call to finalize open function

mov [filedesc1],ax

jc file_1_error
jmp open_file_2

file_1_error: ;prints error message when file can't be opened
mov ax,file_error_message
call putstring
mov ax,[filedesc1]
call putint
jmp main_end

open_file_2:

mov ax,[filename2]
call putstring
call putline

mov ah,3Dh ;call number for DOS open existing file
mov al,0   ;file access: 0=read,1=write,2=read+write
mov dx,[filename2] ;string address to interpret as filename
int 21h ;DOS call to finalize open function

mov [filedesc2],ax

jc file_2_error
jmp files_compare

file_2_error: ;prints error message when file can't be opened
mov ax,file_error_message
call putstring
mov ax,[filedesc1]
call putint
jmp main_end


files_compare:

file_1_read_one_byte:
mov ah,3Fh           ;call number for read function
mov bx,[filedesc1] ;store file handle to read from in bx
mov cx,1             ;we are reading only 1 byte
mov dx,byte1    ;store the bytes here
int 21h

cmp ax,0
jz main_end ;end program if no bytes read

file_2_read_one_byte:
mov ah,3Fh           ;call number for read function
mov bx,[filedesc2] ;store file handle to read from in bx
mov cx,1             ;we are reading only 1 byte
mov dx,byte2    ;store the bytes here
int 21h

cmp ax,0
jz main_end ;end program if no bytes read

compare_bytes:

mov al,[byte1]
mov bl,[byte2]

;compare the two bytes and skip printing them if they are the same
cmp al,bl
jz same
call print_bytes_info
same:

add [file_offset],1
adc [extra_word],0  ;add 1 to extra word if carry flag set

jmp files_compare


main_end: ;this is the correct end of the program

;close the files if they are open

mov ah,3Eh
mov bx,[filedesc1]
int 21h

mov ah,3Eh
mov bx,[filedesc2]
int 21h

ending:
mov ax,4C00h ; Exit program
int 21h

arg_string_end dw 0
arg_index dw 0
file_error_message db 'Could not open the file! Error number: ',0
file_opened_message db 'The file is open with handle: ',0

read_error_message db 'Failure during reading of file. Error number: ',0
end_of_file db 'EOF',0

;function to move ahead to the next art
;only works after the filter has been applied to turn all spaces into zeroes

get_next_arg:
mov bx,[arg_index] ;dx has address of current arg
find_zero:
cmp byte [bx],0
jz found_zero
inc bx
jmp find_zero ; this char is not zero, go to the next char
found_zero:

find_non_zero:
cmp bx,[arg_string_end]
jz arg_finish ;if bx is already at end, nothing left to find
cmp byte [bx],0
jnz arg_finish ;if this char is not zero we have found the next string!
inc bx
jmp find_non_zero ;otherwise, keep looking

arg_finish:
mov [arg_index],bx ; save this index to variable
mov ax,bx ;but also save it to ax register for use
ret



;print the address and the bytes at that address
print_bytes_info:

mov [int_width],4
mov ax,[extra_word]
call putint
mov ax,[file_offset]
call putint
call putspace

mov [int_width],2
mov ax,0
mov al,[byte1]
call putint
call putspace
mov al,[byte2]
call putint
call putspace
call putline
ret



include 'chastelib16.asm'

help db 'chastecmp: compares two files in hexadecimal',0Ah
db 9,'chastecmp file1 file2',0Ah
db 'The bytes of the files are compared until EOF of either is reached.',0Ah,0


;variables for managing arguments and files
argc dw ?
filename1 dw ? ; name of the file to be opened
filename2 dw ? ; name of the file to be opened
filedesc1 dw ? ; file descriptor
filedesc2 dw ? ; file descriptor
byte1 db ?
byte2 db ?
bytes_read dw ?
file_offset dw ?
extra_word dw ? ;define an extra word(16 bits). The initial value doesn't matter.
