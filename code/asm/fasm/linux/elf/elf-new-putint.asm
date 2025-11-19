format ELF executable

main:

mov [radix],0x10 ; can choose radix for integer output!
mov [int_width],1

mov eax,msg
call putstring

mov eax,main
call putint

mov eax,1 ;function SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0 ;return 0 status on exit - 'No Errors'
int 80h   ;call Linux kernel with interrupt

msg db 'Main function begins at address: ',0

include 'chastelib32.asm'
