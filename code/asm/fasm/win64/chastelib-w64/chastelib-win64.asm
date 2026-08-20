write_count dq 0

putstring:              ;print string pointed to by rax register

push rax
push rbx
push rcx
push rdx



mov rbx,rax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [rbx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc rbx
jmp putstring_strlen_start

putstring_strlen_end:
sub rbx,rax ;subtract start pointer from current pointer to get length of string

mov rdx,rax ;pointer to message

mov rcx, -11        ; STD_OUTPUT_HANDLE
call [GetStdHandle] ; Get Standard Output Handle
mov rcx,rax         ; copy handle to ecx

mov r8,rbx  ;message length
mov r9,write_count ;store how many bytes are written


mov qword [rsp + 32], 0 ; Parameter 5: Must be placed on the stack
call [WriteFile]


pop rdx
pop rcx
pop rbx
pop rax



ret ;this is the end of the putstring function return to calling location



; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 64 dup '?' ;reserve bytes for characters string for 64-bit binary integer

int_string_end db 0 ;zero byte terminator for the integer string

radix dq 2     ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dq 8 ;default width of integers. Extra zeros prefixed if more than 1

;this function creates a string of the integer in rax
;it uses the above radix variable to determine base from 2 to 36
;it then loads rax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov rbx,int_string_end-1 ;find address of lowest digit
mov rcx,1

digits_start:

mov rdx,0;
div qword [radix]
cmp rdx,10
jb decimal_digit
jnb hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add rdx,'0'
jmp save_digit

hexadecimal_digit:
sub rdx,10
add rdx,'A'

save_digit:

mov [rbx],dl
cmp rax,0
jz intstr_end
dec rbx
inc rcx
jmp digits_start

intstr_end:

prefix_zeros:
cmp rcx,[int_width]
jnb end_zeros
dec rbx
mov [rbx],byte '0'
inc rcx
jmp prefix_zeros
end_zeros:

mov rax,rbx ;point eax register to this string for putstring

ret

;function to print string form of whatever integer is in rax
;The radix determines which number base the string form takes.
;Anything from 2 to 36 is a valid radix
;in practice though, only bases 2,8,10,and 16 will make sense to other programmers
;this function does not process anything by itself but calls the combination of my other
;functions in the order I intended them to be used.

putint: 

push rax
push rbx
push rcx
push rdx

call intstr
call putstring

pop rdx
pop rcx
pop rbx
pop rax

ret
