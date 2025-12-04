format ELF executable
entry main

include 'chastelib32.asm'

main:

mov eax,filename
call putstring
call putline

file_create:
mov     ecx, 0777o     ; set all permissions to read, write, execute
mov     ebx, filename  ; filename we will create
mov     eax, 8         ; invoke SYS_CREAT (kernel opcode 8)
int     80h            ; call the kernel
mov [filedesc],eax

;next the complex writing of data begins

mov eax,0
data_loop_0:

mov byte [filedata],0
mov byte [filedata+1],al

pusha
mov edx,2          ;number of bytes to write
mov ecx,filedata   ;pointer/address of string to write
mov ebx,[filedesc] ;write to the STDOUT file
mov eax, 4         ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h            ;system call to write the message
popa

;call putint

inc eax
cmp al,0
jnz data_loop_0

file_close:
mov ebx,eax ;file number to close
mov eax,6   ;invoke SYS_CLOSE (kernel opcode 6)
int 80h     ;call the kernel

main_end:
mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

;this is where I keep my variables

filename db 'data16.bin',0
filedesc rd 1
filedata rb 0x100
