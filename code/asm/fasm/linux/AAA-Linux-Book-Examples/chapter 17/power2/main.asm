format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov ecx,0

mov [array],byte 1

powers_of_two:

;this section prints the digits
mov ebx,[length]
array_print:
dec ebx
mov eax,0
mov al,[array+ebx]
call putint
cmp ebx,0
jnz array_print
call putline

;this section adds the digits
mov dl,0
mov ebx,0
array_add:
mov eax,0
mov al,[array+ebx]
add al,al
add al,dl
mov dl,0
cmp al,10
jb less_than_ten

sub al,10
mov dl,1

less_than_ten:
mov [array+ebx],al
inc ebx
cmp ebx,[length]
jnz array_add

cmp dl,0
jz carry_is_zero

mov [array+ebx],1
inc [length]

carry_is_zero:

;keeps track of how many times the loop has run
add ecx,1
cmp ecx,64
jna powers_of_two

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'

length dd 1
array db 0x100 dup 0
