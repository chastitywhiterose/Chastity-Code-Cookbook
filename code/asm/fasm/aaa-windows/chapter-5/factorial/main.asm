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

mov rbx,0
stage2:

mov rax,0
stage2_multiply:

;we need to get the result of multiplication of the current digit
;indexed in array_a by rax and array_b by rbx
;the only safe way is to back up all the registers
;do a multiply operation, and then restore them

push rax
push rbx
push rcx
push rdx

;mov rax and rbx to rcx and rdx
;so that we can index the arrays
;using the low parts of rax and rbx as the result
mov rcx,rax
mov rdx,rbx
;both rax and rbx are zeroed to avoid conflicts
;only the lowest 8 bits will be loaded from the arrays
mov rax,0
mov al,[array_a+rcx]
mov rbx,0
mov bl,[array_b+rdx]
mul bl ;multiply al by bl

;al now has the result of multiplying the
;two digits from the arrays
;next we begin another sub loop where we add this to the c array

add rcx,rdx ;rcx is now sum of original rax and rbx
stage2_add_product:
add [array_c+rcx],al
mov al,0 ;set al to zero before our manual divide by ten
c_divide_with_subtraction:
cmp [array_c+rcx],10
jb digit_less_than_ten ;if less than ten, end the divide

;otherwise, divide by repeated subtraction!
sub [array_c+rcx],10 ;subtract ten from this element
inc al ;add one to count of subtractions
jmp c_divide_with_subtraction

digit_less_than_ten:

inc rcx
cmp al,0 ;is there still a carry left over?
jnz stage2_add_product ;if so, go to next digit and repeat

cmp rcx,[array_c_length] ;is the index higher than current length of c array?
jb c_digits_are_enough
mov [array_c_length],rcx ;expand digits
c_digits_are_enough:

;pop path the original values of the registers
pop rdx
pop rcx
pop rbx
pop rax

inc rax
cmp rax,[array_a_length]
jnz stage2_multiply

inc rbx
cmp rbx,[array_b_length]
jnz stage2
;end of array multiplication stage

;stage 3: add 1 to the b array
mov al,1  ;set carry to 1
mov rbx,0 ;start at lowest element of b
stage3_add_one_to_b:
add [array_b+rbx],al
mov al,0 ;set al to zero before our manual divide by ten
b_divide_with_subtraction:
cmp [array_b+rbx],10
jb b_digit_less_than_ten ;if less than ten, end the divide

;otherwise, divide by repeated subtraction!
sub [array_b+rbx],10 ;subtract ten from this element
inc al ;add one to count of subtractions
jmp b_divide_with_subtraction

b_digit_less_than_ten:

inc rbx
cmp al,0 ;is there still a carry left over?
jnz stage3_add_one_to_b ;if so, go to next digit and repeat

cmp rbx,[array_b_length] ;is the index higher than current length of c array?
jb b_digits_are_enough

mov [array_b_length],rbx ;expand digits

b_digits_are_enough:

;stage 4: replace array_a with array_c
;and turn array_c to all zeros to be used for next product

mov rbx,0 ;start at lowest element of both arrays
stage4:

mov al,[array_c+rbx] ;get element from array_c
mov [array_a+rbx],al ;store it here in array_a  
mov [array_c+rbx],0  ;zero the byte in array_c

;next, expand length of array_a to same as array_c
mov rax,[array_c_length] ;get length of array_c
mov [array_a_length],rax ;set length of array_a

inc rbx
cmp rbx,maxlength
jnz stage4

inc rdx
cmp rdx,64
jna main_loop

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
