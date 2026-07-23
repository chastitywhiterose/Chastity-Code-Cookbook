format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'
include 'chastdinw32.asm'

main:

mov [radix],10 ; can choose radix for integer output!
mov [int_width],1

mov eax,main_string
call putstring

call getstring

mov eax,msg1
call putstring

mov eax,buf
call putstring
call putline

mov eax,msg2
call putstring

mov eax,[count]
call putint
call putline

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

;A string to test if output works
main_string db 'This program tests the Windows Assembly getstring function',0Ah
            db 'This function is part of chastelib by Chastity White Rose',0Ah
            db 'Type anything you like and press Enter',0Ah,0Ah,0

msg1  db 'The the string you entered is: ',0            
msg2  db 'The length of the string you entered is: ',0            
