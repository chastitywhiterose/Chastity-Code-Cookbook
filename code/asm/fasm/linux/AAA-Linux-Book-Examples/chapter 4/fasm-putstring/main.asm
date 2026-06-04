format ELF executable

main:

mov eax,string0
call putstring

mov eax,1 ; invoke SYS_EXIT (kernel opcode 1)
mov ebx,0 ; return 0 status on exit - 'No Errors'
int 80h

string0 db 'The putstring function can print any string!',0Ah,0

putstring:

push eax
push ebx
push ecx
push edx

mov ebx,eax

putstring_strlen_start:

cmp [ebx],byte 0
jz putstring_strlen_end
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax

mov edx,ebx ;number of bytes to write
mov ecx,eax ;pointer/address of string to write
mov ebx,1   ;write to the STDOUT file
mov eax,4   ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h     ;system call to write the message

pop edx
pop ecx
pop ebx
pop eax

ret
