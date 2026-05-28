org 100h     ;DOS programs start at this address

mov word [radix],16 ; can choose radix for integer output!

call getarg
cmp ax,0
jnz args_exist

mov ax,help    ;if no arguments were given, show a help message
call putstring
jmp ending     ;and end the program because there is nothing to do

args_exist:

;now that the argument string is prepared, we will try to use the first argument as a filename to open
call getarg

mov dx,ax                 ;string address to interpret as filename
mov ah,3Dh                ;call number for DOS open existing file
mov al,0                  ;file access: 0=read,1=write,2=read+write
int 21h                   ;DOS call to finalize open function

mov [filedesc],ax ;save the file handle

jc file_error ;if carry flag is set, we have an error, otherwise, file is open

jmp use_file ;skip past error message and start using the file

;this section prints error message and then ends the program if file error found
;usually this happens if the file doesn't exist

file_error: ;prints error code2=file not found
mov ax,dx
call putstr_and_line
mov ax,file_error_message
call putstring
mov ax,[filedesc]
call putint
jmp ending

;how we use the file depends on the number of arguments given
;if no arguments other than the filename exist, we do a regular hex dump
;otherwise we look for two more arguments: the search and replace strings

use_file:

call getarg ;get address of next arg and return into ax register
cmp ax,0 ;if ax equals 0, we begin the textdump main loop without search or replace strings
jz textdump ;jump to textdump section

;otherwise, we save the address at ax to our search string
mov [string_search],ax
;call putstr_and_line


call getarg ;get address of next arg and return into ax register
cmp ax,0 ;if ax equals 0, we have a search string but no replace strings
jz textdump ;jump to textdump section

;otherwise, we save the address at ax to our replacement string
mov [string_replace],ax
;call putstr_and_line

;all other arguments that may exist after this are irrelevant

textdump:

;this is the beginning of the textdump main loop of chastext

;first, check to see if there is a search string
;if there is a search string, go to search_mode

cmp word[string_search],0 ;do we have a search string?
jnz search_mode

;but if there is not a search string
;we will read one character, then display it to stdout
;and then jump to the beginning of the textdump loop to print them until EOF

;This loop is the same as the Linux 'cat' command
;or the DOS 'type' command

;we start the loop with a call to read exactly 1 byte
cat:
mov ah,3Fh           ;call number for read function
mov bx,[filedesc] ;store file handle to read from in bx
mov cx,1             ;we are reading one byte
mov dx,byte_array    ;store the bytes here
int 21h

cmp ax,1        ;check to see if exactly 1 byte was read
jz file_success ;if true, proceed to display

jmp file_close ;otherwise close the file and end program after failure

; this point is reached if 1 byte was read from the file successfully
file_success:

mov al,[byte_array]
call putchar
jmp cat

;if search string doesn't exist, just jump and repeat the loop
;otherwise we continue into the next section that compares the input with the search string

search_mode:

;this is the beginning of search mode
;it handles the file by seeking and reading to search every position for the search string

;first, seek to the file_address we initialized to zero
;this variable will be added to depending on actions taken

mov ah,42h           ;lseek call number
mov al,0             ;seek origin 00h start of file,01h current file position,02h end of file
mov bx,[filedesc]
mov cx,0              ;upper word of offset zero because not planning for larger than 64kb files
mov dx,[file_address] ;lower word of offset
int 21h

;obtain the length of the search string using my strlen function
mov ax,[string_search]
call strlen ;get the length of the search string

;use the length of the string we are searching for as the number of bytes to read at this location

mov dx,byte_array    ;store the bytes here
mov cx,ax            ;we are reading this many bytes to have a string to compare
mov bx,[filedesc]    ;store file handle to read from in bx
mov ah,3Fh           ;call number for read function
int 21h

mov bx,byte_array    ;move the address of bytes read into bx
add bx,ax            ;add number of bytes read (return value of read function in ax)
mov byte[bx],0       ;terminate the string with zero

mov [bytes_read],ax  ;store how many bytes were read with that last read operation

cmp ax,cx ;if the number of bytes is not what we expected to read, end this loop
jnz textdump_end

;move our two strings into the si and di registers for comparison
;with my custom written strcmp function

mov si,[string_search]
mov di,byte_array
call strcmp ;compare these two strings

cmp ax,0 ;test if they are the same (if ax returned zero)
jnz not_match ;if they are not a match go to that section for printing a character

;but if they are a match, then we either quote them
;or replace them if a replacement string is available

;but regardless of which action we do, since a match was found, let us add this count to the file address
;so that we read from beyond this point next time the textdump loop starts
mov ax,[bytes_read]
add [file_address],ax

cmp word[string_replace],0 ;check to see if a replacement string is available
jz print_quotes ;if not, skip to the part where we just quote the strings that match

;otherwise, we will print the replacement string instead of the original!

mov ax,[string_replace]
call putstring ;print the string

jmp textdump ;restart the main loop

print_quotes:
;print quotes around matched string
mov al,'"'
call putchar

mov ax,byte_array
call putstring ;print the string

mov al,'"'
call putchar

jmp textdump ;restart the main loop

not_match: 

mov al,[byte_array]
call putchar
add word[file_address],1 ;add 1 to the file address so we don't read this same position again

jmp textdump


textdump_end:

;print the remaining bytes, if any, left after the main loop ended
mov ax,byte_array
call putstring

main_end:

;this is the end of the program
;we close the open file and then use the exit call

file_close:
;close the file if it is open
mov ah,3Eh
mov bx,[filedesc]
int 21h

;debugging section I use just to test values
;call putline
;mov ax,[string_search]
;call putstr_and_line
;mov ax,[string_replace]
;call putstr_and_line


ending:
mov ax,4C00h ; Exit program
int 21h

include 'getarg.asm'

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

mov ax,bx ;copy the string length back to ax

ret

;strcmp compares the string at si to the one at di
;ax returns 0 if the strings are the same and 1 if different
;the algorithm is simple but I will explain it for those who are confused

;ax is initialized to zero
;a byte from each string is loaded into the al and bl registers
;the bytes are compared. if they are different, then we jump to the end
;However, if they are the same, then we check if one of them is zero
;for this purpose it doesn't matter whether we compare al or bl with zero
;because it is known that they are the same if the jnz did not take place
;if it is zero, this also jumps to the end of the function
;If neither jump took place, then we jump to the start of the loop
;but when the function finally ends bl will be subtracted from al
;this ensures that the function returns zero if the final characters are the same

strcmp:

mov ax,0

strcmp_start:

;read a byte from each string
mov al,[di]
mov bl,[si]
cmp al,bl
jnz strcmp_end

cmp al,0
jz strcmp_end

inc di
inc si

jmp strcmp_start

strcmp_end:
sub al,bl

ret

help db 'chastext by Chastity White Rose',0Dh,0Ah
db '"cat" or "type" a file without changing it:',0Dh,0Ah,9,'chastext file',0Dh,0Ah
db 'search for a string and quote it:',0Dh,0Ah,9,'chastext file search',0Dh,0Ah
db 'replace string:',0Dh,0Ah,9,'chastext file search replace',0Dh,0Ah
db 'Find or replace any string!',0Dh,0Ah,0

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

file_error_message db 'Could not open the file! Error number: ',0
filedesc dw 0
file_address dw 0 ;file address defaults to zero AKA beginning of file
end_of_file db 'EOF',0

;where we will store data from the file
bytes_read dw 0

string_search dw 0 ; place to hold the search string pointer
string_replace dw 0 ; place to hold the replacement string pointer

byte_array db 0x79 dup 0
