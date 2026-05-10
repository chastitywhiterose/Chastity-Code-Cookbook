org 100h     ;DOS programs start at this address

mov word [radix],16 ; can choose radix for integer output!

mov ch,0     ;zero ch (upper half of cx)
mov cl,[80h] ;load length in bytes of the command string
cmp cx,0
jnz args_exist

mov ax,help    ;if no arguments were given, show a help message
call putstring
jmp ending     ;and end the program because there is nothing to do

args_exist:

;Point bx to the beginning of arg string
;however, this always contains a space
mov bx,81h

skip_start_spaces:
cmp byte [bx],' ' ;is this byte a space?
jnz skip_start_spaces_end ;if not, we are done skipping spaces
inc bx ;otherwise, go to next char
dec cx ;but subtract 1 from character count
jmp skip_start_spaces
skip_start_spaces_end:

mov [arg_string_start],bx ; save the location of the first non space in the arg string
mov [arg_string_index],bx ; save the location of the first non space in the arg string

;find the end of the string based on length
mov ax,bx
add ax,cx
mov [arg_string_end],ax ;now we know where the string ends.

;now bx points to the first non space character in the arguments passed to the DOS program
;cx contains the length
;and we know that [arg_string_end] is where it ends

;the next step is to filter the arguments into separate zero terminated strings
;each space will be changed to a zero (normally)
;but we also need to account for spaces inside quotes that are considered part of the string
;Linux handles this normally but DOS needs me to write the code to mimic this behavior
;because the program needs to function identically for DOS or Linux

arg_filter:

filter_quotes:

cmp byte [bx],0x22 ;is this a double quote -> "
jz quote_yes ;not quote, skip to normal space filter section
cmp byte [bx],0x27 ;is this a single quote -> '
jz quote_yes ;not quote, skip to normal space filter section

jmp filter_spaces ; if it was not a quote, skip this section

quote_yes:
;if it is a quote of either type, we handle it like thisWW
mov ah,[bx] ;save this quote byte to ah register
mov byte[bx],0 ;but delete it from string with zero
inc bx      ;go to next byte

quote_loop:

;must check for end of the string or it could crash the DOSBOX emulator with infinite loop
;because it will keep checking for a quote even if it doesn't exist
cmp bx,[arg_string_end] ;are we at the end of the arg string?
jz arg_filter_end       ;if yes, stop the filter and terminate with zero

mov al,[bx] ;get this byte in al register
cmp al,ah   ;check for next quote of same type
jz quote_loop_end ;if this is the end quote, stop the loop
inc bx      ;go to next byte
jmp quote_loop

quote_loop_end:
mov byte[bx],0 ;but delete it from string with zero

filter_spaces:
cmp bx,[arg_string_end] ;are we at the end of the arg string?
jz arg_filter_end       ;if yes, stop the filter and terminate with zero
cmp byte [bx],' '
jnz notspace ; if char is not space, leave it alone
mov byte [bx],0 ;otherwise change the space to a zero
notspace:
inc bx
jmp arg_filter ;if not at end, continue the filter

arg_filter_end:
mov byte [bx],0 ;terminate the ending with a zero for safety

inc word [argc] ;argc is now 1 (name of program plus possibly more we will test for)
mov ax,[argc]
;call putint_and_line

;now that the argument string is prepared, we will try to use the first argument as a filename to open

mov ah,3Dh                ;call number for DOS open existing file
mov al,0                  ;file access: 0=read,1=write,2=read+write
mov dx,[arg_string_index] ;string address to interpret as filename
int 21h                   ;DOS call to finalize open function

mov [file_handle],ax ;save the file handle

jc file_error ;if carry flag is set, we have an error, otherwise, file is open

file_opened:

mov ax,dx
;call putstring
;call putline
jmp use_file ;skip past error message and start using the file

;this section prints error message and then ends the program if file error found

file_error: ;prints error code2=file not found
mov ax,dx
call putstr_and_line
mov ax,file_error_message
call putstring
mov ax,[file_handle]
call putint
jmp ending

;how we use the file depends on the number of arguments given
;if no arguments other than the filename exist, we do a regular hex dump
;otherwise we look for two more arguments: the search and replace strings

use_file:

inc word [argc] ;argc is now 2 because filename was processed and open now
mov ax,[argc]
;call putint_and_line

call get_next_arg ;get address of next arg and return into ax register
cmp ax,[arg_string_end] ;this time, if ax equals end of string, we hex dump and then end the program later
jz textdump ;jump to hexdump section

;otherwise, we save the address at ax to our search string
mov [string_search],ax
;call putstr_and_line

inc word [argc] ;argc is now 3 because a search string was found
mov ax,[argc]
;call putint_and_line

call get_next_arg ;get address of next arg and return into ax register
cmp ax,[arg_string_end] ;this time, if ax equals end of string, we hex dump and then end the program later
jz textdump ;jump to hexdump section

