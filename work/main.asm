org 100h     ;DOS programs start at this address

mov word [radix],16 ; can choose radix for integer output!

mov ch,0     ;zero ch (upper half of cx)
mov cl,[80h] ;load length of the command string
cmp cx,0
jz ending

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

;now that the argument string is prepared, we will try to use the first argument as a filename to open

mov ah,3Dh ;call number for DOS open existing file
mov al,2   ;file access: 0=read,1=write,2=read+write
mov dx,[arg_index] ;string address to interpret as filename
int 21h ;DOS call to finalize open function

mov [file_handle],ax

jc file_error ;if carry flag is set, we have an error, otherwise, file is open

file_opened:
mov ax,dx
call putstring
call putline
;mov ax,file_opened_message
;call putstring
;mov ax,[file_handle]
;call putint
jmp use_file

;this section prints error message and then ends the program if file error found
file_error: ;prints error code2=file not found
mov ax,dx
call putstring
call putline
mov ax,file_error_message
call putstring
mov ax,[file_handle]
call putint
jmp arg_loop_end

;how we use the file depends on the number of arguments given
;if no arguments other than the filename exist, we do a regular hex dump
use_file:

call get_next_arg ;get address of next arg and return into ax register
cmp ax,[arg_string_end] ;this time, if ax equals end of string, we hex dump and then end the program later
jz hexdump ;jump to hexdump section

;otherwise, if there are more args, as contains next arg
;then we use the strint function to transform it into a number
;call putstring
;call putline

call strint ;turn string at address ax into a number returned in ax
;call putint

;this number will be out new offset to seek to
mov [file_offset],ax

mov ah,42h           ;lseek call number
mov al,0            ;seek origin 00h start of file,01h current file position,02h end of file
mov bx,[file_handle]
mov cx,0            ;upper word of offet
mov dx,[file_offset]
int 21h

jc arg_loop_end ;end program if seek error (though I can't imagine how it would fail)

;because we have an argument for an address we will read only this byte and display it
dump_byte:

mov ah,3Fh           ;call number for read function
mov bx,[file_handle] ;store file handle to read from in bx
mov cx,1             ;we are reading only 1 byte
mov dx,byte_array    ;store the bytes here
int 21h


mov [int_newline],0 ;disable auto newline printing
;set width to 8 and display offset
mov [int_width],8
mov ax,[file_offset]
call putint
call putspace

mov ah,0 ;zero upper half of ax
mov al,[byte_array]

mov [int_width],2
call putint
;call putline




jmp arg_loop_end ;we are done so we end the program

hexdump:

;we start the loop with a call to read exactly 16 bytes

mov ah,3Fh           ;call number for read function
mov bx,[file_handle] ;store file handle to read from in bx
mov cx,16            ;we are reading sixteen bytes
mov dx,byte_array    ;store the bytes here
int 21h

;call putint ;check the number of bytes read

;important note: the number of bytes read should be 16 or less and this is not an error
;zero is expected if we are at the end of the file.
;however, if it is zero, we print an EOF message and exit

cmp ax,0
jnz print_row
mov ax,end_of_file
call putstring
jmp arg_loop_end

print_row:

mov cx,ax ;number of bytes read

mov [int_newline],0 ;disable auto newline printing
;set width to 8 and display offset
mov [int_width],8
mov ax,[file_offset]
call putint
call putspace
add [file_offset],cx ;next offset will show correctly

mov ah,0 ;zero upper half of ax
mov bx,byte_array

mov [int_width],2

print_byte:
mov al,[bx]
call putint
call putspace
inc bx
dec cx
cmp cx,0
jnz print_byte
call putline

jmp hexdump ;jump back to hexdump and attempt another read of a row


jnc read_ok ;if carry is clear, there is no error. otherwise display error

;this section prints error message and then ends the program if file error found
read_error: ;prints error code2=file not found
mov ax,dx
call putstring
call putline
mov ax,read_error_message
call putstring
mov ax,[file_handle]
call putint

read_ok:

jmp arg_loop_end ;end program after the hex dump is complete

;this loop processes the rest of the arguments
arg_loop:
mov ax,[arg_index] ;get address of current arg
call putstring
call putline
call get_next_arg ;get address of next arg and return into ax register

cmp ax,[arg_string_end] ;if the ax register contains address of the end of args string, end program to avoid failure
jz arg_loop_end
jmp arg_loop
arg_loop_end:

;close the file if it is open
mov ah,3Eh
mov bx,[file_handle]
int 21h

ending:
mov ax,4C00h ; Exit program
int 21h

arg_string_end dw 0
arg_index dw 0
file_error_message db 'Could not open the file! Error number: ',0
file_opened_message db 'The file is open with handle: ',0
file_handle dw 0
read_error_message db 'Failure during reading of file. Error number: ',0
end_of_file db 'EOF',0

;where we will store data from the file
byte_array db 16 dup '?',0
file_offset dw 0


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



include 'chastelib16.asm'