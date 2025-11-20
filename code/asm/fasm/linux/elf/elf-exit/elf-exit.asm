format ELF executable
mov eax,1 ;function SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0 ;return 0 status on exit - 'No Errors'
int 80h   ;call Linux kernel with interrupt
