format ELF executable

main:

mov eax,string0
call putstring
mov eax,string1
call putstring
mov eax,string2
call putstring

mov eax,0

loop0:
call putint
call putline
inc eax
cmp eax,0x10
jnz loop0

mov eax,1 ; invoke SYS_EXIT (kernel opcode 1)
mov ebx,0 ; return 0 status on exit - 'No Errors'
int 80h

string0 db 'The putstring function can print any string!',0Ah,0
string1 db 'The intstr function can convert an integer to a string!',0Ah,0
string2 db 'The putint function calls intstr and putstring to print an integer',0Ah,0

putstring:

push eax
push ebx
push ecx
push edx

mov ebx,eax

putstring_strlen_start:

cmp [ebx],byte 0
jz putstring_strlen_end
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax

mov edx,ebx ;number of bytes to write
mov ecx,eax ;pointer/address of string to write
mov ebx,1   ;write to the STDOUT file
mov eax,4   ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h     ;system call to write the message

pop edx
pop ecx
pop ebx
pop eax

ret

; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 32 dup '?' ;enough bytes to hold maximum size 32-bit binary integer

int_string_end db 0 ;zero byte terminator for the integer string

radix dd 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dd 1 ;default width of integers. Extra zeros prefixed if more than 1

;this function creates a string of the integer in eax
;it uses the above radix variable to determine base from 2 to 36
;it then loads eax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov ebx,int_string_end-1 ;find address of lowest digit(just before the newline 0Ah)
mov ecx,1

digits_start:

mov edx,0;
div dword [radix]
cmp edx,10
jb decimal_digit
jae hexadecimal_digit

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

line db 0Ah,0 ;a string containing only a newline

;the next function which pushes eax to the stack
;moves the address of the line string and prints it with putstring
;then it pops the original value of eax back from the stack before the function returns
;this allows me to print a newline anywhere in the code without a single register changing

putline:
push eax
mov eax,line
call putstring
pop eax
ret