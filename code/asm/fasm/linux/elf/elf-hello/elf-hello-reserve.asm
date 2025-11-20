format ELF executable

mov eax,4   ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,1   ; write to the STDOUT file
mov ecx,msg ; pointer/address of string to write
mov edx,13  ; number of bytes to write
int 80h

mov eax,1 ;function SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0 ;return 0 status on exit - 'No Errors'
int 80h   ;call Linux kernel with interrupt

msg db 'Hello World!',0Ah

rb 0x10 ;reserve extra sixteen bytes of space here