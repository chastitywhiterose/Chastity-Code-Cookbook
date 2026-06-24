format ELF executable

main:                     ;the main function of the assembly program

mov eax,string0
call putstring

mov dword[radix],16       ;I can choose the radix for integer output!
mov dword[int_width],1    ;and the width of each integer for padded zeros

;Linux system call to open a file

mov ecx,2        ;open file in read and write mode 
mov ebx,filename ;filename should be in eax before this function was called
mov eax,5        ;invoke SYS_OPEN (kernel opcode 5)
int 80h          ;call the kernel

cmp eax,0
jns cat_upper ;if eax is not negative/signed there was no error

;Otherwise, if it was signed, then this code will display an error message.

neg eax
call putint_and_space
mov eax,open_error
call putstr_and_line

jmp main_end ;end the program because we failed at opening the file

cat_upper:

mov eax,string0
call putstring

main_end:

mov eax,1                 ;exit (kernel opcode 1 on 32 bit systems)
mov ebx,0                 ;return 0 status on exit - 'No Errors'
int 80h                   ;system call for 32-bit Linux kernel

include 'chastelib32.asm'

string0 db 'chastelib test suite for Intel 32-bit Assembly on Linux',0Ah,0

filename db 'openthis.txt',0
open_error db 'error opening file',0
