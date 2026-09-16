format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

;fill all 3 array with zeros up to maxlength
mov rbx,0
array_zero:
mov [array_a+rbx],0
mov [array_b+rbx],0
mov [array_c+rbx],0
inc rbx
cmp rbx,maxlength
jb array_zero

mov [array_a],1 ;set low digit of array_a to 1
mov [array_b],2 ;set low digit of array_b to 2

;Keep track of the currently used length of each array.
;At the start, use only one digit
mov qword [array_a_length],1
mov qword [array_b_length],1
mov qword [array_c_length],1

mov rdx,0 ;use rdx as a counter for the main loop
main_loop:

;stage 1: display the a array
mov rax,0
mov rbx,[array_a_length]
stage1:
dec rbx
mov al,[array_a+rbx]
call putint
cmp rbx,0
jnz stage1
call putline


;stage 2: multiply the a and b arrays together and store the result in the c array

;stage 3: add 1 to the b array

inc rdx
cmp rdx,16
jnz main_loop

sub rsp,40
mov rcx,0
call [ExitProcess]

maxlength=1000 ;use this as maximum length of all arrays
array_a rb maxlength ;first array
array_b rb maxlength ;second array
array_c rb maxlength ;third array

;reserve one quad word for each variable that will store the length
;the initial value is unknown but will be set in the program
array_a_length rq 1
array_b_length rq 1
array_c_length rq 1

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
