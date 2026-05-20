org 100h

main:

mov ax,main_string
call putstring

mov word [radix],2 ; choose radix for integer input/output
mov word [int_width],1

mov ax,test_int
call strint

mov bx,ax

mov ax,str_bin
call putstring
mov ax,bx
mov word [radix],2
call putint

mov ax,str_hex
call putstring
mov ax,bx
mov word [radix],16
call putint

mov ax,str_dec
call putstring
mov ax,bx
mov word [radix],10
call putint

mov ax,4C00h
int 21h

main_string db "This is the year I was born",0Dh,0Ah,0

;test string of integer for input
test_int db '11111000011',0

str_bin db 'binary: ',0
str_hex db 'hexadecimal: ',0
str_dec db 'decimal: ',0

include 'chastelib16.asm'
