format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov eax,0
mov ebx,1

;fill all 3 array with zeros up to maxlength
mov ebx,0
array_zero:
mov [array_a+ebx],0
mov [array_b+ebx],0
mov [array_c+ebx],0
inc ebx
cmp ebx,maxlength
jb array_zero

mov [array_a],1 ;set low digit of array_a to 1
mov [array_b],2 ;set low digit of array_b to 2

;Keep track of the currently used length of each array.
;At the start, use only one digit
mov dword [array_a_length],1
mov dword [array_b_length],1
mov dword [array_c_length],1

mov edx,0 ;use edx as a counter for the main loop
main_loop:

;stage 1: display the a array
mov eax,0
mov ebx,[array_a_length]
stage1:
dec ebx
mov al,[array_a+ebx]
call putint
cmp ebx,0
jnz stage1
call putline

;stage 2: multiply the a and b arrays together and store the result in the c array

mov ebx,0
stage2:

mov eax,0
stage2_multiply:

;we need to get the result of multiplication of the current digit
;indexed in array_a by eax and array_b by ebx
;the only safe way is to back up all the registers
;do a multiply operation, and then restore them

push eax
push ebx
push ecx
push edx

;mov eax and ebx to ecx and edx
;so that we can index the arrays
;using the low parts of eax and ebx as the result
mov ecx,eax
mov edx,ebx
;both eax and ebx are zeroed to avoid conflicts
;only the lowest 8 bits will be loaded from the arrays
mov eax,0
mov al,[array_a+ecx]
mov ebx,0
mov bl,[array_b+edx]
mul bl ;multiply al by bl

;al now has the result of multiplying the
;two digits from the arrays
;next we begin another sub loop where we add this to the c array

add ecx,edx ;ecx is now sum of original eax and ebx
stage2_add_product:
add [array_c+ecx],al
mov al,0 ;set al to zero before our manual divide by ten
c_divide_with_subtraction:
cmp [array_c+ecx],10
jb digit_less_than_ten ;if less than ten, end the divide

;otherwise, divide by repeated subtraction!
sub [array_c+ecx],10 ;subtract ten from this element
inc al ;add one to count of subtractions
jmp c_divide_with_subtraction

digit_less_than_ten:

inc ecx
cmp al,0 ;is there still a carry left over?
jnz stage2_add_product ;if so, go to next digit and repeat

cmp ecx,[array_c_length] ;is the index higher than current length of c array?
jb c_digits_are_enough
mov [array_c_length],ecx ;expand digits
c_digits_are_enough:

;pop path the original values of the registers
pop edx
pop ecx
pop ebx
pop eax

inc eax
cmp eax,[array_a_length]
jnz stage2_multiply

inc ebx
cmp ebx,[array_b_length]
jnz stage2
;end of array multiplication stage

;stage 3: add 1 to the b array
mov al,1  ;set carry to 1
mov ebx,0 ;start at lowest element of b
stage3_add_one_to_b:
add [array_b+ebx],al
mov al,0 ;set al to zero before our manual divide by ten
b_divide_with_subtraction:
cmp [array_b+ebx],10
jb b_digit_less_than_ten ;if less than ten, end the divide

;otherwise, divide by repeated subtraction!
sub [array_b+ebx],10 ;subtract ten from this element
inc al ;add one to count of subtractions
jmp b_divide_with_subtraction

b_digit_less_than_ten:

inc ebx
cmp al,0 ;is there still a carry left over?
jnz stage3_add_one_to_b ;if so, go to next digit and repeat

cmp ebx,[array_b_length] ;is the index higher than current length of c array?
jb b_digits_are_enough

mov [array_b_length],ebx ;expand digits

b_digits_are_enough:

;stage 4: replace array_a with array_c
;and turn array_c to all zeros to be used for next product

mov ebx,0 ;start at lowest element of both arrays
stage4:

mov al,[array_c+ebx] ;get element from array_c
mov [array_a+ebx],al ;store it here in array_a  
mov [array_c+ebx],0  ;zero the byte in array_c

;next, expand length of array_a to same as array_c
mov eax,[array_c_length] ;get length of array_c
mov [array_a_length],eax ;set length of array_a

inc ebx
cmp ebx,maxlength
jnz stage4

inc edx
cmp edx,64
jna main_loop

mov eax,1
mov ebx,0
int 0x80

maxlength=1000 ;use this as maximum length of all arrays
array_a rb maxlength ;first array
array_b rb maxlength ;second array
array_c rb maxlength ;third array

;reserve one double word for each variable that will store the length
;the initial value is unknown but will be set in the program
array_a_length rd 1
array_b_length rd 1
array_c_length rd 1

include 'chastelib32.asm'
