org 100h

main:

mov [radix],10 ; can choose radix for integer output!
mov [int_width],1

mov ax,main_string
call putstring

call getstring

mov ax,msg1
call putstring

mov ax,buf
call putstring
call putline

mov ax,msg2
call putstring

mov ax,[count]
call putint
call putline

mov ax,4C00h ;DOS system call number ah=0x4C to exit program with ah=0x00 as return value
int 21h      ;DOS interrupt to exit the program with numbers on previous line

include 'chastelib16.asm' ; use %include if assembling with NASM instead of FASM.
include 'chastdin16.asm'

;A string to test if output works
main_string db 'This program tests the Windows Assembly getstring function',0Dh,0Ah
            db 'This function is part of chastelib by Chastity White Rose',0Dh,0Ah
            db 'Type anything you like and press Enter',0Dh,0Ah,0Dh,0Ah,0

msg1  db 'The the string you entered is: ',0            
msg2  db 'The length of the string you entered is: ',0     