;otherwise, we save the address at ax to our replacement string
mov [string_replace],ax
;call putstr_and_line

inc word [argc] ;argc is now 4 because a replace string was found
mov ax,[argc]
;call putint_and_line

;all other arguments that may exist are irrelevant
;we are done processing them but the argc variable will be later used to conditionally execute code

textdump:

;we start the loop with a call to read exactly 1 byte

mov ah,3Fh           ;call number for read function
mov bx,[file_handle] ;store file handle to read from in bx
mov cx,1             ;we are reading one byte
mov dx,byte_array    ;store the bytes here
int 21h

;call putint ;check the number of bytes read

cmp ax,1        ;check to see if exactly 1 byte was read
jz file_success ;if true, proceed to display
;mov ax,end_of_file
;call putstring
jmp file_close ;otherwise close the file and end program after failure

; this point is reached if file was read from successfully
file_success:

cmp word[argc],2 ;if only 2 arguments, just putchar and read next one
jnz putchar_skip

;normally, we will print the last read character
mov al,[byte_array]
call putchar

putchar_skip:

cmp word[argc],3 ;if not enough arguments, skip the search string section
jb textdump

mov bx,[string_search]

mov al,[bx]
mov ah,[byte_array]
cmp al,ah ;compare the first character of search string with the byte read already
jz search_start ; if they are equal, skip putchar and begin searching for the string

;otherwise, if they are not equal, just putchar the last byte read and repeat the loop
mov al,[byte_array]
call putchar
jmp textdump

search_start:
mov ax,[string_search]
call strlen ;get the length of the search string
;call putint_and_line

mov ax,[string_search]
call strlen ;get the length of the search string

;attempt to read the length-1 bytes because the first one is already read into the byte array

dec ax               ;subtract 1 from ax which holds our length of string

mov dx,byte_array+1  ;store the bytes here
mov cx,ax            ;we are reading this many bytes to have a string to compare
mov bx,[file_handle] ;store file handle to read from in bx
mov ah,3Fh           ;call number for read function
int 21h

mov bx,cx ;do some math to calculate where the string should end
add bx,ax
mov byte [bx],0 ;terminate the string with zero

mov si,[string_search]
mov di,byte_array
call strcmp ;compare these two strings

cmp ax,0 ;test if they are the same (if ax returned zero)
jnz normal_print ;if they are not a match print them unmodified and unquoted

;but if they are a match, then we either quote them
;or replace them if a replacement string is available

cmp word[argc],4 ;if less than 4 args, no replacement exist, so we quote the strings
jb print_quotes

;otherwise, we will print the replacement string instead of the original!

mov ax,[string_replace]
call putstring ;print the string

jmp normal_print_skip

print_quotes:
;print quotes around matched string
mov al,'"'
call putchar

mov ax,byte_array
call putstring ;print the string

mov al,'"'
call putchar

jmp normal_print_skip

normal_print: ;print normal / unquoted because it doesn't match

mov ax,byte_array
call putstring ;print the string

normal_print_skip:

jmp textdump

file_close:
;close the file if it is open
mov ah,3Eh
mov bx,[file_handle]
int 21h

ending:
mov ax,4C00h ; Exit program
int 21h

;the strlen and strcmp are named after the equivalent C functions
;but are written from scratch by me based on their expected behavior

;a function to get the length of string in ax and return the integer in ax

strlen:

mov bx,ax ; copy ax to bx. bx will be used as index to the string

strlen_start: ; this loop finds the length of the string as part of the putstring function

cmp [bx],byte 0 ; compare byte at address bx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc bx
jmp strlen_start

strlen_end:
sub bx,ax ;subtract start pointer from current pointer to get length of string

mov ax,bx ;copy the string length back to eax

ret

;compare the string at si to the one at di

strcmp:

mov ax,0 ;this will be stay zero unless the strings are different

strcmp_start:
mov bl,[di]
cmp bl,0
jz strcmp_end
mov bh,[si]
cmp bh,0
jz strcmp_end

inc di
inc si

cmp bl,bh
jz strcmp_start ;if they are the same, continue to next character

inc ax ;if they were different, eax will be incremented and the function ends

strcmp_end:
ret

;function to move ahead to the next argument
;only works after the filter has been applied to turn all spaces into zeroes

get_next_arg:
mov bx,[arg_string_index] ;get address of current arg
find_zero:
cmp byte [bx],0
jz found_zero
inc bx
jmp find_zero ; this char is not zero, go to the next char
found_zero:

;once we have found a zero, check to make sure we are not at the end

find_non_zero:
cmp bx,[arg_string_end]
jz arg_finish ;if bx is already at end, nothing left to find
cmp byte [bx],0
jnz arg_finish ;if this char is not zero we have found the next string!
inc bx
jmp find_non_zero ;otherwise, keep looking

