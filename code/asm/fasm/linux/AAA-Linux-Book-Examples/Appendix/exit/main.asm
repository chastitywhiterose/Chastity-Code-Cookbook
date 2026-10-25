format ELF executable

main:
mov eax,1 ;exit
mov ebx,0 ;return int
int 80h   ;system call
