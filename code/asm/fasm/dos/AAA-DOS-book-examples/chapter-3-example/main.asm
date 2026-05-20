org 100h

main:

mov ax,text
call putstring

mov [radix],word 10
mov [int_width],word 1 

mov ax,1

main_loop:
call putint
add ax,ax
cmp ax,0
jnz main_loop

mov ax,4C00h
int 21h

text db 'This program displays numbers!',0Dh,0Ah,0

;This section is for the putstring function I wrote.
;It will print any zero terminated string that register ax points to

stdout dw 1 ; variable for standard output so that it can theoretically be redirected

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
mov bx,[stdout]            ; file handle 1=stdout
int 21h                    ; call the DOS kernel

pop dx
pop cx
pop bx
pop ax

ret

;this is the location in memory where digits are written to by the intstr function
int_string db 16 dup '?' ;enough bytes to hold maximum size 16-bit binary integer
;this is the end of the integer string optional line feed and terminating zero
;clever use of this label can change the ending to be a different character when needed 
int_newline db 0Dh,0Ah,0 ;the proper way to end a line in DOS/Windows

radix dw 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dw 8

intstr:

mov bx,int_newline-1 ;find address of lowest digit(just before the newline 0Ah)
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

;function to print string form of whatever integer is in eax
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
