format ELF64 executable
entry main

include 'chastelib64.asm'

main:

mov qword [radix],10
mov qword [int_width],1

mov rax,0
mov rbx,1

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

mov rdx,0 ;use edx as a counter for the main loop
main_loop:
push rdx

;stage 1: display the a array
mov rax,0
mov rbx,[array_a_length]
stage1:
dec rbx
mov al,[array_a+ebx]
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
;indexed in array_a by eax and array_b by ebx
;the only safe way is to back up all the registers
;do a multiply operation, and then restore them

push rax
push rbx

;mov eax and ebx to ecx and edx
;so that we can index the arrays
;using the low parts of eax and ebx as the result
mov rcx,rax
mov rdx,rbx
;both eax and ebx are zeroed to avoid conflicts
;only the lowest 8 bits will be loaded from the arrays
;then we will do a multiply instruction
mov rax,0
mov al,[array_a+rcx]
mov rbx,0
mov bl,[array_b+rdx]
add rcx,rdx ;add edx to ecx before edx is overwritten with mul
mul rbx ;multiply eax by ebx

stage2_add_product:
add al,[array_c+rcx] ;add the byte at this index to al
mov rbx,[radix]      ;set the bl register to the radix
mov rdx,0            ;clear edx before division
div rbx              ;divide eax by ebx
mov [array_c+rcx],dl ;move the remainder back to this index

inc rcx
cmp al,0               ;is the carry or quotient zero?
jnz stage2_add_product ;if not zero, go to next digit and repeat

cmp rcx,[array_c_length] ;is the index higher than current length of c array?
jb c_digits_are_enough
mov [array_c_length],rcx ;expand digits
c_digits_are_enough:

;pop back the original values of the registers
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
mov rax,1 ;set carry to 1
mov rbx,0 ;start at lowest element of b
stage3_add_one_to_b:
add al,[array_b+ebx]
mov rdx,0
div qword [radix]
mov [array_b+rbx],dl ;move the remainder back to this index

inc rbx
cmp al,0                ;is the carry or quotient zero?
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

pop rdx
inc rdx
cmp rdx,64     ;maximum factorial
jnz main_loop

mov rax,0x3C              ;exit (kernel opcode 0x3C on 64 bit systems) (60 decimal)
mov rdi,0                 ;return 0 status on exit - 'No Errors'
syscall                   ;system call for 64-bit Linux kernel

maxlength=1000 ;use this as maximum length of all arrays
array_a rb maxlength ;first array
array_b rb maxlength ;second array
array_c rb maxlength ;third array

;reserve one double word for each variable that will store the length
;the initial value is unknown but will be set in the program
array_a_length rq 1
array_b_length rq 1
array_c_length rq 1


