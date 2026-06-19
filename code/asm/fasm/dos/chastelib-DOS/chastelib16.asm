; chastelib assembly header file for 32 bit Linux
; This file is where I keep the source of my most important Assembly functions
; These are my string and integer output and conversion routines.

; To simplify documentation. The Accumulator/Arithmetic register
; (ax,eax,rax) depending on bit size shall be referred to as register A
; for the description of these core functions because the A register
; is treated special both by the Intel company and my code;

; putstring; Prints a zero terminated string from the address pointer to by A register.
; intstr;    Converts the number in A into a zero terminated string and points A to that address
; putint;    Prints the integer in A by calling intstr and then putstring.
; strint;    Converts the zero terminated string into an integer and sets A to that value
   
; Now, the source of the functions begins, with comments included for parts that I felt needed explanation.

putstring:

push ax
push bx
push cx
push dx

mov bx,ax                  ;copy ax to bx to be used as index to the string

putstring_strlen_start:    ;this loop finds the length of the string as part of the putstring function

cmp byte[bx],0             ;compare this byte with 0
jz putstring_strlen_end    ;if comparison was zero, jump to loop end because we have found the length
inc bx
jmp putstring_strlen_start ;jump to the start of the loop and keep trying until we find a zero

putstring_strlen_end:
sub bx,ax                  ; sub ax from bx to get the difference for number of bytes

;Write string using DOS Write system call.
;write(int fd, const void buf[.count], size_t count);
;ax=0x40,bx=fd,dx=buf,cx=count

mov cx,bx        ;number of bytes to write
mov dx,ax        ;pointer/address of string to write
mov bx,1         ;write to the STDOUT file
mov ah,0x40      ;write (kernel opcode 0x40 on 16 bit DOS)
int 21h          ;system call for 16-bit DOS kernel

pop dx
pop cx
pop bx
pop ax

ret ;this is the end of the putstring function return to calling location

; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 16 dup '?' ;reserve bytes for characters string for 16-bit binary integer

int_string_end db 0 ;zero byte terminator for the integer string

radix dw 2     ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dw 8 ;default width of integers. Extra zeros prefixed if more than 1

;this function creates a string of the integer in eax
;it uses the above radix variable to determine base from 2 to 36
;it then loads eax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov bx,int_string_end-1 ;find address of lowest digit(just before the newline 0Ah)
mov cx,1

digits_start:

mov dx,0;
div word [radix]
cmp dx,10
jb decimal_digit
jnb hexadecimal_digit

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
mov byte[bx], '0'
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

;this function converts a string pointed to by ax into an integer returned in eax instead
;it is a little complicated because it has to account for whether the character in
;a string is a decimal digit 0 to 9, or an alphabet character for bases higher than ten
;it also checks for both uppercase and lowercase letters for bases 11 to 36
;finally, it checks if that letter makes sense for the base.
;For example, G to Z cannot be used in hexadecimal, only A to F can
;The purpose of writing this function was to be able to accept user input as integers
;This function is improved with error checking and uses the new strint_error variable
;The program can check this value after the call and see how many errors happened.

strint_error db 0 ;declare a byte variable that keeps track of errors

strint:

mov bx,ax ;copy string address from ax to bx because ax will be replaced soon!
mov ax,0
mov byte[strint_error],0 ;set errors to 0 at the start of this function

read_strint:
mov cx,0 ; zero cx so only lower 8 bits are used
mov cl,[bx] ;copy byte/character at address bx to cl register (lowest part of cx)
inc bx ;increment bx to be ready for next character
cmp cl,0 ;compare this byte with 0
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
;it isn't a decimal digit, but it could be perhaps an alphabet character
;which could be a digit in a higher base like hexadecimal
;we will check for that possibility next

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

;if we have reached this point, result invalid and end function with error
jmp strint_end_error

process_char:

cmp cx,[radix] ;compare char with radix
jnb strint_end_error ;if this value is above or equal to radix, it is too high despite being a valid digit/alpha

mov dx,0 ;zero dx because it is used in mul sometimes
mul word [radix]    ;mul ax with radix
add ax,cx

jmp read_strint ;jump back and continue the loop if nothing has exited it

strint_end_error:  ;we jump here if there was an error with one of the chars
inc byte[strint_error] ;increment error counter because char invalid

strint_end: ;we jump here when no errors happened

ret

;The utility functions below simply print a space or a newline.
;these help me save code when printing lots of strings and integers.

space db ' ',0 ;a string containing only a space

putspace:
push ax
mov ax,space
call putstring
pop ax
ret

line db 0Dh,0Ah,0 ;a string containing only a newline

;the next function which pushes eax to the stack
;moves the address of the line string and prints it with putstring
;then it pops the original value of eax back from the stack before the function returns
;this allows me to print a newline anywhere in the code without a single register changing

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

;a small function just for the common operation of
;printing an integer followed by a space
;this saves a few bytes in the assembled code
;by reducing the number of function calls in the main program

putint_and_space:
call putint
call putspace
ret

;a small function just for the common operation of
;printing an integer followed by a line feed
;this saves a few bytes in the assembled code
;by reducing the number of function calls in the main program

putint_and_line:
call putint
call putline
ret

;a small function just for the common operation of
;printing a string followed by a line feed
;this saves a few bytes in the assembled code
;by reducing the number of function calls in the main program
;it also means we don't need to include a newline in every string!

putstr_and_line:
call putstring
call putline
ret