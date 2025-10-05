format ELF executable
entry main

include 'chaste-lib.asm'

main:

;Print message about what the program is doing.
mov eax,msg0
call putstring

mov     ecx, 0777o          ; set all permissions to read, write, execute
mov     ebx, filename       ; filename we will create
mov     eax, 8              ; invoke SYS_CREAT (kernel opcode 8)
int     80h                 ; call the kernel

;now that the file is created, we will write to it

mov     edx, 16             ; number of bytes to write - one for each letter of our contents string
mov     ecx, msg1           ; move the memory address of our contents string into ecx
mov     ebx, eax            ; move the file descriptor of the file we created into ebx
mov     eax, 4              ; invoke SYS_WRITE (kernel opcode 4)
int     80h                 ; call the kernel

;we are done writing, now time to close the file
;ebx still contains the file handle from above

mov     eax, 6              ; invoke SYS_CLOSE (kernel opcode 6)
int     80h                 ; call the kernel

mov     ebx, 0      ; return 0 status on exit - 'No Errors'
mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
int     80h

msg0 db 'This program will create, write to, and close a file!',0Ah,0
msg1 db 'Party on dudes!',0Ah,0
filename db 'excellent.txt',0 


; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main