arg_finish:
mov [arg_string_index],bx ; save this index to the variable
mov ax,bx ;but also save it to ax register for use in printing or something else
ret

help db 'chastext by Chastity White Rose',0Ah,0Ah
db '"cat" a file:',0Ah,0Ah,9,'chastext file',0Ah,0Ah
db 'search for a string:',0Ah,0Ah,9,'chastext file search',0Ah,0Ah
db 'replace string:',0Ah,0Ah,9,'chastext file search replace',0Ah,0Ah
db 'Find or replace any string!',0Ah,0

; About the chastelib variant

;instead of including chastelib16.asm as a header file
;I copy pasted it except that I excluded functions that were not used.
;Notably, the strint function is excluded because strint_32 is used instead

;start of chastelib

; This file is where I keep my function definitions.
; These are usually my string and integer output routines.

;this is my best putstring function for DOS because it uses call 40h of interrupt 21h
;this means that it works in a similar way to my Linux Assembly code
;the plan is to make both my DOS and Linux functions identical except for the size of registers involved

putstring:

push ax
push bx
push cx
push dx

mov bx,ax                  ;copy ax to bx for use as index register

putstring_strlen_start:    ;this loop finds the length of the string as part of the putstring function

cmp [bx], byte 0           ;compare this byte with 0
jz putstring_strlen_end    ;if comparison was zero, jump to loop end because we have found the length
inc bx                     ;increment bx (add 1)
jmp putstring_strlen_start ;jump to the start of the loop and keep trying until we find a zero

putstring_strlen_end:

sub bx,ax                  ; sub ax from bx to get the difference for number of bytes
mov cx,bx                  ; mov bx to cx
mov dx,ax                  ; dx will have address of string to write

mov ah,40h                 ; select DOS function 40h write 
mov bx,1                   ; file handle 1=stdout
int 21h                    ; call the DOS kernel

pop dx
pop cx
pop bx
pop ax

ret

;this is the location in memory where digits are written to by the intstr function
int_string db 16 dup '?' ;enough bytes to hold maximum size 16-bit binary integer
int_string_end db 0 ;zero byte terminator for the integer string

radix dw 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dw 8

intstr:

mov bx,int_string_end-1 ;find address of lowest digit(just before the newline 0Ah)
mov cx,1

digits_start:

mov dx,0;
div word [radix]
cmp dx,10
jb decimal_digit
jge hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add dx,'0'
jmp save_digit

hexadecimal_digit:
sub dx,10
add dx,'A'

save_digit:

mov [bx],dl
cmp ax,0
jz intstr_end
dec bx
inc cx
jmp digits_start

intstr_end:

prefix_zeros:
cmp cx,[int_width]
jnb end_zeros
dec bx
mov [bx],byte '0'
inc cx
jmp prefix_zeros
end_zeros:

mov ax,bx ; store string in ax for display later

ret

;function to print string form of whatever integer is in ax
;The radix determines which number base the string form takes.
;Anything from 2 to 36 is a valid radix
;in practice though, only bases 2,8,10,and 16 will make sense to other programmers
;this function does not process anything by itself but calls the combination of my other
;functions in the order I intended them to be used.

putint: 

push ax
push bx
push cx
push dx

call intstr
call putstring

pop dx
pop cx
pop bx
pop ax

ret

;the next utility functions simply print a space or a newline
;these help me save code when printing lots of things for debugging

space db ' ',0
line db 0Dh,0Ah,0

putspace:
push ax
mov ax,space
call putstring
pop ax
ret

putline:
push ax
mov ax,line
call putstring
pop ax
ret

;a function for printing a single character that is the value of al

char: db 0,0

putchar:
push ax
mov [char],al
mov ax,char
call putstring
pop ax
ret

;a small function just for the common operation
;printing an integer followed by a space
;this saves a few bytes in the assembled code

putint_and_space:
call putint
call putspace
ret

;a small function just for the common operation
;printing an integer followed by a space
;this saves a few bytes in the assembled code

putint_and_line:
call putint
call putline
ret


;a small function just for the common operation
;printing an integer followed by a space
;this saves a few bytes in the assembled code

putstr_and_space:
call putstring
call putspace
ret

;a small function just for the common operation
;printing an integer followed by a space
;this saves a few bytes in the assembled code

putstr_and_line:
call putstring
call putline
ret

;end of chastelib



argc dw 0

arg_string_start dw 0
arg_string_end dw 0
arg_string_index dw 0

file_error_message db 'Could not open the file! Error number: ',0
file_handle dw 0
read_error_message db 'Failure during reading of file. Error number: ',0
end_of_file db 'EOF',0

;where we will store data from the file
bytes_read dw 0

string_search rw 1 ; place to hold the search string pointer
string_replace rw 1 ; place to hold the replacement string pointer

byte_array db 0x64 dup 0
